## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Auto uninstallation generation is disabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

# Define variables
FIRMDIR="/system/lib/firmware"
DALVIKDIR="/data/dalvik-cache"
EFFECTIVE_FIRMDIR_PLACEHOLDER="$FIRMDIR/effective-kernel"
RESCUE_KERNEL_IMAGE="$GRROOT/rescue-kernel"

# Define functions
handleError ()
{ 
	if [ $? != 0 ]; then
		# Revert back any incomplete changes
		test ! -e "$FIRMDIR" -a -e "$FIRMDIR.old" && mv "$FIRMDIR.old" "$FIRMDIR"
		test ! -e "$KERNEL_IMAGE" -a -e "$RESCUE_KERNEL_IMAGE" && mv "$RESCUE_KERNEL_IMAGE" "$KERNEL_IMAGE"
		geco "\n++++ Error: $1" && exit ${2:-101}
	fi
}

# Deny uninstallation from GUI to avoid system crash
if [ "$GEARLOCK_APP" == "yes" ]; then
	geco "\n+ You can not uninstall kernel from GUI, it will crash your system"
	while true
	do
		read -n1 -p "$(geco "Do you want to switch to ${BGREEN}tty${RC} and uninstall from there ? [${GREEN}Y${RC}/n]") " i
		case $i in
			[Yy] ) geco "\n\n+ Switching to tty GearLock ..." && sleep 1
					openvt -s bash gearlock-cli main.src/1; gkillapp "$GAPPID"; break ;;
			[Nn] ) geco "\n\n+ Okay, uninstallation process will exit"
					return 101; break ;;
				*) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
		esac
	done
fi

# Restore stock kernel image
if [ -f "$RESCUE_KERNEL_IMAGE" ]; then
	geco "\n+ Restoring stock kernel image ..." && sleep 1
	nout mv "$RESCUE_KERNEL_IMAGE" "$KERNEL_IMAGE"; handleError "Failed to restore stock kernel image"
fi

# Restore stock modules/firmware dir
if [ -d "$FIRMDIR.old" ] && [ "$(cat "$EFFECTIVE_FIRMDIR_PLACEHOLDER")"  == "${NAME}_${VERSION}" ]; then
	geco "\n+ Restoring stock "$(basename "$FIRMDIR")" ..."
	nout rm -rf "$FIRMDIR" && mv "$FIRMDIR.old" "$FIRMDIR"; handleError "Failed to restore stock "$(basename "$FIRMDIR")""
fi

# Clear dalvik-cache
test -d "$DALVIKDIR" && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..." && rm -rf "$DALVIKDIR"/*
