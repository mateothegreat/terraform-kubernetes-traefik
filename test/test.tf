#
#{

#"service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
#"service.beta.kubernetes.io/aws-load-balancer-internal" = var.service_loadbalancer_internal == true || var.service_loadbalancer_internal == "true" ? "true" : null
#
#}
#
provider "kubernetes" {
    config_path = "~/.kube/config"
}

module "test" {

    source = "./.."

    name      = "traefik"
    namespace = "default"

    request_cpu    = "100m"
    request_memory = "100Mi"
    limit_cpu      = "100m"
    limit_memory   = "100Mi"

    tls_name             = "tls-traefik"
    tls_store_namespaces = [
        "default",
        "convictionsai",
    ]

    service_ports = [

        {

            name        = "http"
            port        = 80
            target_port = 80
            protocol    = "TCP"

        }, {

            name        = "dashboard"
            port        = 8080
            target_port = 8080
            protocol    = "TCP"

        }, {

            name        = "https"
            port        = 443
            target_port = 443
            protocol    = "TCP"
            #
            #        }, {
            #
            #            name        = "dashboard"
            #            port        = 8080
            #            target_port = 8080
            #            protocol    = "TCP"
            #
            #        }, {
            #
            #            name        = "webrtc-http"
            #            port        = 9000
            #            target_port = 9000
            #            protocol    = "UDP"
            #
            #        }, {
            #
            #            name        = "webrtc-udp"
            #            port        = 9001
            #            target_port = 9001
            #            protocol    = "UDP"

        }

    ]

    traefik_config = <<EOF
global:
  checkNewVersion: true
  sendAnonymousUsage: false

serversTransport:
  insecureSkipVerify: true
  maxIdleConnsPerHost: 10
  forwardingTimeouts:
    dialTimeout: 5m
    responseHeaderTimeout: 5m
    idleConnTimeout: 5m

entryPoints:
    http:
        address: ":80"
        transport:
          respondingTimeouts:
            writeTimeout: 2m
            readTimeout: 2m

    https:
        address: ":443"
        transport:
          respondingTimeouts:
            writeTimeout: 2m
            readTimeout: 2m

#    metrics:
#        address: ":8081"
#    webrtc-udp-9001:
#        address: ":9001/udp"
#http:
#  routers:
#    api-http:
#      rule: "Path(`/`)"
##      tls:
##        secretName: tls-traefik
##        options:
##          name: tlsoptions
##    middlewares:
##        https-redirect:
##            redirectScheme:
##                scheme: https
#
#https:
#  routers:
#    api-primary:
#      rule: "Path(`/`)"
#      tls:
#        secretName: tls-traefik
#        options:
#          name: tlsoptions
#          namespace: default
#      middlewares:
#        - path-replace-base@kubernetes
#        - path_base
#    middlewares:
#        default-headers:
#            headers:
#                frameDeny: true
#                sslRedirect: true
#                browserXssFilter: true
#                contentTypeNosniff: true
#                forceSTSHeader: true
#                stsIncludeSubdomains: true
#                stsPreload: true
#        secured:
#            chain:
#                middlewares:
#                    - default-whitelist
#                    - default-headers
#    tls:
#        secretName: tls-traefik
ingress:
  enabled: true
  className: "http"

providers:
#  providersThrottleDuration: 42s
  kubernetesCRD:
    namespaces:
      - default
      - rbacai
      - convictionsai
    allowCrossNamespace: true
    allowExternalNameServices: true
#    throttleDuration: 60s
    allowEmptyServices: true
  kubernetesIngress:
    namespaces:
      - default
      - rbacai
      - convictionsai
    ingressClass: traefik
    throttleDuration: 42s
    allowEmptyServices: true

api:
  insecure: true
  dashboard: true
  debug: true

#metrics:
#  prometheus:
#    entryPoint: metrics
#    buckets:
#      - 0.1
#      - 0.3
#      - 1.2
#      - 5.0
#      - 10.0
#    addEntryPointsLabels: true
#    addRoutersLabels: true
#    addServicesLabels: true
#    manualRouting: true
#
#ping:
#  terminatingStatusCode: 42

#accessLog:
#    format: json

#experimental:
#    plugins:
#        blockpath:
#            moduleName: github.com/traefik/plugin-blockpath
#            version: v0.2.1
log:
  level: DEBUG
EOF

}
