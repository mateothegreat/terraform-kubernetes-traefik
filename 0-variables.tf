variable "namespace" {

    type        = string
    default     = "traefik"
    description = "namespace to deploy daemonset in"

}

variable "name" {

    type        = string
    default     = "traefik"
    description = "name of the daemonset"

}

variable "node_selector" {

    type        = map(string)
    description = "map of node selector labels"
    default     = {}

}

variable "image" {

    type        = string
    default     = "traefik:2.8"
    description = "traefik docker image"

}

variable "request_cpu" {

    type        = string
    description = "resource request for cpu"

}

variable "request_memory" {

    type        = string
    description = "resource request for memory"

}

variable "limit_cpu" {

    type        = string
    description = "resource limit for cpu"

}

variable "limit_memory" {

    type        = string
    description = "resource limit for memory"

}

variable "service_type" {

    type        = string
    default     = "LoadBalancer"
    description = "type of service for the load balancer (LoadBalancer or NodePort)"

}

variable "service_loadbalancer_internal" {

    type        = bool
    default     = true
    description = "whether or not to make this an internal only load balancer or public"

}

variable "service_ports" {

    type = list(object({

        name        = string
        port        = number
        target_port = number
        protocol    = string

    }))

    default = [

        {

            name        = "http"
            port        = 80
            target_port = 80
            protocol    = "TCP"

        }, {

            name        = "https"
            port        = 443
            target_port = 443
            protocol    = "TCP"

        }

    ]

}

variable "service_tcp_annotations" {

    type        = map(string)
    description = "additional service annotations"
    default     = null

}

variable "service_udp_annotations" {

    type        = map(string)
    description = "additional service annotations"
    default     = null

}

variable "traefik_config" {

    type        = string
    description = "traefik.yaml configuration"

}

variable "tls_name" {

    type        = string
    description = "tls certificate name"

}

variable "tls_store_namespaces" {

    type        = list(string)
    default     = [ "default" ]
    description = "list of namespaces to install tls store in to"

}
