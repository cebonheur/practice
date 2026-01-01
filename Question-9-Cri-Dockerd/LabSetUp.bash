#!/bin/bash
set -e

Q_NUM="q9"
Q_DIR="$HOME/questions/${Q_NUM}"

mkdir -p "$Q_DIR"
echo "⚠️ WARNING: This lab involves installing and configuring cri-dockerd."
echo "⚠️ Changing the Container Runtime Interface (CRI) can break node stability and connectivity."
echo "⚠️ Procced with caution as this may require a node/cluster reset."
echo

# Download CRI Dockerd Debian package to Q_DIR, matching typical exam setup
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb -O "$Q_DIR/cri-dockerd.deb"

echo "CRI Dockerd package downloaded to $Q_DIR/cri-dockerd.deb"
