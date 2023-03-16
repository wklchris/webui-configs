@echo off

set PYTHON=
set GIT=
set VENV_DIR=

rem 请按需设置 COMMANDLINE_ARGS。此处使用了 --medvram 模式
set COMMANDLINE_ARGS=--medvram --listen --enable-insecure-extension-access

rem 允许从 Powershell/CMD 命令行接受单个参数，并合并到默认 COMMANDLINE_ARGS 尾部
set COMMANDLINE_ARGS=%COMMANDLINE_ARGS% %~1

call webui.bat
