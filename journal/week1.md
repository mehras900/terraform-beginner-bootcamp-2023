# Terraform Beginner Bootcamp 2023 - Week 1

### Table of contents(TOC)


## 1. Root Module Structure
Our root module structure is as follows:

```
<root_module>/
├── README.md                # Describes the Terraform module/configuration and its usage.
├── main.tf                  # Contains the primary set of Terraform resources and configurations.
├── variables.tf             # Declares variables for customizing the Terraform configuration.
├── outputs.tf               # Defines values to output after provisioning infrastructure(like, bucket name, arn, etc).
├── providers.tf             # Configures the providers (e.g., AWS, Azure, GCP) Terraform uses.
├── terraform.tfvars         # Sets default or specific values for the declared variables.
```

### 1.1 Errors that you might run into!!!
1. While running terraform plan, you might run into following error:


    ![Alt text](../public/assets/errors/tf_plan_err_because_of_aws_creds_not_available_intf_cloud.png)

    Our terraform state is stored in Terraform Cloud, but it doesn't have AWS Access & Secret access keys stored as environment variables to interact with AWS API. 

    Therefore, to fix above error:  
    - Go to Terraform Cloud UI
    - Select the workspace
    - Click on variables and add AWS keys as env variables, mark it as sensitive.
    - run `terraform plan` again

    
 
2. While running terraform plan, the other error you may encounter is as follows: 

    ![Alt text](../public/assets/errors/tf_plan_err_because_of_something_wrong_with_tf_cloud_token.png)

Above error mostly arises because of the incorrect/expired token or sometimes if the token is generated at the wrong place

In this case, I encountered the above error because I generated the 'Organizational Token', which is used to manage teams, team membership and workspaces. This **token does not have permission to perform plans** and applies in workspaces.

Correct way to create the user token:
- Click on user profile icon
- Click on `User Settings` --> Click on tokens
- Create New API Token


## 2. Talk about variables, kind of variables, how to pass those(loading of tf veraibles) and what's the order of prescedence of variables in terraform

### 2.1 Types of variables

There are two kind of variables in terraform:

- **Terrform variables**:    These variables should match the declarations in your configuration, like in variables.tf

- **Environment variables**: These variables are available in the Terraform runtime environment.

### 2.2 Passing variables to TF plan

Variables can either be picked up from default value defined for variables in `variables.tf` file or from `terrform.tfvars` file.

Providing a value for a variable in the terraform.tfvars file is not mandatory if we have already defined a default value for that variable.

In addition to the terraform.tfvars file, you can assign a value to a variable using the -var option when executing the terraform plan command.

```
terraform plan -var "user_uuid=aaaaaaa-bbbb-cccc-dddd-330eeeeeeeee"
```

### 2.3 Terraform varibales `Order Of Precedence`

```
High Priority
     ^                     
     |
     |        command line (-var & -var-file)
     |                       ^
     |                       |
     |                  .auto.tfvars
     |                       ^
     |                       |
     |              terraform.tfvars file
     |                       ^
     |                       |
     |                    env vars
     |                       ^
     |                       |
     |                    defaults
Low Priority

```
### 2.4 Migrating the state from cloud to local again
 In order to migrate the state back from Terraform Cloud to local again, comment out the following section in `providers.tf` file along with the `init` command

 ```tf
 cloud {
    organization = "tfbootcamp-2023"

    workspaces {
      name = "terrahouse-1"
    }
  }
 ```
, and run
```tf
terraform init
```
But, you may run into below error:


  ![Alt text](../public/assets/errors/init_error_while_migrating_state_from_tf_cloud_to_local.png)

  To fix this, delete `.terraform.lock.hcl` file and `.terraform` directory and run `terrform init` again.

  ###### 2.5 Is whatever we did above in Migrating the state from cloud to local again the correct way? --> `TODO`

  ## 3. Dealing with Configuration drift

  ### 3.1 What happens when you lost your terraform state file
When you lose your Terraform state file:

  - It leads to **Loss of Mapping**. Terraform will have no knowledge of the resources it has managed. This disconnect means that Terraform can't manage, modify, or destroy the previously created resources based on your configurations.

  - If you try to run terraform apply during this time, Terraform will likely attempt to create new instances of all resources defined in your configurations, leading to potential resource conflicts or duplications, which is not **BEARABLE** **in** **PRODUCTION**.

  **Solution**:

- **Terraform Import**: Use the terraform import command to reassociate each resource in your configuration with its real-world instance. This manual process can be tedious for large infrastructures.
- **Backup Strategy**: Always back up your state files, especially if stored locally. For production workloads, consider using remote state storage solutions like Terraform Cloud, AWS S3, or other backends that allow versioning and backup capabilities.

In this bootcamp, we purposly deleted the `terraform.tfstate` file and then tried to bring back previously existing stage by importing the resources.

**Note**: `Some resources simply could not be imported back into state, like random_string. It will lead to recreation of existing resources which is not possible sometimes.

We are removing random_string resources in this section as using might not be best use case for future sections.

### 3.2 Fix missing resources with terraform import
If certain resources are missing from the state file but exist in the real-world environment, you can use the terraform import command:

```
# Importing random string
terraform import random_string.bucket_name kj6aabzpfzte3mk226o5tdjioko37if1

# Import S3 bucket
terraform import aws_s3_bucket.example kj6aabzpfzte3mk226o5tdjioko37if1
```

Checkout he docs for [Random string import](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import) and [S3 buckket import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### 3.3 Manual configuration
Any manual changes made to the infra managed by terraform are usually detected by terrafor plan.

Educate teams on Terraform-first changes, restrict infrastructure modification access, utilize monitoring for change alerts, run frequent terraform plan for drift detection, and enforce standards using tools like Sentinel in Terraform Cloud/Enterprise.

## 4. Terraform Modules

### 4.1 Terraform Module Structure
A Terraform module is a set of Terraform configuration files in a single directory. 

Sample terraform module structure is shown below:

```tf
$ tree modules/terrahouse_aws
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

### 4.2 Passing Input Variables 
- Initially, you must declare the variables you intend to provide values for within the child module. This can be accomplished by creating a [variables.tf](/modules/terrahous_aws/variables.tf) file within the [child module's](/modules/terrahous_aws) directory. Here's an example:

```tf
  variable "user_uuid" {
  type        = string
  description = "The Terraform BootCamp UUID"

  validation {
    condition     = length(var.user_uuid) > 5
    error_message = "User UUID provided is not VALID, please check!!!"
  }
}


variable "bucket_name" {
  description = "The name of the S3 bucket, should be all lowercase."
  type        = string
  validation {
    condition     = !can(regex("[A-Z]", var.bucket_name))
    error_message = "The bucket_name must not contain uppercase letters."
  }
}
```

- Next, you should use these variables within the child module wherever they are required. For example, if you're creating an AWS S3 bucket, you might implement it like this:

  ```tf
  resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUUID = var.user_uuid
    managedBy = "terraform"
  }
  }
  ```

- Lastly, when invoking the child module from the parent module, you have the ability to supply values to these variables. This is achieved in the following manner:

  ```
  module "terrahous_aws" {
    source = "./modules/terrahous_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
    } 
  ```


### 4.3 Modules Sources
Modules can be sourced from a variety of locations. Some common sources are:

- Local paths
- GitHub
- Terraform Registry
- S3 buckets