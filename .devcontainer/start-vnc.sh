#!/bin/bash
export DISPLAY=:1

vncserver -kill :1 2>/dev/null || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null

mkdir -p ~/.vnc
echo "" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
vncserver :1 -geometry 1920x1080 -depth 24 -SecurityTypes None

websockify --web=/usr/share/novnc 6080 localhost:5901 &

echo ""
echo "=== VNC Desktop Ready ==="
echo "Open the 'Ports' tab, find port 6080, and click 'Open in Browser'"
echo "You can now run ParaView or any GUI application!"
echo ""
