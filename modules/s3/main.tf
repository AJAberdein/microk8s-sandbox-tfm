resource "aws_s3_bucket" "microk8s-resources" {
  bucket = var.microk8s_s3_bucket
  tags = {
    Name        = "microk8s-resources"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "initsh" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "scripts/init.sh"
  source = "./scripts/init.sh"
  etag   = filemd5("./scripts/init.sh")
}

resource "aws_s3_object" "buildsh" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "scripts/build.sh"
  source = "./scripts/build.sh"
  etag   = filemd5("./scripts/build.sh")
}

resource "aws_s3_object" "dockerfile" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "docker/Dockerfile"
  source = "./docker/Dockerfile"
  etag   = filemd5("./docker/Dockerfile")
}

resource "aws_s3_object" "appjs" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "docker/app.js"
  source = "./docker/app.js"
  etag   = filemd5("./docker/app.js")
}

resource "aws_s3_object" "packagejson" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "docker/package.json"
  source = "./docker/package.json"
  etag   = filemd5("./docker/app.js")
}

resource "aws_s3_object" "deploymentyaml" {
  bucket = aws_s3_bucket.microk8s-resources.id
  key    = "k8s/deployment.yaml"
  source = "./k8s/deployment.yaml"
  etag   = filemd5("./k8s/deployment.yaml")
}
