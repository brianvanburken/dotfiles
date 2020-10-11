require("hs.application")
require("hs.window")

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-----------------------------------------------
-- Global configurations
-----------------------------------------------
hs.window.animationDuration = 0
hs.hints.showTitleThresh = 0
hs.application.enableSpotlightForNameSearches(true)

-----------------------------------------------
-- Reload config on write
-----------------------------------------------
hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", function (files)
    hs.reload()
end):start()
hs.alert.show("Config loaded")

-----------------------------------------------
-- Window management
-----------------------------------------------
hs.hotkey.bind({'ctrl', 'alt'}, 'return', function () resize_win('native_fullscreen') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'c', function () resize_win('center') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'left', function () resize_win('halfleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'right', function () resize_win('halfright') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'up', function () resize_win('halfup') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'down', function () resize_win('halfdown') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'd', function () resize_win('thirdleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'f', function () resize_win('thirdmiddle') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'g', function () resize_win('thirdright') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'e', function () resize_win('twothirdleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 't', function () resize_win('twothirdright') end);

hs.hotkey.bind({'ctrl', 'alt'}, 'u', function () resize_win('topleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'i', function () resize_win('topright') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'j', function () resize_win('bottomleft') end);
hs.hotkey.bind({'ctrl', 'alt'}, 'k', function () resize_win('bottomright') end);

hs.hotkey.bind({'cmd'}, 'escape', function() hs.hints.windowHints() end)

function resize_win(direction)
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local localf = screen:absoluteToLocal(f)
        local max = screen:fullFrame()
        local stepw = max.w/100
        local steph = max.h/100

        if direction == "right" then
            localf.w = localf.w+stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "left" then
            localf.w = localf.w-stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "up" then
            localf.h = localf.h-steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "down" then
            localf.h = localf.h+steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+---------+
        -- |        |         |
        -- |        |    x    |
        -- |        |         |
        -- +--------+---------+
        if direction == "halfright" then
            localf.x = max.w/2 localf.y = 0 localf.w = max.w/2 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +---------+--------+
        -- |         |        |
        -- |    x    |        |
        -- |         |        |
        -- +---------+--------+
        if direction == "halfleft" then
            localf.x = 0 localf.y = 0 localf.w = max.w/2 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +------------------+
        -- |        x         |
        -- +------------------+
        -- |                  |
        -- +------------------+
        if direction == "halfup" then
            localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +------------------+
        -- |                  |
        -- +------------------+
        -- |        x         |
        -- +------------------+
        if direction == "halfdown" then
            localf.x = 0 localf.y = max.h/2 localf.w = max.w localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+------------+
        -- |     |            |
        -- |  x  |            |
        -- |     |            |
        -- +-----+------------+
        if direction == "thirdleft" then
            localf.x = 0 localf.y = 0 localf.w = max.w/3 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----+-----+
        -- |     |     |     |
        -- |     |  x  |     |
        -- |     |     |     |
        -- +-----+-----+-----+
        if direction == "thirdmiddle" then
            localf.x = max.w/3 localf.y = 0 localf.w = max.w/3 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----+-----+
        -- |     |     |     |
        -- |     |     |  x  |
        -- |     |     |     |
        -- +-----+-----+-----+
        if direction == "thirdright" then
            localf.x = max.w/3 * 2 localf.y = 0 localf.w = max.w/3 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+-----------+
        -- |     |           |
        -- |     |     x     |
        -- |     |           |
        -- +-----+-----------+
        if direction == "twothirdright" then
            localf.x = max.w/3
            localf.y = 0
            localf.w = max.w/3 * 2
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
            localf.w = max.w/3 * 2
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
            localf.x = max.w/2 localf.y = 0 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        +--------+
        -- |        |   x    |
        -- +--------+--------+
        if direction == "bottomright" then
            localf.x = max.w/2 localf.y = max.h/2 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- +--------+        |
        -- |    x   |        |
        -- +--------+--------+
        if direction == "bottomleft" then
            localf.x = 0 localf.y = max.h/2 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+--------+
        -- |    x   |        |
        -- +--------+        |
        -- |                 |
        -- +-----------------+
        if direction == "topleft" then
            localf.x = 0 localf.y = 0 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |    +-------+    |
        -- |    |   x   |    |
        -- |    +-------+    |
        -- +-----------------+
        if direction == "center" then
            localf.x = (max.w-localf.w)/2 localf.y = (max.h-localf.h)/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        if direction == "fcenter" then
            localf.x = stepw*5 localf.y = steph*5 localf.w = stepw*20 localf.h = steph*20
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        x        |
        -- |                 |
        -- +-----------------+
        if direction == "fullscreen" then
            localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h
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
-- Workflows
-----------------------------------------------
local browser = "Firefox"
local terminal = "iTerm"
local ide = "IntelliJ IDEA"

function get_application_path(app)
  return "/Applications/" .. app .. ".app"
end

-- Develop/Design workflow with terminal and browser
hs.hotkey.bind({"ctrl", "cmd"}, '1', function ()
  hs.application.launchOrFocus(get_application_path(browser))
  hs.application.launchOrFocus(get_application_path(terminal))
  hs.layout.apply({
    {hs.application.find(terminal), nil, nil, hs.layout.left50, nil, nil},
    {hs.application.find(browser), nil, nil, hs.layout.right50, nil, nil},
  })
end);
