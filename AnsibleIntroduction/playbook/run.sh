#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

HOSTS="almalinux9 ubuntu fedora42"
INVENTORY="inventory/prod.yml"
PLAYBOOK="site.yml"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

cleanup() {
  echo "==> Останавливаю контейнеры"
  docker compose down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

command -v docker >/dev/null || { echo "docker не найден"; exit 1; }
docker info >/dev/null 2>&1 || { echo "Docker не запущен"; exit 1; }

echo "==> Поднимаю контейнеры"
docker compose up -d --build

echo "==> Жду готовности Python в контейнерах"
for host in $HOSTS; do
  ready=false
  for _ in $(seq 1 60); do
    if docker exec "$host" python3 -V >/dev/null 2>&1; then
      ready=true
      break
    fi
    sleep 2
  done
  if [ "$ready" = false ]; then
    echo "Хост $host не поднялся за 120 секунд"
    exit 1
  fi
  echo "    $host готов"
done

echo "==> Запускаю playbook"
if [ -n "${VAULT_PASS:-}" ]; then
  passfile="$(mktemp)"
  chmod 600 "$passfile"
  printf '%s\n' "$VAULT_PASS" > "$passfile"
  ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --vault-password-file "$passfile"
  rm -f "$passfile"
else
  ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-vault-pass
fi

echo "==> Готово"