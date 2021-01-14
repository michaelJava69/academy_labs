Lab 11 - 02 - Partial Configuratoin

Part 1 - Configure a Terraform remote backend using the S3 bucket and Dynamodb Lock table resources created in the previous steps.
Note that variables are not allowed in a terraform backend configuration. For example, the code below would produce an error.
terraform {
  required_version = ">= 0.13, < 0.14"


  backend "s3" {
    bucket         = var.bucket
    region         = var.region
    dynamodb_table = var.dynamodb_table
    key            = "example/terraform.tfstate"
    encrypt        = true
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
A workaround for this issue is to use a partial configuration. With a partial configuration, certain arguments are omitted from the backend configuration in the terraform code block and are instead passed in by specifying the -backend-config command-line argument when you run terraform init.

create main.tf


terraform {
  required_version = ">= 0.13, < 0.14"

  backend "s3" {
    key = "example-11-02/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

note the partial configuration in the backend block. The remaining arguments (bucket, dynamodb_table, and region) will be passed in via the -backend-config argument to terraform init



create backend.hcl


bucket         = <your-s3-bucket-name>
dynamodb_table = <your-dynamodb-table-name>
region         = "eu-west-2"
encrypt        = true

terraform init -backend-config=backend.hcl


Note that the partial configuration in backend.hcl is merged with the partial configuration in the Terraform backend code block to produce the full configuration.



terraform apply


aws s3 ls --recursive s3://<your-s3-bucket-name>



note that another folder has been created with the key example-11-02



Part 2 - Unconfiguring the backend

in main.tf remove the backend config

terraform {
  required_version = ">= 0.13, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

run terraform init


You should see
Initializing the backend...
Terraform has detected you're unconfiguring your previously set "s3" backend.
Do you want to copy existing state to the new backend?
Pre-existing state was found while migrating the previous "s3" backend to the
newly configured "local" backend. No existing state was found in the newly
configured "local" backend. Do you want to copy this state to the new "local"
backend? Enter "yes" to copy and "no" to start with an empty state.
Enter a value:
Entering yes, you should see a terraform.tfstate file containing the terraform state in the local file system.


run terraform destroy


run terraform state pull


{
  "version": 4,
  "terraform_version": "0.13.5",
  "serial": 4,
  "lineage": "e8457cbf-303c-e97a-8efb-fc2c22e78eca",
  "outputs": {},
  "resources": []
}

in main.tf add the backend config back in

terraform {
  required_version = ">= 0.13, < 0.14"

  backend "s3" {
    key = "example-11-02/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


terraform init -backend-config=backend.hcl


terraform state pull


{
  "version": 4,
  "terraform_version": "0.13.5",
  "serial": 2,
  "lineage": "e8457cbf-303c-e97a-8efb-fc2c22e78eca",
  "outputs": {},
  "resources": [
    {
      "mode": "data",
      "type": "aws_ami",
      "name": "ubuntu",
      "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "architecture": "x86_64",
            "arn": "arn:aws:ec2:eu-west-2::image/ami-0ff4c8fb495a5a50d",
            "block_device_mappings": [
              {
                "device_name": "/dev/sda1",
                "ebs": {
                  "delete_on_termination": "true",
                  "encrypted": "false",
                  "iops": "0",
                  "snapshot_id": "snap-087023d5eeb418d5b",
                  "volume_size": "8",
                  "volume_type": "gp2"
                },
                "no_device": "",
                "virtual_name": ""
              },
              {
                "device_name": "/dev/sdb",
                "ebs": {},
                "no_device": "",
                "virtual_name": "ephemeral0"
              },
              {
                "device_name": "/dev/sdc",
                "ebs": {},
                "no_device": "",
                "virtual_name": "ephemeral1"
              }
            ],
            "creation_date": "2020-10-27T01:02:33.000Z",
            "description": "Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2020-10-26",
            "executable_users": null,
            "filter": [
              {
                "name": "name",
                "values": [
                  "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
                ]
              },
              {
                "name": "virtualization-type",
                "values": ["hvm"]
              }
            ],
            "hypervisor": "xen",
            "id": "ami-0ff4c8fb495a5a50d",
            "image_id": "ami-0ff4c8fb495a5a50d",
            "image_location": "099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026",
            "image_owner_alias": null,
            "image_type": "machine",
            "kernel_id": null,
            "most_recent": true,
            "name": "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026",
            "name_regex": null,
            "owner_id": "099720109477",
            "owners": ["099720109477"],
            "platform": null,
            "product_codes": [],
            "public": true,
            "ramdisk_id": null,
            "root_device_name": "/dev/sda1",
            "root_device_type": "ebs",
            "root_snapshot_id": "snap-087023d5eeb418d5b",
            "sriov_net_support": "simple",
            "state": "available",
            "state_reason": {
              "code": "UNSET",
              "message": "UNSET"
            },
            "tags": {},
            "virtualization_type": "hvm"
          }
        }
      ]
    }
  ]
}

note that the state is out of sync


terraform state push terraform.tfstate

terraform state push will manually overwrite the remote state. It is a risky operation and should be avoided if possible. It can, however, be used to do manual fixups if neccessary. Having versioning enabled in the S3 bucket used as the terraform remote backend store provides the ability to access older versions of state files. If you do not have versioning enabled, it is recommended that you make a backup of the state file with terraform state pull prior to overwriting the state.


delete the local copy of terraform.tfstate


run terraform state pull



note that the state is again in sync


Verify with aws s3 cp s3://<your-s3-bucket-name>/example-11-02/terraform.tfstate -
