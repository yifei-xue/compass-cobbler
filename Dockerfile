FROM compassindocker/systemd-base
ENV container docker
VOLUME [ "/sys/fs/cgroup" ]

# pkgs and services...
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install cobbler cobbler-web dhcp bind syslinux pykickstart file initscripts net-tools tcpdump && \
    systemctl enable cobblerd && \
    systemctl enable httpd && \
    systemctl enable dhcpd

# some tweaks on services
RUN sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp && \
    touch /etc/xinetd.d/rsync

RUN mkdir -p /var/www/cblr_ks

COPY start.sh /usr/local/bin/start.sh
RUN mv /etc/httpd/conf.d/cobbler_web.conf /etc/httpd/conf.d/cobbler_web.conf.bk
COPY cobbler_web.conf /etc/httpd/conf.d/cobbler_web.conf
VOLUME ["/var/lib/cobbler", "/var/www/cobbler", "/etc/cobbler", "/mnt", "/var/www/cobbler/repo_mirror"]
EXPOSE 67
EXPOSE 69
EXPOSE 80
EXPOSE 443
EXPOSE 25151
CMD ["/sbin/init", "/usr/local/bin/start.sh"]
