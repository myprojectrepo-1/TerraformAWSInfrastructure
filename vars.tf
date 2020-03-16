variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-07ebfd5b3428b6f4d"
    us-east-2 = "ami-0fc20dd1da406780b"
    us-west-1 = "ami-03ba3948f6c37a4b0"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "RDS_PASSWORD" {
}

variable "RDS_USERNAME" {
}

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}
