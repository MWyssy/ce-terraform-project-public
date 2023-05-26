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

1. Create a file called 'user_data.sh' and place it inside the 'auto-scaling' module.
2. Inside the 'user_data.sh' file, copy the following:

```
#! /bin/bash
sudo apt-get update
home=/home/ubuntu
folder=$home/localfolder
/usr/bin/git clone https://<username>:<git-token>@github.com/<username>/<repository>.git $folder
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /usr/share/nginx/html/index.html
sudo rm /etc/nginx/nginx.conf
cd /home/ubuntu/localfolder
sudo mv index.html /usr/share/nginx/html/index.html
sudo mv styles.css /usr/share/nginx/html/styles.css
sudo mv nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service
```

3. Inside the 'git clone' command, you can edit the 'username' to be your git username, the 'git-token' to be your git-token, and the 'repository' to be the git repository where your website files are located.
4. The code example above assumes that there is an index.html and a styles.css file in the repository. If your website has more files than this, then you can just copy the 'sudo mv' command and insert the other files that you need to move. For example:

```
sudo mv page-two.html /usr/share/nginx/html/page-two.html
```

_However_, please make sure that your main html file is called 'index.html', if it isn't, then the server will not work.

5. Once you have finished creating the 'user_data', you can run 'terraform init' then 'terraform apply' to create the server. This will take around 5 minutes to fully set up, and may take longer if you are trying to host a larger website.

Congratulations! You have a fully functioning, and highly available web-server hosting your website!
