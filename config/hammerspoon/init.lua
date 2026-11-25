-- Window management modelled on Rectangle's default shortcuts, plus window hints.
-- Needs Accessibility access: System Settings > Privacy & Security > Accessibility.

hs.window.animationDuration = 0

local mods = { "ctrl", "alt" }
local screenMods = { "ctrl", "alt", "cmd" }

local function unit(x, y, w, h)
  return hs.geometry.rect(x, y, w, h)
end

-- Pressing the same shortcut again on the same window steps to the next size,
-- like Rectangle's "repeated commands" (1/2 -> 2/3 -> 1/3).
local layouts = {
  left        = { key = "left",   sizes = { unit(0, 0, 1/2, 1), unit(0, 0, 2/3, 1), unit(0, 0, 1/3, 1) } },
  right       = { key = "right",  sizes = { unit(1/2, 0, 1/2, 1), unit(1/3, 0, 2/3, 1), unit(2/3, 0, 1/3, 1) } },
  top         = { key = "up",     sizes = { unit(0, 0, 1, 1/2), unit(0, 0, 1, 2/3), unit(0, 0, 1, 1/3) } },
  bottom      = { key = "down",   sizes = { unit(0, 1/2, 1, 1/2), unit(0, 1/3, 1, 2/3), unit(0, 2/3, 1, 1/3) } },
  maximize    = { key = "return", sizes = { unit(0, 0, 1, 1) } },
  topLeft     = { key = "u",      sizes = { unit(0, 0, 1/2, 1/2) } },
  topRight    = { key = "i",      sizes = { unit(1/2, 0, 1/2, 1/2) } },
  bottomLeft  = { key = "j",      sizes = { unit(0, 1/2, 1/2, 1/2) } },
  bottomRight = { key = "k",      sizes = { unit(1/2, 1/2, 1/2, 1/2) } },
  firstThird  = { key = "d",      sizes = { unit(0, 0, 1/3, 1) } },
  centerThird = { key = "f",      sizes = { unit(1/3, 0, 1/3, 1) } },
  lastThird   = { key = "g",      sizes = { unit(2/3, 0, 1/3, 1) } },
  firstTwo    = { key = "e",      sizes = { unit(0, 0, 2/3, 1) } },
  lastTwo     = { key = "t",      sizes = { unit(1/3, 0, 2/3, 1) } },
}

local placed = {}   -- window id -> frame we last put it in
local original = {} -- window id -> frame before we first touched it
local last = {}     -- { id, name, index } of the previous layout command

-- Runs move(win) on the focused window, remembering where it was so
-- ctrl+alt+backspace can put it back. A window moved by hand since our
-- last placement gets a fresh restore point.
local function manage(move)
  local win = hs.window.focusedWindow()
  if not win then return end

  local id = win:id()
  if not (placed[id] and win:frame():equals(placed[id])) then
    original[id] = win:frame()
    last = {}
  end

  move(win, id)
  placed[id] = win:frame()
end

for name, layout in pairs(layouts) do
  hs.hotkey.bind(mods, layout.key, function()
    manage(function(win, id)
      local index = 1
      if last.id == id and last.name == name then
        index = last.index % #layout.sizes + 1
      end
      win:moveToUnit(layout.sizes[index])
      last = { id = id, name = name, index = index }
    end)
  end)
end

hs.hotkey.bind(mods, "c", function()
  manage(function(win) win:centerOnScreen() end)
end)

hs.hotkey.bind(screenMods, "right", function()
  manage(function(win) win:moveToScreen(win:screen():next(), false, true) end)
end)

hs.hotkey.bind(screenMods, "left", function()
  manage(function(win) win:moveToScreen(win:screen():previous(), false, true) end)
end)

hs.hotkey.bind(mods, "delete", function()
  local win = hs.window.focusedWindow()
  if not win then return end

  local id = win:id()
  if original[id] then
    win:setFrame(original[id])
    original[id], placed[id], last = nil, nil, {}
  end
end)

-- Window hints: overlay a letter on every window, press it to focus that window.
-- "vimperator" style starts each hint with the app's first letter.
hs.hints.style = "vimperator"
hs.hotkey.bind(mods, "tab", hs.hints.windowHints)

-- Home Manager swaps the init.lua symlink on every switch; reload when it does.
ConfigWatcher = hs.pathwatcher.new(hs.configdir, hs.reload):start()
