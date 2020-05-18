#C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -NoLogo -WindowStyle Minimized -File M:\\PowerShell\\context_menu\\Version.ps1 "%L"
#-NoExit


$File = $args


$console = $host.ui.rawui
$console.backgroundcolor = "black"
$console.foregroundcolor = "white"

#$pshost = get-host
#$pswindow = $pshost.ui.rawui
#$newsize = $pswindow.buffersize
#$newsize.height = 3000
#$newsize.width = 100
#$pswindow.buffersize = $newsize
#$newsize = $pswindow.windowsize
#$newsize.height = 8
#$newsize.width = 100
#$pswindow.windowsize = $newsize
$host.ui.rawui.WindowTitle = "Safe: $File"
Clear-Host

$FileVPath = ([io.fileinfo]"$File").DirectoryName
$FileVName = ([io.fileinfo]"$File").Basename
$FileVExt = ([io.fileinfo]"$File").Extension
$SafeDir = "$FileVPath\Safe\$FileVName"

$Safe = 1
$SafePad = "$Safe".PadLeft(2,"0")
$SafeFile = "$SafeDir\$SafePad.$FileVName$FileVExt"
$SafeFileB = $SafeFile

if ((Get-Item $File).length -eq 0){exit}
New-Item $SafeDir -ItemType directory -force | Out-Null


do {
       if (Test-Path $SafeFile)
        {
            $SafeFileB = $SafeFile
            $SafeFile = "$SafeDir\$SafePad.$FileVName$FileVExt"
            $SafePad = "$Safe".PadLeft(2,"0")
        }
    $Safe ++
} while ($Safe -le 99)



if ($SafeFile -eq $SafeFileB)
    {
        Copy-Item $File -Destination $SafeFile
    }
Else
    {
        if(Compare-Object -ReferenceObject $(Get-Content $File) -DifferenceObject $(Get-Content $SafeFileB))
        {
            Copy-Item $File -Destination $SafeFile
        }
        else
        {
            Write-Host "Mentve volt már: $File"
            Start-Sleep -s 5
            exit
        }
    }

Write-Host "Mentve: $File ----> $SafeFile"
Start-Sleep -s 5
exit
