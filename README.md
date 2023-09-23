# Terraform Beginner Bootcamp 2023

# WEEK 0

## 1. Semantic Versioning

Semantic versioning is a versioning scheme for software that aims to convey meaning about the underlying changes in a release. Semantic versioning consists of three main components: **MAJOR, MINOR, and PATCH** versions, often written as X.Y.Z(For example: `0.1.0`) 

Here's what each component means:

- **MAJOR version**: This is typically incremented when there are incompatible changes that require modifications in the way the software interacts with other components. This might include breaking changes to the API or fundamental changes in functionality. For example, going from version `1.0.0` to `2.0.0`

- **MINOR version**: This is incremented when new capabilities have been introduced without disrupting existing integrations. For instance, upgrading from version `1.2.0` to `1.3.0`

- **PATCH version**: This is incremented when you make backward compatible bug fixes or minor improvements that do not introduce new features.  For example, moving from version `1.2.3` to `1.2.4`


#### 1.1 How to delete tags locally and remotely
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

#### 1.2 How to have a graph view of branch

Sometimes you need see an icon for graph view. In order to have that please install `git log --graph` plugin.

## 2. Refactoring Terraform CLI

#### 2.1 Create new bash script that installs Terraform CLI
Following commands in `gitpod.yaml` were showing deprecated warnings and requires user input to perform full terraform cli installation 

```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
      
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
      
sudo apt-get update && sudo apt-get install terraform

```

We've created a new bash script that fixes the above issue of deprecated warnings and user input. It is placed under [terraform_cli_install.sh](./bin/terraform_cli_install.sh)


#### 2.2 Understanding Shebang

We've used `#!/usr/bin/env bash` as the bash interpreter in our script, but what is the difference between `#!/usr/bin/env bash` and `#!/bin/bash`

```
while both shebang lines specify that the script should be interpreted using Bash, 

#!/usr/bin/env bash offers greater flexibility and portability because it relies on the user's environment to locate the Bash interpreter, making it a common choice for cross-platform compatibility. 

However, #!/bin/bash is more explicit and may be preferred in situations where you want to ensure a specific Bash interpreter is used.

```


#### 2.2 How to make bash script executable?

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

#### 2.3 Update the [gitpod.yml](./.gitpod.yml) to use bash script and use `before` gitpod lifecycle.

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

#### 3.1 Ways of setting user-specific environment variables
 - Using the command line: `gp env`
   
   The gp CLI prints and modifies the persistent environment variables associated with your user for the current repository.

   To set the persistent environment variable foo to the value bar use:

   ```
   gp env foo=bar
   ```
   This does not modify your current terminal session, but rather **persists this variable for the next workspace on this repository**. gp can only interact with the persistent environment variables for this repository, not the environment variables of your terminal.


- Using the account settings

  You can also configure and view the persistent environment variables in your account settings


## 3. Refactoring AWS CLI

#### 3.1 New bash script([aws_cli_install.sh](/bin/aws_cli_install.sh)) that installs AWS CLI

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

#### 3.2 Get Access Keys

You need to have an AWS account. Please set it up if you don't have one using [AWS Setup Link](https://aws.amazon.com/free/?trk=58b3b422-9e3d-4d31-a50d-c6f8b1a5161a&sc_channel=ps&ef_id=CjwKCAjwmbqoBhAgEiwACIjzEICLt2B9k7hEt32xHUyzaZcqNMtCtN_w-0V03WpEP21cXmKFl-gWzBoCZc8QAvD_BwE:G:s&s_kwcid=AL!4422!3!507852355859!p!!g!!amazon%20web%20services!12580566202!118888769039&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)

Once you have your account, you need to create new user using `AWS IAM` service.

- Login to AWS console
- Go to IAM service
- Create new user with any name, I've used `tfbootcomp` and add it in a group(I used group name as `Admin`), and finally grant `AdministratorAccess` permissions to the group. Note that this user doesn't need to have `console access` for now.
- Once user is created, click on `user` --> `security credentials` --> create new `access keys`.` 

**WARNING:** 
DON'T EVER EVER EVER EVER EVER PROVIDE THESE KEYS TO ANYONE OR STORE IT IN GITHUB.

#### 3.3 Use gitpod's env variables 

These keys can be stored as env variables in the terminal or workspace.

You have to run following commands to export the keys as the env variables:
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=1234567xxxxxxxxx
export AWS_DEFAULT_REGION=ca-central-1
```

Note that above are not the actual keys. So, don't even think about using it :wink: 

#### 3.4 Verification

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

