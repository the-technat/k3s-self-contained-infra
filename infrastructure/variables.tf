# Note: variables added here are expected to be passed in from github environemnt secrets
# All other config is done inline in code
variable "HCLOUD_TOKEN" {
  type        = string
  sensitive   = true
  description = "hcloud_token to access hcloud project"
}

variable "SSH_KEY" {
  type        = string
  description = "The private ssh key that github actions can use to manage infrastructure"
}

variable "SSH_PUB_KEY" {
  type        = string
  description = "The public ssh key that github actions can use to manage infrastructure"
}
