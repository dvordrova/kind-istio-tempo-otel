resource "kind_cluster" "new" {
  name            = var.kind_cluster_name
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<-EOT
        kind: ClusterConfiguration
        etcd:
          local:
            # Run etcd in a tmpfs (in RAM) for performance improvements
            dataDir: /tmp/kind-cluster-etcd
        apiServer:
          extraArgs:
            profiling: "true"
        # We run single node, drop leader election to reduce overhead
        controllerManager:
          extraArgs:
            leader-elect: "false"
        scheduler:
          extraArgs:
            leader-elect: "false"
        ---
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        patches:
          directory: /patches
        EOT
      ]
      # patch GOMAXPROCS to 1
      extra_mounts {
        host_path      = "${path.module}/kind-patches"
        container_path = "/patches"
      }
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
      extra_port_mappings {
        container_port = 30443
        host_port      = 30443
      }
      extra_port_mappings {
        container_port = 30080
        host_port      = 30080
      }
      extra_port_mappings {
        container_port = 30021
        host_port      = 30021
      }
    }

    node {
      role = "worker"
    }
  }
}
