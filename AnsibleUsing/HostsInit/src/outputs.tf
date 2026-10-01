output "clickhouse_external_ip" {
  value = yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address
}

output "vector_external_ip" {
  value = yandex_compute_instance.vector.network_interface.0.nat_ip_address
}

output "lighthouse_external_ip" {
  value = yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address
}
