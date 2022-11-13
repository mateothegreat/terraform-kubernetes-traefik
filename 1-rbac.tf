resource "kubernetes_service_account" "traefik" {

    metadata {

        name      = var.name
        namespace = var.namespace

    }

}

resource "kubernetes_cluster_role" "traefik" {

    metadata {

        name = var.name

    }

    rule {

        api_groups = [ "" ]
        resources  = [ "services", "endpoints", "secrets" ]
        verbs      = [ "get", "list", "watch" ]

    }

    rule {

        api_groups = [ "networking.k8s.io", "extensions" ]
        resources  = [ "ingresses", "ingressclasses" ]
        verbs      = [ "get", "list", "watch" ]

    }

    rule {

        api_groups = [ "extenions" ]
        resources  = [ "ingresses/status" ]
        verbs      = [ "update" ]

    }

    rule {

        api_groups = [ "traefik.containo.us" ]
        resources  = [
            "middlewares",
            "middlewaretcps",
            "ingressroutes",
            "traefikservices",
            "ingressroutetcps",
            "ingressrouteudps",
            "tlsoptions",
            "tlsstores",
            "serverstransports"
        ]
        verbs = [ "get", "list", "watch" ]

    }

}

resource "kubernetes_cluster_role_binding" "traefik" {

    metadata {

        name = var.name

    }

    role_ref {

        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = var.name

    }

    subject {

        kind      = "ServiceAccount"
        name      = var.name
        namespace = var.namespace

    }

}