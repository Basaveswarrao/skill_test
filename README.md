## Deployment Guide:

### Terraform

You need to run the following commands to create the resources with Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## 1. Terraform Statelocking

_**Start with Terraform Statefile_Locking**_

Path : `insight-aws-pipeline/infrastructue/terraform/backend/Statefile_Locking/`
		
Update the below options according to your need/choice from - variable.tf
- tf_bucket_name
- eks_dynamo_table
- helm_dynamo_table
- aws-region
- vpc_dynamo_table
- vpc_grafana_table

_**Open GIT bash/Mac terminal and run below commands.**_

```bash
terraform init
terraform plan
terraform apply
```
##  2. Backend Network

## What resources will create

1. VPC
2. Internet Gateway (IGW)
3. Public and Private Subnets
4. Security Groups, Route Tables and Route Table Associations

**_Once *Statefile_Locking* creates then go to *Backend-Network* Folder_**

Path : `insight-aws-pipeline/infrastructue/terraform/backend/Backend-Network/variable.tf`

```
Update the below options according to your need/choice from - variable.tf.
- network-name
- aws-region
- availability-zones
```

```
Replace the below options according to your need/choice from - backend.tf.

bucket 
key       
region 
dynamodb_table
```


**_Open GIT bash/Mac terminal and run below commands._**
```bash
terraform init
terraform plan
terraform apply
```

## 3. An EKS Cluster

## What resources will create
1. EKS Managed Node group
2. Autoscaling group and Launch Configuration
3. Worker Nodes in a private Subnet
4. bastion host for ssh access to the VPC
5. The ConfigMap required to register Nodes with EKS
6. KUBECONFIG file to authenticate kubectl using the `aws eks get-token` command. needs awscli version `1.16.156 >`

_**Steps to deploy the K8s Cluster**_

_**Once Backend-Network creates then go to eks-cluster Folder**_

Path : `insight-aws-pipeline/infrastructue/terraform/backend/eks-cluster`

```
Update the below options according to your need/choice from - variable.tf.
- cluster-name 
- aws-region
- availability-zones
- remote_state_bucket
- remote_state_region
- remote_state_region
- remote_state_region
```


```
Replace  the below options according to your need/choice from - backend.tf.

- bucket 
- key       
- region      
- dynamodb_table 
```

_**Open GIT bash/Mac terminal and run below commands.**_

```bash
terraform init
terraform plan
terraform apply
```
### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubeconfig > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
```
## 4. Services
_**Once Cluster is ready then go to tenant Folder**_

Path : `insight-aws-pipeline/infrastructue/terraform/tenant`

Open GIT bash/Mac terminal and run below commands.
```
terraform init
terraform plan
```
## What resources will create
- Kafka strimizi
- Elastic Services
- Presto
- kafka-connect-service
- Prometheus

## 5. Grafana+Loki Deployment: 

path : `insight-aws-pipeline/infrastructue/terraform/backend/grafana-loki`

```
Update the below options according to your need/choice from - variable.tf.
- grafana-name 
- aws-region
- grafana-instance-type
- availability-zones
- remote_state_bucket
- remote_state_region
- networking_remote_state_key
- network-name
```

```
Replace  the below options according to your need/choice from - backend.tf.
- bucket 
- key       
- region      
- dynamodb_table 
```

Open GIT bash/Mac terminal and run below commands.
```
terraform init
terraform plan
terraform apply	
```

## Configuration

You can configure you config with the following input variables:

| Name                      | Description                        | Default                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `cluster-name`            | The name of your EKS Cluster       | `eks-cluster`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `aws-region`              | The AWS Region to deploy EKS       | `us-east-1`                                                                                                                                                                                                                                                                                                                                                                                                      |
| `availability-zones`      | AWS Availability Zones             | `["us-east-1a", "us-east-1b", "us-east-1c"]`                                                                                                                                                                                                                                                                                                                                                                     |
| `k8s-version`             | The desired K8s version to launch  | `1.13`                                                                                                                                                                                                                                                                                                                                                                                                           |
| `node-instance-type`      | Worker Node EC2 instance type      | `m4.large`                                                                                                                                                                                                                                                                                                                                                                                                       |
| `root-block-size`         | Size of the root EBS block device  | `200`                                                                                                                                                                                                                                                                                                                                                                                                             |
| `desired-capacity`        | Autoscaling Desired node capacity  | `2`                                                                                                                                                                                                                                                                                                                                                                                                              |
| `max-size`                | Autoscaling Maximum node capacity  | `5`                                                                                                                                                                                                                                                                                                                                                                                                              |
| `min-size`                | Autoscaling Minimum node capacity  | `1`                                                                                                                                                                                                                                                                                                                                                                                                              |                                                                                                                                                                                                                                                                                                                                                                                                      |
| `vpc-subnet-cidr`         | Subnet CIDR                        | `10.0.0.0/16`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `private-subnet-cidr`     | Private Subnet CIDR                | `["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]`                                                                                                                                                                                                                                                                                                                                                                |
| `public-subnet-cidr`      | Public Subnet CIDR                 | `["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]`                                                                                                                                                                                                                                                                                                                                                            |
| `db-subnet-cidr`          | DB/Spare Subnet CIDR               | `["10.0.192.0/21", "10.0.200.0/21", "10.0.208.0/21"]`                                                                                                                                                                                                                                                                                                                                                            |
| `eks-cw-logging`          | EKS Logging Components             | `["api", "audit", "authenticator", "controllerManager", "scheduler"]`                                                                                                                                                                                                                                                                                                                                            |
| `ec2-key-public-key`      | EC2 Key Pair for bastion and nodes | `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com` |



### IAM

The AWS credentials must be associated with a user having at least the following AWS managed IAM policies

* IAMFullAccess
* AutoScalingFullAccess
* AmazonEKSClusterPolicy
* AmazonEKSWorkerNodePolicy
* AmazonVPCFullAccess
* AmazonEKSServicePolicy
* AmazonEKS_CNI_Policy
* AmazonEC2FullAccess

In addition, you will need to create the following managed policies

*EKS*

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```


> TIP: you should save the plan state `terraform plan -out eks-state` or even better yet, setup [remote storage](https://www.terraform.io/docs/state/remote.html) for Terraform state. You can store state in an [S3 backend](https://www.terraform.io/docs/backends/types/s3.html), with locking via DynamoDB



### Authorize users to access the cluster

Initially, only the system that deployed the cluster will be able to access the cluster. To authorize other users for accessing the cluster, `aws-auth` config needs to be modified by using the steps given below:

* Open the aws-auth file in the edit mode on the machine that has been used to deploy EKS cluster:

```bash
sudo kubectl edit -n kube-system configmap/aws-auth
```

* Add the following configuration in that file by changing the placeholders:


```yaml

mapUsers: |
  - userarn: arn:aws:iam::111122223333:user/<username>
    username: <username>
    groups:
      - system:masters
```

So, the final configuration would look like this:

```yaml
apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::555555555555:role/devel-worker-nodes-NodeInstanceRole-74RF4UBDUKL6
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::111122223333:user/<username>
      username: <username>
      groups:
        - system:masters
```

* Once the user map is added in the configuration we need to create cluster role binding for that user:

```bash
kubectl create clusterrolebinding ops-user-cluster-admin-binding-<username> --clusterrole=cluster-admin --user=<username>
```

Replace the placeholder with proper values

### Cleaning up
## Follwo the below sequence to*Destroy the infrastructure	
1) Start with Grafana+loki
2) tenant
3) Cluster
4) Backend-Network
5) Statefile_Locking 

You can destroy this cluster entirely by running:

```bash
terraform destroy
terraform plan -destroy
terraform destroy  --force
```


