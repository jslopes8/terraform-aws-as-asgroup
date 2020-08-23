output "as_name_to_lb" {
    value = length(aws_autoscaling_group.asg_with_lb) > 1 ? aws_autoscaling_group.asg_with_lb.0.name : null
}
output "as_name_to_tg" {
    value = length(aws_autoscaling_group.asg_with_tg) > 1 ? aws_autoscaling_group.asg_with_tg.0.name : null
}