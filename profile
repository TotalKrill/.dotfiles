export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/chromium
export PATH=~/.cargo/bin:$PATH

autorandr -c

export PATH="/home/krille/.local/share/solana/install/active_release/bin:$PATH"
. "$HOME/.cargo/env"
