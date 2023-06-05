# Instructions for how to use this repository

## Initialise the back-end

_Note_ - If you are working in a team, you will only need to initialise the back end once, then the repository can be used by as many people as necessary.

1. First ensure that you have terraform installed: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
2. Once Terraform is installed, fork and clone this repository.
3. Use the terminal to log into AWS (either use an SSO profile, or export your credentials directly).
4. Make sure the 'backend' block in the 'providers.tf' file is commented out before moving on, running terraform init with this code before the remote backend is properly setup will break it.
5. Run terraform init to initialise the backend locally:

```
terraform init
```

6. Run terraform apply to create the s3 bucket and dynamoDb table which will be used for the remote backend. You will need to change the name of the s3 bucket (you can do so in 'backend.tf'), and the 'bucket' value (in the 'backend' block in the 'providers.tf' file), as s3 buckets need to be globally uniquely named.

```
terraform apply
```

7. Create the 'staging' workspace environment using the following command:

```
terraform workspace new -state=terraform.tfstate staging
```

8. Create the 'production' workspace environment using the following command:

```
terraform workspace new -state=terraform.tfstate production
```

9. Switch back to the 'default' workspace using:

```
terraform workspace select default
```

10. Uncomment the 'backend' block in the 'providers.tf' file.
11. Run terraform init, and terraform apply again. You should get a message saying the backend has been successfulyl initialised, and after running apply, one that says that nothing was changed.

```
terraform init
terraform apply
```

Good Work! The remote back end has now been successfully setup! From now on, you want to be using either the 'staging' or the 'production' workspaces, as the 'default' workspace will not run any of the other code.

## Using the Repository

To use the repository to create a fully functioning, highly available web-server to host your website, follow these steps:

1. Add you website files to the 'website' directory located in the 'media' directory.
2. Switch to the desired workspace, 'staging' for testing purposes, or 'production' for a full scale cloud environment.
3. Run 'terraform apply'. (Please note that you may need to change the name of the s3-filestore bucket, as like above, s3 buckets need a globally unique name. You can change the name of the bucket by finding the 'bucket_name' variable in the 'production.tf' and 'staging.tf' files located in the 'vars' module.)
