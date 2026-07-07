FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    git \
    nano \
    xauth \
    dbus-x11 \
    && apt clean

RUN mkdir -p /root/.vnc

RUN echo "123456\n123456\nn" | vncpasswd

RUN printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nstartxfce4 &\n' > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

EXPOSE 5901
EXPOSE 6080

CMD sh -c "vncserver :1 -localhost no && /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080"
