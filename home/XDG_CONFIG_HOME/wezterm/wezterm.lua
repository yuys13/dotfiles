local wezterm = require 'wezterm'

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

-- M.tab_bar_at_bottom = true
-- M.use_fancy_tab_bar = false

-- M.keys = {
--   -- CMD-y starts `top` in a new window
--   { key = 'y', mods = 'CMD', action = wezterm.action { SpawnCommandInNewTab = { args = { 'top' } } } },
-- }

return M
