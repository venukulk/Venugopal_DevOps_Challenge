
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.10.1"

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
      value = "internet-facing"
    },
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Cluster"
    },
    {
      name  = "controller.hostNetwork"
      value = "true"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-healthcheck-path"
      value = "/"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-healthcheck-port"
      value = "80"
    },
    {
      name  = "controller.extraArgs.default-ssl-certificate"
      value = "default/my-app-tls"
   }
  ]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  
  set = [
  {
    name  = "args.kube-reserved"
    value = "cpu=200m,memory=200Mi"
  },
  {
    name  = "args.kube-reserved"
    value = "cpu=200m,memory=200Mi"
  },
  {
    name  = "apiService.create"
    value = "true"
  }
  ] 
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "my-kube-prometheus-stack"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.6.2" # <-- pick a stable version from 'helm search repo'

  create_namespace = true

  # Optionally set values
  set = [
  {
    name  = "grafana.service.type"
    value = "ClusterIP"
  },

#  Example: expose Grafana via existing ingress (optional)
  {
    name  = "grafana.ingress.enabled"
    value = "true"
  },
  {
    name  = "grafana.ingress.ingressClassName"
    value = "nginx"
  },
  {
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.demo.challenge.local"
  }
  ]
}


resource "helm_release" "loki" {
  name       = "loki"
  namespace  = "monitoring"
  chart      = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  create_namespace = true
  set = [
  {
    name  = "grafana.enabled"
    value = "false"
  },
  {
    name  = "prometheus.enabled"
    value = "true"
  },
  {
    name = "loki.persistence.enabled"
    value = "false"
  }
  ]
}

resource "helm_release" "promtail" {
  name       = "promtail"
  namespace  = "monitoring"
  chart      = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  create_namespace = true  
  set = [
  {
    name  = "config.lokiAddress"
    value = "http://loki.monitoring:3100/loki/api/v1/push"
  },
  {
    name  = "config.filepath"
    value = "/var/log/containers/*.log"
  }
  ]
}

# resource "helm_release" "tempo" {
#   name       = "tempo"
#   namespace  = "tempo"
#   chart      = "tempo"
#   repository = "https://grafana.github.io/helm-charts"
#   #  version    = "0.16.11"

#   create_namespace = true
# }


# resource "helm_release" "mimir" {
#   name       = "mimir"
#   namespace  = "mimir"
#   chart      = "mimir-distributed"
#   repository = "https://grafana.github.io/helm-charts"
#   version    = "2.0.2"

#   create_namespace = true
# }

# resource "helm_release" "grafana" {
#   name       = "grafana"
#   namespace  = "grafana"
#   chart      = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   version    = "6.26.2"

#   create_namespace = true
#   values = [
#     <<EOF
# adminUser: admin
# adminPassword: admin
# datasources:
#   datasources.yaml:
#     apiVersion: 1
#     datasources:
#       - name: Loki
#         type: loki
#         access: proxy
#         url: http://loki.loki.svc.cluster.local:3100
#       - name: Tempo
#         type: tempo
#         access: proxy
#         url: http://tempo.tempo.svc.cluster.local:3100
#       - name: Mimir
#         type: prometheus
#         access: proxy
#         url: http://mimir-query-frontend.mimir.svc.cluster.local:80
#         EOF
#   ]
# }

