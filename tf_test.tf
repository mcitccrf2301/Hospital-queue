resource "aws_s3_bucket" "testing_terraform_sync" {
  bucket = "nichellesalomontestbucket1"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
