## Ready to use kernel script by @AXON
## For proper develoer documentation, visit https://supreme-gamers.com/gearlock

# Check `zygote.sh` to configure your package functions or gearlock can also guide you during the build process

#####--- Import Functions ---#####
get_base_dir # Returns the directory path in $BD variable from where this *install.sh is being executed
#####--- Import Functions ---#####

do_comm_job(){
gclone "$BD/system" /
geco "\n+ Backing up your current kernel zimage...."
if [ -e "$OSROOT/rescue.kernel" ]; then
  geco "+ Your stock kernel zimage is already backed up as rescue.kernel\n"
else
  mv $OSROOT/kernel $OSROOT/rescue.kernel
  geco "+ Your stock kernel zimage is renamed from kernel to rescue.kernel\n"
fi
nout gclone "$BD/kernel" "$OSROOT"
chmod 777 "$OSROOT/kernel"
sleep 1.5
geco "Your system will reboot after 20 seconds. ${RED}Read the information below!${RC}\n"
sleep 1
geco "In case if your system is not booting with ${YELLOW}$Name-$Version${RC} on your hardware,"
geco "then you can rename ${PURPLE}rescue.kernel${RC} to ${GREEN}kernel${RC} on your android_x86 partition to boot with your old kernel..."
sleep 20
}

if [ -d "$BD/system/lib/firmware" ]; then
geco "This kernel package also provides additional firmware."
while true; do
	read -n1 -p "$(geco "Do you want to upgrade the ${BLUE}firmware${RC} through this kernel package? [${GREEN}Y${RC}/n]") " c

	case $c in
		[Yy]* ) 
				geco "\n+ Deleting /system/firmware"
				rm -r /system/lib/firmware
				geco "+ Placing the kernel modules and firmware files into your system"
				do_comm_job
break
	 ;;
	 
		[Nn]* ) 
				geco "\nPlacing the kernel modules files into your system"
				do_comm_job
break
	 ;;
	* ) geco "\nEnter either ${GREEN}y${RC}es or no" ;;
esac
done

else
geco "+ Placing the kernel modules files into your system"
do_comm_job
fi
