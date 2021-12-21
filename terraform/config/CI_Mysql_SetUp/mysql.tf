resource "aws_instance" "db_instance" {
  instance_type = "t2.micro"
  ami           = "ami-0943382e114f188e8"
  key_name      = "BastionKey"
  subnet_id     = "subnet-d94cafa0"
  vpc_security_group_ids      = ["sg-0a44108342b2e84d6"]
  associate_public_ip_address = true
  
  }