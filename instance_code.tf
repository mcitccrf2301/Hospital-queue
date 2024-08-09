resource "aws_api_gateway_deployment" "hospital_queue_api" {
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  stage_name  = "prod"
  depends_on = [
    aws_api_gateway_integration.submit_integration,
    aws_api_gateway_integration.check_queues_integration,
  ]
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.hospital_queue_api.invoke_url
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

  tags = {
    Name = "HospitalQueueSystem"
  }
}
