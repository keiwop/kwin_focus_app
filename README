# Focus App

Hi!  
I've made this KWin script to quickly focus applications and cycle through their windows using custom keyboard shortcuts.  
This has only been tested on Plasma 6 Wayland, it might also be compatible with X11 and Plasma 5.  

## Features

- Focus a specific app window with a keyboard shortcut  
- Cycle through all open windows of the same app  
- Remembers the last app window that was focused  
- Proposes to launch the application if it's not already running  
- Customizable shortcuts  
- Runs natively on KDE Plasma 6 Wayland  

## Installation

### Using the Install Script

```sh
git clone https://github.com/keiwop/kwin_focus_app.git
cd kwin_focus_app
sh focus_app.sh
```

This will install the KWin script in the user home directory.  

You might have to enable it manually if `kwriteconfig6` is not available on your system. This can be done in:
```
System Settings > Window Management > KWin Scripts
```

### NixOS

A Nix shell is provided to work on KWin scripts. It includes a few helper functions.  
```sh
nix-shell shell.nix
kde_log_scripts
kde_install_script
kde_enable_script
```
__Note__: I haven't found a native way to package it correctly for NixOS.  
Installing globally would prevent easy shortcut customization without using an external configuration file.  


## Configuration

You can customize the shortcuts and their actions by editing the source code directly.  
Just replace the __add_shortcut(...)__ calls at the end of the `main.js`.  

It looks like this:  
```javascript
add_shortcut("Focus Firefox", "firefox", "Meta+²");
add_shortcut("Focus VSCodium", "codium", "Meta+&");
add_shortcut("Focus Dolphin", "dolphin", "Meta+é");
```
- __First argument__: Name of the shortcut as it will appear in KDE System Settings  
- __Second argument__: App to focus  
- __Third argument__: Shortcut key combo. It must match you keyboard layout, as KWin scripts seems to be unable to send raw keycodes  

### After editing
Upgrade the KWin script with:  
```sh
sh focus_app.sh
```

Or, if you edited the installed script (~/.local/share/kwin/scripts), reload it with:  
```sh
sh focus_app.sh --reload
```

__Tip__: If you only want to change the actual shortcut key combo, you can also do it in:  
```
System Settings > Keyboard > Shortcuts > KWin
```

## Troubleshoot

If the KWin script doesn't work after enabling it, check these common issues:

### 1) Shortcut conflicts
Your chosen shortcut might already be used by KDE or another app.
You can check shortcuts in:
```
System Settings > Keyboard > Shortcuts
```
__Example__: For me, using *"Meta+&"* was conflicting with the shortcut *"Meta+1"* already defined by plasmashell.  
It happens by the magic of having inconsistencies in how shortcuts are handled by KWin scripts and the system.  

### 2) Shortcuts not updating  
If you modify `main.js` at the installed location, the system won't update the shortcuts during the next launch.  
For that you need to:
- Disable the KWin script
- Clean up the orphaned shortcuts
- Re-enable the script

All of this is handled automatically when you launch:  
```
sh focus_app.sh
# or 
sh focus_app.sh --reload
```

### None of these?
Check the logs to see if there's any useful informations:
```sh
sh focus_app.sh --logs
```
Don't hesitate to open a bug report!  


## Author

[keiwop](mailto:keiwop.dev@gmail.com)  

## License

This project is licensed under the GPL-3.0-or-later.  
