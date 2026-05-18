echo "Add Logout option to system menu"

omarchx-refresh-sddm

if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
  sudo sed -i 's/^Current=.*/Current=omarchx/' /etc/sddm.conf.d/autologin.conf
fi
