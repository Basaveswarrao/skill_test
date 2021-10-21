### Challenge:2
We need to write code that will query the meta data of an instance within AWS and provide a json formatted output

# Ansible-Playbook to get metadata of ec2 in JSON format.

Instance metadata is data about your instance that you can use to configure or manage the running instance. 

## Pre-requisites
To run the ansible playbook, we require following:
#### boto3
#### python3
#### ansible

```javascript
Install ansible using:
# pip install ansible
```

  
## API Reference

#### Query this inside ec2, gives us metadata.

```http
  curl http://169.254.169.254/latest/meta-data/
```



  
## Deployment

To Run the playbook Execute:

```bash
  ansible-playbook -i inventory_aws_ec2.yml meta-data.yml
```



  
## Environment Variables/ Input

To run this project, you will need to add the following environment variables to the playbook and inventory file

### In meta-data.yml

`ansible_ssh_private_key_file` : common SSH key to login to ec2.

`ansible_user`: User to login to ec2 ex: ec2-User

### In inventory_aws_ec2.yml:

`aws_profile`: AWS access profile name to connect to console and list the resources dynamically.


  