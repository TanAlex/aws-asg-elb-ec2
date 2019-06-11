### Creating EC2 instance

resource "aws_instance" "web" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.my-ssh-key.key_name}"

  security_groups = [
    "${aws_security_group.allow_ssh.name}",
    #"${aws_security_group.allow_outbound.name}",
    "${aws_security_group.ec2.name}"
  ]
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get -y install ansible",
  #   ]

  #   connection {
  #     type          = "ssh"
  #     user          = "ubuntu"
  #     private_key   = "${file("~/.ssh/id_rsa")}"
  #   }
  # }
  source_dest_check = false
  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p 80 &
            EOF

  tags {
    Name = "${format("web-%03d", count.index + 1)}"
  }
}


