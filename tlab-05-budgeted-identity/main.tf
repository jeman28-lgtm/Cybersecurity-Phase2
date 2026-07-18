# =================================================================
# GLOBAL RESOURCES
# =================================================================
resource "random_id" "id" {
  byte_length = 4
}

# =================================================================
# STEP 2 — FINANCIAL FIREWALL (BUDGET)
# =================================================================
resource "aws_budgets_budget" "titan_budget" {
  name              = "titan-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["your-personal-email@example.com"] # 👈 Put your real email here!
  }
}

# =================================================================
# STEP 3 — SECRET STORAGE VAULT (S3)
# =================================================================
resource "aws_s3_bucket" "vault" {
  bucket = "titan-fintech-vault-je-${random_id.id.hex}" # 👈 Tied to your initials!
}

resource "aws_s3_bucket_public_access_block" "vault_privacy" {
  bucket                  = aws_s3_bucket.vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =================================================================
# STEP 4 — SURGICAL SECURITY BADGE (IAM ROLE & POLICY)
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
  description = "Allows surgical PutObject access to the Titan vault"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.vault.arn}/*"
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
# STEP 5 — THE GUARD COMPUTER (EC2 DEPLOYMENT)
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
  owners = ["099720109477"] # Canonical's official AWS ID
}

resource "aws_instance" "titan_worker" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro" # 👈 Upgraded to fix your region issue!
  iam_instance_profile = aws_iam_instance_profile.vault_profile.name

  tags = {
    Name = "Titan-FinTech-Worker"
  }
}