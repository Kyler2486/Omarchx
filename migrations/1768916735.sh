echo "Fix microphone gain and audio mixing on Asus ROG laptops"

source "$OMARCHX_PATH/install/config/hardware/asus/fix-mic.sh"
source "$OMARCHX_PATH/install/config/hardware/asus/fix-audio-mixer.sh"

if omarchx-hw-asus-rog; then
  omarchx-restart-pipewire
fi
