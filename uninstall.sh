# GEN_UNIS function is enabled for this prebuild-kernel package (Check `zygote.sh`)
# You don't need to modify this uninstall.sh

if [ -e "$OSROOT/rescue.kernel" ]; then
geco "\n~ Restoring old kernel zimage..."
rm "$OSROOT/kernel"
mv "$OSROOT/rescue.kernel" "$OSROOT/kernel"
chmod 777 "$OSROOT/kernel"
fi
