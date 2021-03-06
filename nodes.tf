module "main_network_node" {
  source = "github.com/eximchain/terraform-aws-eximchain-node.git//terraform/modules/eximchain-node"

  aws_region         = var.aws_region
  availability_zones = [var.eximchain_node_availability_zone]

  node_count   = 1
  archive_mode = true

  create_load_balancer       = true
  use_internal_load_balancer = true

  public_key    = aws_key_pair.blockscout.public_key
  # TODO: Don't make certs if we're using an external vault
  cert_owner    = "$USER"
  cert_org_name = "Eximchain Pte. Ltd."

  eximchain_node_ami           = var.eximchain_node_ami
  eximchain_node_instance_type = var.eximchain_node_instance_type

  aws_vpc = aws_vpc.vpc.id

  base_subnet_cidr = "${cidrsubnet(var.vpc_cidr, 2, 2)}"

  # Allow RPC from tx executor
  rpc_security_groups     = [aws_security_group.app.id]
  num_rpc_security_groups = 1

  # External Vault Parameters
  # TODO: Gamma network
  #vault_dns  = "${module.tx_executor_vault.vault_dns}"
  #vault_port = "${var.vault_port}"
  #vault_cert_bucket = "${module.tx_executor_vault.vault_cert_bucket_name}"

  network_id = "1"

  node_volume_size = 200

  force_destroy_s3_bucket = true
}