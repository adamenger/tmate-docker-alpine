resource "digitalocean_droplet" "tmate" {
  image  = "${var.image}"
  name   = "${var.name}"
  region = "${var.region}"
  size   = "${var.size}"
  ssh_keys = "${var.ssh_keys}"
  user_data = <<USERDATA
#cloud-configs
write_files:
- path: /etc/systemd/system/tmate.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Start tmate server
    
    [Service]
    ExecStartPre=/bin/bash -c "/bin/systemctl set-environment TMATE_IP=$(/sbin/ifconfig eth0 | grep -v 'inet6' | grep inet | awk '{print $2}')"
    ExecStart=/usr/bin/docker run --rm --privileged -e HOST=$${TMATE_IP} -e PORT=${var.port} -p ${var.port}:${var.port} -v tmate-keys:/etc/tmate-keys --name ${var.name} atomenger/tmate-alpine
    ExecStop=/usr/bin/docker stop ${var.name}
    ExecStopPost=/usr/bin/docker rm ${var.name}
runcmd:
- systemctl daemon-reload
- systemctl start tmate.service
USERDATA
}

output "public_ip" {
  value = "${digitalocean_droplet.tmate.ipv4_address}"
}
