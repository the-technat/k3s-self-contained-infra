# Infrastructure for the image factory

The infrastructure for the image factory consists of a single-node K3s cluster on hcloud that scaled automatically for automated builds.

## Prerequisites

1. Create a Hetzner Account
2. Create a Hetzner Project
3. Invite members to Project
4. Create two s3 buckets somewhere else:

- one for final builds
- one for cache artifacts

5. Create new environment in Github Repo and add some secrets:

- `TF_VAR_HCLOUD_TOKEN`: env secret containing a token that has access to your created hcloud project
- `TF_VAR_SSH_KEY`: env secret  private ed25519 ssh key that github uses to manage infrastructure
- `TF_VAR_SSH_PUB_KEY`: env secret public ed25519 ssh key that github uses to manage infrastructure
- TODO: add names for s3 credential secrets

6. Create an account on Terraform Cloud
7. Create new org & workspace for this infrastructure

- use cli-driven workflow
- set execution mode to local

8. Create new user Token in TFC

- add it as `TF_API_TOKEN` to the github environment env secret list

## Continuous Deployment

End goal: github actions pipeline with secrets from the repo deploying the infra over and over, changes cause eventual recreating but this is safe as data should be stored in another location.

Runner environment:

- hcloud
- kubectl
- terraform

## Acknowledgements

- [terraform-hcloud-kube-hetzner]: For an awesome automation of k3s@hcloud
