swapoff -a

sed -i '/ swap / s/^/#/' /etc/fstab

modprobe br_netfilter

sh -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"

sh -c "echo '1' > /proc/sys/net/ipv4/ip_forward"


export VERSION=1.27

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/CentOS_8/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

dnf install cri-o -y 

systemctl enable crio

systemctl start crio


cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.25/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.25/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

dnf install -y kubelet-1.25.0 -y kubeadm-1.25.0  -y kubectl-1.25.0 --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet







