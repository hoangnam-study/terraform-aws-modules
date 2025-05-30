
# # ssm
# resource "aws_iam_role" "ec2_ssm_role" {
#   name = "ec2-ssm-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ssm_core" {
#   role       = aws_iam_role.ec2_ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_instance_profile" "ssm_instance_profile" {
#   name_prefix = "ec2-ssm-profile"
#   role        = aws_iam_role.ec2_ssm_role.name
# }

# # endpoints

# resource "aws_security_group" "vpc_endpoint_sg" {
#   name        = "vpc-endpoint-sg"
#   description = "EC2 to VPC Endpoints"
#   vpc_id      = data.terraform_remote_state.app_vpc.outputs.vpc.id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [data.terraform_remote_state.app_vpc.outputs.vpc.cidr_block]
#     description = "Allow HTTPS from EC2 to endpoint"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id             = data.terraform_remote_state.app_vpc.outputs.vpc.id
#   service_name       = "com.amazonaws.${local.region}.ssm"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = values(data.terraform_remote_state.app_vpc.outputs.be_subnets)[*].id
#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "ssmmessages" {
#   vpc_id             = data.terraform_remote_state.app_vpc.outputs.vpc.id
#   service_name       = "com.amazonaws.${local.region}.ssmmessages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = values(data.terraform_remote_state.app_vpc.outputs.be_subnets)[*].id
#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "ec2messages" {
#   vpc_id             = data.terraform_remote_state.app_vpc.outputs.vpc.id
#   service_name       = "com.amazonaws.${local.region}.ec2messages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = values(data.terraform_remote_state.app_vpc.outputs.be_subnets)[*].id
#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
# }
