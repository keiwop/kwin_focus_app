// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>


function set_active_window(win){
    if(workspace.activeClient !== undefined){
        workspace.activeClient = win;
    }
    else{
        workspace.activeWindow = win;
    }
}


function get_active_window(){
    if(workspace.activeClient !== undefined){
        return workspace.activeClient;
    }
    else{
        return workspace.activeWindow;
    }
}


function get_app_windows(app_name, window_list){
    const lower = app_name.toLowerCase();

    let app_windows = window_list.filter(win => {
        if(win.resourceName && win.resourceName.toLowerCase() === lower){
            return true;
        }
        return (win.resourceClass && win.resourceClass.toLowerCase() === lower) ||
        (win.caption && win.caption.toLowerCase().includes(lower));
    });
    return app_windows;
}


function update_last_focused(app_name, app_windows, window){
    const win_index = app_windows.indexOf(window);
    if(win_index !== -1){
        app_window_last_focused[app_name] = win_index;
        console.log(`focus_app: Last focused window for ${app_name} updated to index ${win_index}`);
    }
    else{
        app_window_last_focused[app_name] = 0;
    }
}


function get_last_focused_window(app_name, app_windows){
    if(app_window_last_focused.hasOwnProperty(app_name)){
        const last_index = app_window_last_focused[app_name];
        if(last_index >= 0 && last_index < app_windows.length){
            // console.log(`focus_app: Last focused window for ${app_name} found at index ${last_index}`);
            return app_windows[last_index];
        }
        else{
            delete app_window_last_focused[app_name];
        }
    }
    // console.log(`focus_app: Last focused window for ${app_name} not found, using first window`);
    return app_windows[0];
}


function focus_application(app_name){
    const window_list = workspace.windowList();
    console.log(`focus_app: focus_application(app_name = ${app_name})`);
    // print(`focus_app: window_list = ${window_list}`);

    // window_list.forEach((win, i) => {
    //     let cls = win.resourceClass || "(no class)";
    //     let name = win.resourceName  || "(no name)";
    //     print(`    ${i}: class = ${cls} | name = ${name} | caption = "${win.caption}"`);
    // });

    const app_windows = get_app_windows(app_name, window_list);

    if(app_windows.length == 0){
        console.log(`focus_app: No window found for “${app_name}”, starting it.`);
        try{
            callDBus("org.kde.krunner", "/App", "org.kde.krunner.App", "query", app_name);
        }
        catch(e){
            console.error(`focus_app: Error while launching the app ${app_name} -> ${e}`);
        }
        return;
    }

    const active_window = get_active_window();
    const active_index = app_windows.indexOf(active_window);

    if(active_index == -1){
        console.log(`focus_app: Activating ${app_name}`);
        const last_focused = get_last_focused_window(app_name, app_windows);
        set_active_window(last_focused);
        update_last_focused(app_name, app_windows, last_focused);
    }
    else{
        console.log(`focus_app: Switching between windows of “${app_name}”`);
        const next_index = (active_index + 1) % app_windows.length;
        const next_window = app_windows[next_index];
        set_active_window(next_window);
        update_last_focused(app_name, app_windows, next_window); 
    }
}


function add_shortcut(shortcut_name, app_name, key_bind){
    if(registerShortcut(shortcut_name, shortcut_name, key_bind, function(){
        console.log(`focus_app: callback(shortcut_name = ${shortcut_name}, app_name = ${app_name}, key_bind = ${key_bind})`);
        try{
            focus_application(app_name);
        }
        catch(e){
            console.error(`focus_app: Error while calling focus_application(${app_name}) -> ${e}`);
        }
    })){
        console.log(`focus_app: Shortcut registered -> ${shortcut_name} - ${key_bind}`);
    }
}


let app_window_last_focused = {};

print("focus_app loaded");

// These are shortcuts for an AZERTY layout
// Unfortunatly it seems that kwin scripts aren't allowed to use keycodes instead
add_shortcut("Focus Firefox", "firefox", "Meta+²");
add_shortcut("Focus VSCodium", "codium", "Meta+&");
add_shortcut("Focus Dolphin", "dolphin", "Meta+é");
add_shortcut("Focus Evince", "evince", "Meta+\"");
add_shortcut("Focus Calculator", "gnome-calculator", "Meta+\'");
add_shortcut("Focus Kate", "kate", "Meta+(");
