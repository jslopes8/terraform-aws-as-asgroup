# Terraform module for create AWS Launch Configuration
Provider a launch configuration for autoscaling group.

The code will provide the following resources
* [AutoScaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
* [AutoScaling Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy)
* [AutoScaling Schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule)

### Usage
```hcl
module "lb_bastion_group" {
    source  = "git@github.com:jslopes8/terraform-aws-as-asgroup.git?ref=v2.0"

    asg_name             = "web-compute-asg"

    vpc_zone_identifier  = [ "sg-xxxxx", "sg-yyyyyy" ]

    min_size             = "1"
    max_size             = "1"

    health_check_type    = "ELB"
    load_balancers       = [ "lb-web-compute" ]
    launch_configuration = module.lb_bastion_config.name

  auto_scaling_policy_up = [
    {
      name                = "${local.stack_name}-Worker-Policy-UP"
      scaling_adjustment  = "1"
      adjustment_type     = "ChangeInCapacity"
      cooldown            = "300"
      policy_type         = "SimpleScaling"
      alarm_name          = "${local.stack_name}-Worker-Metric-Alarm-UP"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/EC2"
      metric_name         = "CPUUtilization"
      period              = "300"
      statistic           = "Average"
      threshold           = "60"
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
| asg_name | O nome do Auto Scaling Group. | `yes` | `string` | `` |
| auto_scaling_policy_up | Definição de uma politica de dimensionamento automaticos. | `no` | `list` | `` |
| auto_scaling_policy_down | Definição de um politica de redimensionamento automaticos. | `no` | `list` | `` |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| as_name_to_lb |  The name of the autoscale group |
| as_name_to_tg |  The name of the autoscale group |