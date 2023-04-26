@echo off

set PYTHON=
set GIT=
set VENV_DIR=

rem 显存分配优化（如有必要）
rem set PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:32
rem 安装 torch 2.0 + cu118 (并在第一次运行时添加 --reinstall-torch，之后移除)
rem set TORCH_COMMAND=pip install torch==2.0.0 torchvision --extra-index-url https://download.pytorch.org/whl/cu118
rem 请按需设置 COMMANDLINE_ARGS。此处使用了 --medvram 模式
rem     LOWVRAM: --lowvram --always-batch-cond-uncond
set COMMANDLINE_ARGS=--medvram --listen --enable-insecure-extension-access

rem 允许从 Powershell/CMD 命令行接受单个参数，并合并到默认 COMMANDLINE_ARGS 尾部
set COMMANDLINE_ARGS=%COMMANDLINE_ARGS% %~1

call webui.bat
