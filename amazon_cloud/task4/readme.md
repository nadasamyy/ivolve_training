
# AWS CLI - S3 Bucket Management

This guide demonstrates how to use the AWS CLI to create an S3 bucket, configure permissions, upload/download files, and enable versioning and logging for the bucket.

## Prerequisites

- AWS CLI installed. If you haven’t installed it yet, follow the official guide: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
- Configure your AWS CLI by running:

  ```bash
  aws configure
  ```

  This will require your AWS Access Key ID, Secret Access Key, region, and output format.

---

## 1. **Create an S3 Bucket**

To create an S3 bucket, run the following command:

```bash
aws s3api create-bucket --bucket my-s3-bucket-name --region us-east-1 --create-bucket-configuration LocationConstraint=us-east-1
```

- Replace `my-s3-bucket-name` with your desired bucket name.
- Replace `us-east-1` with your desired AWS region.

If you're using the default region (e.g., `us-east-1`), you can omit the `--create-bucket-configuration` parameter.

---

## 2. **Enable Versioning**

To enable versioning on the S3 bucket, use this command:

```bash
aws s3api put-bucket-versioning --bucket my-s3-bucket-name --versioning-configuration Status=Enabled
```

This will allow you to retain previous versions of files uploaded to the bucket.

---

## 3. **Enable Logging**

To enable server access logging, specify a target bucket where logs will be stored. You can use the same bucket or a different one (e.g., `my-log-bucket`). First, create a logging configuration file `logging.json`:

```json
{
  "LoggingEnabled": {
    "TargetBucket": "my-log-bucket",
    "TargetPrefix": "log/"
  }
}
```

Then, apply the logging configuration:

```bash
aws s3api put-bucket-logging --bucket my-s3-bucket-name --bucket-logging-status file://logging.json
```

- Replace `my-log-bucket` with your log bucket name.
- Replace `log/` with a custom prefix if needed.

---

## 4. **Upload a File to the S3 Bucket**

To upload a file to the S3 bucket, use:

```bash
aws s3 cp myfile.txt s3://my-s3-bucket-name/myfile.txt
```

- Replace `myfile.txt` with the path to the file you want to upload.
- Replace `my-s3-bucket-name` with your S3 bucket name.

---

## 5. **Download a File from the S3 Bucket**

To download a file from the S3 bucket, use:

```bash
aws s3 cp s3://my-s3-bucket-name/myfile.txt ./downloaded-myfile.txt
```

- Replace `myfile.txt` with the file you uploaded.
- Replace `downloaded-myfile.txt` with the desired name for the downloaded file.

---

## 6. **Configure Permissions for the Bucket**

To configure permissions, you can apply a bucket policy. For example, to allow public read access to files in the bucket, create a `bucket-policy.json` file with the following content:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-s3-bucket-name/*"
    }
  ]
}
```

Then, apply the policy with:

```bash
aws s3api put-bucket-policy --bucket my-s3-bucket-name --policy file://bucket-policy.json
```

- Replace `my-s3-bucket-name` with your bucket name.

---

## 7. **Verify Bucket Configuration**

To verify the bucket versioning status:

```bash
aws s3api get-bucket-versioning --bucket my-s3-bucket-name
```

To verify the bucket logging configuration:

```bash
aws s3api get-bucket-logging --bucket my-s3-bucket-name
```

---

By following these steps, you will have successfully created an S3 bucket, enabled versioning and logging, uploaded and downloaded files, and set permissions for the bucket.
