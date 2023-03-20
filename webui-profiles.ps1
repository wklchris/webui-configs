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
    if ( !$argStr.Contains('--ckpt') ) { $argStr+=" --ckpt `"models/Stable-Diffusion/${selectCkpt}`"" }
    cmd /c "webui-user.bat" $argStr
}
