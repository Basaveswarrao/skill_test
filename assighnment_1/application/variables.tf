# Variables Configuration

variable "cluster-name" {
  default     = "eks-cluster"
  type        = string
  description = "The name of your EKS Cluster"
}
variable "sg-name" {
  default     = "k8s-sg"
  type        = string
  description = "The name of your Node Security Groups"
}
variable "aws-region" {
  default     = "eu-west-1"
  type        = string
  description = "The AWS Region to deploy EKS"
}


variable "k8s-version" {
  default     = "1.21"
  type        = string
  description = "Required K8s version"
}

variable "kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the node kubelet process"
}

variable "public-kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the public node kubelet process"

}

variable "node-instance-type" {
  default     = "t2.micro"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "bastion-instance-type" {
  default     = "t2.micro"
  type        = string
  description = "Bastion Node EC2 instance type"
}
variable "root-block-size" {
  default     = "10"
  type        = string
  description = "Size of the root EBS block device"
}

variable "desired-capacity" {
  default     = 3
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 3
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 0
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "key_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with key_name."
  type        = string
  default     = null
}
variable "default-labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {"name"="default-pool"}
}

variable "remote_state_bucket" {
  default     = "terraform-assets-ex1"
  type        = string
  description = "The s3 bucket name of your tfstate file  storing"
}

variable "remote_state_region" {
  default     = "us-east-2"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "networking_remote_state_key" {
  default     = "Backend-VPC/terraform.tfstate"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "network-name" {
  default     = "Backend"
  type        = string
  description = "The name of your EKS Cluster"
}