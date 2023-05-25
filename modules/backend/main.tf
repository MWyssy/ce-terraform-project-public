resource "aws_s3_bucket" "ce-tf-remote-store" {
  count = var.init ? 1 : 0

  bucket = var.remote_name

  force_destroy = true

  tags = {
    Name      = var.remote_name
    ManagedBy = "Terraform"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  count = var.init ? 1 : 0

  name           = var.dydb_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name      = "DynamoDB Terraform State Lock Table"
    ManagedBy = "Terraform"
  }
}
