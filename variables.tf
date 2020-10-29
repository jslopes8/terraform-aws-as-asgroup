variable "create" {
    type = bool
    default = true
}
variable "asg_name" {
    type = string
}
variable "vpc_zone_identifier" {
    type    = list(string)
    default = []
}
variable "launch_configuration" {
    type    = string
    default = null
}
variable "load_balancers" {
    type    = any
    default = null
}
variable "min_size" {
    type    = number
    default = 1
}
variable "max_size" {
    type    = number
    default = 1
}
variable "health_check_type" {
    type    = string
    default = null
}
variable "default_cooldown" {
    type    = number
    default = "300"
}
variable "health_check_grace_period" {
    type    = number
    default = "300"
}
variable "default_tags" {
    type    = list(map(string))
    default = []
}
variable "target_group_arns" {
    type = any
    default = null
}
variable "asg_policy" {
    type = any 
    default = []
}
variable "metric_alarm" {
    type = any 
    default = []
}
variable "scheduled_action" {
    type = any 
    default = []
}
