## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is disabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

# Define variables
FIRMDIR="/system/lib/firmware"
DALVIKDIR="/data/dalvik-cache"

# Define functions
printError(){ test $? != 0 && geco "\n++++ Error: $@" && return ${2:-101}; }

## Runtime
# Restore stock kernel image
if [ -f "rescue-$KERNEL_IMAGE" ]; then
	geco "\n+ Restoring stock kernel image ..." && sleep 1
	mv "rescue-$KERNEL_IMAGE" "$KERNEL_IMAGE"; printError "Failed to restore stock kernel image"
fi

# Restore stock modules/firmware dir
if [ -d "$FIRMDIR.old" ]; then
	geco "\n+ Restoring stock "$(basename "$FIRMDIR")" ..."
	rm -rf "$FIRMDIR" && mv "$FIRMDIR.old" "$FIRMDIR"; printError "Failed to restore stock "$(basename "$FIRMDIR")""
fi

# Clear dalvik-cache
test -d "$DALVIKDIR" && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..." && rm -rf "$DALVIKDIR"/*
