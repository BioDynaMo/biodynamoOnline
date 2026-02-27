#!/bin/bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"

# Kill any existing processes
killall Xvfb x11vnc fluxbox websockify 2>/dev/null || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null
sleep 1

# Start Xvfb virtual framebuffer (setsid to survive SIGHUP)
setsid Xvfb :1 -screen 0 1920x1080x24 > /tmp/xvfb.log 2>&1 &
sleep 2

# Start window manager
setsid fluxbox > /tmp/fluxbox.log 2>&1 &
sleep 1

# Start x11vnc to mirror the Xvfb display over VNC (port 5900)
setsid x11vnc -display :1 -forever -nopw -rfbport 5900 -shared > /tmp/x11vnc.log 2>&1 &
sleep 1

# Symlink for noVNC landing page
ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html 2>/dev/null

# Start websockify (setsid to survive SIGHUP)
setsid websockify --web=/usr/share/novnc 6080 localhost:5900 > /tmp/websockify.log 2>&1 &

# Wait for port 6080 to be ready
for i in $(seq 1 30); do
  if bash -c "echo >/dev/tcp/localhost/6080" 2>/dev/null; then
    break
  fi
  sleep 1
done

echo "VNC desktop running on port 6080"
