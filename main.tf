provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["/Users/W700872/.aws/credentials"]
  profile                  = "dev-local"
}

data "aws_iam_policy_document" "iam_testing_lambda_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}
# role
resource "aws_iam_role" "lambda_role" {
  name               = "terraform_aws_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
        "Action":  "sts:AssumeRole",
        "Principal": {
                "Service" : "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# policy
resource "aws_iam_policy" "iam_for_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS testing terraform for MGNT lambda role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Action" :[
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource" : "arn:aws:logs:*:*:*",
            "Effect" : "Allow"
        }
    ]
}
EOF
}

# Policy attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_for_policy_for_lambda.arn
}

# data "archive_file" "zip_simpleHello_dotnet" {
#   type        = "zip"
#   source_dir  = "${path.module}/SimpleHello/src/SimpleHello"
#   output_path = "${path.module}/SimpleHello/src/SimpleHello/bin/Release/net6.0/SimpleHello.zip"
# }

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.module}/SimpleHello/src/SimpleHello/bin/Release/net6.0/SimpleHello.zip"
  function_name = "SimpleHelloFunction"
  handler       = "SimpleHello::SimpleHello.SimpleHelloFunction::ConvertToUpperHandler"
  runtime       = "dotnet6"
  role          = aws_iam_role.lambda_role.arn

}
