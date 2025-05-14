variable "allow_everything" {
   type = string
   default = "sg-09c7c70bd56f0d58b"
}

variable "instances" {
    type     = map
    default = {
       node-1     = "t3.micro"
      #  node-2     = "t3.micro"
      #  node-3     = "t3.micro"
    }
}
variable "zone_id" {
    default = "Z08032413NTE19HSX8KA1"
}
variable "domain_name" {
  default = "lingaiah.online"
}


