# Grab information about the TLS certificate that protects HCP Terraform
#
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate
data "tls_certificate" "hcpt_certificate" {
  url = "https://${var.hcpt_hostname}"
}

# Creates an OIDC provider restricted to HCP Terraform
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
resource "aws_iam_openid_connect_provider" "hcpt_provider" {
  url             = data.tls_certificate.hcpt_certificate.url
  client_id_list  = [var.hcpt_aws_audience]
  thumbprint_list = [data.tls_certificate.hcpt_certificate.certificates[0].sha1_fingerprint]
}

# Generates an IAM policy document in a JSON format to be assumed by the IAM role
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "hcpt_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcpt_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.hcpt_hostname}:aud"
      values   = [one(aws_iam_openid_connect_provider.hcpt_provider.client_id_list)]
    }

    condition {
      test     = "StringLike"
      variable = "${var.hcpt_hostname}:sub"
      values   = ["organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:*:run_phase:*"]
    }
  }
}

# Creates an IAM role that can only be used by the specified HCP Terraform workspace
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "hcpt_role" {
  name               = "hcpt-role"
  assume_role_policy = data.aws_iam_policy_document.hcpt_assume_role_policy.json
}

# Or pass the JSON as a heredoc inline policy
# resource "aws_iam_role" "hcpt_role" {
#   name = "hcpt-role"
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Federated": "${aws_iam_openid_connect_provider.hcpt_provider.arn}"
#      },
#      "Action": "sts:AssumeRoleWithWebIdentity",
#      "Condition": {
#        "StringEquals": {
#          "${var.hcpt_hostname}:aud": "${one(aws_iam_openid_connect_provider.hcpt_provider.client_id_list)}"
#        },
#        "StringLike": {
#          "${var.hcpt_hostname}:sub": "organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:${var.hcpt_workspace_name}:run_phase:*"
#        }
#      }
#    }
#  ]
# }
# EOF
# }

# Attaches the AWS managed AdministratorAccess policy to the role
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "hcpt_policy_attachment" {
  role       = aws_iam_role.hcpt_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
