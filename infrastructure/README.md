# Infrastructure for the image factory

The infrastructure for the image factory consists of a single-node K3s cluster on hcloud that scaled automatically for automated builds.

## Prerequisites

The way we are coming to make this happen:

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

8. Create new user token in TFC

- add it as `TF_API_TOKEN` to the github environment env secret list

## Continuous Deployment

A Github Actions Workflow called "Infrastructure" tries to match the desired state with the actual state. All changes in this repo are applied automatically if we are on branch `main`.

## To Do

Nothing is perfect and this just started so there is a lot do to

- Deployment currently doesn't work
- Vars have to passed in on the command-line, env vars using `TF_VAR_` are not recognized
- Github Environment currently doesn´t allow plans on arbitrary branches
- Terraform Cloud is only used for state, maybe github has some feature to remove this dependency (since secrets are also not managed there...)

## Acknowledgements

- [terraform-hcloud-kube-hetzner]: For an awesome automation of k3s@hcloud
