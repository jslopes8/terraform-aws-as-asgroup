variable "asg_name" {
    type    = string
    default = ""
}
variable "vpc_zone_identifier" {
    type    = list(string)
    default = []
}
variable "min_size" {
    type    = number
    default = 1
}
variable "max_size" {
    type    = number
    default = 1
}
variable "load_balancers" {
    type    = string
    default = "null" 
}
variable "launch_configuration" {
    type    = string
}
variable "target_group_arns" {
    type    = string
    default = "null"
}
variable "default_tags" {
    type    = list(map(string))
    default = []
}
variable "health_check_type" {
    type    = string
    default = ""
}
variable "scaling_adjustment" {
    type    = number
    default = 1
}
variable "adjustment_type" {
    type    = string
    default = ""
}
variable "cooldown" {
    type    = number
    default = "300"
}
variable "policy_type" {
    type    = string
}
variable "comparison_operator" {
    type    = string
    default = ""
}
variable "create_sched_policy" {
    type    = bool
    default = true
}
variable "scheduled_action_up" {
    type    = list(map(string))
    default = []
}
variable "scheduled_action_down" {
    type    = list(map(string))
    default = []
}


variable "evaluation_periods" {
    type    = number
    default = "1"
}
variable "metric_name" {
    type    = string
    default = "CPUUtilization"
}
variable "namespace" {
    type    = string
    default = "AWS/EC2"
}
variable "period" {
    type    = number
    default = "120"
}
variable "period_less" {
    type    = number
    default = "300"
}
variable "statistic" {
    type    = string
    default = "Average"
}
variable "threshold" {
    type    = string
    default = "60"
}
variable "threshold_less" {
    type    = string
    default = "5"
}
variable "actions_enabled" {
    type    = bool
    default = "true"
}
variable "comparison_operator_less" {
    type    = string
    default = "LessThanOrEqualToThreshold"
}
