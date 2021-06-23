#!/bin/bash

# Handle args.
if [ $# -eq 0 ]; then
        echo "Usage: $0 <old block device>"
        exit 1
fi

OLD_DEV="$1"
MOUNT_PT=$(cat /etc/mtab | grep $OLD_DEV | cut -d ' ' -f 2)
UUID=$(grep "$MOUNT_PT" /etc/fstab | cut -d ' ' -f 1 | cut -d $'\t' -f 1 | cut -d '=' -f 2);
NEW_DEV=$(readlink -f /dev/disk/by-uuid/$UUID | sed -r 's/\/dev\/(.*)[0-9].*/\1/')

#echo "DEBUG: OLD_DEV=\"$OLD_DEV\", MOUNT_PT=\"$MOUNT_PT\", UUID=\"$UUID\" NEW_DEV=\"$NEW_DEV\""

echo "Remounting $MOUNT_PT with disk UUID=$UUID ($OLD_DEV → $NEW_DEV):"
echo "    Stopping NFS server…"
systemctl stop nfs-kernel-server
echo "    Unmounting (NB: LAZY MODE !!)…"
umount -v -l $MOUNT_PT
echo "    Mounting…"
mount -v $MOUNT_PT
echo "    Starting NFS server…"
systemctl start nfs-kernel-server
