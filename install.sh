#! /bin/sh

echo "Installing KWin script"
if command -v kpackagetool6 >/dev/null 2>&1; then
    kpackagetool6 --type=KWin/Script -i focus_app
else
    echo "kpackagetool6 not found. Copying the KWin script to ~/.local/share/kwin/scripts/"
    mkdir -p ~/.local/share/kwin/scripts
    cp -r focus_app ~/.local/share/kwin/scripts/focus_app
fi

echo "Enabling KWin script"
if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kwinrc --group Plugins --key focus_appEnabled true
    qdbus org.kde.KWin /KWin reconfigure
else
    echo "kwriteconfig6 not found. You will have to enable the script manually in System Settings > Window Management > KWin Scripts"
fi
