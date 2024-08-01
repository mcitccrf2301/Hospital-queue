resource "aws_api_gateway_rest_api" "hospital_queue_api" {
  name        = "hospital_queue_api"
  description = "API for the Hospital Queue System"
}

resource "aws_api_gateway_resource" "hospital" {
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_queue_api.root_resource_id
  path_part   = "hospital"
}

resource "aws_api_gateway_method" "post_hospital" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id   = aws_api_gateway_resource.hospital.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_hospital" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id   = aws_api_gateway_resource.hospital.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_hospital_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id             = aws_api_gateway_resource.hospital.id
  http_method             = aws_api_gateway_method.post_hospital.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = insert_lambda_arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/json'"
  }

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }

  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method_response" "post_hospital_response" {
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id = aws_api_gateway_resource.hospital.id
  http_method = aws_api_gateway_method.post_hospital.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "post_hospital_integration_response" {
  rest_api_id  = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id  = aws_api_gateway_resource.hospital.id
  http_method  = aws_api_gateway_method.post_hospital.http_method
  status_code  = aws_api_gateway_method_response.post_hospital_response.status_code
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "hospital_queue_api" {
  depends_on = [
    aws_api_gateway_method.post_hospital,
    aws_api_gateway_integration.post_hospital_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  stage_name  = "prod"
}
