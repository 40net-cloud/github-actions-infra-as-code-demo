#cloud-config
package_upgrade: true
packages:
  - curl
  - apt-transport-https
  - ca-certificates
  - software-properties-common
runcmd:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - DEBIAN_FRONTEND=noninteractive apt update
  - DEBIAN_FRONTEND=noninteractive apt -y install docker-ce
  - docker run -d --restart always -p 80:5000 bencuk/python-demoapp
  - docker run -d --restart always -p 81:5000 bencuk/python-demoapp