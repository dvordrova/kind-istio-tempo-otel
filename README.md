# What

Create cluster with grafana, tempo, victoria metrics, istio and
To discover how spans draws like a service graph in tempo

# Prerequisites

- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm (for manual runs)](https://helm.sh/docs/intro/install/)

# How to

```bash codespace
make prepare-codespace
make run
curl http://localhost:30080/svc2/proxy
# {"text":"Hello, World!"}

# check user/pass in
```

# How to check

Check creds in [terraform/values](terraform/values)
Open grafana in browser http://localhost:30080/grafana
Go to "Explore" -> "Service Graph"

```bash destroy
make destroy
```

![result service graph](result.jpg)

# How

we start infrustructure where tempo comes with service metrics-generator, which generates metrics by spans

moreover in tempo datasource we use our prometheus-compatible victoria for fetching metrics for service graph

general application
[docs](https://grafana.com/docs/tempo/latest/metrics-generator/service_graphs/)

```

```
