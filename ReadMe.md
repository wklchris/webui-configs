# WebUI-Configs <!-- ignore in ToC -->

本仓库用于存放对[stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)工具进行快速设置的一些工具。适用于 Windows。

- [以 Powershell 参数启动：webui-profiles.ps1](#以-powershell-参数启动webui-profilesps1)
- [PNG 内嵌文本管理：tools/pnginfo.py](#png-内嵌文本管理toolspnginfopy)
- [开发参考](#开发参考)
- [许可证](#许可证)

以下是功能介绍与说明。

## 以 Powershell 参数启动：webui-profiles.ps1

[webui-profiles.ps1](./webui-profiles.ps1) 能从 Powershell 命令行使用 `sdwebui` 快速启动。可以在本机使用，也便于通过 SSH 启动远程机的 SD-WebUI。
  * 支持额外的、正常使用空格分隔的 SD-WebUI 参数，比如： `sdwebui --medvram --listen`。
  * 在启动时会检测所有本地模型（并标数字序号），用户应输入数字来选择一个模型加载。
    * 如果只查找到一个模型文件，那么将自动加载它；用户无需再输入数字序号。
    * 特别地，用户可以指定一个字符串，让脚本只查找以该字符串开头的模型文件：
      ```
      sdwebui sd-v1
      ```

安装：

1. 参考本仓库中的 [webui-user.bat](stable-diffusion-webui/webui-user.bat) 对本地的 `webui-user.bat` 进行配置。
2. 打开 Powershell，输入 `notepad $profile` 以编辑本地的 Powershell 的默认 .ps1 配置文件；如果该文件不存在，则输入 `echo $profile` 来查看文件应存在的路径，并去该路径新建一个同名文本文件。
3. 将本脚本（[webui-profiles.ps1](./webui-profiles.ps1) 文件）中 `webuiDir` 变量的值（下例中为 `D:\Git-repos\stable-diffusion-webui`）改为本地的实际 SD-WebUI 安装路径。
4. 复制本脚本中的内容到本地的 Powershell 默认配置文件中。
5. 保存并关闭配置文件。重新打开 Powershell 以使用。

使用：

安装完成后，可以打开一个新的 Powershell 窗口，并输入：
```
sdwebui
```
以运行 SD-WebUI 工具。同时，它也支持参数传递，比如：
```
sdwebui --share
```

传递参数，并在打印模型列表时，只查看以给定字符串 `sd-v1-5` 开头的模型文件：
```
sdwebui sd-v1-5 --share
```

最后，用户可以通过 `get-help sdwebui --examples` 来查看该函数的使用帮助。

## PNG 内嵌文本管理：tools/pnginfo.py

[pnginfo.py](tools/pnginfo.py) 可以读取/写入文本到 PNG 文件块（chunk），或者将图片转为其他格式（例如 JPG）来去除 SD-WebUI 生成的 PNG 中嵌入的 prompt 文本。

使用示例：

```python
img_path = 'test.png'
img = InfoImage(img_path)
print(img.geninfo)

new_info = { "foo": "bar" }
img.update_save_info(new_info, replace=False)
# 将更新的文本键值另存为 PNG
img.save_img('test-info.png')  
# 通过转 JPG 的方式去除文本
img.save_img('test-info.jpg', quality=95)  
```
## 开发参考

[pnginfo.py](tools/pnginfo.py) 工具的开发参考了 [WebUI 官方仓库](https://github.com/AUTOMATIC1111/stable-diffusion-webui)中的 Prompt 嵌入与读取方法实现：

- `modules/images.py` 文件的 `read_info_from_image()` 函数；
- `modules/script_callbacks.py` 文件的 `save_image()` 函数。

## 许可证

[MIT](./LICENSE)
 