## Ready to use kernel installation script by @AXON
## I strictly provide the rights to use this script with GearLock only.
## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Check `!zygote.sh` to configure your package functions or gearlock can also guide you during the build process.

#####--- Import Functions ---#####
get_base_dir # Returns execution directory path in $BD variable
#####--- Import Functions ---#####

# Define vars
KMODDIR="/system/lib/modules"
FIRMDIR="/system/lib/firmware"
DALVIKDIR="/data/dalvik-cache"
PKG_KERNEL_IMAGE="$BD/kernel"
PRINT_KERNEL_IMAGE="$(basename "$KERNEL_IMAGE")"


# Make sure KERNEL_IMAGE exist and is accessible
[ -z "$KERNEL_IMAGE" -o ! -e "$KERNEL_IMAGE" ] && geco "\n++++ Error: Kernel image is not accessible" && exit 101

do_comm_job ()
{

# Move/clean current modules & firmware dir if necessary (to avoid module mismatch by android init)
	for tget in $@; do
		if [ ! -d $tget.old ]; then
			mv $tget $tget.old && ckdirex $tget 755
		elif [ -d $tget.old -a -d $tget ]; then
			rm -rf $tget && ckdirex $tget 755
		fi
	done

# Merge files
	gclone "$BD/system" / || geco "\n++++ Error: Failed to place files" && exit 101

# Backup kernel image
	geco "\n+ Backing up your current kernel zimage" && sleep 1
	if [ -e "$KERNEL_IMAGE.rescue" ]; then
		geco "+ Your stock kernel image is already backed up as $PRINT_KERNEL_IMAGE.rescue"
	else
		mv "$KERNEL_IMAGE" "$KERNEL_IMAGE.rescue" || geco "\n++++ Error: Failed to backup stock kernel image" && exit 101
		geco "+ Your stock kernel image is renamed from $PRINT_KERNEL_IMAGE to $PRINT_KERNEL_IMAGE.rescue"
	fi

# Merge new kernel image
	rsync "$PKG_KERNEL_IMAGE" "$KERNEL_IMAGE" || geco "\n++++ Error: Failed to update kernel image" && exit 101

# Print rescue information
geco "\n\n- Read the information below and press ${RED}${URED}Enter${RC} to continue ...${RC}
-- In case if you can't boot with ${YELLOW}${NAME}-${VERSION}${RC} on your hardware,
-- then you can uninstall ${YELLOW}${NAME}-${VERSION}${RC} from RECOVERY mode." && read EnterKey

# # Cleanup package firmware before uninstallation script generation
# # Only required when auto GEN_UNINS is enabled, deprecieated since GearLock 6.0
# [ -d "$BD$FIRMDIR" ] && rm -rf "$BD$FIRMDIR"

}

# Runtime
if [ -d "$BD/system/lib/firmware" ]; then
	geco "This kernel package also provides additional firmware."
	while true; do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " i
		case $i in
			[Yy] ) geco "\n+ Placing the kernel module and firmware files into your system" && do_comm_job $KMODDIR $FIRMDIR; break ;;
			[Nn] ) geco "\n+ Placing the kernel module files into your system" && do_comm_job $KMODDIR; break ;;
				*) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
		esac
	done
else
	geco "\n+ Placing the kernel module files into your system" && do_comm_job $KMODDIR
fi

# Clear dalvik-cache
[ -d "$DALVIKDIR" ] && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..." && rm -rf $DALVIKDIR/*
