# S23: Ghost Lab - IAM Least Privilege Remediation

## 📌 Overview
This lab demonstrates identifying and remediating an over-permissive AWS IAM execution role attached to an AWS Lambda function (`TKH-Phase2-Ghost`).

## 🛡️ Security Remediation
- **The Issue:** The initial deployment utilized a toxic wildcard policy (`"Action": "*"`, `"Resource": "*"`), violating the Principle of Least Privilege.
- **The Fix:** Replaced the wildcard statement with a tightly scoped policy granting only the necessary CloudWatch Logging actions required for runtime execution:
  - `logs:CreateLogGroup`
  - `logs:CreateLogStream`
  - `logs:PutLogEvents`

## 📁 Repository Files
- `lambda_function.py`: Python 3.12 handler script logging operational status.
- `execution-role.json`: Remediated least-privilege IAM policy document.
