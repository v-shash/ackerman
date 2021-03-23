# resource "aws_iam_role" "pod_role" {
#   name = "read_write_dynamodb"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = ["dynamodb:PutItem", "dynamodb:Update*","dynamodb:Get*", "dynamodb:BatchGet*","dynamodb:Query","dynamodb:Scan","dynamodb:BatchWrite*" ]
#         Effect = "Allow"
#         Sid = "DynamoDBTableAccess"
#         Resource = "arn:aws:dynamodb:*:*:table/UrlTable"
#       },
#     ]
#   })

#   depends_on = [module.dynamodb_table]
# }


resource "aws_iam_access_key" "pod" {
  user    = aws_iam_user.pod.name
}

resource "aws_iam_user" "pod" {
  name = "UrlShortenerPod_user"
}

resource "aws_iam_user_policy" "pod" {
  name = "UrlShortener_policy"
  user = aws_iam_user.pod.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:Update*",
        "dynamodb:Get*",
        "dynamodb:BatchGet*",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchWrite*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:*:table/UrlTable-MoHusseini"
    }
  ]
}
EOF
}
