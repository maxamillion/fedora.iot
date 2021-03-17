lang en_US.UTF-8
keyboard us
timezone UTC
zerombr
clearpart --all --initlabel
autopart --type=plain --fstype=xfs --nohome
reboot
text
network --bootproto=dhcp
user --name=core --groups=wheel --password=edge
services --enabled=ostree-remount
ostreesetup --nogpg --url=http://10.0.2.2:8000/repo/ --osname=rhel --remote=edge --ref=rhel/8/x86_64/edge

%post
# Create a dummy service to tickle insights-client on boot
# This could (should?) integrate somehow with greenboot
cat > /etc/systemd/system/insights-on-boot.service << EOF
[Unit]
Description=Collect insights data on reboot
ConditionFileNotEmpty=/etc/pki/consumer/cert.pem
After=insights-client-results.service
Wants=insights-client.service

[Service]
Type=oneshot
ExecStart=/usr/bin/sh -c 'echo "Ran insights client on boot"'

[Install]
WantedBy=multi-user.target
EOF

systemctl enable insights-on-boot
%end
