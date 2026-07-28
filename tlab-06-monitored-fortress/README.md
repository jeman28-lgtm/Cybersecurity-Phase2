# TLAB 6: The Monitored Fortress

## 📌 Project Overview
Built a production-grade secure cloud network on AWS using Terraform for **Titan FinTech**. The design enforces **Zero Trust access** and full continuous network observation (**wiretapping**).

## 🏗️ Architecture & Security Features

* **Network Perimeter:** 
  * Custom AWS VPC (`10.0.0.0/16`) with a public subnet (`10.0.1.0/24`).
  * Internet Gateway attached to route outward-bound traffic (`0.0.0.0/0`).
* **Telemetry & Wiretapping:** 
  * Integrated **AWS VPC Flow Logs** capturing `ALL` ingress/egress IP traffic.
  * Streams real-time network traffic directly to CloudWatch Log Group (`/tkh/titan-prod-vpc-logs`) with a 1-day retention policy.
* **Zero Trust Compute:**
  * Deployed a `t3.micro` Ubuntu EC2 instance with **zero inbound ports open** (`0` ingress security group rules).
  * Outbound internet access permitted (`0.0.0.0/0` egress).
  * Instance managed exclusively via **AWS Systems Manager (SSM) Session Manager** using IAM roles (no SSH keys or public open ports required).

## 📸 Verification & Proof
* **SSM Access:** Verified connection through Session Manager with `whoami` returning `ssm-user`.
* **Flow Logs:** Confirmed active traffic capture in CloudWatch log group.
* **Cleanup:** Infrastructure safely torn down via `terraform destroy`.

## 🛠️ Tech Stack
* **IaC:** Terraform
* **Cloud Provider:** AWS (VPC, EC2, CloudWatch, IAM, SSM)
* **OS:** Ubuntu 22.04 LTS
