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
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function (files)
    hs.reload()
end):start()
hs.alert.show("Config loaded")

----------------------------------------------
-- Airplane mode
-----------------------------------------------
hs.hotkey.bind({'ctrl', 'shift', 'cmd'}, 'a', function ()
  local wifiPower = hs.wifi.interfaceDetails().power
  hs.wifi.setPower(not wifiPower);

  local blueutil = "/usr/local/bin/blueutil"
  local bluetoothPower = io.popen(blueutil .. " -p", 'r'):read() == "1" and true
  if (bluetoothPower) then
    os.execute(blueutil .. " -p 0")
  else
    os.execute(blueutil .. " -p 1")
  end
end);

-----------------------------------------------
-- Window management
-----------------------------------------------
local browser = "Google Chrome"
local terminal = "iTerm"
local ide = "IntelliJ IDEA"

function get_application_path(app)
  return "/Applications/" .. app .. ".app"
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'f', function () resize_win('native_fullscreen') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'g', function () resize_win('fullscreen') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'c', function () resize_win('center') end);

hs.hotkey.bind({'ctrl', 'cmd'}, 'u', function () resize_win('halfleft') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'i', function () resize_win('halfright') end);

hs.hotkey.bind({'ctrl', 'cmd'}, 't', function () resize_win('halfup') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'y', function () resize_win('halfdown') end);

hs.hotkey.bind({'ctrl', 'cmd'}, 'a', function () resize_win('thirdleft') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 's', function () resize_win('thirdmiddle') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'd', function () resize_win('thirdright') end);

hs.hotkey.bind({'ctrl', 'cmd'}, 'n', function () resize_win('twothirdleft') end);
hs.hotkey.bind({'ctrl', 'cmd'}, 'm', function () resize_win('twothirdright') end);

hs.hotkey.bind({        'cmd'}, 'escape', function() hs.hints.windowHints() end)

-- Develop/Design workflow with terminal and browser
hs.hotkey.bind({"ctrl", "cmd"}, '1', function ()
  hs.application.launchOrFocus(get_application_path(browser))
  hs.application.launchOrFocus(get_application_path(terminal))
  hs.layout.apply({
    {hs.application.find(terminal), nil, nil, hs.layout.left50, nil, nil},
    {hs.application.find(browser), nil, nil, hs.layout.right50, nil, nil},
  })
end);

-- Test workflow with ide and terminal
hs.hotkey.bind({"ctrl", "cmd"}, '2', function ()
  hs.application.launchOrFocus(get_application_path(ide))
  hs.application.launchOrFocus(get_application_path(terminal))
  hs.layout.apply({
    {hs.application.find(ide), nil, nil, hs.layout.left50, nil, nil},
    {hs.application.find(terminal), nil, nil, hs.layout.right50, nil, nil},
  })
end);

-- Develop/Design workflow with ide and browser
hs.hotkey.bind({"ctrl", "cmd"}, '3', function ()
  hs.application.launchOrFocus(get_application_path(browser))
  hs.application.launchOrFocus(get_application_path(ide))
  hs.layout.apply({
    {hs.application.find(ide), nil, nil, hs.layout.left50, nil, nil},
    {hs.application.find(browser), nil, nil, hs.layout.right50, nil, nil},
  })
end);

function resize_win(direction)
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local localf = screen:absoluteToLocal(f)
        local max = screen:fullFrame()
        -- Height of menubar in macOS is 22px this is used
        -- to prevent certain windows without native titlebar to start behind
        -- the menubar
        local menubar = 22 -- pixels

        -- +--------+---------+
        -- |        |         |
        -- |        |    x    |
        -- |        |         |
        -- +--------+---------+
        if direction == "halfright" then
            localf.x = max.w/2
            localf.y = menubar
            localf.w = max.w/2
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
            localf.y = menubar
            localf.w = max.w/2
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
            localf.y = menubar
            localf.w = max.w
            localf.h = max.h/2
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
            localf.y = max.h/2
            localf.w = max.w
            localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----+------------+
        -- |     |            |
        -- |  x  |            |
        -- |     |            |
        -- +-----+------------+
        if direction == "thirdleft" then
            localf.x = 0
            localf.y = menubar
            localf.w = max.w/3
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
            localf.x = max.w/3
            localf.y = menubar
            localf.w = max.w/3
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
            localf.x = max.w/3 * 2
            localf.y = menubar
            localf.w = max.w/3
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
            localf.x = max.w/3
            localf.y = menubar
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
            localf.y = menubar
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
        if direction == "cornerNE" then
            localf.x = max.w/2
            localf.y = menubar
            localf.w = max.w/2
            localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        +--------+
        -- |        |   x    |
        -- +--------+--------+
        if direction == "cornerSE" then
            localf.x = max.w/2
            localf.y = max.h/2
            localf.w = max.w/2
            localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- +--------+        |
        -- |    x   |        |
        -- +--------+--------+
        if direction == "cornerSW" then
            localf.x = 0
            localf.y = max.h/2
            localf.w = max.w/2
            localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +--------+--------+
        -- |    x   |        |
        -- +--------+        |
        -- |                 |
        -- +-----------------+
        if direction == "cornerNW" then
            localf.x = 0
            localf.y = menubar
            localf.w = max.w/2
            localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |    +-------+    |
        -- |    |   x   |    |
        -- |    +-------+    |
        -- +-----------------+
        if direction == "center" then
            localf.x = (max.w-localf.w)/2
            localf.y = (max.h-localf.h)/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end

        -- +-----------------+
        -- |                 |
        -- |        x        |
        -- |                 |
        -- +-----------------+
        if direction == "fullscreen" then
            localf.x = 0
            localf.y = menubar
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
