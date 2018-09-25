variable "name" {
  default = "tmate-server"
}

variable "region" {
  default = "nyc1"
}

variable "image" {
  default = "38147840"
}

variable "size" {
  default = "s-1vcpu-1gb"
}

variable "port" {
  default = "2222"
}

variable "ssh_keys" {
  type = "list"
  default = []
}
