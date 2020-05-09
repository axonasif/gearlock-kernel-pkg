## Ready to use kernel installation script by @AXON
## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Check `!zygote.sh` to configure your package functions or gearlock can also guide you during the build process.

#####--- Import Functions ---#####
get_base_dir # Returns execution directory path in $BD variable
#####--- Import Functions ---#####

# Define vars
PRINT_KERNEL_IMAGE="$(basename ${KERNEL_IMAGE})"

# Do not allow old GearLock versions (5.9 & 6.0) since there is lack of support
if [ -n "$GEARLOCK_V" ] || [ ! -e "$CORE/version" ] || [ -e "$CORE/version" ] && (( $(echo "$(cat $CORE/version) 6.0" | awk '{print ($1 == $2)}') )); then
	geco "\n\n!! Installation can not continue, update to ${BGREEN}GearLock 6.1+${RC} in order to install this ..." && sleep 8 && exit 1
fi

do_comm_job(){
# Merge files
	gclone "$BD/system" /

# Backup kernel image
	geco "\n+ Backing up your current kernel zimage" && sleep 1
	if [ -e "${KERNEL_IMAGE}.rescue" ]; then
		geco "+ Your stock kernel image is already backed up as ${PRINT_KERNEL_IMAGE}.rescue"
	else
		mv "$KERNEL_IMAGE" "${KERNEL_IMAGE}.rescue"
		geco "+ Your stock kernel image is renamed from ${PRINT_KERNEL_IMAGE} to ${PRINT_KERNEL_IMAGE}.rescue"
	fi

# Merge new kernel image
	rsync -a "$BD/kernel" "$KERNEL_IMAGE" && chmod 777 "$KERNEL_IMAGE" && sleep 1.5

# Print rescue information
geco "\n\n- Read the information below and press ${RED}Enter${RC} to continue ...${RC}
-- In case if you can't boot with ${YELLOW}${NAME}-${VERSION}${RC} on your hardware,
-- then you can rename ${PURPLE}${PRINT_KERNEL_IMAGE}.rescue${RC} to ${GREEN}${PRINT_KERNEL_IMAGE}${RC} on your android_x86 partition,
-- or you can also uninstall ${YELLOW}${NAME}-${VERSION}${RC} from RECOVERY mode." && read EnterKey

# Cleanup package firmware before uninstallation script generation
	[ -d "$BD/system/lib/firmware" ] && rm -rf "$BD/system/lib/firmware"
}

if [ -d "$BD/system/lib/firmware" ]; then
	geco "This kernel package also provides additional firmware."
	while true; do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " c

		case $c in
			[Yy]* )
				geco "\n+ Backing up stock firmware blobs"; cd /system/lib && nout garca a -m0=lzma2 -mx=3 "$DEPDIR/firmware.bak" firmware
				geco "\n+ Deleting /system/firmware" && rm -rf /system/lib/firmware
				geco "\n+ Placing the kernel module and firmware files into your system" && do_comm_job; break ;;

			[Nn]* ) geco "\n+ Placing the kernel module files into your system" && do_comm_job; break ;;
				* ) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
		esac
	done
else
	geco "\n+ Placing the kernel module files into your system" && do_comm_job
fi

# Clear dalvik-cache
if [ -d "/data/dalvik-cache" ]; then
	geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot ..."
	rm -rf /data/dalvik-cache/*
fi
