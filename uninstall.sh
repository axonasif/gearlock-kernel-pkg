## For proper develoer documentation, visit https://supreme-gamers.com/gearlock

# GEN_UNIS function is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

R="$GRROOT/rescue.kernel"
if [ -e "$R" ]; then geco "\n+ Restoring old kernel zimage ..."; sleep 1; rsync "$R" "$GRROOT/kernel"; fi
