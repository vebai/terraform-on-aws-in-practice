terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

variable "aws_region" {
  description = "AWS Region for the exercise"
  type        = string
  default     = "eu-west-2"
}

variable "bucket_name" {
  description = "Globally unique bucket name, supplied by the reader"
  type        = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
