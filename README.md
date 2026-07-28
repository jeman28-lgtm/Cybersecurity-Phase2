# Phase 2: Cloud Security Architecture & DevSecOps (AWS)

Welcome to my **Phase 2** repository. This space serves as an engineering portfolio documenting my transition into cloud infrastructure, security governance, and automated systems deployment using Amazon Web Services (AWS) and Terraform. 

## 🎯 Phase Objective
To master the transition of core security operations into highly scalable, virtualized environments—focusing deeply on **Infrastructure as Code (IaC)**, **Identity Governance (IAM)**, and the orchestration of secure **DevSecOps pipelines**.

---

## 🗺️ Architectural Domains & Competencies

### 🛡️ Domain 4: Cloud Infrastructure & Identity Governance
*   **Core Competencies:** Engineering secure, multi-tenant architectures within public cloud providers (AWS).
*   **Key Focus Areas:** The AWS Shared Responsibility Model, granular JSON identity policies, data-at-rest encryption, and explicit storage bucket hardening (S3).
*   **Practical Validation:** Remediating over-privileged identities, eliminating public-facing data exposures, and replacing wildcard access with surgical Principle of Least Privilege controls.

### ⚙️ Domain 5: Infrastructure as Code (IaC) & Cloud Networking
*   **Core Competencies:** Utilizing declarative code to deploy, manage, and audit repeatable cloud topographies.
*   **Key Focus Areas:** Terraform (HCL) compilation, remote state-file management, lock mechanisms, and Disaster Recovery (DR) automation.
*   **Network Design:** Building secure Virtual Private Clouds (VPC) featuring isolated public/private subnetting, NAT Gateways, and strict Statefully Inspected Security Groups.

### 🚀 Domain 6: DevSecOps, GRC, & Emerging AI Threats
*   **Core Competencies:** Integrating continuous security checks into the software delivery lifecycle and auditing compliance boundaries.
*   **Key Focus Areas:** Automated CI/CD scanning (SAST & `tfsec`), auditing deployments against the **NIST CSF 2.0** framework, and Red Teaming / defending LLMs against Prompt Injection attacks.

---

## 🗂️ Portfolio Laboratory Index

This repository is structurally indexed to track production-ready infrastructure builds as they are deployed:

*   📂 **[`tlab-05-budgeted-identity`](./tlab-05-budgeted-identity/)**
    *   **Scenario:** Financial Vault deployment for Titan FinTech.
    *   **Controls Enforced:** Surgical `s3:PutObject` least-privilege IAM configuration via Terraform interpolation, dynamic S3 asset privacy blocks, and AWS hard-cap budget triggers to mitigate "Denial of Wallet" vectors.

---

## 🛠️ Technical Stack & Framework Alignment

| Skill Category | Primary Technologies | NIST NICE Framework Work Role |
| :--- | :--- | :--- |
| **Cloud Infrastructure** | AWS (IAM, EC2, S3, VPC) | Cloud Security Specialist |
| **Automation & IaC** | Terraform, GitHub Actions, Bash | Systems Architect / DevSecOps |
| **Operating Systems**| Linux (Ubuntu/Debian) | System Administrator |
| **Security & GRC** | NIST CSF 2.0, CIS Benchmarks | Security Control Assessor |

---

## 🎓 Professional Certification Track
The hands-on work compiled within this repository directly maps to the testing domains of the following industry credentials:
*   **HashiCorp Certified:** Terraform Associate
*   **AWS Certified:** Cloud Practitioner
*   **CompTIA:** Security+ 
*   **NIST:** AI RMF Professional
