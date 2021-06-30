ISE14_IMAGE=${ISE14_IMAGE:-"ise:14.7"}

ID=$(docker create $ISE14_IMAGE)

ISE_PATH=/opt/Xilinx/14.7/ISE_DS/ISE

docker cp $ID:$ISE_PATH/bin/lin64/xusb_emb.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusb_xlp.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusb_xp2.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusb_xpr.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusb_xse.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusb_xup.hex /tmp/
docker cp $ID:$ISE_PATH/bin/lin64/xusbdfwu.hex /tmp/

docker rm $ID

