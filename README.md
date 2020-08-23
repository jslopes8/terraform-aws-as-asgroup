# Terraform module for create AWS Launch Configuration
Provider a launch configuration for autoscaling group.

The code will provide the following resources
* [AutoScaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
* [AutoScaling Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy)
* [AutoScaling Schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule)

### Usage
```hcl
module "lb_bastion_group" {
    source  = "/home/jslopes/Documents/CloudTeam/Modules_Terraform/AWS/Services/Compute/AS/terraform-aws-as-asgroup/"

    asg_name             = "web-compute-asg"

    vpc_zone_identifier  = [ "sg-xxxxx", "sg-yyyyyy" ]

    min_size             = "1"
    max_size             = "1"

    health_check_type    = "ELB"
    load_balancers       = [ "lb-web-compute" ]
    launch_configuration = module.lb_bastion_config.name

    asg_policy = [
        {
            name                = "cpualarm_policy"
            caling_adjustment   = "1"
            adjustment_type     = "ChangeInCapacity"
            cooldown            = "300"
            policy_type         = "SimpleScaling"
            
        }
    ]

    metric_alarm = [
        {
            alarm_name          = "${local.stack_name}-metric-alarm-up"
            comparison_operator = "GreaterThanOrEqualToThreshold" 
            evaluation_periods  = "2"
            metric_name         = "CPUUtilization"
            period              = "300"
            threshold           = "60"
        },
        {
            alarm_name         =  "${local.stack_name}-metric-alarm-down"
            comparison_operator = "LessThanOrEqualToThreshold" 
            evaluation_periods  = "2"
            metric_name         = "CPUUtilization"
            period              = "120"
            threshold           = "5"
        }
    ]
}
```
## Requirements
| Name | Version |
| ---- | ------- |
| aws | ~> 3.3 |
| terraform | 0.13 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| asg_name | The name of the auto scaling group | `yes` | `string` | `` |


## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| as_name_to_lb |  The name of the autoscale group |
| as_name_to_tg |  The name of the autoscale group |