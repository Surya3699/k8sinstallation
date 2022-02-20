# Kubernetes Cluster Installation
**A.** Cluster Installation Commands:

*1.* ETCD: ansible-playbook -i hosts.ini playbook.yml --tags=etcd

*2.* Binaries: ansible-playbook -i hosts.ini playbook.yml --tags=k8s-binary

*3.* Masters: ansible-playbook -i hosts.ini playbook.yml --tags=k8s-master

*4.* Workers: ansible-playbook -i hosts.ini playbook.yml --tags=k8s-worker

*5.* Monitoring: ansible-playbook -i hosts.ini playbook.yml --extra-vars "env=dev name=\<clustername\>" --tags=k8s-mon

    "env=dev"  --> For Development
    "env=qa"   --> For QA
    "env=ppd"  --> For PreProduction
    "env=prod" --> For Production
    "name=hcp" --> For HCP Cluster

**Note:** This ansible is irrespective of HostOS and Network Interface

**B.** Node Addition Commands:

*1.* ansible-playbook -i new-node-hosts.ini add-node-playbook.yml --tags=k8s-new-worker
