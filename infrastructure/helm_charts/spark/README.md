# Apache Spark Helm Chart

This chart deploys a basic Apache Spark master on a Kubernetes cluster.

## Installation

To install the chart:

```bash
helm install my-spark ./infrastructure/helm_charts/spark
```

## Configuration

The following table lists the configurable parameters of the Spark chart and their default values.

| Parameter | Description | Default |
|---|---|---|
| `replicaCount` | Number of Spark master replicas | `1` |
| `image.repository` | Spark image repository | `bitnami/spark` |
| `image.tag` | Spark image tag | `3.5.0` |
| `service.type` | Kubernetes Service type | `ClusterIP` |
| `service.port` | Port for the Spark UI | `80` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install my-spark ./infrastructure/helm_charts/spark --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided:

```bash
helm install my-spark ./infrastructure/helm_charts/spark -f values.yaml
```
