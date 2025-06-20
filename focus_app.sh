#! /bin/sh

SCRIPT_NAME="focus_app"
SCRIPT_PRETTY="Focus App"


show_help(){
    cat << EOF
${SCRIPT_NAME}.sh - Install the $SCRIPT_PRETTY KWin script

USAGE:
    ./${SCRIPT_NAME}.sh [opt]

    This script will install the KWin script to ~/.local/share/kwin/scripts

OPTIONS:
    --reload, -r        Reload the script
    --uninstall, -u     Uninstall the script
    --logs,-l           Prints journald logs for KWin scripts
    --help, -h          Show this help

EOF
}


handle_args(){
    case "$1" in
        --reload|-r)
            reload_script
            exit 0
            ;;
        --uninstall|-u)
            disable_script
            uninstall_script
            exit 0
            ;;
        --logs|-l)
            print_logs
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        "")
            install_script
            enable_script
            exit 0
            ;;
        *)
            echo "Error: Unknown option '$1'"
            show_help
            exit 1
            ;;
    esac
}


install_script(){
    if command -v kpackagetool6 >/dev/null 2>&1; then
        if [ -d "$HOME/.local/share/kwin/scripts/${SCRIPT_NAME}" ]; then
            echo "Upgrading $SCRIPT_PRETTY KWin script"
            disable_script
            clean_shortcuts
            kpackagetool6 --type=KWin/Script -u "${SCRIPT_NAME}"
        else
            echo "Installing $SCRIPT_PRETTY KWin script"
            kpackagetool6 --type=KWin/Script -i "${SCRIPT_NAME}"
        fi
    else
        echo "kpackagetool6 not found. Copying the KWin script to ~/.local/share/kwin/scripts/"
        mkdir -p ~/.local/share/kwin/scripts
        cp -r "${SCRIPT_NAME}" ~/.local/share/kwin/scripts/
    fi
}


uninstall_script(){
    echo "Uninstalling $SCRIPT_PRETTY KWin script"
    if command -v kpackagetool6 >/dev/null 2>&1; then
        kpackagetool6 --type=KWin/Script -r "${SCRIPT_NAME}"
    else
        echo "kpackagetool6 not found. Removing the KWin script from ~/.local/share/kwin/scripts/"
        if [ -d "$HOME/.local/share/kwin/scripts/${SCRIPT_NAME}" ]; then
            rm -fr "$HOME/.local/share/kwin/scripts/${SCRIPT_NAME}"
        fi
    fi
}


reload_script(){
    disable_script
    if [ $? -eq 1 ]; then
        echo "Press Enter when you have disabled the KWin script, or Ctrl+C to cancel"
        read -r
    fi
    clean_shortcuts
    enable_script
}


enable_script(){
    echo "Enabling $SCRIPT_PRETTY KWin script"
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kwinrc --group Plugins --key focus_appEnabled true
        qdbus org.kde.KWin /KWin reconfigure
        sleep 0.5
    else
        echo "kwriteconfig6 not found. You will have to enable the script manually in System Settings > Window Management > KWin Scripts"
    fi
}


disable_script(){
    echo "Disabling $SCRIPT_PRETTY KWin script"
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kwinrc --group Plugins --key focus_appEnabled false
        qdbus org.kde.KWin /KWin reconfigure
        sleep 0.5
        return 0
    else
        echo "kwriteconfig6 not found. You will have to disable the script manually in System Settings > Window Management > KWin Scripts"
        return 1
    fi
}


clean_shortcuts(){
    echo "Cleaning up orphaned shortcuts"
    result=$(qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.cleanUp 2>/dev/null)
    if [[ "$result" = "true" ]]; then
        echo "Orphaned shortcuts were found and deleted"
    else
        echo "No orphaned shortcuts found"
    fi
}


# TODO
show_conflicting_shortcuts(){
    echo "Checking for conflicting shortcuts"
}


print_logs(){
    journalctl -f QT_CATEGORY=js QT_CATEGORY=kwin_scripting
}


handle_args $@
