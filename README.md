# What

Create cluster with grafana, tempo, victoria metrics, istio and
To discover how spans draws like a service graph in tempo

# Prerequisites

- make
- python3
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm (for manual runs)](https://helm.sh/docs/intro/install/)

# How to run (Github Codespaces)

## Create codespace

![create codespace](images/codespace-create.jpg)

## Run next commands

```bash
make prepare-codespace
make run
curl http://localhost:30080/svc2/proxy
# {"text":"Hello, World!"}
```

## Find the proxied port 3080

![find port](images/check-grafana-find-port.jpg)

## Go to grafana

![grafana](images/check-grafana-go-to-grafana.jpg)

## Pass creds to grafana

![grafana creds](images/check-grafana-creds.jpg)

## Open expore tab

Go to "Explore" -> "Service Graph"

## Results

![result service graph](images/tempo-my-go-app.jpg)
![bonus](images/tempo-tempo-service-graph.jpg)

## Friendly reminder

delete codespace after you finish if don't need it anymore

# How to destroy cluster

```bash destroy
make destroy
```

# How

we start infrustructure where tempo comes with service metrics-generator, which generates metrics by spans and sends them to victoria-metrics

the go application itelf make spans and sends them to tempo distributor (otel)
on top of that istio tracks down requests from servicer to service and sends them to tempo distributor (zipkin)

[docs](https://grafana.com/docs/tempo/latest/metrics-generator/service_graphs/)
