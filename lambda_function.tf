resource "aws_lambda_function" "hospital_queue" {
  function_name = "HospitalQueueLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("lambda_function_payload.py")

  environment {
    variables = {
      DYNAMODB_TABLE = "HospitalQueue"
    }
  }

  code {
    zip_file = <<EOF
import json
import boto3
import uuid
from datetime import datetime
from boto3.dynamodb.conditions import Key
 
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('HospitalQueue')
 
def lambda_handler(event, context):
    path = event['path']
    http_method = event['httpMethod']
    if path == '/submit' and http_method == 'POST':
        return submit_patient(json.loads(event['body']))
    elif path == '/check_queues' and http_method == 'GET':
        return check_queues()
    else:
        return {
            'statusCode': 404,
            'body': json.dumps('Not Found')
        }
 
def submit_patient(data):
    user_id = str(uuid.uuid4())
    timestamp = datetime.now().isoformat()
    item = {
        'UserId': user_id,
        'Name': data['name'],
        'LastName': data['lastName'],
        'DoB': data['dob'],
        'Hospital': data['hospital'],
        'Symptoms': data['symptoms'],
        'Timestamp': timestamp,
        'QueuePosition': calculate_queue_position(data['symptoms'])
    }
    table.put_item(Item=item)
    return {
        'statusCode': 200,
        'body': json.dumps({
            'userId': user_id,
            'queuePosition': item['QueuePosition']
        })
    }
 
def check_queues():
    hospitals = ['Hospital A', 'Hospital B', 'Hospital C']
    queue_lengths = {}
    for hospital in hospitals:
        response = table.query(
            IndexName='HospitalIndex',
            KeyConditionExpression=Key('Hospital').eq(hospital)
        )
        queue_lengths[hospital] = len(response['Items'])
    return {
        'statusCode': 200,
        'body': json.dumps(queue_lengths)
    }
 
def calculate_queue_position(symptoms):
    if 'emergency' in symptoms.lower():
        return 1
    return 10  # Default position
EOF
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "IAM policy for Lambda to access DynamoDB"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/HospitalQueue",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

