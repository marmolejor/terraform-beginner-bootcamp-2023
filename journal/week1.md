# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag

```sh
git tag -d <tag_name>
```

Remotely delete a tag
```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT/
│
├── main.tf            - all the infrastructure is defined here.
├── variables.tf       - stores the structure of input variables.
├── providers.tf       - defined required providers and their configuration.
├── outputs.tf         - stores our outputs.
├── terraform.tfvars   - the data of variables we want to load into our terraform project.
└── README.md          - required for root modules.
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

## Terraform Cloud Variables

In terraform we can set two kinds of variables:
- Environment variables: those you would set in your bash terminal eg. AWS credentials.
- Terraform varuables: those you would normally set in your tfvars file.

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user-uuid="my-user_id"`

### var-file flag 

In Terraform, the -var-file flag is used to specify a file from which to load Terraform variables. This allows you to maintain sets of variables in separate files, which can be especially useful for managing different environments (like staging, production, development, etc.) or for organizing configurations more cleanly.

When you use Terraform's apply, plan, or other relevant commands, you can provide the -var-file flag to indicate which file Terraform should use to source its variable values.

Here's an example:

```
terraform apply -var-file="staging.tfvars"

```

In this example, Terraform would apply the configuration using variables defined in the staging.tfvars file.

Some key things to note about -var-file:

Default terraform.tfvars: By default, Terraform will automatically load variables from a file named terraform.tfvars or any file with a .auto.tfvars extension. If you use -var-file, it's in addition to this automatic loading, not in place of it.

Multiple Files: You can use the -var-file flag multiple times in a single command to load variables from multiple files. They are loaded in the order they're provided on the command line, so if there are overlapping variables, the last one takes precedence.

Overriding Variables: Variables specified directly with the -var flag or set as environment variables will override those set in a var-file.

The -var-file flag provides flexibility in how you manage and organize your Terraform configurations, enabling better structure and separation of variable values based on different needs or environments.

### terraform.tfvars

This is the default file to load in terraform variables in bulk.

### auto.tfvars

In Terraform, files with the `.tfvars` or `.auto.tfvars` extension are used to define variable values. The special thing about `.auto.tfvars` files is that Terraform will automatically load them without requiring the `-var-file` flag. This automatic loading is a feature that works both in the local Terraform CLI as well as in Terraform Cloud.

Here's how `.auto.tfvars` works specifically in Terraform Cloud:

1. **Automatic Loading**: When you initiate a run in Terraform Cloud (either via VCS integration, API, or UI), Terraform Cloud will automatically pick up any `.auto.tfvars` files in the workspace's root directory and use the variable values defined within.

2. **Workspace-Specific Variables**: In Terraform Cloud's web UI, you can define workspace-specific variables. If there's a conflict between a variable defined in the web UI and one in an `.auto.tfvars` file, the value set in the web UI will take precedence.

3. **Version Control Integration**: If you have linked a VCS repository (like GitHub, GitLab, etc.) to your Terraform Cloud workspace, every time you push changes, Terraform Cloud will initiate a run. During this run, it will automatically load the values from `.auto.tfvars` files.

4. **Sensitive Variables**: You can mark certain variables as sensitive in Terraform Cloud's UI. This ensures that the values of these variables are never shown in logs or outputs. If you have a variable declared as sensitive in the UI, and the same variable is also present in an `.auto.tfvars` file, the sensitive marking still applies.

5. **File Ordering**: If you have multiple `.auto.tfvars` files, Terraform loads them in alphabetical order. If variables are defined in multiple files, the value from the last file loaded will take precedence.

Using `.auto.tfvars` files with Terraform Cloud is a convenient way to provide default values for your Terraform variables. However, be aware of the potential overlap with values set in the Terraform Cloud UI and ensure that your configuration behaves as expected.

### Order of terraform variables

In Terraform, several methods can be used to set variable values, and they have a specific order of precedence. When the same variable is defined in multiple places, the source with the highest precedence will determine the final value.

Here's the order of precedence for variable definitions in Terraform, starting from the highest:

1. **CLI `terraform apply` Options (`-var` and `-var-file` flags)**:
   - Variables set with `-var` flags when running `terraform apply` or other relevant Terraform commands.
   - If you specify multiple `-var-file` flags, they are loaded in the order they're provided, with later files overwriting previous ones.
   - Variables from `-var` flags take precedence over `-var-file`.

2. **Environment Variables**:
   - Terraform will read environment variables that start with `TF_VAR_`. For instance, the `TF_VAR_instance_type` environment variable sets the `instance_type` Terraform variable.

3. **The `terraform.tfvars` and `terraform.tfvars.json` files**:
   - If present, Terraform automatically loads variables from these files. If both files are present and contain a definition for the same variable, the variable from `terraform.tfvars.json` will take precedence.

4. **`.auto.tfvars` and `.auto.tfvars.json` files**:
   - Any file with the `.auto.tfvars` or `.auto.tfvars.json` extension is loaded automatically, in alphabetical order. If variables are defined in multiple such files, and those variables conflict, the last file's value will take precedence.
   - If the same variable is defined in both an `.auto.tfvars` file and a `terraform.tfvars` or `terraform.tfvars.json` file, the `.auto.tfvars` value takes precedence.

5. **Variable Defaults**:
   - If you've set a default value for a variable in the variable declaration within your Terraform configuration (using the `default` attribute), that value will be used if no other method sets the variable.

6. **Terraform Cloud/Enterprise Workspace Variables**:
   - If you're using Terraform Cloud or Terraform Enterprise, you can define workspace-specific variables through the web UI or API. These variables have the lowest precedence and can be overridden by any of the other methods mentioned.

It's essential to be aware of this order, especially when troubleshooting or when the same variable is defined in multiple places. Knowing which source has the highest precedence can help you determine the effective value of a variable during Terraform operations.


## Dealing With Configuration Drift

## What happens if you lose your state file

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket.html#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resources manually through ClickOps.

If we run Terraform plan with an attempt to put our infrastructure configuration back into the expected state fixing configuration drift.

## Fix using Terraform Refresh

```sh

terraform apply -refresh-only -auto-aprove

```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a modules directory when locally developing modules but you can name it whatever you like.

## Passing Input Variables

We can pass input variables to our module.

The module has to declare the terraform variables in its own `variables.tf`.

```tf
module "terrahouse_aws"{
  source = "./Modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the modules from various places eg.
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws"{
  source = "./Modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources#github)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation about Terraform, so it might likely produce older examples that could be
deprecated, often afecting providers. Be careful with this.


## Working with files in Terraform

### Fileexists Function

This is a built in terraform function to check the existence of a file, eg.:

```tf
> fileexists("${path.module}/hello.txt")
true

```

[fileexists function documentation](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### filemd5 

In Terraform, the filemd5 function is used to compute the MD5 hash of a file's contents. This can be useful for various reasons, such as ensuring the integrity of a file, generating unique names based on file content, or detecting changes in files.

When you pass a file path to the filemd5 function, it reads the file, calculates its MD5 hash, and then returns the hash as a hexadecimal string.

Here's a basic usage example:

```
output "example_file_md5" {
  value = filemd5("path/to/example/file.txt")
}
```

In this example, Terraform will read the contents of file.txt, compute its MD5 hash, and output the result.

A practical use case might be when you're uploading files to an S3 bucket and want to set the etag property (which is based on the file's MD5 hash) or want to create a unique object key based on the file's content to ensure cache invalidation when the file changes.

[filemd5 Documentation](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform there is a special variable called `path` that allows to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

We used this in this example code from our module's `main.tf` where we used the:

```tf

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = var.index_html_filepath
  #https://developer.hashicorp.com/terraform/language/functions/filemd5
  etag = filemd5(var.index_html_filepath)
}

```
## Terraform Locals

In Terraform, locals are used to define named expressions that can help simplify and make your Terraform configurations more readable. Essentially, locals provide a way to assign names to intermediate values and computations, which can then be referenced elsewhere within the same module.

locals can be thought of as a mechanism for creating "local variables" or constants within your Terraform configuration.

Benefits of using locals:
- Readability: Helps in simplifying complex expressions and making the Terraform code more understandable.
- Reusability: Reduces repetition by allowing you to define a value or computation once and reference it multiple times.
- Organization: Helps in grouping related values or calculations, keeping your configuration organized.

Example:

```tf
locals {
  s3_origin_id = "MyS3Origin"
}

```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the `jsonencode` to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the Lyfecycle of Resources

[Meta Arguments Lyfecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

Example:

```tf
variable "revision" {
  default = 1
}

resource "terraform_data" "replacement" {
  input = var.revision
}

# This resource has no convenient attribute which forces replacement,
# but can now be replaced by any change to the revision variable value.
resource "example_database" "test" {
  lifecycle {
    replace_triggered_by = [terraform_data.replacement]
  }
}

```

## Provisioners

Provisioners allow you to execute commands on compute instances eg. AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

This will execute a command on the machine running the Terraform commands eg. plan apply

Example:

```tf

resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

```

### Remote-exec

https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

Example:

```tf

resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}


```