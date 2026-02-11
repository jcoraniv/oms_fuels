# AWS S3 Configuration for Signature Images

## Setup Instructions

### 1. Edit Rails Credentials

Run the following command to edit your credentials:

```bash
EDITOR="nano" rails credentials:edit --environment production
```

Or for development:

```bash
EDITOR="nano" rails credentials:edit --environment development
```

### 2. Add AWS Credentials

Add the following structure to your credentials file:

```yaml
aws:
  access_key_id: YOUR_AWS_ACCESS_KEY_ID
  secret_access_key: YOUR_AWS_SECRET_ACCESS_KEY
  region: us-east-1
  bucket: your-bucket-name
```

### 3. AWS S3 Bucket Setup

1. Create an S3 bucket in AWS Console
2. Set bucket permissions:
   - Block public access: OFF (for public read access to signatures)
   - Or configure bucket policy for specific access
3. Enable CORS if needed:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
```

### 4. IAM User Permissions

Ensure your IAM user has the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*",
        "arn:aws:s3:::your-bucket-name"
      ]
    }
  ]
}
```

### 5. Environment Configuration

- **Development**: Uses local storage by default
- **Production**: Uses Amazon S3 (configured in `config/environments/production.rb`)

### 6. Testing

After configuration, test by uploading a signature image through the user form.

## Files Modified

- `Gemfile`: Added `aws-sdk-s3` gem
- `config/storage.yml`: Configured Amazon S3 service
- `config/environments/production.rb`: Set active_storage service to `:amazon`
- `app/models/user.rb`: Added `has_one_attached :sign_image`
- `app/models/fuel_order.rb`: Added `has_one_attached :requester_sign` and `has_one_attached :approver_sign`
