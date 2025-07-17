
resource "aws_instance" "nodes_ec2" {
    for_each = var.instances
    ami           = data.aws_ami.rhel_info.id
    instance_type = each.value
    vpc_security_group_ids = [var.allow_everything]
    #user_data = file("${path.module}/node_exporter/node_exporter.sh")
    root_block_device {
        encrypted             = false
        volume_type           = "gp3"
        volume_size           = 50
        iops                  = 3000
        throughput            = 125
        delete_on_termination = true
    }
    user_data = <<-EOF
                #!/bin/bash
                cd /opt
                wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
                tar -xf node_exporter-1.9.1.linux-amd64.tar.gz
                mv node_exporter-1.9.1.linux-amd64 node_exporter
                
                echo "
                [Unit]
                Description=Node Exporter
                After=network-online.target

                [Service]
                Restart=on-failure
                ExecStart=/opt/node_exporter/node_exporter

                [Install]
                WantedBy=multi-user.target
                " > /etc/systemd/system/node_exporter.service

                systemctl daemon-reload
                systemctl enable node_exporter
                systemctl start node_exporter
                systemctl status node_exporter
                EOF

    tags = {
        Name = each.key
        Environment = "dev"
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
