resource "aws_launch_template" "app" {
  name_prefix   = "app-template"
  image_id      = "ami-050887ebff330de9f" # Replace with a valid AMI ID
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id] # Attach EC2 SG
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              docker run -d -p 80:80 nginx
              EOF
            )
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
}

