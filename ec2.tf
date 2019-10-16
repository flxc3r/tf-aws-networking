resource "aws_key_pair" "test_access" {
  key_name   = "test_access_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjKa/yFvD27WW6oEkwJlfWGOV+avgBjVUDTTn8t+YjRrT3rhPP7ckupDpFkja5xvAGJrqo4ki+i0jypzFz1mboxo2zR1zAgRxIwlWX5AGOBFet2jljytdyo9bCBHVd5tUwUswD+BGUKmF6v8U4aX6VwUSDdIN0tRrvvHnfneeJqK921ztKBn65s/CD66uS7gFQg9amNCbtV15XWCUzF/eWtor/suR+WQkQnt98UkAy5o5ypBT//4rWIkvw39HKaqBJO2bmebZomNw17Gg8bIG4FhPSZcya3BUYIYn7383I6XtarUzbqHtv/ftslbh8MFAknvp/xGkkur6TBdfzfTuJQ=="
}

locals {
    instance-userdata = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        sudo service httpd start
        sudo chkconfig httpd on
        sudo mkdir /var/www/html/
        cd /var/www/html/
        sudo echo "instance-id: " > index.html
        curl http://169.254.169.254/latest/meta-data/instance-id >> index.html
        sudo echo "<br>" >> index.html
        sudo echo "security-groups: " >> index.html
        curl http://169.254.169.254/latest/meta-data/security-groups/ >> index.html
        EOF
}


# resource "aws_instance" "web" {
#   ami           = "ami-00c03f7f7f2ec15c3" # Amazon Linux 2 AMI on us-east-2
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.webdmz.id]
#   key_name = aws_key_pair.test_access.key_name

#   user_data_base64 = "${base64encode(local.instance-userdata)}"

#   depends_on=[aws_key_pair.test_access]

#   tags = {
#     Name = "web"
#   }
# }


resource "aws_instance" "bastion" {
  ami           = "ami-00c03f7f7f2ec15c3" # Amazon Linux 2 AMI on us-east-2
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name = aws_key_pair.test_access.key_name

  user_data_base64 = "${base64encode(local.instance-userdata)}"

  depends_on=[aws_key_pair.test_access]

  tags = {
    Name = "bastion"
  }
}


# resource "aws_instance" "db" {
#   ami           = "ami-00c03f7f7f2ec15c3" # Amazon Linux 2 AMI on us-east-2
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.db.id]
#   key_name = aws_key_pair.test_access.key_name

#   user_data_base64 = "${base64encode(local.instance-userdata)}"

#   depends_on=[aws_key_pair.test_access]

#   tags = {
#     Name = "db"
#   }
# }
