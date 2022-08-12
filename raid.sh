DEVICE_LIST=("sdb" "sdc")
FILE_SYSTEM="ext4"
MOUNT_POINT="/mnt/raidfolder"
RAID_LEVEL=0

usage()
{
    echo "Usage:"
    echo "  $0 [OPTIONS]"
    echo "    -m <MOUNT_POINT>          Destination mount point, defaults to /mnt/raidfolder/"
    echo "    -d <DEVICE_LIST>          Disks' names to raid (ex. \"sdb sdc sdd\"), defaults to sdb sdc"
    echo "    -l <RAID_LEVEL>           Level of raidin, default to 0"
    echo "    -f <FILE_SYSTEM>          File system, defaults to ext4."
    echo "    created by @rottenahorta"
}

while getopts "m:d:f:l:" opt; do
    case ${opt} in
        m )
            MOUNT_POINT=$OPTARG
            echo "    Mount point: $MOUNT_POINT"
            ;;
        d )
            DEVICE_LIST=($OPTARG)
            echo "    Disks to raid: $DEVICE_LIST"
            ;; 
        f )
            FILE_SYSTEM=$OPTARG
            echo "    File System: $FILE_SYSTEM"
            ;;
        l )
            RAID_LEVEL=$OPTARG
            echo "    Raid lvl: $RAID_LEVEL"
            ;; 
        *)
            usage
            ;;
    esac
done

echo -e "Creating Partitions.... "
DEVICE_LIST_PARTED=()
for DEVICE in "${DEVICE_LIST[@]}"
do
    echo "    Partitioning disk /dev/${DEVICE}"
    sudo fdisk /dev/${DEVICE} << EOF
    n
    
     
    

    wq
EOF
DEVICE_LIST_PARTED+=("/dev/${DEVICE}1")
done

sudo mdadm --create --level ${RAID_LEVEL} --raid-device=${#DEVICE_LIST[@]} /dev/md0 ${DEVICE_LIST_PARTED[@]} 
echo "RAIDIN"

sudo mdadm --detail --scan >> /etc/mdadm.conf
echo "Updatin mdadm.conf"

sudo mkfs.${FILE_SYSTEM} /dev/md0
echo "creatin drive for raid"

sudo mkdir ${MOUNT_POINT}
sudo mount /dev/md0 ${MOUNT_POINT}
echo "mountin raid"

sudo echo "/dev/md0 ${MOUNT_POINT} ${FILE_SYSTEM} defaults 0 0" >> /etc/fstab
echo "default setup of raid to boot onto /etc/fstab"
echo "raid has ended sucessfully"