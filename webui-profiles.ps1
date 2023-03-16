# 使用：
#
# 【依赖项：参考 stable-diffusion-webui/webui-user.bat 中的编辑工作】
#
# 1. 打开 Powershell，输入 notepad $profile 以编辑本地的 Powershell 的 .ps1 配置文件；
#    如果文件不存在，则输入 echo $profile 来查看文件应存在的路径，并去该路径新建一个同名文本文件。
# 2. 复制以下内容到 .ps1 配置文件中。
# 3. 将下述 webuiDir 变量的值（下例中为 D:\Git-repos\stable-diffusion-webui）改为本地的实际 SD-WEBUI 安装路径。
# 4. 保存并关闭配置文件。打开一个新的 Powershell 窗口，并输入 sdwebui 以运行 SD-WEBUI 工具。

Set-Variable -Name "webuiDir" -Value "D:\Git-repos\stable-diffusion-webui"

function sdwebui {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$argArr
    )
    $models=Get-ChildItem "${webuiDir}/models/Stable-Diffusion" -Recurse -Include *.safetensors,*.ckpt | % Name
    $modelCount=$models.Count
    For ($i = 0; $i -lt $modelCount; $i++) {
        $m = $models[$i]
        Write-Output " ($($i+1)) $m" 
    }
    [int]$selectNum = Read-Host "Choose model [1~$($modelCount)]: "
    $selectNum=$selectNum - 1
    $selectCkpt=$models[$selectNum]
    Write-Output "---- Model chosen: $selectCkpt"
    
    cd $webuiDir
    $argStr=$argArr -join ' '
    if ( !$argStr.Contains('--ckpt') ) { $argStr+=" --ckpt `"${selectCkpt}`"" }
    cmd /c "webui-user.bat" $argStr
}
