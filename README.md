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