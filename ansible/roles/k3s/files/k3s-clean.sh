#!/usr/bin/env bash
set -euo pipefail

skip=false
for arg in "$@"; do
    case "$arg" in
        -s|--skip) skip=true ;;
    esac
done

sudo -v

while ! systemctl is-active --quiet k3s.service; do
    echo "K3s is not running"
    exit 0
done

if [ "$skip" = false ]; then
    CURRENT_TIME="$(date +%s)"
    BACKUP_JOB_NAME="backups-rclone-backup-${CURRENT_TIME}"
    kubectl -n infrastructure create job --from cronjob/backups-rclone-backup "$BACKUP_JOB_NAME"
    kubectl -n infrastructure wait job/"$BACKUP_JOB_NAME" --for=condition=complete --timeout=300s
    echo "Backup successful"
    RESTORE_JOB_NAME="backups-rclone-restore-${CURRENT_TIME}"
    kubectl -n infrastructure create job --from cronjob/backups-rclone-restore "$RESTORE_JOB_NAME"
    kubectl -n infrastructure wait job/"$RESTORE_JOB_NAME" --for=condition=complete --timeout=300s
    echo "Restore successful"
fi

sudo k3s-killall.sh
sudo -k
unset ANSIBLE_BECOME_PASSWORD
