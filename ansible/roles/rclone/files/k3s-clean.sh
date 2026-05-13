#!/usr/bin/env bash
set -euo pipefail

skip=false
for arg in "$@"; do
    case "$arg" in
        -s|--skip) skip=true ;;
    esac
done

read -rs -p "[sudo: authenticate] Password: " pass
echo
export ANSIBLE_BECOME_PASSWORD="$pass"
echo "$pass" | sudo -Sv

while ! systemctl is-active --quiet k3s.service; do
    echo "K3s is not running"
    exit 0
done

if [ "$skip" = false ]; then
    cd /opt/repos/home-lab && uv run ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --tags backup,restore -e "ansible_become_password=$pass"
fi

sudo k3s-killall.sh
sudo -k
unset ANSIBLE_BECOME_PASSWORD
