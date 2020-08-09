## Ready to use kernel installation script by @AXON
## I strictly provide the rights to use this script with GearLock only.
## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Check `!zygote.sh` to configure your package functions or gearlock can also guide you during the build process.

#####--- Import Functions ---#####
get_base_dir # Returns execution directory path in $BD variable
#####--- Import Functions ---#####

# Define variables
FIRMDIR="/system/lib/firmware"
DALVIKDIR="/data/dalvik-cache"
PKG_KERNEL_IMAGE="$BD/kernel"
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

doJob ()
{

# Make sure KERNEL_IMAGE exist and is accessible
test -n "$KERNEL_IMAGE" -a -e "$KERNEL_IMAGE"; handleError "Kernel image is not accessible"

# Merge files
	gclone "$BD/system/" "$SYSTEM_DIR"; handleError "Failed to place files"

# Backup kernel image
	geco "\n+ Backing up your current kernel image: \c" && sleep 1
	if [ -e "$RESCUE_KERNEL_IMAGE" ]; then
		geco "Already backed up as $(basename "$RESCUE_KERNEL_IMAGE")"
	else
        nout mv "$KERNEL_IMAGE" "$RESCUE_KERNEL_IMAGE"; handleError "Failed to backup stock kernel image"
		geco "Renamed from $(basename "$KERNEL_IMAGE") to $(basename "$RESCUE_KERNEL_IMAGE")"
	fi

# Merge new kernel image
	nout rsync "$PKG_KERNEL_IMAGE" "$KERNEL_IMAGE"; handleError "Failed to update kernel image"

# Print rescue information
geco "
\n- ${BRED}${URED}Read the information below${RC}
-- In case if you can't boot with ${YELLOW}${NAME}-${VERSION}${RC} on your hardware,
-- then you can uninstall ${YELLOW}${NAME}-${VERSION}${RC} from RECOVERY mode.
-- You can also rename ${PURPLE}$(basename "$RESCUE_KERNEL_IMAGE")${RC} to $(basename "$KERNEL_IMAGE"),
-- in your android-x86 partition in order to boot with stock kernel.
- Note: To purge old kernel modules, use ${GREEN}GearLock > Game / System Tweaks${RC} 
\c"

# Cleanup package firmware before uninstallation script generation (GEN_UNINS)
test -d "$BD$FIRMDIR" && rm -r "$BD$FIRMDIR"

}

# Main Loop
if [ -d "$BD$FIRMDIR" ]; then
	geco "This kernel package also provides additional firmware."
	while true
	do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " i
		case $i in
			[Yy] ) geco "\n\n+ Placing the kernel module and firmware files into your system"
					echo "${NAME}_${VERSION}" > "$EFFECTIVE_FIRMDIR_PLACEHOLDER"
					nout mv "$FIRMDIR" "$FIRMDIR.old"; handleError "Failed to backup old firmware"; doJob; break ;;
			[Nn] ) geco "\n\n+ Placing the kernel module files into your system"
					rm -r "$BD$FIRMDIR" && doJob; break ;;
				*) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
		esac
	done
else
	geco "\n+ Placing the kernel module files into your system" && doJob
fi

# Clear dalvik-cache
test -d "$DALVIKDIR" && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot" && rm -rf "$DALVIKDIR"/*
