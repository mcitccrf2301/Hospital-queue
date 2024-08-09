resource "aws_api_gateway_rest_api" "hospital_queue_api" {
  name = "hospital_queue_api"
}

resource "aws_api_gateway_resource" "submit_resource" {
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_queue_api.root_resource_id
  path_part   = "submit"
}

resource "aws_api_gateway_resource" "check_queues_resource" {
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_queue_api.root_resource_id
  path_part   = "check_queues"
}

resource "aws_api_gateway_method" "submit_method" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id   = aws_api_gateway_resource.submit_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "check_queues_method" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id   = aws_api_gateway_resource.check_queues_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id             = aws_api_gateway_resource.submit_resource.id
  http_method             = aws_api_gateway_method.submit_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hospital_queue.invoke_arn
}

resource "aws_api_gateway_integration" "check_queues_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_queue_api.id
  resource_id             = aws_api_gateway_resource.check_queues_resource.id
  http_method             = aws_api_gateway_method.check_queues_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hospital_queue.invoke_arn
}

resource "aws_api_gateway_deployment" "hospital_queue_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.submit_integration,
    aws_api_gateway_integration.check_queues_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.hospital_queue_api.id
  stage_name  = "prod"
}
