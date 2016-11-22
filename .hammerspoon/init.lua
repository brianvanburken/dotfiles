hs.window.animationDuration = 0

require("hs.application")
require("hs.window")
-----------------------------------------------
-- Reload config on write
-----------------------------------------------

function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")

-----------------------------------------------
-- Window management
-----------------------------------------------
local hyper = {"ctrl", "cmd"}

-- +--------------------+
-- |                    |
-- |        HERE        |
-- |                    |
-- +--------------------+
hs.hotkey.bind(hyper, 'f', function()
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

-- +--------------------+
-- |         |          |
-- |  HERE   |          |
-- |         |          |
-- +--------------------+
hs.hotkey.bind(hyper, 'u', function()
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

-- +--------------------+
-- |         |          |
-- |         |   HERE   |
-- |         |          |
-- +--------------------+
hs.hotkey.bind(hyper, 'i', function()
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

-- +--------------------+
-- |      |      |      |
-- | HERE |      |      |
-- |      |      |      |
-- +--------------------+
hs.hotkey.bind(hyper, 'j', function()
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

-- +--------------------+
-- |      |      |      |
-- |      | HERE |      |
-- |      |      |      |
-- +--------------------+
hs.hotkey.bind(hyper, 'k', function()
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

-- +--------------------+
-- |      |      |      |
-- |      |      | HERE |
-- |      |      |      |
-- +--------------------+
hs.hotkey.bind(hyper, 'l', function()
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

-- +----------+----------+
-- |   HERE   |          |
-- +----------+          |
-- |                     |
-- +---------------------+
hs.hotkey.bind(hyper, 'v', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-- +--------+----------+
-- |        |   HERE   |
-- |        +----------+
-- |                   |
-- +-------------------+
hs.hotkey.bind(hyper, 'b', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-- +---------------------+
-- |                     |
-- +----------+          |
-- |   HERE   |          |
-- +----------+----------+
hs.hotkey.bind(hyper, 'n', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-- +-------------------+
-- |                   |
-- |        +----------+
-- |        |   HERE   |
-- +--------+----------+
hs.hotkey.bind(hyper, 'm', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)

-----------------------------------------------
-- show window hints
-----------------------------------------------
hs.hints.showTitleThresh = 0
hs.hotkey.bind({"cmd"}, '[', function()
    hs.hints.windowHints()
end)

-----------------------------------------------
-- audio control
-----------------------------------------------
hs.hotkey.bind(hyper, '[', function()
  hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume - 5)
end)

hs.hotkey.bind(hyper, ']', function()
  hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume + 5)
end)

hs.hotkey.bind(hyper, 'p',     hs.spotify.play)
hs.hotkey.bind(hyper, 'o',     hs.spotify.pause)
hs.hotkey.bind(hyper, 'n',     hs.spotify.next)
hs.hotkey.bind(hyper, 'i',     hs.spotify.previous)

-----------------------------------------------
-- Hyper hjkl to switch window focus
-----------------------------------------------
local hyper = {"shift", "cmd"}
hs.hotkey.bind(hyper, 'k', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowNorth()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'j', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowSouth()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'l', function()
    if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowEast()
    else
        hs.alert.show("No active window")
    end
end)

hs.hotkey.bind(hyper, 'h', function()
    if hs.window.focusedWindow() then
        hs.window.focusedWindow():focusWindowWest()
    else
        hs.alert.show("No active window")
    end
end)
