# WebUI-Configs

本仓库用于存放对[stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)工具进行快速设置的一些工具。适用于 Windows。

## 功能

* [webui-profiles.ps1](./webui-profiles.ps1)：从 Powershell 命令行使用 `sdwebui` 快速启动。可以在本机使用，也便于通过 SSH 启动远程机的 SD-WEBUI。
  * 在启动时会检测所有本地模型（并标数字序号），用户应输入数字来选择一个模型加载。
  * 支持额外的、正常使用空格分隔的 SD-WebUI 参数，比如： `sdwebui --medvram --listen`。不过方便起见，仍然建议把总是固定启用的参数写在 `webui-user.bat` 的 `COMMANDLINE_ARGS` 中。

## 许可证

[MIT](./LICENSE)
 