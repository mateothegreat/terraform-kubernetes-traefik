resource "kubernetes_config_map" "traefik" {

    metadata {

        name      = var.name
        namespace = var.namespace

    }

    data = {

        "traefik.yml" = var.traefik_config

    }

}