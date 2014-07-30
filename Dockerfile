FROM centos:centos6

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV HOME /root

RUN rpm -Uvh \
	https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum reinstall -y glibc-common

RUN yum --enablerepo centosplus install -y \
	libselinux-python \
 	openssh-server \
 	sudo \
 	passwd \
 	supervisor \
 	nginx

# Setup ssh
RUN service sshd start ; service sshd stop

# Setup sudo
RUN echo "Defaults !requiretty" > /etc/sudoers.d/no-require-tty && chmod 0600 /etc/sudoers.d/no-require-tty
RUN adduser user && sudo -u user mkdir /home/user/.ssh && sudo -u user chmod 0700 /home/user/.ssh
RUN echo "user ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/user && chmod 0600 /etc/sudoers.d/user

# Upload authorized_keys
COPY authorized_keys /home/user/.ssh/authorized_keys
RUN chmod 0600 /home/user/.ssh/authorized_keys && chown user.user -R /home/user/.ssh

# Setup supervisord
COPY supervisor.conf /etc/supervisord.conf

# Setup nginx
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 22

CMD ["/usr/bin/supervisord"]

