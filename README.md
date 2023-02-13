# K3S Self-Contained Infra

single-node Kubernetes cluster ready to autoscale. Perfect for small projects that need a self-contained env.

Deployed using Github Actions and TFC.

## Prerequisites

The way we are coming to make this happen:

1. Create a Hetzner Account
2. Create a Hetzner Project
3. Invite members to Project
4. Create two s3 buckets somewhere else:

- one for final builds
- one for cache artifacts

5. Create some Repository Secrets:

- `TF_VAR_HCLOUD_TOKEN`: env secret containing a token that has access to your created hcloud project
- `TF_VAR_SSH_KEY`: env secret  private ed25519 ssh key that github uses to manage infrastructure
- `TF_VAR_SSH_PUB_KEY`: env secret public ed25519 ssh key that github uses to manage infrastructure
- TODO: add names for s3 credential secrets

6. Create an account on Terraform Cloud
7. Create new org & workspace for this infrastructure

- use cli-driven workflow
- set execution mode to local

8. Create new user token in TFC

- add it as `TF_API_TOKEN` to the repository secrets

## Continuous Deployment

A Github Actions Workflow called "Continuous Deployment" tries to match the desired state with the actual state. All changes in this repo are applied automatically if we are on branch `main`.

All other branches and pull-requests get terraform checks to ensure integrity.

## To Do

Nothing is perfect and this just started so there is a lot do to

- Deployment currently doesn't work
- Terraform Cloud is only used for state, maybe github has some feature to remove this dependency (since secrets are also not managed there...)

## Acknowledgements

- [terraform-hcloud-kube-hetzner]: For an awesome automation of k3s@hcloud
