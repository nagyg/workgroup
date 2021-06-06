#SafeDir V1.0 KNM

$Dir = $args

#$pshost = get-host
#$pswindow = $pshost.ui.rawui
#$newsize = $pswindow.buffersize
#$newsize.height = 3000
#$newsize.width = 150
#$pswindow.buffersize = $newsize
#$newsize = $pswindow.windowsize
#$newsize.height = 8
#$newsize.width = 100
#$pswindow.windowsize = $newsize
$host.ui.rawui.WindowTitle = "SafeDir: $Dir"
Clear-Host



$DirPath = ([io.fileinfo]"$Dir").DirectoryName
$DirName = ([io.fileinfo]"$Dir").Basename
$Safe = 1
$SafePad = "$Safe".PadLeft(2,"0")
$SafeDir = "$DirPath\SafeDir\$SafePad.$DirName"
$SafeDirB = 'First'



if((Get-ChildItem $Dir -force | Select-Object -First 1 | Measure-Object).Count -eq 0)
    {
        Write-Host "Üres: $Dir"
        Start-Sleep -s 5
        exit            
    }

New-Item "$DirPath\SafeDir" -ItemType directory -force | Out-Null


do {
    if (Test-Path $SafeDir)
    {
        $SafeDirB = $SafeDir
        $SafeDir = "$DirPath\SafeDir\$SafePad.$DirName"
        $SafePad = "$Safe".PadLeft(2,"0")
    }
    $Safe ++
} while ($Safe -le 99)

if ($SafeDirB -ne 'First')
    {
    if (Compare-Object (Get-childitem -Recurse -Exclude *.ass,*.ifd $Dir | Select-Object LastWriteTime) (Get-childitem -Recurse $SafeDirB | Select-Object LastWriteTime)) {}
        else
        {
            Write-Host "Már mentve: $SafeDirB"
            Start-Sleep -s 5
            exit
        }
    }

Write-Host "Copy: $Dir ---> $SafeDir"

Copy-Item -Path $Dir -Exclude *.ass,*.ifd -Destination $SafeDir -Recurse

if (Compare-Object (Get-childitem -Recurse -Exclude *.ass,*.ifd $Dir | Select-Object LastWriteTime ) (Get-childitem -Recurse $SafeDir | Select-Object LastWriteTime))
    {
        Write-Host 'Nem sikerult!'
        Remove-Item $SafeDir -Force -Recurse
    }
    else
    {
        Write-Host 'OK!'
    }
Start-Sleep -s 5
Exit
