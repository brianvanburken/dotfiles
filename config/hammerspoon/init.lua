require("hs.application")
require("hs.window")

-----------------------------------------------
-- Global configurations
-----------------------------------------------
hs.window.animationDuration = 0
hs.hints.showTitleThresh = 0
hs.application.enableSpotlightForNameSearches(true)

-----------------------------------------------
-- Window management
-----------------------------------------------
hs.hotkey.bind({'ctrl', 'alt'}, 'return', function () ResizeWindow('native_fullscreen') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'c', function () ResizeWindow('center') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'left', function () ResizeWindow('halfleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'right', function () ResizeWindow('halfright') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'up', function () ResizeWindow('halfup') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'down', function () ResizeWindow('halfdown') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'd', function () ResizeWindow('thirdleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'f', function () ResizeWindow('thirdmiddle') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'g', function () ResizeWindow('thirdright') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'e', function () ResizeWindow('twothirdleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 't', function () ResizeWindow('twothirdright') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'u', function () ResizeWindow('topleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'i', function () ResizeWindow('topright') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'j', function () ResizeWindow('bottomleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'k', function () ResizeWindow('bottomright') end);

function ResizeWindow(direction)
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local localf = screen:absoluteToLocal(f)
        local max = screen:fullFrame()
        local stepw = max.w / 100
        local steph = max.h / 100

        if direction == "right" then
            localf.w = localf.w + stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "left" then
            localf.w = localf.w - stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "up" then
            localf.h = localf.h - steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "down" then
            localf.h = localf.h + steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+---------+
        -- |        |         |
        -- |        |    x    |
        -- |        |         |
        -- +--------+---------+
        if direction == "halfright" then
            localf.x = max.w / 2
            localf.y = 0
            localf.w = max.w / 2
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +---------+--------+
        -- |         |        |
        -- |    x    |        |
        -- |         |        |
        -- +---------+--------+
        if direction == "halfleft" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w / 2
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +------------------+
        -- |        x         |
        -- +------------------+
        -- |                  |
        -- +------------------+
        if direction == "halfup" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +------------------+
        -- |                  |
        -- +------------------+
        -- |        x         |
        -- +------------------+
        if direction == "halfdown" then
            localf.x = 0
            localf.y = max.h / 2
            localf.w = max.w
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----+-----+
        -- |     |     |     |
        -- |  x  |     |     |
        -- |     |     |     |
        -- +-----+-----+-----+
        if direction == "thirdleft" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w / 3
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----+-----+
        -- |     |     |     |
        -- |     |  x  |     |
        -- |     |     |     |
        -- +-----+-----+-----+
        if direction == "thirdmiddle" then
            localf.x = max.w / 3
            localf.y = 0
            localf.w = max.w / 3
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----+-----+
        -- |     |     |     |
        -- |     |     |  x  |
        -- |     |     |     |
        -- +-----+-----+-----+
        if direction == "thirdright" then
            localf.x = max.w / 3 * 2
            localf.y = 0
            localf.w = max.w / 3
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----------+
        -- |     |           |
        -- |     |     x     |
        -- |     |           |
        -- +-----+-----------+
        if direction == "twothirdright" then
            localf.x = max.w / 3
            localf.y = 0
            localf.w = max.w / 3 * 2
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------+-----+
        -- |           |     |
        -- |     x     |     |
        -- |           |     |
        -- +-----------+-----+
        if direction == "twothirdleft" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w / 3 * 2
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+--------+
        -- |        |   x    |
        -- |        +--------+
        -- |                 |
        -- +-----------------+
        if direction == "topright" then
            localf.x = max.w / 2
            localf.y = 0
            localf.w = max.w / 2
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        +--------+
        -- |        |   x    |
        -- +--------+--------+
        if direction == "bottomright" then
            localf.x = max.w / 2
            localf.y = max.h / 2
            localf.w = max.w / 2
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- +--------+        |
        -- |    x   |        |
        -- +--------+--------+
        if direction == "bottomleft" then
            localf.x = 0
            localf.y = max.h / 2
            localf.w = max.w / 2
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+--------+
        -- |    x   |        |
        -- +--------+        |
        -- |                 |
        -- +-----------------+
        if direction == "topleft" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w / 2
            localf.h = max.h / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |    +-------+    |
        -- |    |   x   |    |
        -- |    +-------+    |
        -- +-----------------+
        if direction == "center" then
            localf.x = (max.w - localf.w) / 2
            localf.y = (max.h - localf.h) / 2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "fcenter" then
            localf.x = stepw * 5
            localf.y = steph * 5
            localf.w = stepw * 20
            localf.h = steph * 20
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |+---------------+|
        -- ||       x       ||
        -- |+---------------+|
        -- +-----------------+
        if direction == "fullscreen" then
            localf.x = 0
            localf.y = 0
            localf.w = max.w
            localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        x        |
        -- |                 |
        -- +-----------------+
        if direction == "native_fullscreen" then
            win:toggleFullScreen()
        end
    else
        hs.alert.show("No focused window!")
    end
end

-----------------------------------------------
-- Application management
-----------------------------------------------
local applicationHotkeys = {
  c = 'Slack', -- Chat
  b = 'Firefox', -- Browser
  m = 'Mail', -- Mail
  n = 'Notes', -- Notes
  s = 'Spotify', -- Sounds
  t = 'Alacritty', -- Terminal
}

for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind({'alt', 'cmd'}, key, function()
    hs.application.launchOrFocus(app)
  end)
end
