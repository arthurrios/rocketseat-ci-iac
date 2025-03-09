resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    IAC = true
  }
}

resource "aws_iam_role" "tf-role" {
  name = "tf-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    Statement = [{
      "Principal" : {
        "Federated" : "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringLike" : {
          "token.actions.githubusercontent.com:sub" : [
            "repo:arthurrios/rocketseat-ci-iac:ref:refs/heads/main",
            "repo:arthurrios/rocketseat-ci-iac:ref:refs/heads/dev",
            "repo:arthurrios/rocketseat-ci-iac:pull_request",
            "repo:arthurrios/rocketseat-ci-api:ref:refs/heads/main",
            "repo:arthurrios/rocketseat-ci-api:ref:refs/heads/dev",
            "repo:arthurrios/rocketseat-ci-api:pull_request"
          ],
          "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
        }
      },
      Effect = "Allow"
    }]
  })

  tags = {
    IAC = true
  }
}

resource "aws_iam_role_policy" "tf_policy" {
  name = "tf-permission"
  role = aws_iam_role.tf-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "Statement1",
      Action   = "ecr:*",
      Effect   = "Allow",
      Resource = "*"
      },
      {
        Sid      = "Statement2",
        Action   = "iam:*",
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Sid      = "Statement3",
        Action   = "s3:*",
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "app-runner-role" {
  name = "app-runner-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          Service = "build.apprunner.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    IAC = true
  }
}

resource "aws_iam_role_policy_attachment" "app-runner-role-ecr" {
  role       = aws_iam_role.app-runner-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    Statement = [{
      "Principal" : {
        "Federated" : "arn:aws:iam::266735825067:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "token.actions.githubusercontent.com:sub" : "repo:arthurrios/rocketseat-ci-api:ref:refs/heads/main",
          "token.actions.githubusercontent.com:sub" : "repo:arthurrios/rocketseat-ci-api:ref:refs/heads/dev",
          "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
        }
      }
      Effect = "Allow"
      },
    ]
  })

  tags = {
    IAC = true
  }
}

resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr-app-permission"
  role = aws_iam_role.ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "Statement1",
      Action   = "apprunner:*",
      Effect   = "Allow",
      Resource = "*"
      },
      {
        Sid = "Statement2",
        Action = [
          "iam:PassRole",
          "iam:CreateServiceLinkedRole",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Sid = "Statement3",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}