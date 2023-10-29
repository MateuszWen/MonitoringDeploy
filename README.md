# Monitoring Deploy 


Code contains GitHub Action and Ansible pipelines to configure remote server.

## Ansible code
It consists of:
 - roles directory, 
 - inventory.yml,
 - playbook.yml.

Directory "roles" contains roles for Grafana, Prometheus, and node-exporter deployment. 


## GitHub Actions pipeline
File pipeline.yml is implemented under the .github/workflows directory. To trigger pipeline, you have to do it manually. 

In order to execute code without trouble, you have to define 3 variables in GitHub repository: 

 - SSH_PRIVATE_KEY,
 - HOST_ADDRESS,
 - HOST_USER. 

To ensure confidentiality, SSH_PRIVATE_KEY should be stored as a secure variable. 


## How to us?

 1. Just create dump virtual machine with Linux OS,
 2. clone the project to your remote repository,
 3. add the above variables to GiHub repository,
 4. then change tab to "Actions" and Run pipeline using "main" branch.
