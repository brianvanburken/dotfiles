-----------------------------------------------
-- Global configurations
-----------------------------------------------
hs.window.animationDuration = 0
hs.hints.showTitleThresh = 0

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
-- Mouse management
-----------------------------------------------
-- TODO: mouse movement
-- Example: https://github.com/ashfinal/awesome-hammerspoon/blob/255e11ab964de00c7a35286158ca3460a06a66f9/modes/basicmode.lua

-----------------------------------------------
-- Window management
-----------------------------------------------
-- Start mode with ⌥  + R
-- Exit mode with escape
--
-- Use ; to display hints for active windows.
-- Use [/] to cycle through active windows.
-- Use H/J/K/L to resize windows to 1/2 of screen.
-- Use Y/U/I/O to resize windows to 1/4 of screen.
-- Use ⇧  + H/J/K/L to move windows around.
-- Use ⇧  + Y/U/I/O to resize windows.
-- Use =, - to expand/shrink the window size.
-- Use F to put windows to fullscreen
-- Use C to put windows to center of screen

-- Use ⇧  + C to resize windows to predefined size and center them.

wm = hs.hotkey.modal.new('alt', 'r')
function wm:entered() hs.alert 'Entered resize mode' end
function wm:exited()  hs.alert 'Exited resize mode'  end
wm:bind('', 'escape', function() wm:exit() end)

wm:bind('', '[', 'Focus left',  function() cycle_wins_pre()  end, nil, function() cycle_wins_pre()  end)
wm:bind('', ']', 'Focus right', function() cycle_wins_next() end, nil, function() cycle_wins_next() end)


wm:bind('shift', 'Y', 'Shrink Leftward',     function () resize_win('left')       end, nil, function () resize_win('left')  end)
wm:bind('shift', 'O', 'Stretch Rightward',   function () resize_win('right')      end, nil, function () resize_win('right') end)
wm:bind('shift', 'U', 'Stretch Downward',    function () resize_win('down')       end, nil, function () resize_win('down')  end)
wm:bind('shift', 'I', 'Shrink Upward',       function () resize_win('up')         end, nil, function () resize_win('up')    end)
wm:bind('',      'F', 'Fullscreen',          function () resize_win('fullscreen') end, nil, nil)
wm:bind('',      'C', 'Center Window',       function () resize_win('center')     end, nil, nil)
wm:bind('shift', 'C', 'Resize & Center',     function () resize_win('fcenter')    end, nil, nil)
wm:bind('',      'H', 'Lefthalf of Screen',  function () resize_win('halfleft')   end, nil, nil)
wm:bind('',      'J', 'Downhalf of Screen',  function () resize_win('halfdown')   end, nil, nil)
wm:bind('',      'K', 'Uphalf of Screen',    function () resize_win('halfup')     end, nil, nil)
wm:bind('',      'L', 'Righthalf of Screen', function () resize_win('halfright')  end, nil, nil)
wm:bind('',      'Y', 'NorthWest Corner',    function () resize_win('cornerNW')   end, nil, nil)
wm:bind('',      'U', 'SouthWest Corner',    function () resize_win('cornerSW')   end, nil, nil)
wm:bind('',      'I', 'SouthEast Corner',    function () resize_win('cornerSE')   end, nil, nil)
wm:bind('',      'O', 'NorthEast Corner',    function () resize_win('cornerNE')   end, nil, nil)
wm:bind('shift', 'H', 'Move Leftward',       function () resize_win('mleft')      end, nil, function () resize_win('mleft')  end)
wm:bind('shift', 'L', 'Move Rightward',      function () resize_win('mright')     end, nil, function () resize_win('mright') end)
wm:bind('shift', 'J', 'Move Downward',       function () resize_win('mdown')      end, nil, function () resize_win('mdown')  end)
wm:bind('shift', 'K', 'Move Upward',         function () resize_win('mup')        end, nil, function () resize_win('mup')    end)
wm:bind('',      '=', 'Stretch Outward',     function () resize_win('expand')     end, nil, function () resize_win('expand') end)
wm:bind('',      '-', 'Shrink Inward',       function () resize_win('shrink')     end, nil, function () resize_win('shrink') end)

function cycle_wins_next()
    windows_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum + 1
    if resize_current_winnum > #windows_list then resize_current_winnum = 1 end
end

function cycle_wins_pre()
    windows_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum - 1
    if resize_current_winnum < 1 then resize_current_winnum = #windows_list end
end

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
        if direction == "halfright" then
            localf.x = max.w/2 localf.y = 0 localf.w = max.w/2 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "halfleft" then
            localf.x = 0 localf.y = 0 localf.w = max.w/2 localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "halfup" then
            localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "halfdown" then
            localf.x = 0 localf.y = max.h/2 localf.w = max.w localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "cornerNE" then
            localf.x = max.w/2 localf.y = 0 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "cornerSE" then
            localf.x = max.w/2 localf.y = max.h/2 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "cornerNW" then
            localf.x = 0 localf.y = 0 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "cornerSW" then
            localf.x = 0 localf.y = max.h/2 localf.w = max.w/2 localf.h = max.h/2
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
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
        if direction == "fullscreen" then
            localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "shrink" then
            localf.x = localf.x+stepw localf.y = localf.y+steph localf.w = localf.w-(stepw*2) localf.h = localf.h-(steph*2)
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "expand" then
            localf.x = localf.x-stepw localf.y = localf.y-steph localf.w = localf.w+(stepw*2) localf.h = localf.h+(steph*2)
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "mright" then
            localf.x = localf.x+stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "mleft" then
            localf.x = localf.x-stepw
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "mup" then
            localf.y = localf.y-steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
        if direction == "mdown" then
            localf.y = localf.y+steph
            local absolutef = screen:localToAbsolute(localf)
            win:setFrame(absolutef)
        end
    else
        hs.alert.show("No focused window!")
    end
end
