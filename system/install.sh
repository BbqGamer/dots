#!/bin/bash
# Install system-level config (files under etc/ and usr/ mirror their real paths).
# Existing files that differ are kept as <file>.orig before being replaced.
#
#   ./install.sh            install everything except the ath11k suspend workaround
#   ./install.sh --ath11k   also install the ath11k rmmod/modprobe-on-suspend units
set -e
cd "$(dirname "$0")"

ATH11K=0
[ "$1" = "--ath11k" ] && ATH11K=1

find etc usr -type f | sort | while read -r f; do
    case "$f" in
        etc/systemd/system/ath11k-*) [ "$ATH11K" = 1 ] || continue ;;
    esac
    dest="/$f"
    if [ -e "$dest" ] && sudo cmp -s "$f" "$dest"; then
        continue
    fi
    if [ -e "$dest" ] && [ ! -e "$dest.orig" ]; then
        sudo cp -a "$dest" "$dest.orig"
    fi
    mode=644
    case "$f" in
        usr/local/bin/*|usr/local/sbin/*) mode=755 ;;
        etc/doas.conf) mode=400 ;;
    esac
    sudo install -D -m "$mode" -o root -g root "$f" "$dest"
    echo "installed $dest"
done

command -v restorecon >/dev/null && sudo restorecon -R /etc /usr/local

sudo systemctl daemon-reload
sudo udevadm control --reload
sudo systemctl enable --now battery-charge-thresholds.service auto-power-profile.timer
systemctl list-unit-files udevmon.service >/dev/null 2>&1 && sudo systemctl enable --now udevmon.service
[ "$ATH11K" = 1 ] && sudo systemctl enable ath11k-suspend.service ath11k-resume.service
sudo systemctl try-reload-or-restart sshd.service earlyoom.service 2>/dev/null || true

for g in input audio; do
    getent group "$g" >/dev/null && sudo usermod -aG "$g" "$USER"
done

echo
echo "Done. Not handled here (do manually if needed):"
echo "  - kernel args: append to KERNEL_CMDLINE[default] in /etc/default/limine (e.g. amdgpu.gpu_recovery=1), then sudo limine-update"
echo "  - homelab CIFS mount in /etc/fstab (+ cifs-utils, ~/.smbcredentials)"
echo "  - printer: Brother DCP-J105 (needs Brother's driver)"
echo "  - re-login for new group membership"
