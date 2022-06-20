FROM ubuntu:20.04 AS builder
LABEL stage=builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y libguestfs-tools linux-image-generic unzip

COPY Xilinx_ISE_14.7_Win10_14.7_VM_0213_1.zip /tmp/Xilinx_ISE_14.7_Win10_14.7_VM_0213_1.zip

RUN (unzip -p /tmp/Xilinx_ISE_14.7_Win10_14.7_VM_0213_1.zip ova/14.7_VM.ova | tar xv) && \
    rm -rf /tmp/Xilinx_ISE_14.7_Win10_14.7_VM_0213_1.zip ova/14.7_VM.ova && \
    (virt-copy-out -a 14.7_VM-disk001.vmdk /opt/Xilinx /opt) && \
    (virt-copy-out -a 14.7_VM-disk001.vmdk /home/ise/.Xilinx/Xilinx.lic /opt/Xilinx) && \
    rm 14.7_VM-disk001.vmdk

FROM ubuntu:20.04
LABEL maintainer="Victor Muñoz <victor@2c-b.cl>"
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=builder /opt/Xilinx /opt/Xilinx

RUN apt update && apt -y install \
    libusb-dev fxload \ 
    libsm6 libglib2.0-0 libxi6 libxrender1 libxrandr2 \
    libxtst6 \
    libfreetype6 libfontconfig1 gcc && \
    rm -rf /var/lib/apt/lists/* && \
    cp /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusbdfwu.hex /usr/share/ && \
    ln -s libusb-1.0.so.0 /opt/Xilinx/14.7/ISE_DS/ISE/lib/lin64/libusb.so
