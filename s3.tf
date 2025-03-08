resource "aws_s3_bucket" "s3-test" {
  bucket        = "test-pipeline-iac"
  force_destroy = true

  tags = {
    IAC = true
  }
}