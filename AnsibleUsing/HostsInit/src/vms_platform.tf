# clickhouse VM
variable "vm_clickhouse_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_clickhouse_default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_clickhouse_yandex_compute_instance_platform_id" {
  type    = string
  default = "standard-v2"
}

#vector VM
variable "vm_vector_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_vector_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_vector_yandex_compute_instance_platform_id" {
  type    = string
  default = "standard-v2"
}

#lighthouse VM
variable "vm_lighthouse_default_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_lighthouse_default_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_lighthouse_yandex_compute_instance_platform_id" {
  type    = string
  default = "standard-v2"
}

#resources:
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    disc_size     = number
    disc_type     = string
  }))
  description = "Параметры ресурсов ВМ (cores/memory/core_fraction/disc) по ключу web/db"
  default = {
    resources = {
      cores         = 2
      memory        = 1
      core_fraction = 5
      disc_size     = 10
      disc_type     = "network-hdd"
    }
  }
}

variable "vms_metadata" {
  type        = map(string)
  description = "Метадата для ВМ"
}