Immutable Legal Document Vault (Zero Trust S3)

This project builds an immutable document vault on AWS using Terraform. The vault stores sensitive records in a way that prevents deletion or modification during a defined retention period.

The design is based on defense-in-depth security principles and aligns with Zero Trust architecture by restricting access paths and enforcing multiple protection layers at the storage level.

The system is designed for environments where records must remain tamper-proof for regulatory or legal reasons.

Examples include financial agreements, compliance documents, or audit evidence.

Architecture

The vault uses the following AWS services:

Amazon S3

Versioning enabled

Object Lock enabled (immutability)

Public access blocked

AWS KMS

Encrypts stored documents

AWS CloudTrail

Logs all object-level activity

Amazon EventBridge

Detects risky operations

Amazon SNS

Sends alerts when suspicious actions occur

Security controls implemented:

Immutable storage using S3 Object Lock

Server-side encryption (SSE-KMS)

Full audit logging

Alerting on deletion attempts

Public access prevention

Use Case

This architecture is applicable in regulated environments where records must be preserved without risk of tampering.

Example:

A financial services firm storing signed client agreements or transaction confirmations. Regulations may require these documents to be retained for several years and provide proof that they were never altered or destroyed.

With this system the organization can demonstrate that:

Documents cannot be permanently deleted during retention

All access activity is logged

Data is encrypted at rest

Suspicious activity triggers alerts
Prerequisites

Before deploying the project ensure you have:

AWS CLI configured

Terraform installed (v1.5+ recommended)

Appropriate AWS permissions to create:

S3 buckets

KMS keys

CloudTrail

EventBridge rules

SNS topics

Configure AWS credentials:
aws configure

Deployment

Initialize Terraform:

terraform init

Review the infrastructure plan:

terraform plan

Deploy the infrastructure:

terraform apply

Confirm deployment when prompted.

Terraform will provision:

Secure S3 vault bucket

Encryption keys

Logging configuration

Monitoring and alerting system

Testing the Vault

Upload a test document:

aws s3 cp test.txt s3://<vault-bucket-name>

Attempt to delete the object:

aws s3 rm s3://<vault-bucket-name>/test.txt

The deletion will only create a delete marker.

The original object version remains protected until the retention period expires.

Destroying the Infrastructure

To remove the infrastructure:

terraform destroy

Important note:

If Object Lock COMPLIANCE mode is enabled and objects are still under retention, AWS will prevent bucket deletion.

This behavior is intentional and ensures the vault cannot be destroyed while protected records exist.

To avoid this in development environments you may use:

Governance mode

Short retention periods

Cost Considerations

This architecture is inexpensive for small workloads.

Typical costs come from:

AWS KMS (~$1/month per key)

S3 storage usage

CloudTrail data events if high activity occurs

For small test files, the monthly cost is typically only a few dollars.

Security Design Highlights

Immutable storage enforcement

Encryption with customer-managed keys

Audit logging for compliance

Event-driven alerting

Defense-in-depth data protection

License

MIT License