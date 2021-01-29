## AWS Terraform Example

```
Terraform code that created a Load Balanced / Auto Scaling Group controlled Web Application that would run in AWS. across two availability zones in a non default VPC
```

```

Note:

With instructions below please bear in mind what role Arn has ben assigned to you. Also bear in mind new security tags restrictions newly implemented in AWS

Key Pairs
---------

So in order to give users the ability to ssh onto the newly crated Linux vms we ae going to use the aws_key_pair resource we have to create a key up front in AWS.

Goto the Key Pairs screen in AWS
    click Create key pair button top right
        Give your key a name i.e chapter5
                leave pem radio button                  
        Click create key pair

    Your key will be downloaded to your pc
    Store in the following directory for thus exercide [ ~/certification/keypair/keypair/]

    Create a corresponding public key from your pem/private key
            Follow this link  :  https://docs.jamcracker.com/latest/Knowledge%20Hub/topic/public_key.html

                ssh-keygen -y -f <private_key1.pem > <public_key1.pub>
                [rem to chmod your private key 400 - to restrict access to it ]
                
            Place this in the same folder. 
            Call it chapter5.pub
                

```


```

How to use mfa Assumed role script : start_aws_profile.sh 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Step 1:
=======

How to set up ~/.aws/config
---------------------------
[profile default]
#region = eu-west-2
region = us-east-2

[profile dev]
region = us-east-2
#region = eu-west-2
source_profile = mfa
role_arn = arn:aws:iam::904806826062:role/OrganizationEngineerAccessRole

How to set up ~/.aws/credentials
---------------------------------

[default]
aws_access_key_id = <default key id>
aws_secret_access_key = <default access key>

[mfa]


Step 2:
=======

export AWS_PROFILE=dev
export AWS_SDK_LOAD_CONFIG=1


Step 3:
=======

./start_aws_profile.sh mfa michalugbechie <mfa number from fob>

Your ~/.aws/credentials file will be automatically updated with assumed role key id and access key


```
