## For proper develoer documentation, visit https://supreme-gamers.com/gearlock
# GEN_UNIS function is enabled for this prebuild-kernel package (Check `!zygote.sh`)
# You don't need to modify this uninstall.sh

R="$GRROOT/rescue.kernel"
if [ -f "$R" ]; then 
    geco "\n+ Restoring stock kernel zimage ..."; sleep 1
    rsync "$R" "$GRROOT/kernel"
fi
if [ -f $DEPDIR/firmware.bak ]; then
    geco "\n+ Restoring stock firmware blobs ..."
    nout garca x -aoa -o/system/lib $DEPDIR/firmware.bak
    rm $DEPDIR/firmware.bak
fi

# Clear dalvik-cache
geco "\n+ Clearing dalvik-cache ..."
[ -d "/data/dalvik-cache" ] && rm -rf /data/dalvik-cache/*
