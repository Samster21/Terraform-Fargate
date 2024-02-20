# data "aws_vpc" "vpc" {
#   tags = {
#     key = "purpose"
#     value = "ECS"
#   }
# }

# data "aws_subnets" "subnets" {
#   filter {
#     name = "vpc-id"
#     values = [data.aws_vpc.vpc.id]
#   }
# }