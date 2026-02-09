## 📁 Repository Layout

```
cloud-guardrails/
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
👤 Author

Ayfilla
GitHub: https://github.com/Ayfilla




