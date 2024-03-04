resource "helm_release" "metallb" {
  name             = "metallb"
  namespace        = "metallb"
  create_namespace = true

  repository       = "oci://registry-1.docker.io/bitnamicharts/metallb"
  chart            = "metallb"
  version          = "4.15.0"
  #values           = [templatefile("${path.module}/values/values.yaml",
  #  {    
  #  })
  #]
  timeout                 = 1200
}
