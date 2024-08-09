resource "aws_dynamodb_table" "hospital_queue" {
  name         = "hospital_queue"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "patient_id"

  attribute {
    name = "patient_id"
    type = "S"
  }

  attribute {
    name = "hospital_id"
    type = "S"
  }

  tags = {
    Name = "Hospital Queue Table"
  }
}
