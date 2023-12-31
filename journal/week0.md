# Terraform Beginner Bootcamp 2023 - Week 0

## Table of Contents

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle)
- [Working with Env Vars](#working-with-env-vars)
  * [env command](#env-command)
    + [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisitng Env Vars in Gitpod](#persisitng-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
  * [Terraform Lock Files](#terraform-lock-files)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform Directory](#terraform-directory)
- [Difficulty found while using terraform - 1](#difficulty-found-while-using-terraform---1)
- [Difficulty found while using terraform - 2](#difficulty-found-while-using-terraform---2)

## Semantic Versioning
 
This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation intructions changed due to gpg keyring changes. So we needed to refer to the latest installation CLI instructions via Terraform Documentation and change the script for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distribution

This project is built on against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to check linux version](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version>
```sh
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation we noticed that the bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraorm_cli](./bin/install_terraform_cli.sh)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This will allow us an easier way to debug and execute manually Terraform CLI Install.
- This will allow for better portability for other projects that need to Install terraform CLI.

#### Shebang Considerations

A Shebang (Pronounced Sha-bang) tells the bash script what program will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distributions
- Will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix) 

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`




#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli.sh
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli.sh
```

https://en.wikipedia.org/wiki/Chmod


## Gitpod Lifecycle

'before', 'init' and 'command':

We need to be careful when using the Init because it will not return if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Working with Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the  `env` command.

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO = `world` .bin/print_message

```
Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO = `world`

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open up a new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals thay are open you need to set env vars in your bash profile. eg. `.bash_profile`

### Persisitng Env Vars in Gitpod

We can persist env vars into gitpos by storing them in Gitpod Secret Storage.

```
gp env HELLO = `world`

```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.


## AWS CLI Installation

AWS CLI is instaled for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install AWS CLI](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip)

[Env variables to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
 aws sts get-caller-identity

```

If it is successful you should see a json payload return that looks like this:

``` json

{
    "UserId": "AIDA3RRNSONBLIEXAMPLE",
    "Account": "1234567890",
    "Arn": "arn:aws:iam::1234567890:user"
}
```

We'll need to generate AWS CLI credentials from IAM user in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Teeraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in terraform.
- **Modules** are a way to make large amount of terraform code modular, portable and shareable.

[Random terraform provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the terraform commands by typing `terraform`.

#### Terraform Init

`terraform init`

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by Terraform. Apply should prompt us to choose "yes" or no.

If we want to automate this approval we can use the "auto-approve" flag, eg.: `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`

This will destroy resources that are specified in the cofiguration file.

You can also use the auto approve flag to skip the approve prompt, eg. `terraform destroy --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The terraform Lock File **should be commited** to your Version Control System (VSC), eg. Github.

###  Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be commited** to your VS.

This files contains sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup`  is the previous state file backup.

### Terraform Directory

`.terraform` directory contains binaries of Terraform providers.

## Difficulty found while using terraform - 1

The naming convention of the s3 buckets did not allow upper case letters so when we did the `terraform apply --auto-approve` command we got an error
stating that the name was invalid so we had to go and change the random string module code configuration parameters in order to reflect this, we used the following documentation: 

[random_string schema](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#schema)

## Difficulty found while using terraform - 2 

We had an issue with Terraform Cloud and Gitpod Workspace that when attempting to run `terraform login` command, it will launch bash wiswig to generate a token.
However it does not work as expected in Gitpod VSCode in the browser.

The workaround is to manually generate a token in Terraform Cloud:

```
https://app.terraform.io/app/settings/tokens?source=terraform-login

```

Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json

```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-terraform-cloud-token"
    }
  }
}

```
Then close the file.

We have automated the process using a workaround with the following bash scrip: [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials) 
