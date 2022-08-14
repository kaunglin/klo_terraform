terraform {

}

variable worlds {
  type = list
}

variable info {
    type = map
}

variable "users" {
  type = map(object({
    is_admin = bool
  }))  
}

variable "worlds_splat" {
  type = list
}
