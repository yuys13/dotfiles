local wezterm = require 'wezterm'

wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

  window:set_right_status(date)
end)

local M = {}
M.use_ime = true

M.font = wezterm.font 'HackGenNerd Console'
M.font_size = 14.0

local status, dracula = pcall(require, 'dracula')
if status then
  M.colors = dracula
else
  M.color_scheme = 'Dracula'
end

M.adjust_window_size_when_changing_font_size = false
-- M.hide_tab_bar_if_only_one_tab = true
-- M.tab_bar_at_bottom = true
-- M.use_fancy_tab_bar = false

M.send_composed_key_when_right_alt_is_pressed = false

-- M.keys = {
--   -- CMD-y starts `top` in a new window
--   { key = 'y', mods = 'CMD', action = wezterm.action { SpawnCommandInNewTab = { args = { 'top' } } } },
-- }

return M
