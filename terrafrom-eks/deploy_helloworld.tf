resource "helm_release" "helloworld" {
  name      = "hello-world"
  namespace = "default"
  chart     = "../deploy/helloworld"

  #   set {
  #     name  = "service.type"
  #     value = "ClusterIP"
  #   }

}
