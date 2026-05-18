# Install Sound Open Firmware for the audio DSP on non-XPS Intel Panther
# Lake systems. XPS PTL stays on linux-ptl, which hard-deps sof-firmware.
# Mainline `linux` only optdeps it, so without this the DSP fails to boot
# and only auto_null shows up in PipeWire.

if omarchx-hw-intel-ptl && ! omarchx-hw-match "XPS"; then
  omarchx-pkg-add sof-firmware
fi
