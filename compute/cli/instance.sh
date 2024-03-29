get-ip() {
    local instance_name=$1
    gcloud compute instances describe ${instance_name} --zone=${zone} --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
}

wait-until-ssh() {
    local instance_name=$1
    # --quiet is useless here
    curl -sSL https://raw.githubusercontent.com/davidkhala/linux-utils/main/wait-until.sh | bash -s gcloud compute ssh ${instance_name} --zone=${zone} --command=true
}
backup-vm() {
    local instance_name=$1
    gcloud compute machine-images create $2 --source-instance=${instance_name}
}
delete-vm() {
    local instance_name=$1
    gcloud compute instances delete ${instance_name} --zone=${zone} --quiet
}

$@
