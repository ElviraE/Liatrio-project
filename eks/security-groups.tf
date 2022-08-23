resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }

  ingress {
    description      = "443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }


  ingress {
    description      = "80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [
      "10.0.0.0/8",
    ]
    ipv6_cidr_blocks = ["::/0"]
  }




}

resource "aws_security_group" "node_group_two" {
  name_prefix = "node_group_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }


  ingress {
    description      = "443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }


  ingress {
    description      = "80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [
      "192.168.0.0/16",
    ]
    ipv6_cidr_blocks = ["::/0"]
  }









}
