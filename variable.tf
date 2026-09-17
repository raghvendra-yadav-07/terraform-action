variable ssh_ip {
     default = ["49.237.187.150/32"]
    type = list(string)
  
}

variable "storage_default" {
    default = 10
    type = number
  
}

variable "env" {
    default = "production"
    type = string
}