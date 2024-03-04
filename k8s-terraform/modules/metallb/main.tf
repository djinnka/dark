resource "helm_release" "metallb" {
  name             = "metallb"
  namespace        = "metallb"
  create_namespace = true

  repository       = "github.com/metallb/metallb/config/frr?ref=v0.14.3"
  chart            = "metallb"
  version          = "4.15.0"
  #values           = [templatefile("${path.module}/values/values.yaml",
  #  {    
  #  })
  #]
  timeout                 = 1200
}
