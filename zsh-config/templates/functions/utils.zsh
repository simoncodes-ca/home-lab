# ~/.config/zsh/functions/utils.zsh
# Utility functions

# Find and kill process by port
killport() {
  local port=$1
  local pid=$(lsof -ti:$port)
  if [[ -n $pid ]]; then
    kill -9 $pid
    echo "Killed process on port $port (PID: $pid)"
  else
    echo "No process found on port $port"
  fi
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick file search
find-file() {
  find . -type f -iname "*$1*"
}

# Quick directory search
find-dir() {
  find . -type d -iname "*$1*"
}

# Git clone and cd
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Create backup of file
backup() {
  cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Show disk usage of current directory
duf() {
  du -sh * | sort -hr
}

# Get public IP
myip() {
  curl -s https://api.ipify.org
}

# Weather in terminal
weather() {
  curl -s "wttr.in/${1:-}"
}
