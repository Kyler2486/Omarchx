echo "Add emoji font fallback to fontconfig"
cp $OMARCHX_PATH/config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -f
