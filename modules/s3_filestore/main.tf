resource "aws_s3_bucket" "s3_filestore_bucket" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name      = var.bucket_name
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_filestore_bucket" {
  bucket = aws_s3_bucket.s3_filestore_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_filestore_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_filestore_bucket]

  bucket = aws_s3_bucket.s3_filestore_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_filestore_bucket" {
  bucket = aws_s3_bucket.s3_filestore_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "s3_filestore_bucket" {
  for_each = fileset("${path.module}/../../media/website", "**/*")
  bucket   = aws_s3_bucket.s3_filestore_bucket.id
  key      = each.value
  source   = "${path.module}/../../media/website/${each.value}"
  etag     = filemd5("${path.module}/../../media/website/${each.value}")
  acl      = "private"
}

resource "aws_iam_policy" "S3RoleForEC2" {
  name        = "S3RoleForEC2"
  description = "Provide permission to access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.s3_filestore_bucket.arn}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
  ]
}
  EOF
}

resource "aws_iam_role" "S3RoleForEC2" {
  name = "S3RoleForEC2"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Sid": "RoleForEC2",
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "S3RoleForEC2" {
  name = "S3RoleForEC2"
  role = aws_iam_role.S3RoleForEC2.name
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {

  role       = aws_iam_role.S3RoleForEC2.name
  policy_arn = aws_iam_policy.S3RoleForEC2.arn
}
