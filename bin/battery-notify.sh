#!/bin/sh
# Alerte batterie : notification chaque minute en décharge à 20% ou moins.
# --once : un seul contrôle (tests). BATTERY_TEST_CAPACITY / BATTERY_TEST_STATUS simulent la batterie.
if [ -z "$XDG_RUNTIME_DIR" ]; then export XDG_RUNTIME_DIR="/tmp/run-user-$(id -u)"; fi

INTERVAL=${BATTERY_INTERVAL:-60}
LIMIT=${BATTERY_LIMIT:-20}

read_battery() {
    BAT=""
    for b in /sys/class/power_supply/BAT*; do
        if [ -d "$b" ]; then BAT=$b; break; fi
    done

    if [ -n "${BATTERY_TEST_CAPACITY:-}" ]; then
        CAPACITY=$BATTERY_TEST_CAPACITY
    else
        CAPACITY=$(cat "$BAT/capacity" 2>/dev/null || echo 0)
    fi
    if [ -n "${BATTERY_TEST_STATUS:-}" ]; then
        STATUS=$BATTERY_TEST_STATUS
    else
        STATUS=$(cat "$BAT/status" 2>/dev/null || echo Unknown)
    fi
    case "$CAPACITY" in ''|*[!0-9]*) CAPACITY=0 ;; esac
}

check() {
    read_battery
    [ "$STATUS" = "Discharging" ] || return 0
    [ "$CAPACITY" -le "$LIMIT" ] || return 0
    notify-send -u critical -t 50000 "Batterie faible" \
        "$CAPACITY% restants — branche le chargeur" >/dev/null 2>&1 || true
}

if [ "${1:-}" = "--once" ]; then
    check
    exit 0
fi

# Une seule boucle par session.
PIDFILE="$XDG_RUNTIME_DIR/battery-notify.pid"
if [ -r "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null; then
    exit 0
fi
printf '%s\n' "$$" > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT INT TERM

while :; do
    check
    sleep "$INTERVAL"
done
