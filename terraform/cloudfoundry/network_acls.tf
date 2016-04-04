resource "aws_network_acl" "cf" {
  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.cf.*.id}"]
  tags {
    Name = "${var.env}-cf-acl"
  }
}
