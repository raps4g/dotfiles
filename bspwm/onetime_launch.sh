onetime_file=$HOME/.config/bspwm/onetime

uptime=$(stat -c %Z /proc/uptime)
last_run=$(date +"%s" -r $onetime_file)
echo $uptime
echo $last_run
if [[ $last_run < $uptime ]] ; then
   rm $onetime_file
   touch $onetime_file
   nm-applet &
   xfce4-power-manager &
   docker-compose --project-directory /opt/owncloud-docker-server up -d
   /opt/serviio-2.3/bin/serviio.sh &
   qbittorrent &
   flatpak run com.discordapp.Discord --start-minimized &
fi


