IMAGE_NAME="win11_24h2_x64.qcow2"
DISK_SIZE="64G"
MACHINE_TYPE="pc-q35-3.1"
VNC_PORT=":1"
WINDOWS_ISO="Win11_24H2_English_x64.iso"
VIRT_IO_ISO="virtio-win.iso"
EVE_UEFI="OVMF_CODE.fd"
SSH_PORT="7171"

if [ ! -f "$IMAGE_NAME" ]; then
    echo "Creating qcow2 image..."
    qemu-img create -f qcow2 $IMAGE_NAME $DISK_SIZE
fi

if [ ! -f "$VIRT_IO_ISO" ]; then
    wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.262-2/virtio-win.iso
fi

if [ ! -f "$EVE_UEFI" ]; then
     wget https://github.com/shjala/win11-on-eve/raw/refs/heads/main/OVMF_CODE.fd
fi

rm -rf /tmp/swtpm-win11
mkdir /tmp/swtpm-win11
swtpm socket --tpmstate dir=/tmp/swtpm-win11 \
    --ctrl type=unixio,path=/tmp/swtpm-win11/swtpm-sock \
    --terminate \
    --tpm2 \
    --daemon \
    --log level=20

qemu-system-x86_64 \
    -machine type=$MACHINE_TYPE,accel=kvm \
    -cpu host,hv_time,hv_relaxed,hv_vendor_id=eveitis,hypervisor=off,kvm=off \
    -enable-kvm \
    -s \
    -m 4G \
    -vga std \
    -smp 4 \
    -vnc $VNC_PORT \
    -display vnc=localhost$VNC_PORT \
    -nographic \
    -chardev socket,id=chrtpm,path=/tmp/swtpm-win11/swtpm-sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -drive if=pflash,format=raw,unit=0,readonly=on,file=$EVE_UEFI \
    -device pcie-root-port,port=14,chassis=4,bus=pcie.0,addr=0x4,id=pci.4 \
    -drive file=win11_24h2_x64.qcow2,format=qcow2,aio=io_uring,cache=writeback,if=none,id=drive-virtio-disk0 \
    -device virtio-blk-pci,drive=drive-virtio-disk0,scsi=off,bus=pci.4,addr=0x0 \
    -cdrom $WINDOWS_ISO \
    -drive file=$VIRT_IO_ISO,media=cdrom

rm -rf /tmp/swtpm-win11
