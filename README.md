# Infrastructure as Code (IaC) for Node.js API

## Overview

This repository contains the Infrastructure as Code (IaC) implementation using Terraform to provision and manage AWS resources required for the Node.js API deployment. The infrastructure setup includes Amazon ECR for container registry and necessary IAM roles for AWS App Runner deployment.

## Technology Stack

- **IaC Tool**: Terraform
- **Cloud Provider**: AWS
- **Services**: 
  - Amazon ECR (Elastic Container Registry)
  - AWS App Runner
  - IAM (Identity and Access Management)

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform CLI installed (version 1.0.0 or higher)
- Basic understanding of AWS services and Terraform

## Project Structure

```
├── .github/
│   └── workflows/    # GitHub Actions workflow configurations
├── ecr.tf            # ECR repository configuration
├── iam.tf            # IAM roles and policies
├── main.tf           # Main Terraform configuration
└── variables.tf      # Variable definitions
```

## AWS Resources

### Amazon ECR Repository

The `ecr.tf` file configures an Elastic Container Registry repository to store Docker images of the Node.js API. The repository is configured with:

- Image tag mutability
- Image scanning on push
- Lifecycle policies for image management

### IAM Roles and Policies

The `iam.tf` file sets up the necessary IAM roles and policies for:

- AWS App Runner service role
- ECR access permissions
- Other required AWS service integrations

## Setup and Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the infrastructure changes:
   ```bash
   terraform apply
   ```

4. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

## CI/CD Integration

The infrastructure deployment is integrated with GitHub Actions workflow that:

1. Validates Terraform configurations
2. Plans infrastructure changes
3. Applies changes when merged to main branch

### Required Secrets

Configure the following secrets in GitHub:

- `AWS_ACCESS_KEY_ID`: AWS access key for Terraform
- `AWS_SECRET_ACCESS_KEY`: AWS secret key for Terraform
- `AWS_REGION`: Target AWS region

## Best Practices

- Always review `terraform plan` output before applying changes
- Use workspaces for managing multiple environments
- Keep sensitive information in variables and GitHub secrets
- Follow AWS security best practices

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.