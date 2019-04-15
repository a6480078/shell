#!/bin/bash


select kube in env_prepare kubeadm_init exit;do
case $kube in
env_prepare)
######################装包#################################################
echo
yum install -y  bash-completion ebtables epel-release docker etcd yum-utils device-mapper-persistent-data lvm2 net-tools conntrack-tools wget vim  ntpdate libseccomp libtool-ltdl
sleep 2
echo
echo
IP=`ifconfig eth0|grep "inet "|awk '{print$2}'`
HOSTNAME=`hostname`
mkdir -p /root/kubernetes-1.10
cd /root/kubernetes-1.10
wget http://203.110.209.244:88/rpm/kubernetes-1.10/kube-flannel.yml
wget http://203.110.209.244:88/rpm/kubernetes-1.10/k8s_docker_images_1.10.0.zip
wget http://203.110.209.244:88/rpm/kubernetes-1.10/kube-packages-1.10.1.tar
#####################关闭防火墙########################################
systemctl stop firewalld && systemctl disable firewalld

swapoff -a
sed -i '/swap/d' /etc/fstab

setenforce 0
echo SELINUX=disabled > /etc/sysconfig/selinux

modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.d/k8s.conf

echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf
echo "* soft nproc 65536"  >> /etc/security/limits.conf
echo "* hard nproc 65536"  >> /etc/security/limits.conf
echo "* soft  memlock  unlimited"  >> /etc/security/limits.conf
echo "* hard memlock  unlimited"  >> /etc/security/limits.conf
echo
echo
echo
echo "#################################################"
echo "#                                               #"
echo "# configured firewalld,swap,selinux,kernel,limit#"
echo "#                                               #"
echo "#################################################"



#####################创建etcd证书#########################################
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl_linux-amd64
mv cfssl_linux-amd64 /usr/local/bin/cfssl
chmod +x cfssljson_linux-amd64
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
chmod +x cfssl-certinfo_linux-amd64
mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo
export PATH=/usr/local/bin:$PATH

echo "cfssl env installed"
echo
echo

mkdir -p /root/ssl
cd /root/ssl
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes-Soulmate": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF
echo "ca-config.json is created"
cat > ca-csr.json << EOF
{
  "CN": "kubernetes-Soulmate",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "shanghai",
      "L": "shanghai",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
echo "ca-csr.json is created"
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cat > etcd-csr.json << EOF
{
  "CN": "etcd",
  "hosts": ["127.0.0.1","$IP"],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "shanghai",
      "L": "shanghai",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
echo "etcd-csr.json is created"
cfssl gencert -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes-Soulmate etcd-csr.json | cfssljson -bare etcd

mkdir -p /etc/etcd/ssl
cp etcd.pem etcd-key.pem ca.pem /etc/etcd/ssl/
chmod 644 /etc/etcd/ssl/etcd-key.pem

echo "#################################################"
echo "#                                               #"
echo "#       etcd authorization is completed         #"
echo "#                                               #"
echo "#################################################"
echo
echo
#####################安装etcd####################################
mkdir -p /var/lib/etcd
systemctl enable etcd
cat > /etc/systemd/system/multi-user.target.wants/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
User=etcd
# set GOMAXPROCS to number of processors
#ExecStart=/bin/bash -c "GOMAXPROCS=\$(nproc) /usr/bin/etcd --name=\"\${ETCD_NAME}\" --data-dir=\"\${ETCD_DATA_DIR}\" --listen-client-urls=\"\${ETCD_LISTEN_CLIENT_URLS}\""
ExecStart=/usr/bin/etcd \
--name $HOSTNAME \
--cert-file=/etc/etcd/ssl/etcd.pem \
--key-file=/etc/etcd/ssl/etcd-key.pem \
--peer-cert-file=/etc/etcd/ssl/etcd.pem \
--peer-key-file=/etc/etcd/ssl/etcd-key.pem \
--trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \
--initial-advertise-peer-urls https://$IP:2380 \
--listen-peer-urls https://$IP:2380 \
--listen-client-urls https://$IP:2379,http://127.0.0.1:2379 \
--advertise-client-urls https://$IP:2379 \
--initial-cluster-token etcd-cluster-0 \
--initial-cluster $HOSTNAME=https://$IP:2380 \
--initial-cluster-state new \
--data-dir=/var/lib/etcd
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload && systemctl start etcd

etcdctl --endpoints=https://$IP:2379 \
  --ca-file=/etc/etcd/ssl/ca.pem \
  --cert-file=/etc/etcd/ssl/etcd.pem \
  --key-file=/etc/etcd/ssl/etcd-key.pem  cluster-health

echo "#################################################"
echo "#                                               #"
echo "#       etcd        is          healthy         #"
echo "#                                               #"
echo "#################################################"
######################安装docker####################################
cat > /usr/lib/systemd/system/docker.service << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target
Wants=docker-storage-setup.service
Requires=docker-cleanup.timer

[Service]
Type=notify
NotifyAccess=main
EnvironmentFile=-/run/containers/registries.conf
EnvironmentFile=-/etc/sysconfig/docker
EnvironmentFile=-/etc/sysconfig/docker-storage
EnvironmentFile=-/etc/sysconfig/docker-network
Environment=GOTRACEBACK=crash
Environment=DOCKER_HTTP_HOST_COMPAT=1
Environment=PATH=/usr/libexec/docker:/usr/bin:/usr/sbin
ExecStart=/usr/bin/dockerd-current -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock \
          --add-runtime docker-runc=/usr/libexec/docker/docker-runc-current \
          --default-runtime=docker-runc \
          --exec-opt native.cgroupdriver=cgroupfs \
          --userland-proxy-path=/usr/libexec/docker/docker-proxy-current \
          --init-path=/usr/libexec/docker/docker-init-current \
          --seccomp-profile=/etc/docker/seccomp.json \
          \$OPTIONS \
          \$DOCKER_STORAGE_OPTIONS \
          \$DOCKER_NETWORK_OPTIONS \
          \$ADD_REGISTRY \
          \$BLOCK_REGISTRY \
          \$INSECURE_REGISTRY \
          \$REGISTRIES 
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
Restart=on-abnormal
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
echo
echo
echo {\"registry-mirrors\": [\"http://f1361db2.m.daocloud.io\"]} > /etc/docker/daemon.json
systemctl daemon-reload && systemctl restart docker ; systemctl enable docker
echo
echo
echo "#################################################"
echo "#                                               #"
echo "#       docker        is      installed         #"
echo "#                                               #"
echo "#################################################"

##################安装配置kubeadm#####################################
cd ~/kubernetes-1.10
tar -xvf kube-packages-1.10.1.tar
cd kube-packages-1.10.1/
sleep 1
rpm -ivdh socat-1.7.3.2-2.el7.x86_64.rpm 
sleep 1
rpm -ivdh kubernetes-cni-0.6.0-0.x86_64.rpm kubelet-1.10.1-0.x86_64.rpm  
sleep 1
rpm -ivdh kubectl-1.10.1-0.x86_64.rpm  
sleep 1
rpm -ivdh kubeadm-1.10.1-0.x86_64.rpm
sleep 1
cat > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf <<EOF
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
Environment="KUBELET_EXTRA_ARGS=–v=2 –fail-swap-on=false –pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/k8sth/pause-amd64:3.0"
ExecStart=
ExecStart=/usr/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_SYSTEM_PODS_ARGS \$KUBELET_NETWORK_ARGS \$KUBELET_DNS_ARGS \$KUBELET_AUTHZ_ARGS \$KUBELET_CADVISOR_ARGS \$KUBELET_CGROUP_ARGS \$KUBELET_CERTIFICATE_ARGS \$KUBELET_EXTRA_ARGS
EOF
systemctl daemon-reload
systemctl enable kubelet
echo "#################################################"
echo "#                                               #"
echo "#       kubeadm kubectl is    installed         #"
echo "#                                               #"
echo "#################################################"
#################导入docker 镜像######################################
cd ~/kubernetes-1.10
yum install unzip -y
unzip k8s_docker_images_1.10.0.zip -d k8s_docker_images
cd k8s_docker_images
bash docker_images_load.sh
echo "#################################################"
echo "#                                               #"
echo "#       docker images    is   uploaded          #"
echo "#                                               #"
echo "#################################################"


###############命令补全#############################################
source /usr/share/bash-completion/bash_completion
kubectl completion bash >> ~/.bashrc
source ~/.bashrc

echo "#################################################"
echo "#                                               #"
echo "#  kubectl bash-completion is installed         #"
echo "#                                               #"
echo "#################################################"

##############初始化集群###########################################
cd ~/kubernetes-1.10
cat > config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
etcd:
  endpoints:
  - https://$IP:2379
  caFile: /etc/etcd/ssl/ca.pem
  certFile: /etc/etcd/ssl/etcd.pem
  keyFile: /etc/etcd/ssl/etcd-key.pem
  dataDir: /var/lib/etcd
networking:
  podSubnet: 10.244.0.0/16
kubernetesVersion: 1.10.0
api:
  advertiseAddress: "$IP"
token: "b99a00.a144ef80536d4348"
tokenTTL: "0s"
apiServerCertSANs:
- $HOSTNAME
- $IP
featureGates:
  CoreDNS: true
EOF
echo
echo "config.yaml is created"
echo
sleep 5
read -n 1 -p "Do you want to reboot[Y/N]" answer
case $answer in
Y|y)
  echo
  reboot
;;
*)
  echo
  exit 1
esac
exit 0
;;
kubeadm_init)
echo
kubeadm init --config config.yaml
if [ $? -eq 0 ];then
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
fi
echo kubenetes is installed
sleep 5
##############部署flannel网络##########################################
kubectl apply -f kube-flannel.yml
;;
exit)
echo
exit 0
;;
esac
done
