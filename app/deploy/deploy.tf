data "aws_ecs_task_definition" "this" {
  task_definition = "ci-cd-app"
}

resource "aws_ecs_service" "this" {
  name                          = "app-service"
  cluster                       = var.cluster_name
  task_definition               = data.aws_ecs_task_definition.this.arn
  desired_count                 = var.desired_count
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    subnets          = var.subnets_id
    security_groups  = data.aws_security_groups.this.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.this.arn
    container_name   = "ci-cd-app"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}