provider "aws" {
  region = "us-east-1"
}

# =================================================================
# GLOBAL TOOLS
# =================================================================
resource "random_id" "id" {
  byte_length = 4
}

# =================================================================
# STEP 2 — FINANCIAL FIREWALL (Strict $10 Budget)
# =================================================================
resource "aws_budgets_budget" "titan_budget" {
  name              = "titan-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10.0" # 👈 Hard limit set to $10.00
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80 # 👈 Alerts you at 80% ($8.00)
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["jeman28@gamil.com"] # 👈 Put your real email here!
  }
}

# =================================================================
# STEP 3 — SECRET STORAGE VAULT (Private S3 Bucket)
# =================================================================
resource "aws_s3_bucket" "vault" {
  bucket = "titan-fintech-vault-je-${random_id.id.hex}" # 👈 Dynamically named with your initials
}

resource "aws_s3_bucket_public_access_block" "vault_privacy" {
  bucket                  = aws_s3_bucket.vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =================================================================
# STEP 4 — SURGICAL IDENTITY (Least Privilege IAM Role)
# =================================================================
resource "aws_iam_role" "vault_role" {
  name = "Titan-EC2-Vault-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "vault_put_only" {
  name        = "Titan-Vault-PutObject-Only"
  description = "Allows ONLY PutObject access to the Titan vault bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"         # 👈 Surgical permission only
        Resource = "${aws_s3_bucket.vault.arn}/*" # 👈 Strict interpolation scoping
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.vault_role.name
  policy_arn = aws_iam_policy.vault_put_only.arn
}

resource "aws_iam_instance_profile" "vault_profile" {
  name = "Titan-EC2-Vault-Profile"
  role = aws_iam_role.vault_role.name
}

# =================================================================
# STEP 5 — THE COMPUTE INSTANCE (t3.micro Guard Computer)
# =================================================================
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] 
}

resource "aws_instance" "titan_worker" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro" # 👈 Corrected instance type for your region
  iam_instance_profile = aws_iam_instance_profile.vault_profile.name

  tags = {
    Name = "Titan-FinTech-Worker"
  }
}