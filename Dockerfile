FROM centos:7

MAINTAINER Takuya Murakami <tmurakam@tmurakam.org>

RUN yum install -y sudo shadow-utils openssh-server openssh-clients
RUN rm -rf /var/cache/yum/* && yum clean all

ENV USER ansible
RUN useradd -g wheel $USER && echo "$USER:$USER" | chpasswd ;\
    mkdir /home/$USER/.ssh;\
    sed -i -e 's/^\(%wheel\s\+.\+\)/#\1/gi' /etc/sudoers ;\
    echo -e '\n%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo -e '\nDefaults:root   !requiretty' >> /etc/sudoers && \
    echo -e '\nDefaults:%wheel !requiretty' >> /etc/sudoers

ADD id_rsa.pub /home/$USER/.ssh/authorized_keys

RUN ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd



CMD ["/usr/sbin/sshd", "-D"]
