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
PRINT_KERNEL_IMAGE="$(basename "$KERNEL_IMAGE")"


# Define functions
printError(){ test $? != 0 && geco "\n++++ Error: $@" && exit ${2:-101}; }
doJob ()
{

# Make sure KERNEL_IMAGE exist and is accessible
test -z "$KERNEL_IMAGE" -o ! -e "$KERNEL_IMAGE"; printError "Kernel image is not accessible"

# Merge files
	gclone "$BD/system" /; printError "Failed to place files"

# Backup kernel image
	geco "\n+ Backing up your current kernel image" && sleep 1
	if [ -e "rescue-$KERNEL_IMAGE" ]; then
		geco "+ Your stock kernel image is already backed up as rescue-$PRINT_KERNEL_IMAGE"
	else
		nout mv "$KERNEL_IMAGE" "rescue-$KERNEL_IMAGE"; printError "Failed to backup stock kernel image"
		geco "+ Your stock kernel image is renamed from $PRINT_KERNEL_IMAGE to rescue-$PRINT_KERNEL_IMAGE"
	fi

# Merge new kernel image
	nout rsync "$PKG_KERNEL_IMAGE" "$KERNEL_IMAGE"; printError "Failed to update kernel image"

# Print rescue information
geco "
\n- Read the information below and press ${BRED}${URED}Enter${RC} to continue ...${RC}
-- In case if you can't boot with ${YELLOW}${NAME}-${VERSION}${RC} on your hardware,
-- then you can uninstall ${YELLOW}${NAME}-${VERSION}${RC} from RECOVERY mode.
-- You can also rename ${PURPLE}kernel-rescue${RC} to $KERNEL_IMAGE,
-- in your android-x86 partition to boot with old kernel.
\c" && read EnterKey

# Cleanup package firmware before uninstallation script generation (GEN_UNINS)
test -d "$BD$FIRMDIR" && rm -r "$BD$FIRMDIR"

}

# Runtime
if [ -d "$BD$FRIMDIR" ]; then
	geco "This kernel package also provides additional firmware."
	while true; do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " i
		case $i in
			[Yy] ) geco "\n+ Placing the kernel module and firmware files into your system"
					nout mv "$FRIMDIR" "$FRIMDIR.old"; printError "Failed to backup old firmware"; doJob; break ;;
			[Nn] ) geco "\n+ Placing the kernel module files into your system"
					rm -r "$BD$FRIMDIR" && doJob; break ;;
				*) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
		esac
	done
else
	geco "\n+ Placing the kernel module files into your system" && doJob
fi

# Clear dalvik-cache
test -d "$DALVIKDIR" && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot" && rm -rf "$DALVIKDIR"/*
