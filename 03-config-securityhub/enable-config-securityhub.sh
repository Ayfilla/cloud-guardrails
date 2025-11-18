#!/bin/bash
set -e

REGION=$1

if [ -z "$REGION" ]; then
    echo "Usage: $0 <aws-region>"
    exit 1
fi

echo "=== Enabling AWS Config and Security Hub in $REGION ==="

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
BUCKET="config-$ACCOUNT_ID"

# --- CREATE S3 BUCKET ---
if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    echo "Bucket $BUCKET already exists"
else
    echo "Creating bucket $BUCKET"
    if [ "$REGION" = "us-east-1" ]; then
        aws s3api create-bucket --bucket "$BUCKET"
    else
        aws s3api create-bucket --bucket "$BUCKET" --region $REGION --create-bucket-configuration LocationConstraint=$REGION
    fi
fi

# --- ENABLE CONFIG RECORDER ---
aws configservice put-configuration-recorder --configuration-recorder "{
    \"name\": \"default\",
    \"roleARN\": \"arn:aws:iam::$ACCOUNT_ID:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig\",
    \"recordingGroup\": {
        \"allSupported\": true,
        \"includeGlobalResourceTypes\": true
    }
}"

aws configservice put-delivery-channel --delivery-channel "{
    \"name\": \"default\",
    \"s3BucketName\": \"$BUCKET\"
}"

aws configservice start-configuration-recorder \
    --configuration-recorder-name default

echo "=== AWS Config Enabled ==="

# --- ENABLE SECURITY HUB ---
echo "=== Enabling Security Hub ==="
aws securityhub enable-security-hub --region $REGION || echo "Security Hub already enabled"

# --- SECURITY HUB STANDARDS JSON ---
cat > /tmp/securityhub-standards.json <<EOF
[
  {
    "StandardsArn": "arn:aws:securityhub:$REGION::standards/aws-foundational-security-best-practices/v/1.0.0"
  },
  {
    "StandardsArn": "arn:aws:securityhub:$REGION::standards/cis-aws-foundations-benchmark/v/1.2.0"
  }
]
EOF

# --- ENABLE STANDARDS ---
aws securityhub batch-enable-standards \
  --region $REGION \
  --standards-subscription-requests file:///tmp/securityhub-standards.json \
  || echo "Standards already enabled"

echo "=== DONE ==="

