### Intro

1. what is terraform
    1. opensource tool for provisioning infra
    2. supports devops best practices for change management
    3. managing config files in source control maintains ideal provisioning state for testing and prod envs
2. IaC?
    1. infra as code
    2. build, change, and manage infra in a safe consistent, repeatable way by defining resource configs that can be versioned, reused, shared
3. advantages
    1. lifecycle management
    2. version control
    3. usefull for stack based deployments and with cloud providors
    4. state based approach to track resource changes thru deployments

### files

- main.tf
- variables.tf
- .tfstate
- optional: resources.tf, output.tf

### declarations

- `terraform`: configure basic tf settings to provision infra
    - `required_version` : minium tf version to apply to ur config
    - `backend` : stores tf state snapshots to map real resources to your config
        - `local` :  stores state files locally `terraform.tfstate`
    - `required_providers` : specify providers required by the current module
- `provider` : adds a set of resources for TF to manage
    - the tf registry is the main directory for providers
- `resource` : blocks to define components of ur infrastructure
    - project modules/resources: google_storage_bucket, google_bigquery_dataset, google_bigquery_table
- `variable` & `locals` : runtime arguments and constants

### execution steps

1. `terraform init` : 
    1. initializes and configures backend, installs plugins/providers, and checks out an existing config from vcs
2. `terraform plan` : 
    1. matches local changes against the remote state and proposes an execution plan
3. `terraform apply`: 
    1. asks for approval for proposed plan and applies the changes to the cloud
4. `terraform destroy` :
    1. removes your stack from the cloud