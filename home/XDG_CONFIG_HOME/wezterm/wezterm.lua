local wezterm = require 'wezterm'

local function convert_homedir(path)
  local cwd = path
  return cwd:gsub('^' .. wezterm.home_dir, '~')
end

local function basename(s)
  return string.gsub(s, '/$', ''):gsub('(.*[/\\])(.*)', '%2')
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local proc = basename(tab.active_pane.foreground_process_name)
  local cwd = convert_homedir(tab.active_pane.current_working_dir:gsub('^file://', ''))
  cwd = basename(cwd)
  local title = tab.tab_index + 1 .. ':' .. cwd .. ' | ' .. proc
  return {
    { Text = wezterm.truncate_right(title, max_width) },
  }
end)

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

M.tab_max_width = 24

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
