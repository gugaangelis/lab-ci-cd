data "aws_security_groups" "this" {
  filter {
    name   = "tag:Name"
    values = [var.sg_name]
  }
}

data "aws_lb" "this" {
  name = var.lb_name
}

data "aws_lb_target_group" "this" {
  name = var.tg_name
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/ci-cd-app"
  retention_in_days = 7
}
