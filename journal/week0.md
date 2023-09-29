# Terraform Beginner Bootcamp 2023 - Week 0

### Table of contents(TOC)

- [1. Semantic Versioning](#1-semantic-versioning)
  * [1.1 How to delete tags locally and remotely](#11-how-to-delete-tags-locally-and-remotely)
  * [1.2 How to have a graph view of branch](#12-how-to-have-a-graph-view-of-branch)
- [2. Refactoring Terraform CLI](#2-refactoring-terraform-cli)
  * [2.1 Create new bash script that installs Terraform CLI](#21-create-new-bash-script-that-installs-terraform-cli)
  * [2.2 Understanding Shebang](#22-understanding-shebang)
  * [2.3 How to make bash script executable?](#23-how-to-make-bash-script-executable)
  * [2.4 Update the `gitpod.yml` to use bash script and use `before` gitpod lifecycle.](#24-update-the-gitpodyml-to-use-bash-script-and-use-before-gitpod-lifecycle)
- [3. ENV Vars in Gitpod](#3-env-vars-in-gitpod)
  * [3.1 Ways of setting user-specific environment variables](#31-ways-of-setting-user-specific-environment-variables)
- [4. Refactoring AWS CLI](#4-refactoring-aws-cli)
  * [4.1 New bash script `aws_cli_install.sh` that installs AWS CLI](#41-new-bash-scriptaws_cli_installsh-that-installs-aws-cli)
  * [4.2 Get Access Keys](#42-get-access-keys)
  * [4.3 Use gitpod's env variables](#43-use-gitpods-env-variables)
  * [4.4 Verification](#44-verification)
- [5. Terraform Basics](#5-terraform-basics)
  * [5.1 Terraform Registry](#51-terraform-registry)
    + [5.1.1 Terrform Providers](#511-terrform-providers)
    + [5.1.2 Terrform Modules](#512-terrform-modules)
  * [5.2 Terraform commands](#52-terraform-commands)
  * [5.3 Terraform state and lock files](#53-terraform-state-and-lock-files)
    + [5.3.1 Terraform State file](#531-terraform-state-file)
    + [5.3.2 Terraform lock file](#532-terraform-lock-file)
- [6. Create S3 bucket with random name](#6-create-s3-bucket-with-random-name)
  * [6.1 Install AWS S3 provider](#61-install-aws-s3-provider)
  * [6.2 Create S3 bucket with a random name](#62-create-s3-bucket-with-a-random-name)
- [7 Terraform Cloud backend](#7-terraform-cloud-backend)
  * [7.1 Issues with terraform cloud login in gitpod workspace](#71-issues-with-terraform-cloud-login-in-gitpod-workspace)
  * [7.2 Migrate local state to terraform cloud](#72-migrate-local-state-to-terraform-cloud)
- [8 Bash script to automate steps in section - 6.1](#8-bash-script-to-automate-steps-in-section---61)
- [9 Create a Bash Script for setting the `tf` alias](#9-create-a-bash-script-for-setting-the-tf-alias)






## 1. Semantic Versioning

Semantic versioning is a versioning scheme for software that aims to convey meaning about the underlying changes in a release. Semantic versioning consists of three main components: **MAJOR, MINOR, and PATCH** versions, often written as X.Y.Z(For example: `0.1.0`) 

Here's what each component means:

- **MAJOR version**: This is typically incremented when there are incompatible changes that require modifications in the way the software interacts with other components. This might include breaking changes to the API or fundamental changes in functionality. For example, going from version `1.0.0` to `2.0.0`

- **MINOR version**: This is incremented when new capabilities have been introduced without disrupting existing integrations. For instance, upgrading from version `1.2.0` to `1.3.0`

- **PATCH version**: This is incremented when you make backward compatible bug fixes or minor improvements that do not introduce new features.  For example, moving from version `1.2.3` to `1.2.4`


### 1.1 How to delete tags locally and remotely
In order to delete a local Git tag, use the “git tag” command with the “-d” option.

```
$ git tag -d <tag_name>

Example: git tag -d 0.1.0 
```

In order to delete a remote Git tag(from github repo), use the “git push” command with the “–delete” option and specify the tag name.
```
$ git push --delete origin tagname

Example: git push --delete origin 0.1.0
```

### 1.2 How to have a graph view of branch

Sometimes you need see an icon for graph view. In order to have that please install `git log --graph` plugin.

## 2. Refactoring Terraform CLI

### 2.1 Create new bash script that installs Terraform CLI
Following commands in `gitpod.yaml` were showing deprecated warnings and requires user input to perform full terraform cli installation 

```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
      
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
      
sudo apt-get update && sudo apt-get install terraform

```

We've created a new bash script that fixes the above issue of deprecated warnings and user input. It is placed under [terraform_cli_install.sh](./bin/terraform_cli_install.sh)


### 2.2 Understanding Shebang

We've used `#!/usr/bin/env bash` as the bash interpreter in our script, but what is the difference between `#!/usr/bin/env bash` and `#!/bin/bash`

```
while both shebang lines specify that the script should be interpreted using Bash, 

#!/usr/bin/env bash offers greater flexibility and portability because it relies on the user's environment to locate the Bash interpreter, making it a common choice for cross-platform compatibility. 

However, #!/bin/bash is more explicit and may be preferred in situations where you want to ensure a specific Bash interpreter is used.

```


### 2.3 How to make bash script executable?

In order to make bash script([terraform_install_cli.sh](./bin/terraform_cli_install.sh)) executable, you can use following command

```
$ ls -la bin/
-rw-r--r-- 1 gitpod gitpod 567 Sep 21 10:44 terraform_cli_install.sh

chmod u+x bin/terraform_cli_install.sh   <-- # This will update the permissions and make the script executable.

ls -la bin/
-rwxr--r-- 1 gitpod gitpod 567 Sep 21 10:44 terraform_cli_install.sh
```

Permissions are as follows:
```
Permissions:
r <-> read     <-> 4
w <-> write    <-> 2
x <-> execute  <-> 1
--------------------
Total:       4+2+1=7
```

### 2.4 Update the [gitpod.yml](./.gitpod.yml) to use bash script and use `before` gitpod lifecycle.

We have added following block in `gitpod.yml`, where we replaced the set of individual commands with the bash script that installs terraform cli 

```
before: |
      source ./bin/terraform_cli_install.sh
```

Few points to keep in mind for gitpod task lifecyle:

- Gitpod executes the before and most importantly, init tasks automatically for each new commit to your project.
- When you restart a workspace, Gitpod don't execute the init task again either as part of a Prebuild, it only executes the before and command tasks.
- Execution order of tasks is `before(1st) --> init(2nd) --> command(3rd)`

For more information about gitpod task lifecylce, please checkout 
[task lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks#restart-a-workspace)

## 3. ENV Vars in Gitpod

To check environment variables use:
```
$ env

##You can fetch any specific env variable using grep##
$ env | grep -i <var_name>
```

### 3.1 Ways of setting user-specific environment variables
 - Using the command line: `gp env`
   
   The gp CLI prints and modifies the persistent environment variables associated with your user for the current repository.

   To set the persistent environment variable foo to the value bar use:

   ```
   gp env foo=bar
   ```
   This does not modify your current terminal session, but rather **persists this variable for the next workspace on this repository**. gp can only interact with the persistent environment variables for this repository, not the environment variables of your terminal.


- Using the account settings

  You can also configure and view the persistent environment variables in your account settings


## 4. Refactoring AWS CLI

### 4.1 New bash script([aws_cli_install.sh](/bin/aws_cli_install.sh)) that installs AWS CLI

You can refer [aws document](https://docs.aws.amazon.com/cli/v1/userguide/install-linux.html) to get the commands required to install the AWS CLI in linux.

Create a new bash script that installs AWS CLI. Copy the following contents from `gitpod.yml` and place it in [aws_cli_install.sh](/bin/aws_cli_install.sh)

Bash script([aws_cli_install.sh](/bin/aws_cli_install.sh)) content:
```
#!/usr/bin/env bash

cd /workspace

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qo awscliv2.zip
sudo ./aws/install --update

cd $PROJECT_ROOT

```

In the `unzip -qo awscliv2.zip` command, `'q'` stand for performing operations quietly (-qq = even quieter), and `'o'` stands for overwriting the existing files without prompting.

or, probably you could delete the exiting cli and it's contents using below in the bash script. It will not ask for prompts if delete it before re-intsalling the same cli.

```
#!/usr/bin/env bash

cd /workspace
rm -f awscliv2.zip.   <-- Added this
rm -rf aws            <-- Added this
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip.   <-- Changed this
sudo ./aws/install    <-- Changed this

cd $PROJECT_ROOT
```

### 4.2 Get Access Keys

You need to have an AWS account. Please set it up if you don't have one using [AWS Setup Link](https://aws.amazon.com/free/?trk=58b3b422-9e3d-4d31-a50d-c6f8b1a5161a&sc_channel=ps&ef_id=CjwKCAjwmbqoBhAgEiwACIjzEICLt2B9k7hEt32xHUyzaZcqNMtCtN_w-0V03WpEP21cXmKFl-gWzBoCZc8QAvD_BwE:G:s&s_kwcid=AL!4422!3!507852355859!p!!g!!amazon%20web%20services!12580566202!118888769039&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)

Once you have your account, you need to create new user using `AWS IAM` service.

- Login to AWS console
- Go to IAM service
- Create new user with any name, I've used `tfbootcomp` and add it in a group(I used group name as `Admin`), and finally grant `AdministratorAccess` permissions to the group. Note that this user doesn't need to have `console access` for now.
- Once user is created, click on `user` --> `security credentials` --> create new `access keys`.` 

**WARNING:** 
DON'T EVER EVER EVER EVER EVER PROVIDE THESE KEYS TO ANYONE OR STORE IT IN GITHUB.

### 4.3 Use gitpod's env variables 

These keys can be stored as env variables in the terminal or workspace.

You have to run following commands to export the keys as the env variables:
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=1234567xxxxxxxxx
export AWS_DEFAULT_REGION=ca-central-1
```

Note that above are not the actual keys. So, don't even think about using it :wink: 

### 4.4 Verification

In order to verify whether that AWS CLI has properly configured to interact with AWS, use following command. The following `get-caller-identity` command displays information about the IAM identity used to authenticate the request. The caller is an IAM user.

```
aws sts get-caller-identity
```
```
Sample Output:

{
    "UserId": "AIDASAMPLEUSERID",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/tfbootcamp"
}
```


## 5. Terraform Basics

### 5.1 Terraform Registry
The [Terraform Registry](https://registry.terraform.io/) is a collection of publicly available Terraform modules and providers. It allows users to share and reuse configurations.

#### 5.1.1 Terrform Providers
A [provider](https://registry.terraform.io/browse/providers) in Terraform is a plugin that enables interaction with an API. The providers are specified in the Terraform configuration code. They tell Terraform which services it needs to interact with.

Example provider:
```
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}
```

#### 5.1.2 Terrform Modules
A [Terraform module](https://registry.terraform.io/browse/modules) is a collection of standard configuration files in a dedicated directory and set of resources for reuse. It way of making large code modular, shareble and portable

Example module:
```
module "custom_module" {
    source = "./custom_module"
    # ... other config ...
}
```

### 5.2 Terraform commands
- **terraform -help**: Get a list of available commands for execution with descriptions.

- **terraform init**: In order to prepare the working directory for use with Terraform, the terraform init command performs `Backend Initialization`, `Child Module Installation`, and `Plugin Installation`. Generates a ``.terraform/`` directory containing provider plugins.

- **terraform plan**: It will generate an execution plan, showing you what actions will be taken without actually performing the planned actions. No new files/directories by default.

- **terraform apply**: Applies the proposed changes to the infrastructure. It updates or creates `terraform.tfstate` and may create `terraform.tfstate.backup`.

- **terraform console**: Provides an interactive shell to evaluate Terraform expressions.

- **terraform validate**: Checks the configuration for syntax and basic errors. It does not access any remote state or services. `terraform init` should be run before this command

- **terraform fmt**: Reformats configuration in HCL language standard.

- **terraform output**: Displays the values of outputs currently held in the state file.

- **terraform destroy**: Destroy the infrastructure managed by Terraform.

Above are just few examples of terraform commands. For full comprehensive list, you can refer [More Terraform Commands](https://spacelift.io/blog/terraform-commands-cheat-sheet).

### 5.3 Terraform state and lock files
#### 5.3.1 Terraform State file
- **terraform.tfstate**: Terraform uses this file to track the state of the infrastructure it manages. The state file contains information about the resources that Terraform has created and has all the associated attributes to the infra like usernames, passwords or any other sensitice info.

  The `terraform.tfstate` file is created automatically by Terraform when you run `terraform apply` for the first time

- **terraform.tfstate.backup**: The `terraform.tfstate.backup` file is a backup of the `terraform.tfstate` file. Terraform automatically creates a backup of the state file before making any changes to the state file. This ensures that you can recover from a corrupted or lost state file.

  The terraform.tfstate.backup file is stored in the same directory as the terraform.tfstate file

  Here are some reasons why you might need to restore your Terraform state from a backup:

  - If the terraform.tfstate file is corrupted or lost.
  - If you accidentally delete a resource from Terraform management.
  - If you need to revert to a previous version of your infrastructure.

**Important Note**: It is never advisable to commit .tfstate or .tfstate.backuo files to github or VCS.

#### 5.3.2 Terraform lock file

- **.terraform.lock.hcl**: It's a lock file that pins the versions of providers and modules, ensuring a consistent environment across operations and team members.

This **should be commited** in your VCS or source control repository


## 6. Create S3 bucket with random name

### 6.1 Install AWS S3 provider

We need to have s3 provider installed before creating the s3 bucket. Copy and paste the following code into your Terraform configuration file, `main.tf` in our case. Then, run terraform init to download the s3 provider plugin.

Doc link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

### 6.2 Create S3 bucket with a random name

In this step, we are creating an S3 bucket with the random string being generated by the random provider

```
resource "random_string" "bucket_name" {         
  length  = 32                                
  special = false
  lower = true
}


resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}
```

Can you identify what's wrong in the above terraform code in main.tf file? Do you think that it will work as is? :thinking:

Let's try and find out. 
```
$ terraform init
Initializing the backend...
...
...

-----------------------------------------------

$ terraform plan  # This did not give any error

-----------------------------------------------

$ terraform apply --auto-approve
...
...
Changes to Outputs:
  ~ random_bucket_name = "a07vflis16caqkrjqale9un4zz2eu3t7" -> (known after apply)
aws_s3_bucket.example: Destroying... [id=a07vflis16caqkrjqale9un4zz2eu3t7]
aws_s3_bucket.example: Destruction complete after 0s
random_string.bucket_name: Destroying... [id=a07vflis16caqkrjqale9un4zz2eu3t7]
random_string.bucket_name: Destruction complete after 0s
random_string.bucket_name: Creating...
random_string.bucket_name: Creation complete after 0s [id=FTc0eq2sxg800W2PxtZs3RrdravkAQhW]
aws_s3_bucket.example: Creating...

Error: validating S3 Bucket (FTc0eq2sxg800W2PxtZs3RrdravkAQhW) name: only lowercase alphanumeric characters and hyphens allowed in "FTc0eq2sxg800W2PxtZs3RrdravkAQhW"

```
Wait, what is this error "**name: only lowercase alphanumeric characters and hyphens allowed**"?

Above error is related to accepted names that an S3 bucket can have. S3 cannot have names in uppercase

[Rules for S3 bucket naming convention](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console)

So, to fix this error we have to create a random string without uppercase letters.

```
resource "random_string" "bucket_name" {         
  length  = 32                                
  special = false
  lower = true
  upper = false  # Add this
}
```

## 7 Terraform Cloud backend
You need to have Terraform Cloud Account already setup for this. 

### 7.1 Issues with terraform cloud login in gitpod workspace

When we tried to access Terraform Cloud using the `terraform login` command in Gitpod VSCODE, it didn't automatically open the web browser to retrieve the token from 'app.terraform.io'.

As a workaround, if the browser doesn't open automatically, you can manually open the following URL to obtain the token. Afterward, create a file at `/home/gitpod/.terraform.d/credentials.tfrc.json`` with the following content, making sure to replace 'ADD YOUR TOKEN HERE' with the actual token you copied from the provided link: https://app.terraform.io/app/settings/tokens?source=terraform-login

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "ADD YOUR TOKEN HERE"
    }
  }
}

```

### 7.2 Migrate local state to terraform cloud

- To use Terraform Cloud as a backend for your configuration, you must include a cloud block in your configuration.

 ```
terraform {
  cloud {
    organization = "ORGANIZATION-NAME"
    workspaces {
      name = "learn-terraform-cloud-migrate"
    }
  }
 ```

- **Authenticate with Terraform Cloud**:

  In order to authenticate to Terraform Cloud run `terraform login` and type **yes** at the confirmation prompt.

- Follow workaround provided in previous step [6.1](#61-issues-with-terraform-cloud-login-in-gitpod-workspace)

- **Migrate the state file**:

  Reinitialize your configuration to update the backend and migrate your existing state to terraform cloud. Type `yes` to confirm the migration.

  ```
  terraform init
  ```
 
## [8 Bash script to automate steps in section - 6.1](#61-issues-with-terraform-cloud-login-in-gitpod-workspace)

Bash script([generate_tfrc_credentials.sh](./bin/generate_tfrc_credentials.sh)) has been created to automate workaround steps that we performed manually because of the issue faced while running `terraform login` command.

## 9 Create a Bash Script for setting the `tf` alias

We have create a bash script [set_terraform_alias.sh](./bin/set_terraform_alias.sh) and added in gitpod.yml file. This script will check if the alias for `terraform` command already exist, if not, it will add the alias in the `.bash_profile` file so that the alias persist across different terminals. 

