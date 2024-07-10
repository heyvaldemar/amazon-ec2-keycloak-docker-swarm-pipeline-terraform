# Amazon EC2 Keycloak in a Docker Swarm Pipeline with Terraform

The Terraform script performs the following operations to set up a Keycloak environment on AWS:

1. **Database Secrets Management**: The script retrieves secrets such as passwords and keys stored in AWS Secrets Manager. It obtains the secrets for database, and Keycloak configurations.

2. **RDS Instance Creation**: It creates an Amazon RDS instance using provided variables, including the DB engine, version, size, backup settings, etc. The RDS instance is configured with database credentials retrieved from AWS Secrets Manager.

3. **EC2 Instance Creation**: It creates an EC2 instance for the Keycloak application running as a Docker container. The instance is created using a specific AMI and instance type. The instance metadata is set to enforce IMDSv2 for enhanced security.

4. **Keycloak Configuration Generation**: It uses the Keycloak Docker configuration file (keycloak-docker-swarm.yml) using values from previously defined resources and the provided variables.s

5. **Route53 Record Creation**: The script creates Route53 DNS record pointing to the ALB. This DNS record provides a user-friendly way to access the Keycloak application.

6. **Application Load Balancer Creation**: The script creates an application (ALB) load balancer. This load balancer is used for routing traffic to the Keycloak EC2 instance. The ALB is used for HTTP/HTTPS traffic. It also creates the necessary target groups, listeners, and attachments for the load balancer.

7. **Network Load Balancer Creation**: In addition to the creation of an application load balancer (ALB) for HTTP/HTTPS traffic, an NLB (Network Load Balancer) is created specifically for port 22. The NLB is used for routing traffic to the Keycloak EC2 instance over SSH. The creation process involves setting up the necessary target groups, listeners, and attachments for the NLB.

# Requirements

Install AWS CLI by following the [guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

Configure AWS CLI by following the [guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

Install Terraform by following the [guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

Install pre-commit by following the [guide](https://pre-commit.com/#install)

Install tflint by following the [guide](https://github.com/terraform-linters/tflint)

Install tfsec by following the [guide](https://github.com/aquasecurity/tfsec)

Install tfupdate by following the [guide](https://github.com/minamijoyo/tfupdate)

# Route53

Please be aware that this Terraform deployment operates on the premise that your application's domain is registered/parked with Amazon Route53. The deployment process will automatically create "A" records within the Route53 zone that correspond to your application's domain. In addition, Amazon Certificate Manager (ACM) will seamlessly obtain an SSL certificate for the specified domain.

# Secrets

Create secrets with [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) for:
1. Username and password for the database
2. Username and password for the Keycloak
3. Set secrets ARNs in the `00-variables.tf` file

# Pre-commit Hooks

`.pre-commit-config.yaml` is useful for identifying simple issues before submission to code review. Pointing these issues out before code review, allows a code reviewer to focus on the architecture of a change while not wasting time with trivial style nitpicks. Make sure you have all tools from the requirements section installed for pre-commit hooks to work.

# Manual Installation

Make sure you have all tools from the requirements section installed.

You may change variables in the `00-variables.tf` to meet your requirements.

Initialize a working directory containing Terraform configuration files using the command:

`terraform init`

Run the pre-commit hooks to check for formatting and validation issues:

`pre-commit run --all-files`

Review the changes that Terraform plans to make to your infrastructure using the command:

`terraform plan`

Deploy using the command:

`terraform apply -auto-approve`

# SSH

Once you've run `terraform apply` and the resources are successfully created, a private key file will be generated in your project root directory (where your Terraform files are located). This key can be used to securely connect to the created Amazon Lightsail instance via SSH.

Here's an example of how to use the key to connect via SSH (replace myuser with your username and myinstance with your instance's public IP address or hostname):

`ssh -i key-pair-1.pem ubuntu@instance-static-ip`

# user_data.sh Description

The `user_data.sh` script is a bootstrapping script used for provisioning an EC2 instance. The main tasks performed by the script are as follows:

1. **Creating a Directory for Logs**: It creates a directory `/var/log/user_data_script` to store the error logs for the script.

2. **Package Installation**: It installs necessary packages including curl, openssh-server, ca-certificates, tzdata, and PostgreSQL client.

3. **Docker Installation**: The script then uses the curl command to download a script from https://get.docker.com and executes it with sh to install Docker on the machine.

4. **Adding User to Docker Group**: The script then adds the default user of the distribution to the docker group. This is done so that the default user can run Docker commands without requiring sudo.

5. **Creating Keycloak Docker Swarm File**: The script generates a Docker Swarm file for the Keycloak server by writing the rendered Keycloak configuration to a file named keycloak-docker-swarm.yml in the /opt directory.

6. **Deploying Keycloak Server**: The script then uses Docker Swarm to deploy the Keycloak server. It does this by executing the Docker Swarm file with the `sudo docker stack deploy -c /opt/keycloak-docker-swarm.yml Keycloak` command, which launches the Keycloak server.

# user_data.sh Logs

Once your EC2 instance is provisioned and the `user_data.sh` script has run, you can check its logs to confirm whether it ran successfully or encountered any errors.

The logs for `user_data.sh` can be found at `/var/log/user_data_script/errors.log`.

To view these logs, you can use the cat command as follows:

`cat /var/log/user_data_script/errors.log`

# GitHub Actions

`.github` is useful if you are planning to run a pipeline on GitHub and implement the GitOps approach.

Remove the `.example` part from the name of the files in `.github/workflow` for the GitHub Actions pipeline to work.

Note, that you will need to add variables such as AWS_ACCESS_KEY_ID, AWS_DEFAULT_REGION, and AWS_SECRET_ACCESS_KEY in your GitHub projects CI/CD settings section to run your pipeline.

Therefore, you will need to create a service user in advance, using AWS Identity and Access Management (IAM) to get values for these variables and assign an access policy to the user to be able to operate with your resources.

You can delete `.github` if you are not planning to use the GitLab pipeline.

1. **Terraform Unit Tests**

This workflow executes a series of unit tests on the infrastructure code and is triggered by each commit. It begins by running [terraform fmt]( https://www.terraform.io/cli/commands/fmt) to ensure proper code formatting and adherence to terraform best practices. Subsequently, it performs [terraform validate](https://www.terraform.io/cli/commands/validate) to check for syntactical correctness and internal consistency of the code.

To further enhance the code quality and security, two additional tools, tfsec and tflint, are utilized:

tfsec: This step checks the code for potential security issues using tfsec, an open-source security scanner for Terraform. It helps identify any security vulnerabilities or misconfigurations in the infrastructure code.

tflint: This step employs tflint, a Terraform linting tool, to perform additional static code analysis and linting on the Terraform code. It helps detect potential issues and ensures adherence to best practices and coding standards specific to Terraform.

2. **Terraform Plan / Apply**

This workflow runs on every pull request and on each commit to the main branch. The plan stage of the workflow is used to understand the impact of the IaC changes on the environment by running [terraform plan](https://www.terraform.io/cli/commands/plan). This report is then attached to the PR for easy review. The apply stage runs after the plan when the workflow is triggered by a push to the main branch. This stage will take the plan document and [apply](https://www.terraform.io/cli/commands/apply) the changes after a manual review has signed off if there are any pending changes to the environment.

3. **Terraform Drift Detection**

This workflow runs on a periodic basis to scan your environment for any configuration drift or changes made outside of terraform. If any drift is detected, a GitHub Issue is raised to alert the maintainers of the project.

If you have paid version of GitHub and you wish to have the approval process implemented, please refer to the provided [guide](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment) to create an environment called production and uncomment this part in the `02-terraform-plan-apply.yml`:

```
on:
  push:
    branches:
    - main
  pull_request:
    branches:
    - main
```

And comment out this part in the `02-terraform-plan-apply.yml`:

```
on:
  workflow_run:
    workflows: [Terraform Unit Tests]
    types:
      - completed
```

Once the production environment is created, set up a protection rule and include any necessary approvers who must approve production deployments. You may also choose to restrict the environment to your main branch. For more detailed instructions, please see [here](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules).

If you have a free version of GitHub no action is needed, but approval process will not be enabled.

# GitLab CI/CD

`.gitlab-ci.yml` is useful if you are planning to run a pipeline on GitLab and implement the GitOps approach.

Remove the `.example` part from the name of the file `.gitlab-ci.yml` for the GitLab pipeline to work.

Note, that you will need to add variables such as AWS_ACCESS_KEY_ID, AWS_DEFAULT_REGION, and AWS_SECRET_ACCESS_KEY in your GitLab projects CI/CD settings section to run your pipeline.

Therefore, you will need to create a service user in advance, using AWS Identity and Access Management (IAM) to get values for these variables and assign an access policy to the user to be able to operate with your resources.

You can delete `.gitlab-ci.yml` if you are not planning to use the GitLab pipeline.

1. **Terraform Unit Tests**

This workflow executes a series of unit tests on the infrastructure code and is triggered by each commit. It begins by running [terraform fmt]( https://www.terraform.io/cli/commands/fmt) to ensure proper code formatting and adherence to terraform best practices. Subsequently, it performs [terraform validate](https://www.terraform.io/cli/commands/validate) to check for syntactical correctness and internal consistency of the code.

To further enhance the code quality and security, two additional tools, tfsec and tflint, are utilized:

tfsec: This step checks the code for potential security issues using tfsec, an open-source security scanner for Terraform. It helps identify any security vulnerabilities or misconfigurations in the infrastructure code.

tflint: This step employs tflint, a Terraform linting tool, to perform additional static code analysis and linting on the Terraform code. It helps detect potential issues and ensures adherence to best practices and coding standards specific to Terraform.

2. **Terraform Plan / Apply**

To ensure accuracy and control over the changes made to your infrastructure, it is essential to manually initiate the job for applying the configuration. Before proceeding with the application, it is crucial to carefully review the generated plan. This step allows you to verify that the proposed changes align with your intended modifications to the infrastructure. By manually reviewing and approving the plan, you can confidently ensure that only the intended modifications will be implemented, mitigating any potential risks or unintended consequences.

# Committing Changes and Triggering Pipeline

Follow these steps to commit changes and trigger the pipeline:

1. **Install pre-commit hooks**: Make sure you have all tools from the requirements section installed.

2. **Clone the Git repository** (If you haven't already):

`git clone <repository-url>`

3. **Navigate to the repository directory**:

`cd <repository-directory>`

4. **Create a new branch**:

`git checkout -b <new-feature-branch-name>`

5. **Make changes** to the Terraform files as needed.

6. **Run pre-commit hooks**: Before committing, run the pre-commit hooks to check for formatting and validation issues:

`pre-commit run --all-files`

7. **Fix any issues**: If the pre-commit hooks report any issues, fix them and re-run the hooks until they pass.

8. **Stage and commit the changes**:

`git add .`

`git commit -m "Your commit message describing the changes"`

9. **Push the changes** to the repository:

`git push origin <branch-name>`

Replace `<branch-name>` with the name of the branch you are working on (e.g., `new-feature-branch-name`).

10.  **Monitor the pipeline**: After pushing the changes, the pipeline will be triggered automatically. You can monitor the progress of the pipeline and check for any issues in the CI/CD interface.

11.  **Merge Request**: If the pipeline is successful and the changes are on a feature branch, create a Merge Request to merge the changes into the main branch. If the pipeline fails, investigate the issue, fix it, and push the changes again to re-trigger the pipeline. Once the merge request is created, your team can review the changes, provide feedback, and approve or request changes. After the merge request has been reviewed and approved, it can be merged into the main branch to apply the changes to the production infrastructure.
