################################################################################
## AutoScaling Group

resource "aws_autoscaling_group" "scalegroup_load_balancers" {

    name                    = var.asg_name
    vpc_zone_identifier     = var.vpc_zone_identifier
    launch_configuration    = var.launch_configuration
    min_size                = var.min_size
    max_size                = var.max_size
    #load_balancers          = [ "${var.load_balancers}" ]
    health_check_type       = var.health_check_type
    target_group_arns       = [ var.target_group_arns ]

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

resource "aws_autoscaling_policy" "as_policy_lb" {

    name                    = "${var.asg_name}-CPU-Alarm-Policy"
    scaling_adjustment      = var.scaling_adjustment
    adjustment_type         = var.adjustment_type
    cooldown                = var.cooldown
    autoscaling_group_name  = aws_autoscaling_group.scalegroup_load_balancers.name
    policy_type             = var.policy_type
}

resource "aws_cloudwatch_metric_alarm" "as_metric_alarm_lb" {

    alarm_name          = "${var.asg_name}-Metric-Alarm"
    alarm_description   = "CPU-Alarm-${var.asg_name}"
    comparison_operator = var.comparison_operator
    evaluation_periods  = var.evaluation_periods
    metric_name         = var.metric_name
    namespace           = var.namespace
    period              = var.period
    statistic           = var.statistic
    threshold           = var.threshold
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.scalegroup_load_balancers.name
    }
    actions_enabled     = var.actions_enabled
    alarm_actions       = [ aws_autoscaling_policy.as_policy_lb.arn ]
}



resource "aws_autoscaling_policy" "as_policy_down_lb" {

    name                    = "${var.asg_name}-CPU-Alarm-Policy-scaledown"
    scaling_adjustment      = -1
    adjustment_type         = var.adjustment_type
    cooldown                = var.cooldown
    autoscaling_group_name  = aws_autoscaling_group.scalegroup_load_balancers.name
    policy_type             = var.policy_type
}

resource "aws_cloudwatch_metric_alarm" "as_metric_scaledown_lb" {

    alarm_name          = "${var.asg_name}-Metric-Alarm-scaledown"
    alarm_description   = "Metric-Alarm-scaledown-${var.asg_name}"
    comparison_operator = var.comparison_operator_less
    evaluation_periods  = var.evaluation_periods
    metric_name         = var.metric_name
    namespace           = var.namespace
    period              = var.period_less
    statistic           = var.statistic
    threshold           = var.threshold_less
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.scalegroup_load_balancers.name
    }
    actions_enabled     = true
    alarm_actions       = [ aws_autoscaling_policy.as_policy_down_lb.arn ]
}

resource "aws_autoscaling_schedule" "schedule_down" {
    count   = var.create_sched_policy ? length(var.scheduled_action_down) : 0

    scheduled_action_name  = var.scheduled_action_down[count.index]["scheduled_action_name"]
    min_size               = var.scheduled_action_down[count.index]["min_size"]
    max_size               = var.scheduled_action_down[count.index]["max_size"]
    desired_capacity       = var.scheduled_action_down[count.index]["desired_capacity"]
    recurrence             = var.scheduled_action_down[count.index]["recurrence"]
    autoscaling_group_name = aws_autoscaling_group.scalegroup_load_balancers.name
}
resource "aws_autoscaling_schedule" "schedule_up" {
    count   = var.create_sched_policy ? length(var.scheduled_action_up) : 0

    scheduled_action_name  = var.scheduled_action_up[count.index]["scheduled_action_name"]
    min_size               = var.scheduled_action_up[count.index]["min_size"]
    max_size               = var.scheduled_action_up[count.index]["max_size"]
    desired_capacity       = var.scheduled_action_up[count.index]["desired_capacity"]
    recurrence             = var.scheduled_action_up[count.index]["recurrence"]
    autoscaling_group_name = aws_autoscaling_group.scalegroup_load_balancers.name
}