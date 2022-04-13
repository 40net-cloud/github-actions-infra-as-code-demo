#cloud-config
package_upgrade: true
packages:
  - curl
  - apt-transport-https
  - ca-certificates
  - software-properties-common
  - unzip
runcmd:
  - [mkdir, '/actions-runner']
  - cd /actions-runner
  - [curl, -o, 'actions-runner.tar.gz', -L, 'https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz']
  - [tar, -xzf, 'actions-runner.tar.gz']
  - [chmod, -R, 777, '/actions-runner']
  - [su, azureuser, -c, '/actions-runner/config.sh --url https://github.com/${github_repo} --token ${runner_token} --runasservice --unattended --replace']
  - ./svc.sh install
  - ./svc.sh start
  - [rm, '/actions-runner/actions-runner.tar.gz']
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - DEBIAN_FRONTEND=noninteractive apt update
  - DEBIAN_FRONTEND=noninteractive apt -y install docker-ce
  - curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
  - apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  - DEBIAN_FRONTEND=noninteractive apt update
  - DEBIAN_FRONTEND=noninteractive apt -y install terraform
  - DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:ansible/ansible
  - DEBIAN_FRONTEND=noninteractive apt update
  - DEBIAN_FRONTEND=noninteractive apt -y install ansible