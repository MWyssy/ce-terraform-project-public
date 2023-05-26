resource "aws_s3_bucket" "ce-tf-remote-store" {

  bucket        = var.remote_name
  force_destroy = true

  tags = {
    Name      = var.remote_name
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "ce-tf-remote-store" {

  bucket = aws_s3_bucket.ce-tf-remote-store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {

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
