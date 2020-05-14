## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh


# Restore stock kernel image
if [ -f "$KERNEL_IMAGE.rescue" ]; then
    geco "\n+ Restoring stock kernel image ..." && sleep 1
    mv "$KERNEL_IMAGE.rescue" "$KERNEL_IMAGE"
fi

# Restore backed up firmware blobs
if [ -f "$DEPDIR/firmware.bak" ]; then
    geco "\n+ Restoring stock firmware blobs ..."
    nout garca x -aoa -o/system/lib "$DEPDIR/firmware.bak" && rm "$DEPDIR/firmware.bak"
fi

# Move/clean current module dir if necessary (to avoid module mismatch by android init)
if [ -d "$KMODDIR.old" ]; then
    geco "\n+ Restoring stock kernel modules ..."
    rm -rf "$KMODDIR" && mv "$KMODDIR.old" "$KMODDIR"
fi

# Clear dalvik-cache
if [ -d "/data/dalvik-cache" ]; then
    geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..."
    rm -rf /data/dalvik-cache/*
fi
