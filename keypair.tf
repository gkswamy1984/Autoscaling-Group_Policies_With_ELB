resource "aws_key_pair" "esafe-demo" {
  key_name   = "esafe.demo"
  public_key = "${file("public_key")}"
}
