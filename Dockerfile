ARG ALT_DOCKER_REGISTRY=docker.io
FROM $ALT_DOCKER_REGISTRY/python:3

WORKDIR /usr/src/app

COPY . .

ARG ALT_PYPI_REGISTRY=https://pypi.org/simple
RUN pip install --trusted-host host.docker.internal --no-cache-dir --index-url $ALT_PYPI_REGISTRY -r requirements.txt

#RUN rm /etc/apt/sources.list && \
#    rm -f /var/lib/apt/lists/* && \
#    echo deb http://host.docker.internal:8083/nexus/repository/apt-deb.debian.org-main-proxy/ buster main >> /etc/apt/sources.list && \
#    echo deb http://host.docker.internal:8083/nexus/repository/apt-security.debian.org-busterupdates-proxy/ buster/updates main  >> /etc/apt/sources.list && \
#    echo deb http://host.docker.internal:8083/nexus/repository/apt-deb.debian.org-busterupdates-proxy/ buster-updates main  >> /etc/apt/sources.list && \
#    apt-get update 

# Plotly depedencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        xvfb \
        xauth \
        libgtk2.0-0 \
        libxtst6 \
        libxss1 \
        libgconf-2-4 \
        libnss3 \
        libasound2 && \
    mkdir -p /opt/orca && \
    cd /opt/orca && \
    wget https://github.com/plotly/orca/releases/download/v1.2.1/orca-1.2.1-x86_64.AppImage && \
    chmod +x orca-1.2.1-x86_64.AppImage && \
    ./orca-1.2.1-x86_64.AppImage --appimage-extract && \
    rm orca-1.2.1-x86_64.AppImage && \
    printf '#!/bin/bash \nxvfb-run --auto-servernum --server-args "-screen 0 640x480x24" /opt/orca/squashfs-root/app/orca "$@"' > /usr/bin/orca && \
    chmod +x /usr/bin/orca
    
ENTRYPOINT ["python3"]

CMD ["success_metrics.py", "-h"]


