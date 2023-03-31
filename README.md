# demo1

## Create - Delete Repository using Awscli
- Create ECR repository using Awscli.
```bash
aws ecr create-repository \
--repository-name demo1/apache \
--region us-east-1
```
- Authenticate the Docker CLI to your default registry
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```
- After the build completes, tag your image so you can push the image to this repository:
```bash
docker tag demo1/apache:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/demo1/apache:latest
```
- Run the following command to push this image to your newly created AWS repository:
```bash
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/demo1/apache:latest
```

- Delete ECR repository using Awscli.
```bash
aws ecr delete-repository \
--repository-name demo1/apache \
--force
```