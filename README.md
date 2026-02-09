## 📁 Repository Layout

```
AWS Cloud Guardrails Platform (Terraform + OPA Gatekeeper)/
├── 01-eks-gatekeeper/
│ ├── install-gatekeeper.sh
│ ├── policies/
│ └── tests/
│
├── 02-conftest-terraform/
│ ├── policies/
│ └── terraform/
│ └── run.sh
│
├── 03-config-securityhub/
│ ├── enable-config-securityhub.sh
│ └── verify-findings.sh
│
├── 04-auto-remediation/
│ ├── eventbridge-rule.json
│ ├── lambda_s3_public_block/
│ └── deploy.sh
│
└── .github/workflows/policy-checks.yml
```
## Architecture

Components:

- Amazon EKS with OPA Gatekeeper
- Terraform modules for policy deployment
- AWS Config + Security Hub integration
- Automated remediation via Lambda
- CI validation pipeline (policy checks)

Flow:
Terraform → Deploy Guardrails → Policy Validation → Security Findings → Auto-Remediation

## Tech Stack
AWS (EKS, Config, Security Hub, Lambda, EventBridge)
Terraform
OPA Gatekeeper
Conftest
Jenkins / CI Pipeline
Bash, Python

👤 Author
Ayfilla
GitHub: https://github.com/Ayfilla




