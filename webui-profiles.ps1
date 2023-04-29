Set-Variable -Name "webuiDir" -Value "D:\Git-repos\stable-diffusion-webui"

function sdwebui {
<#
.SYNOPSIS
从用户指定的 ${webuiDir} 文件夹处启动 SD-WebUI，并传递参数。
用户可以从检测到的模型文件列表中，通过输入序号来选择一个模型加载。

.PARAMETER argArr
一个由 SD-WebUI 参数字符串组成的列表，由空格分隔列表元素。

特别地，如果列表中的第一个元素不是用 '--' 开头的，那么它不会被传递，而会被用来匹配模型文件的开头字符串。
如果在本地的模型文件匹配中只有一个结果，那么无需用户输入就会自动加载该模型。
    
.EXAMPLE
PS > sdwebui
PS > sdwebui any
PS > sdwebui sd-v1-5 --share
PS > sdwebui any --share --gradio-auth user:pswd
#>
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$argArr
    )
    cd $webuiDir
    
    $modelStartStr=''
    $argStr=$argArr -join ' '
    if (($argArr.Count -gt 0) -and -not ($argArr[0].StartsWith('--'))) {
        $modelStartStr=$argArr[0]
        $argStr=($argArr | select-object -Skip 1) -join ' '
    }
    if ( !$argStr.Contains('--ckpt') ) { 
		$models=@(Get-ChildItem "${webuiDir}/models/Stable-Diffusion" -Recurse -Filter "${modelStartStr}*" -Include *.safetensors,*.ckpt | % Name)
		$modelCount=$models.Count
		if ($modelCount -eq 1) {
		    $selectCkpt = $models[0]
		} elseif ($modelCount -gt 1) {
			for ($i = 0; $i -lt $modelCount; $i++) {
				$m = $models[$i]
				Write-Output " ($($i+1)) $m" 
			}
			[int]$selectNum = Read-Host "Choose model [1~$($modelCount)]"
			$selectNum=$selectNum - 1
			$selectCkpt=$models[$selectNum]
		}
		$argStr+=" --ckpt `"models/Stable-Diffusion/${selectCkpt}`""
		Write-Output "---- Model chosen: $selectCkpt ----"
	}
    cmd /c "webui-user.bat" $argStr
}
