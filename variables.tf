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
      #  node-4     = "t3.micro"
      #  node-5     = "t3.micro"
    }
}
variable "zone_id" {
   default = "Z07608533HHBQHW47XU3F"
}
variable "domain_name" {
  default = "lingaiah.online"
}


