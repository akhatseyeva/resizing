#!/bin/bash

SIZE=${1:-20}

NAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

VOLUMEID=$(aws ec2 describe-instances \
--filters Name=dns-name,Values=${NAME} \
--query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" \
--output text)



echo Modify volume ${VOLUMEID}

aws ec2 modify-volume --volume-id $VOLUMEID --size $SIZE

seconds=1

while [ \
    "$(aws ec2 describe-volumes-modifications \
        --volume-id $VOLUMEID \
        --filters Name=modification-state,Values="optimizing","completed" \
        --query "length(VolumesModifications)"\
        --output text)" != "1" ]; do
    sleep 1
    let seconds++
done

echo ${seconds} seconds to resize disk

#Check if we're on an NVMe filesystem
if [ $(curl http://169.254.169.254/latest/meta-data/block-device-mapping/ami
) = "/dev/xvda" ]
then
    sudo growpart /dev/xvda 1
    STR=$(cat /etc/os-release)
    SUB="VERSION_ID=\"2\""
    if [[ "$STR" == *"$SUB"* ]]
    then
        sudo xfs_growfs -d /
    else
        sudo resize2fs /dev/xvda1
    fi

else
    sudo growpart /dev/nvme0n1 1

    STR=$(cat /etc/os-release)
    SUB="VERSION_ID=\"2\""
    if [[ "$STR" == *"$SUB"* ]]
    then
        sudo xfs_growfs -d /
    else
        sudo resize2fs /dev/nvme0n1p1
    fi
fi
