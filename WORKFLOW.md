# Where things live

Goal: the OS is disposable, configuration is reproducible from this repo, and every
piece of data has exactly one home, a known backup path, and an end-of-life path.
A wiped disk costs reinstall time, never work.

## Three layers

| Layer | Where | Source of truth | Lost disk means |
|-------|-------|-----------------|-----------------|
| **System** | btrfs `root` subvolume | Fedora + `dotfiles/system/` | reinstall |
| **Config** | dotfiles in `~` | this repo (public) + `~/.secrets` (private, see below) | `stow`, restore secrets |
| **Data** | top-level folders in `~` (btrfs `home` subvolume) | the table below | restore from backup |

## Data folders

| Path | What goes there | Synced / pushed to | Backup | End of life |
|------|-----------------|--------------------|--------|-------------|
| `~/code/<host>/<owner>/<repo>` | every git clone (`ghq get`) | its git remote (always has one) | restic, minus `.venv`/`node_modules` | delete when idle 90 days |
| `~/scratch/YYYY-MM-DD-name` | experiments, tutorials, one-offs (`s name`) | nothing | restic | promote, archive, or delete after 30 days |
| `~/data/<project>` | datasets, checkpoints, mlruns, reports, exports | nothing | restic, except `~/data/*/cache/` | archive with the project |
| `~/work/<org>` | non-code work docs (tenders, contracts, zips) | org drive if any | restic | archive when the engagement ends |
| `~/life` | personal documents, finance, contacts | syncthing → minipc | minipc → Backblaze, and restic | keep |
| `~/Obsidian` | notes | syncthing → minipc | minipc → Backblaze, and restic | keep |
| `~/media` | music, books, videos (photos live in **Immich**) | Immich for photos | restic (photos excluded once in Immich) | keep |
| `~/Downloads` | inbox only | nothing | **not** backed up | empty weekly |
| `minipc:/data/archive/` | finished projects (`archive-repo`) | n/a | minipc → Backblaze | keep |

Rules of thumb:
- If you can't say which row a file belongs to, it belongs in `~/scratch`.
- Data never lives inside a repo: keep it in `~/data/<project>` and symlink or configure the path. Things you can regenerate go in `~/data/<project>/cache/`.
- `.venv`, `node_modules`, `~/.cache` and toolchains are disposable and never backed up.
- `~/.cache` and `~/.local/share/containers` are nested btrfs subvolumes, so they stay out of snapshots too.

## Secrets

- `pass` (GPG) holds passwords and tokens. Its store syncs to minipc (git + syncthing).
- `~/.secrets/` (mode 700, never in dotfiles) holds credential *files* (`gh/hosts.yml`, rclone.conf, mail configs…). Apps reach them through symlinks from their config paths. It's backed up by restic (encrypted).
- **Keys bundle** (`make-keys-bundle.sh`): SSH, GPG, age and the password store, symmetric-encrypted with a passphrase you remember. Copies live on the Toshiba and one USB stick, refreshed whenever a key changes.
  This breaks the loop "restic password is in pass → pass needs GPG → GPG key is in restic".
- Write the restic password and LUKS passphrase on paper too.

## Backups (3-2-1)

| Tier | What | Tool | When |
|------|------|------|------|
| Undo | `root` + `home` snapshots | snapper (btrfs) | hourly / daily, automatic |
| Primary | `~` minus excludes | restic → `sftp:minipc:/data/backups/laptop` (Tailscale) | daily systemd timer |
| Offsite | minipc's `/data` (includes the laptop repo, archive, Immich) | restic → Backblaze (runs on minipc) | nightly, automatic |
| Cold | `~` | restic → Toshiba repo (or `restic copy` from minipc) | monthly, manual; also before risky operations |

The exclude file lives in dotfiles (`.config/restic/excludes`), so every machine backs up the same way.
Test a restore at least twice a year: `restic mount ~/mnt` and open a few files.

## Rules

1. **Clone only with `ghq get <url>`.** One place, predictable paths, `ghq list` to find things.
2. **Experiments start in scratch.** `s mnist-thing` creates `~/scratch/2026-10-03-mnist-thing`.
3. **Keep it? Promote it the same day.** `scratch-promote` makes a private GitHub repo and moves it to `~/code`.
   A repo without a remote is a bug.
4. **No long-lived stashes or local-only branches.** WIP goes on a pushed branch (`git push -u origin wip/x`).
5. **Agent worktrees are temporary.** Remove them when the branch merges (`git worktree prune`).
6. **Done with something?** `archive-repo PATH`, rsync to `minipc:/data/archive/`, then delete locally.

## Weekly (automatic)

`repo-health.timer` runs Mondays at 10:00 and sends a notification when something needs attention:
`NOREMOTE`, `UNPUSHED n`, `STASH n`, `DIRTY n` (untouched 7+ days), `IDLE` (pushed, 90+ days),
and scratch dirs untouched for 30+ days.
Enable it once: `systemctl --user enable --now repo-health.timer`

## Tools (in `.local/bin`)

- `scratch [NAME]`, `s NAME`: create or list scratch dirs
- `scratch-promote [DIR]`: private GitHub repo, then move to `~/code`
- `repo-health [ROOT...]`: the weekly report, on demand
- `archive-repo [-i] [-p] PATH...`: restorable archive (git bundle with stashes and LFS,
  uncommitted files, optionally ignored data). Restore instructions are in the script header.
