resource "kubernetes_manifest" "tls-store" {

    count = length(var.tls_store_namespaces)

    manifest = {

        apiVersion = "traefik.containo.us/v1alpha1"
        kind       = "TLSStore"

        metadata = {

            namespace = var.tls_store_namespaces[ count.index ]
            name      = "${ var.name }-tls-store"

        }

        spec = {

            defaultCertificate = {

                secretName = var.tls_name

            }

        }

    }

}
