# outputs.tf

output "sg_webdmz" {
  value = aws_security_group.webdmz.id
}


#########


output "this_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = module.aurora.this_rds_cluster_resource_id
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.this_rds_cluster_endpoint
}

output "this_rds_cluster_master_password" {
  description = "The master password"
  value       = module.aurora.this_rds_cluster_master_password
}

output "this_rds_cluster_port" {
  description = "The port"
  value       = module.aurora.this_rds_cluster_port
}

output "this_rds_cluster_master_username" {
  description = "The master username"
  value       = module.aurora.this_rds_cluster_master_username
}


# bastion
output "ec2_bastion_public_ip" {
  
  value       = aws_instance.bastion.public_ip
}