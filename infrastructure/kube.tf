module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  source = "kube-hetzner/kube-hetzner/hcloud"
  # version = "1.2.0"

  ## General
  hcloud_token               = var.HCLOUD_TOKEN
  ssh_port                   = 59245
  ssh_public_key             = var.SSH_PUB_KEY
  ssh_private_key            = var.SSH_KEY
  ssh_additional_public_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJov21J2pGxwKIhTNPHjEkDy90U8VJBMiAodc2svmnFC cardno:000618187880"]
  network_region             = "eu-central"
  base_domain                = "los.alleaffengaffen.ch"
  additional_tls_sans        = ["cp.los.alleaffengaffen.ch"]

  ## Compute
  control_plane_nodepools = [
    {
      name        = "control-planes-hel1",
      server_type = "cpx11",
      location    = "hel1",
      labels      = [],
      taints      = [],
      count       = 1
    },
  ]

  agent_nodepools = [
    # Note: dummy nodegroup since we only use autoscaled nodes
    {
      name        = "worker-nodes-hel1",
      server_type = "cpx11",
      location    = "hel1",
      labels      = [],
      taints      = [],
      count       = 0
    },
  ]
  autoscaler_nodepools = [
    {
      name        = "build-runners"
      server_type = "ccx32"
      location    = "hel1"
      min_nodes   = 0
      max_nodes   = 5
    }
  ]


  ## Addons
  ingress_controller                = "nginx"
  enable_klipper_metal_lb           = "true" # Since we are running single-node (would be the default in that case)
  enable_metrics_server             = false
  allow_scheduling_on_control_plane = true # since we are running single-node
  automatically_upgrade_k3s         = true # how reliable with single-node?
  automatically_upgrade_os          = true # how reliable with single-node?
  kured_options = {
    "reboot-days" : "mo,tu,we,th,fr"
    "start-time" : "1am"
    "end-time" : "6am"
    "time-zone" : "Europe/Zurich"
  }
  initial_k3s_channel    = "latest"
  cluster_name           = "los-for-microg-image-factory"
  cni_plugin             = "cilium"
  disable_network_policy = true # use the one from cilium
  enable_cert_manager    = true
  lb_hostname            = "los.alleaffengaffen.ch"
  create_kustomization   = false # don't dump arbitray files to ephemeral runner fs

  # If you want to allow all outbound traffic you can set this to "false". Default is "true".
  # restrict_outbound_traffic = false

  # Adding extra firewall rules, like opening a port
  # More info on the format here https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall
  # extra_firewall_rules = [
  #   # For Postgres
  #   {
  #     direction       = "in"
  #     protocol        = "tcp"
  #     port            = "5432"
  #     source_ips      = ["0.0.0.0/0", "::/0"]
  #     destination_ips = [] # Won't be used for this rule
  #   },
  #   # To Allow ArgoCD access to resources via SSH
  #   {
  #     direction       = "out"
  #     protocol        = "tcp"
  #     port            = "22"
  #     source_ips      = [] # Won't be used for this rule
  #     destination_ips = ["0.0.0.0/0", "::/0"]
  #   }
  # ]


  cilium_values = <<EOT
ipam:
  mode: kubernetes
devices: "eth1"
k8s:
  requireIPv4PodCIDR: true
kubeProxyReplacement: strict
l7Proxy: false
encryption:
  enabled: true
  type: wireguard
  EOT 

  # Cert manager, all cert-manager helm values can be found at https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
  # The following is an example, please note that the current indentation inside the EOT is important.
  /*   cert_manager_values = <<EOT
installCRDs: true
replicaCount: 3
webhook:
  replicaCount: 3
cainjector:
  replicaCount: 3
  EOT */



  # Nginx, all Nginx helm values can be found at https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
  # You can also have a look at https://kubernetes.github.io/ingress-nginx/, to understand how it works, and all the options at your disposal.
  # The following is an example, please note that the current indentation inside the EOT is important.
  /*   nginx_ingress_values = <<EOT
controller:
  watchIngressWithoutClass: "true"
  kind: "DaemonSet"
  config:
    "use-forwarded-headers": "true"
    "compute-full-forwarded-for": "true"
    "use-proxy-protocol": "true"
  service:
    annotations:
      "load-balancer.hetzner.cloud/name": "k3s"
      "load-balancer.hetzner.cloud/use-private-ip": "true"
      "load-balancer.hetzner.cloud/disable-private-ingress": "true"
      "load-balancer.hetzner.cloud/location": "nbg1"
      "load-balancer.hetzner.cloud/type": "lb11"
      "load-balancer.hetzner.cloud/uses-proxyprotocol": "true"
  EOT */

}
