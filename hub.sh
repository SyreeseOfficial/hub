#!/bin/bash
# Hub: pick a tool from tools.conf, then launch / stop / open it. Uninstall: ./uninstall.sh
HUB=$(dirname "$(readlink -f "$0")")
CODE=$(dirname "$HUB")
pick() { omarchy-menu-select "$@" 2>/dev/null; }
running() { [[ $1 != - ]] && ss -ltn "sport = :$1" | grep -q LISTEN; }
open_url() { omarchy-launch-browser "$1" 2>/dev/null || firefox "$1" & }
term() { setsid uwsm-app -- xdg-terminal-exec --dir="$1" bash -c "$2" >/dev/null 2>&1 & }

mapfile -t rows < <(grep -v '^\s*#' "$HUB/tools.conf" | grep .)
list=(); for r in "${rows[@]}"; do IFS='|' read -r n d _ <<<"$r"; list+=("▸	$n	$d"); done
choice=$(pick Hub "${list[@]}" | cut -f1) || exit 0
for r in "${rows[@]}"; do IFS='|' read -r name _ dir cmd port repo inst <<<"$r"; [[ $name == "$choice" ]] && break; done
path=$CODE/$dir

actions=("Launch")
running "$port" && actions=("Open in browser" "Restart" "Stop")
actions+=("Open folder in terminal" "Open on GitHub")
act=$(pick "$name" "${actions[@]}") || exit 0

launch() {
  if [[ -n $inst && $dir != "" && ! -d $path/node_modules && $inst == npm* ]]; then
    [[ $(pick "Dependencies missing" "Install and launch" "Cancel") == Install* ]] || exit 0
    cmd="$inst && $cmd"
  fi
  term "$path" "$cmd; echo; read -rp '[$name exited] press Enter to close'"
  if [[ $port != - ]]; then
    for _ in $(seq 60); do running "$port" && break; sleep 0.5; done
    open_url "http://localhost:$port"
  fi
}

case $act in
  Launch) launch ;;
  "Open in browser") open_url "http://localhost:$port" ;;
  Restart) fuser -k "$port/tcp" >/dev/null 2>&1; sleep 1; launch ;;
  Stop) fuser -k "$port/tcp" >/dev/null 2>&1 ;;
  "Open folder in terminal") term "$path" "exec \$SHELL" ;;
  "Open on GitHub") open_url "https://github.com/$repo" ;;
esac
