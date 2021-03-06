output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
  sensitive = true
}

# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
  value = kubernetes_service.load_balancer.status[0].load_balancer[0].ingress[0].hostname
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
  sensitive = true
}


# output "aws_secret" {
#   value = aws_iam_access_key.pod.encrypted_secret
#   sensitive = true
# }

# output "aws_key_id" {
#   value = aws_iam_access_key.pod.id
# }
