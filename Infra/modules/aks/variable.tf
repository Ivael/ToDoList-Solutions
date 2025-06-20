variable "cluster_name" { 
  type = string 
}

variable "resource_group_name" { 
  type = string 
}

variable "location" { 
  type = string 
}

variable "dns_prefix" { 
  type = string 
}

variable "node_count" { 
  type = number 
}

variable "vm_size" { 
  type = string 
}

variable "tags" { 
  type =  map(string)
  default = {} 
}
