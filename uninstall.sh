## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

# Define vars
KMODDIR="/system/lib/modules"
FIRMDIR="/system/firmware"

# Restore stock kernel image
if [ -f "$KERNEL_IMAGE.rescue" ]; then
    geco "\n+ Restoring stock kernel image ..." && sleep 1
    mv "$KERNEL_IMAGE.rescue" "$KERNEL_IMAGE"
fi

# Restore stock module/firmware dir
for tget in "$KMODDIR" "$FIRMDIR"; do
    if [ -d "$tget.old" ]; then
        geco "\n+ Restoring stock "$(basename "$tget")" ..."
        rm -rf "$tget" && mv "$tget.old" "$tget"
    fi
done

# Clear dalvik-cache
if [ -d "/data/dalvik-cache" ]; then
    geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..."
    rm -rf /data/dalvik-cache/*
fi
