# raid_script
Simple raid shell script that creates RAID system of given disks using md0 drive, creates simple default partitions of given disks

"Usage:"
    echo "    -m <MOUNT_POINT>          Destination mount point, defaults to /mnt/raidfolder/"
    echo "    -d <DEVICE_LIST>          Disks' names to raid (ex. \"sdb sdc sdd\"), defaults to sdb sdc"
    echo "    -l <RAID_LEVEL>           Level of raidin, default to 0"
    echo "    -f <FILE_SYSTEM>          File system, defaults to ext4."
    echo "    created by @rottenahorta"
