# Monitoring Deploy 


The code contains GitHub Action pipelines to deploy and then configure Grafana and Prometheus on the remote server.
Server deployment has been conducted using Terraform, while Ansible has been used to configuration deployment.

## Terraform code
In terraform directory are:
 - main.tf,
 - backend.tfvars, 
 - variables.tf,
 - output.tf. 

## Ansible code
It consists of:
 - roles directory, 
 - inventory.yml,
 - playbook.yml.

Directory "roles" contains roles for Grafana, Prometheus, and node-exporter deployment. 

## GitHub Actions pipeline
The functionality of the pipeline could be divided into two stages. 

 1. Creating of infrastructure
 2. Deployment of configuration

File pipeline.yml is implemented under the .github/workflows directory. To trigger the pipeline, you have to do it manually. 


## How to us?
In order to execute code without trouble, you must create a Storage Account with a container on your Azure environment. Moreover, have to create a Service principal account with Contributor privilege to subscription.

 1. Create a Storage Account with the container.
 2. Alter the following variables in the backend.tfvars:
- resource_group_name =  &lt; name of Storage Account resource group &gt;
- storage_account_name = &lt;name of Storage Account &gt;
- container_name =  &lt;container name &gt;
 4. Create a Service principal account with Contributor privilege to subscription.
 5. Define the following variables in GitHub repository secrets: 
 - AZURE_CLIENT_ID,
 - AZURE_CLIENT_SECRET,
 - AZURE_TENANT_ID,
 - MVP_SUBSCRIPTION,
 - SSH_PRIVATE,
 - SSH_PUBLIC. 

All above variables must be stored as secure variables to ensure confidentiality.

4. Optionally modify variables.tf. 