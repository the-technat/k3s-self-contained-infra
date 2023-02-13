terraform {
  cloud {
    organization = "alleaffengaffen"

    workspaces {
      name = "los_for_microg_image_factory"
    }
  }
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}
