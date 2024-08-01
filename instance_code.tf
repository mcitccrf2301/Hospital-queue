data "template_file" "bootstrap_hospital_queue" {
  template = file("${path.module}/bootstrap_hospital_queue.sh.tpl")

  vars = {
    db_password    = var.DB_PASSWORD
    api_gateway_url = aws_api_gateway_deployment.hospital_queue_api.invoke_url
  }
}

resource "aws_instance" "hospital_queue" {
  ami           = var.ami_for_compute
  instance_type = var.compute_type
  key_name      = "hospital_key_pair_ssh"

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_web.id,
  ]

  associate_public_ip_address = true
  
  user_data = data.template_file.bootstrap_hospital_queue.rendered

  tags = {
    Name = "HospitalQueueSystem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/hospital_queue/bootstrap_hospital_queue.sh",

    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "hospital_key_pair_ssh"
      host        = self.public_ip
    }
  }
}
