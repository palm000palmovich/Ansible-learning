data "yandex_vpc_network" "develop" {
  name = "default"
}

data "yandex_compute_image" "ubuntu" {
  family    = var.vm_yandex_compute_image_family
  folder_id = "standard-images"
}

resource "yandex_vpc_subnet" "clickhouse" {
  name           = "${var.vpc_name}-clickhouse"
  zone           = var.vm_clickhouse_default_zone
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_clickhouse_default_cidr
}

resource "yandex_vpc_subnet" "vector" {
  name           = "${var.vpc_name}-vector"
  zone           = var.vm_vector_default_zone
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_vector_default_cidr
}

resource "yandex_vpc_subnet" "lighthouse" {
  name           = "${var.vpc_name}-lighthouse"
  zone           = var.vm_lighthouse_default_zone
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_lighthouse_default_cidr
}

resource "yandex_compute_instance" "clickhouse" {
  name        = "${var.project_name}-clickhouse"
  zone        = var.vm_clickhouse_default_zone
  platform_id = var.vm_clickhouse_yandex_compute_instance_platform_id

  resources {
    cores         = var.vms_resources["resources"].cores
    memory        = var.vms_resources["resources"].memory
    core_fraction = var.vms_resources["resources"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vms_resources["resources"].disc_size
      type     = var.vms_resources["resources"].disc_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.clickhouse.id
    nat       = true
  }

  metadata = var.vms_metadata
}

resource "yandex_compute_instance" "vector" {
  name        = "${var.project_name}-vector"
  zone        = var.vm_vector_default_zone
  platform_id = var.vm_vector_yandex_compute_instance_platform_id

  resources {
    cores         = var.vms_resources["resources"].cores
    memory        = var.vms_resources["resources"].memory
    core_fraction = var.vms_resources["resources"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vms_resources["resources"].disc_size
      type     = var.vms_resources["resources"].disc_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vector.id
    nat       = true
  }

  metadata = var.vms_metadata
}

resource "yandex_compute_instance" "lighthouse" {
  name        = "${var.project_name}-lighthouse"
  zone        = var.vm_lighthouse_default_zone
  platform_id = var.vm_lighthouse_yandex_compute_instance_platform_id

  resources {
    cores         = var.vms_resources["resources"].cores
    memory        = var.vms_resources["resources"].memory
    core_fraction = var.vms_resources["resources"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vms_resources["resources"].disc_size
      type     = var.vms_resources["resources"].disc_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lighthouse.id
    nat       = true
  }

  metadata = var.vms_metadata
}

