## Ready to use kernel installation script by @AXON
## I strictly provide the rights to use this script with GearLock only.
## For proper developer documentation, visit https://supreme-gamers.com/gearlock
# Check `!zygote.sh` to configure your package functions or gearlock can also guide you during the build process.

#####--- Import Functions ---#####
get_base_dir # Returns execution directory path in $BD variable
#####--- Import Functions ---#####

# Define variables
FIRMDIR="/system/lib/firmware"
FIRMDIR_OLD="$FIRMDIR.old"
FIRMDIR_UPDATE="$FIRMDIR.update"
DALVIKDIR="/data/dalvik-cache"
PKG_KERNEL_IMAGE="$BD/kernel"
EFFECTIVE_FIRMDIR_PLACEHOLDER="effective-kernel"
RESCUE_KERNEL_IMAGE="$GRROOT/rescue-kernel"
GBSCRIPT="$GBDIR/init/UpdateKernelFirmware"

# Define functions
handleError ()
{ 
	if [ $? != 0 ]; then
		# Revert back any incomplete changes
		test ! -e "$FIRMDIR" -a -e "$FIRMDIR_OLD" && mv "$FIRMDIR_OLD" "$FIRMDIR"
		test ! -e "$KERNEL_IMAGE" -a -e "$RESCUE_KERNEL_IMAGE" && mv "$RESCUE_KERNEL_IMAGE" "$KERNEL_IMAGE"
		geco "\n++++ Error: $1" && exit ${2:-101}
	fi
}

make_gbscript ()
{
cat << EOF >> "$GBSCRIPT"

handleError ()
{

test \$? != 0 && geco "\n++++ Error: \$1" && exit \${2:-101}

}

if [ -d "$FIRMDIR_UPDATE" ]; then
	geco "--+ Updating pending firmware"
	if [ -e "$FIRMDIR_OLD" ]; then nout rm -r "$FIRMDIR_OLD"; handleError "Failed to cleanup firmware.old"; fi
	mv "$FIRMDIR" "$FIRMDIR_OLD"; handleError "Failed to backup old firmware"
	mv "$FIRMDIR_UPDATE" "$FIRMDIR"; handleError "Failed to install firmware update"
    
    write_gbscript "Kernel Firmware Update Successful"
	rm "$0" # Remove GBSCRIPT when operation is successful
	
fi
EOF

}

doJob ()
{

# Make sure KERNEL_IMAGE exist and is accessible
	test -n "$KERNEL_IMAGE" -a -e "$KERNEL_IMAGE"; handleError "Kernel image is not accessible"

# Merge files
	gclone "$BD/system/" "$SYSTEM_DIR"; handleError "Failed to place files"

# Backup kernel image
	geco "\n\n+ Backing up your current kernel image: \c" && sleep 1
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


# Warning info for installation from GUI to avoid system crash
test "$ANDROID_GUI" == "yes" -o "$BOOTCOMP" == "yes" \
&& geco "+ You seem to be installing from a live system, best practice is to install from RECOVERY-MODE.\n"

# Main Loop
if [ -d "$BD$FIRMDIR" ]; then
	geco "This kernel package also provides additional firmware."
	while true
	do
		read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " i
		case $i in
					
			[Yy] ) geco "\n\n+ Placing the kernel module and firmware files into your system"
					
					if [ "$ANDROID_GUI" == "yes" ]; then
						make_gbscript; mv "${BD}${FIRMDIR}" "${BD}${FIRMDIR_UPDATE}"; handleError "Failed to rename package firmware to firmware.update"
						echo "${NAME}_${VERSION}" > "${BD}${FIRMDIR_UPDATE}${EFFECTIVE_FIRMDIR_PLACEHOLDER}"
					else
						if [ -e "$FIRMDIR_OLD" ]; then nout rm -r "$FIRMDIR_OLD"; handleError "Failed to cleanup firmware.old"; fi
						mv "$FIRMDIR" "$FIRMDIR_OLD"; handleError "Failed to backup old firmware"
						doJob; echo "${NAME}_${VERSION}" > "${FIRMDIR}${EFFECTIVE_FIRMDIR_PLACEHOLDER}"; break ;;
					fi
					
			[Nn] ) geco "\n\n+ Placing the kernel module files into your system"
					
						if [ -e "$GBSCRIPT" ]; then rm "$GBSCRIPT"; handleError "Failed to remove pre-existing kernel updater GearBoot script"; fi
						nout rm -r "${BD}${FIRMDIR}"; handleError "Failed to cleanup package firmware"; doJob; break ;;
					
				*) geco "\n- Enter either ${GREEN}Y${RC}es or no" ;;
					
		esac
	done
else
	if [ -e "$GBSCRIPT" ]; then rm "$GBSCRIPT"; handleError "Failed to remove pre-existing kernel updater GearBoot script"; fi
	geco "\n+ Placing the kernel module files into your system" && doJob
fi

# Clear dalvik-cache
test -d "$DALVIKDIR" && geco "\n+ Clearing dalvik-cache, it may take a bit long on your next boot" && rm -rf "$DALVIKDIR"/*
