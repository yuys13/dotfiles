@echo off

cd /d %~dp0

mklink /d %USERPROFILE%\AppData\Local\nvim %~dp0home\XDG_CONFIG_HOME\nvim
