resource "aws_instance" "hospital_queue" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  key_name      = "hospital_key_pair"

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_web.id,
  ]

  associate_public_ip_address = true
  user_data = file("${path.module}/bootstrap_hospital_queue.sh")

  tags = {
    Name = "HospitalQueueSystem"
  }
