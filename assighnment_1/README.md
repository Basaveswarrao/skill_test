### Assighnment-1:
A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these resources.
This pattern divides the infrastructure into 3 separate layers: one public and 2 private layers. The idea is that the public layer acts as a shield to the private layers

In public subnet, I have created Bastion instance to access the EKS cluster worker nodes at times.

In private subnets I have created EKS cluster where all the applications can be containarized with in the cluster and RDS been placed outside the cluster having its separate layer of private subnet DB groups. 


The architectural Diagram is as show in the picture below:
![3-tier](https://user-images.githubusercontent.com/41645323/138348587-8f47365a-ece6-44fd-8ec9-e96412add4f4.jpg)


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

Path : `Statefile_Locking/`
		
Update the below options according to your need/choice from - variable.tf
- tf_bucket_name
- eks_dynamo_table
- aws-region
- vpc_dynamo_table

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

Path : `Backend-Network/variable.tf`

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
7. RDS in DB subnet Group

_**Steps to deploy the K8s Cluster**_

_**Once Backend-Network creates then go to eks-cluster Folder**_

Path : `application`

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

Once the terraform apply completes, export your kubeconfig file to query or communicate with the cluster.

```bash
terraform output kubeconfig > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
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


You can destroy this cluster entirely by running:

```bash
terraform destroy
terraform plan -destroy
terraform destroy  --force
```


