#!/usr/bin/env bash

backup_active=""
backup_inactive=""

#while true; do
#  backup_is_active_res=$(systemctl is-active restic-nas-backup.service)
#  if [ "$backup_is_active_res" == "inactive" ]; then
#    echo "$backup_inactive next: $(systemctl show restic-nas-backup.timer --value --property=NextElapseUSecRealtime)" ; sleep 10
#  elif [ "$backup_is_active_res" == "activating" ]; then
#    echo "$backup_active in progress" ; sleep 10
#  else
#    echo "$backup_inactive backup state unknown"
#  fi
#done

backup_is_active_res=$(systemctl is-active restic-nas-backup.service)
if [ "$backup_is_active_res" == "inactive" ]; then
    echo "$backup_inactive next: $(systemctl show restic-nas-backup.timer --value --property=NextElapseUSecRealtime | date -f /dev/stdin '+%-d %b %H:%M:%S')"
elif [ "$backup_is_active_res" == "activating" ]; then
    echo "$backup_active in progress"
else
    echo "$backup_inactive backup state unknown"
fi

