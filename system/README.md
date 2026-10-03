# system

Root-owned config for the ThinkPad T14 Gen 3 (not stowed; paths mirror `/`).
Run `./install.sh` (add `--ath11k` only if Wi-Fi breaks after suspend).

| File | What |
|------|------|
| `etc/interception/udevmon.yaml` | caps2esc: Caps = Esc on tap, Ctrl on hold (needs interception-tools + caps2esc) |
| `usr/local/sbin/set-battery-thresholds` + `battery-charge-thresholds.service` | Charge battery only between 75% and 85% |
| `usr/local/bin/auto-power-profile` + `.service`/`.timer` + `90-auto-power-profile.rules` | performance on AC, power-saver on battery |
| `etc/udev/rules.d/80-dotool.rules` | dotool/uinput without root (group `input`) |
| `etc/modules-load.d/i2c-dev.conf` | DDC/CI for external monitor brightness (ddcutil) |
| `etc/modprobe.d/` | ThinkPad fan control, Apple keyboard Fn keys, no PC speaker beep |
| `etc/security/limits.d/audio.conf` | realtime priority for group `audio` |
| `etc/environment.d/wayland.conf` | Wayland env for Electron/Qt/GTK |
| `etc/default/earlyoom` | earlyoom: protect sway/pipewire/nvim, kill python/node/chromium first |
| `etc/systemd/logind.conf.d/power-key.conf` | Power key handled by sway, not logind |
| `etc/ssh/sshd_config.d/10-local.conf` | key-only SSH, no root login |
| `etc/doas.conf` | doas for the main user |
| `etc/systemd/system/ath11k-*.service` | Qualcomm Wi-Fi suspend workaround (opt-in) |

Not kept here on purpose (secrets or machine-specific): Wi-Fi/eduroam certs, OpenVPN
configs, CIFS fstab line, PPP secrets, FortiClient/AnyDesk state. Those live in the
encrypted backup.
