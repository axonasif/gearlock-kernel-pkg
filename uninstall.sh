## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

if [ -f "${KERNEL_IMAGE}.rescue" ]; then 
    geco "\n+ Restoring stock kernel image ..." && sleep 1
    mv "${KERNEL_IMAGE}.rescue" "$KERNEL_IMAGE"
fi

if [ -f "$DEPDIR/firmware.bak" ]; then
    geco "\n+ Restoring stock firmware blobs ..."
    nout garca x -aoa -o/system/lib "$DEPDIR/firmware.bak" && rm "$DEPDIR/firmware.bak"
fi

# Clear dalvik-cache
geco "\n+ Clearing dalvik-cache ..."
[ -d "/data/dalvik-cache" ] && rm -rf /data/dalvik-cache/*
