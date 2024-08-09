resource "aws_dynamodb_table" "hospital_queue" {
  name         = "HospitalQueue"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Hospital"
    type = "S"
  }

  global_secondary_index {
    name            = "HospitalIndex"
    hash_key        = "Hospital"
    projection_type = "ALL"
  }

  tags = {
    Name = "Hospital Queue Table"
  }
}
