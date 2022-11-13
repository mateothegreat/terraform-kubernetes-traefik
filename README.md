# traefik on kubernetes

This module installs traefik on kubernetes as a DaemonSet with a service.

## Example

```hcl
provider "kubernetes" {

    config_path = "~/.kube/config"

}

module "test" {

    source = "./.."

    name           = "traefik"
    namespace      = "default"
    request_cpu    = "1"
    request_memory = "1Gi"
    limit_cpu      = "1"
    limit_memory   = "1Gi"
    
    node_selector = {

        role = "infra"

    }

    traefik_config = <<EOF
global:
  checkNewVersion: true
  sendAnonymousUsage: false

serversTransport:
  insecureSkipVerify: true
  maxIdleConnsPerHost: 42
  forwardingTimeouts:
    dialTimeout: 42s
    responseHeaderTimeout: 42s
    idleConnTimeout: 42s

entryPoints:
    http:
        address: ":80"
    https:
        address: ":443"
    metrics:
        address: ":8081"

http:
    middlewares:
        https-redirect:
            redirectScheme:
                scheme: https
https:
    middlewares:
        default-headers:
            headers:
                frameDeny: true
                sslRedirect: true
                browserXssFilter: true
                contentTypeNosniff: true
                forceSTSHeader: true
                stsIncludeSubdomains: true
                stsPreload: true
        secured:
            chain:
                middlewares:
                    - default-whitelist
                    - default-headers
    tls:
        secretName: tls-mlfabric.ai


ingress:
  enabled: true
  className: "nginx"

providers:
  providersThrottleDuration: 42s
  kubernetesCRD:
    namespaces:
      - models
    allowCrossNamespace: true
    allowExternalNameServices: true
    throttleDuration: 42s
    allowEmptyServices: true
  kubernetesIngress:
    namespaces:
      - models
    ingressClass: http
    throttleDuration: 42s
    allowEmptyServices: true

api:
  insecure: true
  dashboard: true
  debug: true

metrics:
  prometheus:
    entryPoint: metrics
    buckets:
      - 0.1
      - 0.3
      - 1.2
      - 5.0
      - 10.0
    addEntryPointsLabels: true
    addRoutersLabels: true
    addServicesLabels: true
    entryPoint: foobar
    manualRouting: true

ping:
  terminatingStatusCode: 42

accessLog:
    format: json

experimental:
    plugins:
        blockpath:
            moduleName: github.com/traefik/plugin-blockpath
            version: v0.2.1
log:
  level: DEBUG
EOF

}
```