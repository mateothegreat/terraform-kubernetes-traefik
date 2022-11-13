resource "kubernetes_daemonset" "traefik" {

    depends_on = [

        kubernetes_config_map.traefik,
        kubernetes_manifest.tls-store,
        kubernetes_manifest.tls-options

    ]

    metadata {

        name      = var.name
        namespace = var.namespace

        annotations = {

            "prometheus.io/scrape" = "true"
            "prometheus.io/port"   = "80"

        }

        labels = {

            app = var.name

        }

    }

    spec {

        selector {

            match_labels = {

                app = var.name

            }

        }

        template {

            metadata {

                name = var.name

                labels = {

                    app = var.name

                }

            }

            spec {

                service_account_name             = var.name
                node_selector                    = var.node_selector
                termination_grace_period_seconds = 0

                container {

                    name = "traefik"

                    image = var.image

                    #                    args = concat([
                    #
                    #                        #                        "--api",
                    #                        #                        "--kubernetes",
                    #                        #                        "--logLevel=INFO",
                    #                        #                        "--api.insecure=true",
                    #
                    #                    ], [ for p in var.service_ports : "--entryPoints.${ lower(p.name) }.address=:${ p.port }" ])

                    dynamic "port" {

                        for_each = var.service_ports

                        content {

                            name           = port.value.name
                            container_port = port.value.target_port
                            protocol       = port.value.protocol

                        }

                    }

                    volume_mount {

                        name       = "config"
                        mount_path = "/etc/traefik"

                    }

                    resources {

                        requests = {

                            cpu    = var.request_cpu
                            memory = var.request_memory

                        }

                        limits = {

                            cpu    = var.limit_cpu
                            memory = var.request_memory

                        }

                    }

                }

                volume {

                    name = "config"

                    config_map {

                        name = var.name

                        items {

                            key  = "traefik.yml"
                            path = "traefik.yml"

                        }

                    }

                }

            }

        }

    }

}
