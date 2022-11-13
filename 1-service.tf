resource "kubernetes_service" "tcp" {

    metadata {

        name        = "${ var.name }-tcp"
        namespace   = var.namespace
        annotations = var.service_tcp_annotations

    }

    spec {

        type = var.service_type

        selector = {

            app = var.name

        }

        dynamic "port" {

            for_each = [ for p in var.service_ports : p if p.protocol == "TCP" ]

            content {

                name        = port.value.name
                port        = port.value.port
                target_port = port.value.target_port
                protocol    = "TCP"

            }
        }

    }

}

#resource "kubernetes_service" "udp" {
#
#    metadata {
#
#        name        = "${ var.name }-udp"
#        namespace   = var.namespace
#        annotations = var.service_tcp_annotations
#
#    }
#
#    spec {
#
#        type = var.service_type
#
#        selector = {
#
#            app = var.name
#
#        }
#
#        dynamic "port" {
#
#            for_each = concat(var.service_udp_ports, var.service_udp_additional_ports)
#
#            content {
#
#                name        = port.value.name
#                port        = port.value.port
#                target_port = port.value.target_port
#                protocol    = "UDP"
#
#            }
#        }
#
#    }
#
#}
