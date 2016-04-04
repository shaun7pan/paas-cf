resource "aws_security_group" "bosh_server" {
  name = "${var.env}-bosh-server"
  description = "Bosh security group"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      "${var.concourse_security_group_id}"
    ]
  }

  ingress {
    from_port = 6868
    to_port   = 6868
    protocol  = "tcp"
    security_groups = [
      "${var.concourse_security_group_id}"
    ]
  }

  ingress {
    from_port = 25555
    to_port   = 25555
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.bosh_client.id}",
      "${var.concourse_security_group_id}"
    ]
  }

  ingress {
    from_port = 4222
    to_port   = 4222
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.bosh_client.id}",
    ]
  }

  ingress {
    from_port = 25250
    to_port   = 25250
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.bosh_client.id}",
    ]
  }


  ingress {
    from_port = 25777
    to_port   = 25777
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.bosh_client.id}",
    ]
  }

  tags {
    Name = "${var.env}-bosh-server"
  }
}

resource "aws_security_group" "bosh_client" {
  name = "${var.env}-bosh-client"
  description = "Default security group for VMs which will interact with bosh"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-bosh-client"
  }
}
