resource "kubernetes_manifest" "tls-options" {

    manifest = {

        apiVersion = "traefik.containo.us/v1alpha1"
        kind       = "TLSOption"

        metadata = {

            namespace = var.namespace
            name      = "${ var.name }-tls-options"

        }

        spec = {

            minVersion = "VersionTLS12"
            sniStrict  = false

            curvePreferences = [

                "CurveP521",
                "CurveP384"

            ]

            cipherSuites = [

                "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
                "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
                "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
                "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305",
                "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
                "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305",
                "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
                "TLS_AES_256_GCM_SHA384",
                "TLS_AES_128_GCM_SHA256",
                "TLS_CHACHA20_POLY1305_SHA256",
                "TLS_FALLBACK_SCSV"

            ]

        }

    }

}
