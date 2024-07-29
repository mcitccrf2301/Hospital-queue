resource "aws_instance" "hospital_queue" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  key_name      = "hospital_key_pair"
  subnet_id = 
  security_groups = 
  associate_public_ip_address = true
  # Using a file function to load the startup script
  user_data = file("${path.module}/bootstrap_hospital_queue.sh")

  tags = {
    Name = "HospitalQueueSystem"
  }
