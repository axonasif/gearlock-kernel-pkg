# GEN_UNIS function is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

if [ -e "$GRROOT/rescue.kernel" ]; then
geco "\n+ Restoring old kernel zimage"
rm "$GRROOT/kernel"
mv "$GRROOT/rescue.kernel" "$GRROOT/kernel"
chmod 777 "$GRROOT/kernel"
fi
