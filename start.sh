#!/system/bin/sh
cd /data/local/iptv-rust
killall ysp-web-android iptv-rust
nohup /data/local/iptv-rust/ysp-web-android --channels /data/local/iptv-rust/channels.yaml --host 0.0.0.0 --port 8787 > /data/local/iptv-rust/ysp-web-android.log 2>&1 &
sleep 1
ps -A | grep ysp
