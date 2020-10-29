## AutoScaling Group
resource "aws_autoscaling_group" "asg_with_lb" {
    count = var.create && var.target_group_arns == null ? 1 : 0

    name                        = var.asg_name
    vpc_zone_identifier         = var.vpc_zone_identifier
    launch_configuration        = var.launch_configuration
    min_size                    = var.min_size
    max_size                    = var.max_size
    load_balancers              = var.load_balancers
    health_check_type           = var.health_check_type
    health_check_grace_period   = var.health_check_grace_period
    default_cooldown            = var.default_cooldown

    tags    = concat([
         {
            "key"                   = "Name"
            "value"                 = var.asg_name
            "propagate_at_launch"   = true
         },
        ],
        var.default_tags,
    )

    lifecycle {
      create_before_destroy = true
    }
}
resource "aws_autoscaling_group" "asg_with_tg" {
    count = var.create && var.target_group_arns != null ? 1 : 0

    name                    = var.asg_name
    vpc_zone_identifier     = var.vpc_zone_identifier
    launch_configuration    = var.launch_configuration
    min_size                = var.min_size
    max_size                = var.max_size
    health_check_type       = var.health_check_type
    target_group_arns       = var.target_group_arns

    tags    = concat([
         {
            "key"                   = "Name"
            "value"                 = var.asg_name
            "propagate_at_launch"   = true
         },
        ],
        var.default_tags,
    )

    lifecycle {
      create_before_destroy = true
    }
}
## AutoScaling Policy
resource "aws_autoscaling_policy" "asg_with_lb" {
    count = var.create && var.target_group_arns == null ? length(var.asg_policy) : 0

    autoscaling_group_name  = aws_autoscaling_group.asg_with_lb.0.name
    name                = lookup(var.asg_policy[count.index], "name", null)
    scaling_adjustment  = lookup(var.asg_policy[count.index], "scaling_adjustment", null)
    adjustment_type     = lookup(var.asg_policy[count.index], "adjustment_type", null)
    cooldown            = lookup(var.asg_policy[count.index], "cooldown", null)
    policy_type         = lookup(var.asg_policy[count.index], "policy_type", null)
}
resource "aws_autoscaling_policy" "asg_with_tg" {
    count = var.create && var.target_group_arns != null ? length(var.asg_policy) : 0

    autoscaling_group_name  = aws_autoscaling_group.asg_with_tg.0.name
    name                = lookup(var.asg_policy[count.index], "name", null)
    scaling_adjustment  = lookup(var.asg_policy[count.index], "scaling_adjustment", null)
    adjustment_type     = lookup(var.asg_policy[count.index], "adjustment_type", null)
    cooldown            = lookup(var.asg_policy[count.index], "cooldown", null)
    policy_type         = lookup(var.asg_policy[count.index], "policy_type", null)
}
# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "asg_with_lb" {
    count = var.create && var.target_group_arns == null ? length(var.metric_alarm) : 0

    alarm_name          = lookup(var.metric_alarm[count.index], "alarm_name", null)
    alarm_description   = lookup(var.metric_alarm[count.index], "alarm_description", null)
    comparison_operator = lookup(var.metric_alarm[count.index], "comparison_operator", null)
    evaluation_periods  = lookup(var.metric_alarm[count.index], "evaluation_periods", null)
    metric_name         = lookup(var.metric_alarm[count.index], "metric_name", null)
    namespace           = lookup(var.metric_alarm[count.index], "namespace", null)
    period              = lookup(var.metric_alarm[count.index], "period", null)
    statistic           = lookup(var.metric_alarm[count.index], "statistic", null)
    threshold           = lookup(var.metric_alarm[count.index], "threshold", null)
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.asg_with_lb.0.name
    }
    actions_enabled     = lookup(var.metric_alarm[count.index], "actions_enabled", null)
    alarm_actions       = [ aws_autoscaling_policy.asg_with_lb.0.arn ]
}
resource "aws_cloudwatch_metric_alarm" "asg_with_tg" {
    count = var.create && var.target_group_arns != null ? length(var.metric_alarm) : 0

    alarm_name          = lookup(var.metric_alarm[count.index], "alarm_name", null)
    alarm_description   = lookup(var.metric_alarm[count.index], "alarm_description", null)
    comparison_operator = lookup(var.metric_alarm[count.index], "comparison_operator", null)
    evaluation_periods  = lookup(var.metric_alarm[count.index], "evaluation_periods", null)
    metric_name         = lookup(var.metric_alarm[count.index], "metric_name", null)
    namespace           = lookup(var.metric_alarm[count.index], "namespace", null)
    period              = lookup(var.metric_alarm[count.index], "period", null)
    statistic           = lookup(var.metric_alarm[count.index], "statistic", null)
    threshold           = lookup(var.metric_alarm[count.index], "threshold", null)
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.asg_with_tg.0.name
    }
    actions_enabled     = lookup(var.metric_alarm[count.index], "actions_enabled", null)
    alarm_actions       = [ aws_autoscaling_policy.asg_with_tg.0.arn ]
}
## AutoScaling Schedule
resource "aws_autoscaling_schedule" "asg_with_lb" {
    count = var.create && var.target_group_arns == null ? length(var.scheduled_action) : 0

    autoscaling_group_name = aws_autoscaling_group.asg_with_lb.0.name
    scheduled_action_name  = var.scheduled_action[count.index]["scheduled_action_name"]
    min_size               = var.scheduled_action[count.index]["min_size"]
    max_size               = var.scheduled_action[count.index]["max_size"]
    desired_capacity       = var.scheduled_action[count.index]["desired_capacity"]
    recurrence             = var.scheduled_action[count.index]["recurrence"]
}
resource "aws_autoscaling_schedule" "asg_with_tg" {
    count = var.create && var.target_group_arns != null ? length(var.scheduled_action) : 0

    scheduled_action_name  = var.scheduled_action[count.index]["scheduled_action_name"]
    min_size               = var.scheduled_action[count.index]["min_size"]
    max_size               = var.scheduled_action[count.index]["max_size"]
    desired_capacity       = var.scheduled_action[count.index]["desired_capacity"]
    recurrence             = var.scheduled_action[count.index]["recurrence"]
    autoscaling_group_name = aws_autoscaling_group.asg_with_tg.0.name
}
