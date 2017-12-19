FROM voidlinux/voidlinux
MAINTAINER Andrea Brancaleoni "miwaxe@gmail.com"

RUN xbps-install -Syyu &&\
	xbps-install -Syy git curl &&\
	mkdir -p /run/runit/runsvdir/current &&\
	xbps-install -Syu socklog-void &&\
	ln -s /etc/sv/socklog-unix /var/service/ &&\
	mkdir /etc/sv/socklog-forward &&\
	printf "#!/bin/sh\ntail -F -n0 /var/log/socklog/everything/current" > /etc/sv/socklog-forward/run &&\
	chmod +x /etc/sv/socklog-forward/run &&\
	ln -s /etc/sv/socklog-forward /var/service &&\
	ln -s /etc/sv /etc/service

RUN xbps-install -Syyu qemu && mkdir -p /etc/sv/qemu /usr/lib/qemu/ && ln -s /etc/sv/qemu /var/service
ADD enoch_rev2839_boot /usr/lib/qemu/
ADD boot.sh /etc/sv/qemu/run
ADD OVMF_CODE-pure-efi.fd /usr/lib/qemu/
ADD OVMF_VARS-pure-efi-1024x768.fd /usr/lib/qemu/
ADD Clover.qcow2 /usr/lib/qemu/

EXPOSE 2222 5800 5900 5001

CMD runsvdir -P /var/service
