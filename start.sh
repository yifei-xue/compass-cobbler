#!/bin/bash
cp -rf /root/conf/* /etc/cobbler/

mkdir -p /var/lib/cobbler/kickstarts-backup
mv /var/lib/cobbler/kickstarts/* /var/lib/cobbler/kickstarts-backup
cp -rf /root/kickstarts/* /var/lib/cobbler/kickstarts

mkdir -p /var/lib/cobbler/snippets-backup
mv /var/lib/cobbler/snippets/* /var/lib/cobbler/snippets-backup
cp -rf /root/snippets/* /var/lib/cobbler/snippets/

mkdir -p /var/lib/cobbler/triggers-backup
mv /var/lib/cobbler/triggers/* /var/lib/cobbler/triggers-backup
cp -rf /root/triggers/* /var/lib/cobbler/triggers

mkdir -p /var/lib/cobbler/scripts-backup
mv /var/lib/cobbler/scripts/* /var/lib/cobbler/scripts-backup
cp -rf /root/scripts/* /var/lib/cobbler/scripts

mkdir -p /var/lib/cobbler/repo_mirror
cp -rf /root/ppas/* /var/lib/cobbler/repo_mirror

service httpd restart
service cobblerd restart
sleep 5

cobbler import --path=/mnt/ubuntu-14.04.3-server-amd64 --name ubuntu-14.04.3-server-amd64 --arch=x86_64 --kickstart=/var/lib/cobbler/kickstarts/default.seed --breed=ubuntu
cobbler import --path=/mnt/CentOS-7-Minimal-1511-x86_64 --name CentOS-7-Minimal-1511-x86_64 --arch=x86_64 --kickstart=/var/lib/cobbler/kickstart/default.ks --breed=redhat
cobbler repo add --name trusty-mitaka-ppa  --mirror=/var/lib/cobbler/repo_mirror/trusty-mitaka-ppa --miorror-locally=Y --arch=x86_64 --apt-dists=trusty --apt-components=main
cobbler repo add --name centos7-mitaka-ppa --mirror=/var/lib/cobbler/repo_mirror/centos7-mitaka-ppa --miorror-locally=y --arch=x86_64

service cobblerd restart
sleep 5
cobbler sync
cobbler reposync
