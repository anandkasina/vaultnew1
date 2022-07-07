provider vault{
  address = "http://34.71.251.34:8200"
  token = "hvs.0F8m6ealq5Ij0I10TfUoR0L4"

}

resource "vault_aws_secret_backend" "aws" {
  access_key = "AKIAWCLFHFHVOSEW236W"
  secret_key = "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"
  path = "awsvaulpocnew"
  region = "ap-south-1"
}

resource "vault_aws_secret_backend_role" "role" {
  backend = vault_aws_secret_backend.aws.path
  name    = "test2"
  credential_type = "assumed_role"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOT
}

# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  backend = vault_aws_secret_backend.aws.path
  role    = vault_aws_secret_backend_role.role.name
}
#error here
provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}
resource "aws_s3_bucket" "bucket" {
  bucket = "aws-vault"
  acl    = "public-read"
