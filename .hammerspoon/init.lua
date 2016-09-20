-----------------------------------------------
-- Set up
-----------------------------------------------

local hyper = {"shift", "cmd", "alt", "ctrl"}
hs.window.animationDuration = 0

require("hs.application")
require("hs.window")

-----------------------------------------------
-- left one half window
-----------------------------------------------

hs.hotkey.bind({"ctrl", "cmd"}, 'u', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- right one half window
-----------------------------------------------

hs.hotkey.bind({"ctrl", "cmd"}, 'i', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- fullscreen
-----------------------------------------------

hs.hotkey.bind({"ctrl","cmd"}, 'f', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- left third
-----------------------------------------------

hs.hotkey.bind({"ctrl","cmd"}, 'j', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- middle third
-----------------------------------------------

hs.hotkey.bind({"ctrl","cmd"}, 'k', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 3)
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- right third
-----------------------------------------------

hs.hotkey.bind({"ctrl","cmd"}, 'l', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 3) * 2
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- Reload config on write
-----------------------------------------------

function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")

-----------------------------------------------
-- show window hints
-----------------------------------------------

hs.hotkey.bind({"shift","cmd"}, 'i', function()
    hs.hints.windowHints()
end)

-----------------------------------------------
-- Hyper hjkl to switch window focus
-----------------------------------------------

-- hs.hotkey.bind(hyper, 'k', function()
--     if hs.window.focusedWindow() then
--         hs.window.focusedWindow():focusWindowNorth()
--     else
--         hs.alert.show("No active window")
--     end
-- end)

-- hs.hotkey.bind(hyper, 'j', function()
--     if hs.window.focusedWindow() then
--         hs.window.focusedWindow():focusWindowSouth()
--     else
--         hs.alert.show("No active window")
--     end
-- end)

-- hs.hotkey.bind(hyper, 'l', function()
--     if hs.window.focusedWindow() then
--     hs.window.focusedWindow():focusWindowEast()
--     else
--         hs.alert.show("No active window")
--     end
-- end)

-- hs.hotkey.bind(hyper, 'h', function()
--     if hs.window.focusedWindow() then
--         hs.window.focusedWindow():focusWindowWest()
--     else
--         hs.alert.show("No active window")
--     end
-- end)
