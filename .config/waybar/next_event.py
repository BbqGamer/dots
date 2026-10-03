#!/usr/bin/env python3
"""Waybar module: next calendar event, read from Waylandar's sync cache.

Classes: "soon" (starts within 15 min), "next" (within 2 h), "now" (in progress),
"later" (nothing within 2 h; only the icon is shown), "stale" (cache not
refreshed recently, i.e. the widget isn't syncing).
"""
import datetime as dt
import html
import json
import math
import os

CACHE = os.path.expanduser("~/.cache/waylandar/cache_current_current.json")
SOON = dt.timedelta(minutes=15)
HORIZON = dt.timedelta(hours=2)  # further-out events stay in the tooltip only
STALE = dt.timedelta(hours=1)
MAX_TITLE = 32


def short(title):
    title = title or "(no title)"
    return title if len(title) <= MAX_TITLE else title[: MAX_TITLE - 1] + "…"


def until(delta):
    mins = math.ceil(delta.total_seconds() / 60)
    return f"{mins}m" if mins < 60 else f"{mins // 60}h{mins % 60:02d}m"


def main():
    now = dt.datetime.now().astimezone()
    try:
        with open(CACHE) as f:
            data = json.load(f)
        age = now - dt.datetime.fromtimestamp(os.path.getmtime(CACHE)).astimezone()
    except (OSError, ValueError):
        print(json.dumps({"text": "󰃭 ?", "tooltip": "No Waylandar data yet; is waylandar-widget running?", "class": "stale"}))
        return

    events = []
    for e in data.get("events", []):
        if len(e.get("start", "")) == 10:  # all-day
            continue
        start = dt.datetime.fromisoformat(e["start"])
        end = dt.datetime.fromisoformat(e["end"]) if e.get("end") else start
        if end > now and start.date() <= (now + dt.timedelta(days=1)).date():
            events.append((start, end, e.get("title")))
    # At equal start times prefer a real title over free/busy-only "Busy" entries.
    events.sort(key=lambda ev: (ev[0], ev[2] == "Busy"))

    upcoming = [ev for ev in events if ev[0] > now]
    ongoing = [ev for ev in events if ev[0] <= now]

    if upcoming and upcoming[0][0] - now <= SOON:
        start, _, title = upcoming[0]
        text, cls = f"󰃭 {start:%H:%M} {short(title)} · in {until(start - now)}", "soon"
    elif ongoing:
        _, end, title = min(ongoing, key=lambda ev: ev[1])
        text, cls = f"󰃭 now: {short(title)} · until {end:%H:%M}", "now"
    elif upcoming and upcoming[0][0] - now <= HORIZON:
        start, _, title = upcoming[0]
        text, cls = f"󰃭 {start:%H:%M} {short(title)} · in {until(start - now)}", "next"
    else:
        text, cls = "󰃭", "later"

    lines = []
    for day, label in ((now.date(), "Today"), ((now + dt.timedelta(days=1)).date(), "Tomorrow")):
        day_events = [ev for ev in events if ev[0].date() == day or (ev[0] <= now and day == now.date())]
        if day_events:
            lines.append(f"<b>{label}</b>")
            lines += [f"{s:%H:%M}–{e:%H:%M}  {html.escape(t or '(no title)')}" for s, e, t in day_events]
    tooltip = "\n".join(lines) or "Nothing today or tomorrow"

    classes = [cls]
    if age > STALE:
        classes.append("stale")
        tooltip += f"\n\n⚠ Last sync {until(age)} ago; is waylandar-widget running?"

    print(json.dumps({"text": html.escape(text), "tooltip": tooltip, "class": classes}, ensure_ascii=False))


if __name__ == "__main__":
    main()
