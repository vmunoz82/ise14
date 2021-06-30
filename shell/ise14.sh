#!/bin/bash

ISE14_IMAGE=${ISE14_IMAGE:-"ise:14.7"}
LICENSE_MAC=${LICENSE_MAC:-"08:00:27:68:c9:35"}
XILINXD_LICENSE_FILE=${XILINXD_LICENSE_FILE:-"/opt/Xilinx/Xilinx.lic"}

ISE_PATH=/opt/Xilinx/14.7/ISE_DS

echo ISE14_IMAGE: $ISE14_IMAGE
echo LICENSE_MAC: $LICENSE_MAC
echo XILINXD_LICENSE_FILE: $XILINXD_LICENSE_FILE
echo WORKPLACE: $PWD

docker run --rm \
--user $(id -u):$(id -g) \
--mac-address $LICENSE_MAC \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro  \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-e PATH=/bin:/sbin:$ISE_PATH/ISE/bin/lin64 \
-e LD_LIBRARY_PATH=$ISE_PATH/ISE/lib/lin64:$ISE_PATH/common/lib/lin64 \
-e XILINXD_LICENSE_FILE=$XILINXD_LICENSE_FILE \
-v "$PWD:$PWD" \
-w $PWD \
-v /dev/bus/usb:/dev/bus/usb \
--device-cgroup-rule='c *:* rmw' \
-ti $ISE14_IMAGE $@
