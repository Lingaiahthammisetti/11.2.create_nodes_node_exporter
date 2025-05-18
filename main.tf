
resource "aws_instance" "nodes_ec2" {
    for_each = var.instances
    ami           = data.aws_ami.rhel_info.id
    instance_type = each.value
    vpc_security_group_ids = [var.allow_everything]
    #user_data = file("${path.module}/node_exporter/node_exporter.sh")

    tags = {
        Name = each.key
    }
}
resource "aws_route53_record" "nodes_r53" {
    zone_id = var.zone_id
    for_each = aws_instance.nodes_ec2
    name    = "${each.key}.${var.domain_name}"
    type    = "A"
    ttl     = 1
    records = each.key == "" ? [] : [each.value.public_ip]
    allow_overwrite = true
}
