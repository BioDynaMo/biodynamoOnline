#!/bin/bash
export DISPLAY=:1

# Kill any existing processes
killall Xvfb x11vnc fluxbox websockify 2>/dev/null || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null
sleep 1

# Start Xvfb virtual framebuffer
Xvfb :1 -screen 0 1920x1080x24 &
sleep 2

# Start window manager
fluxbox &
sleep 1

# Start x11vnc to mirror the Xvfb display over VNC (port 5900)
x11vnc -display :1 -forever -nopw -rfbport 5900 -shared -bg

# Symlink for noVNC landing page
sudo ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html 2>/dev/null

# Start websockify to bridge VNC to browser via noVNC (port 6080)
websockify --web=/usr/share/novnc 6080 localhost:5900 &

echo ""
echo "=== VNC Desktop Ready ==="
echo "Open the 'Ports' tab, find port 6080, and click 'Open in Browser'"
echo "You can now run ParaView or any GUI application!"
echo ""
