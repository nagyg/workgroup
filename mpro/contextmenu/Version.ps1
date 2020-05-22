#Versions V1.0 KNM

$Dir = $args

$console = $host.ui.rawui
$console.backgroundcolor = "black"
$console.foregroundcolor = "white"

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
$host.ui.rawui.WindowTitle = "Version: $Dir"
Clear-Host


$script:showWindowAsync = Add-Type –memberDefinition @” 
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null


$DirVPath = ([io.fileinfo]"$Dir").DirectoryName
$DirVName = ([io.fileinfo]"$Dir").Basename
if ($DirVName.Length -gt 5)
    {
        if ($DirVName.Remove(0,($DirVName.Length-5)).Trimend("0123456789") -eq "_V")
            {
                Write-Host "Ez már egy verzíó: $Dir"
                Start-Sleep -s 5
                exit
            }
    }


if (Get-ChildItem -Path $Dir -Exclude *.dpx,*.exr,*.jpg,*.tga,*tif) 
{
    Write-Host "Probléma! $Dir"
    [system.windows.forms.messagebox]::show("Nem csak képek vannak a $Dir mappába !", "Probléma!")
    exit
}


$Selector = "_V"
if ($DirVName.Remove(0,$DirVName.Length-1) -eq "_") {$Selector = "V"}
$ver = 1
$verok = 1
$VerDirPrev = ''

do {
        $VerPad = "$ver".PadLeft(3,"0")
        $VerDir = "$DirVPath\$DirVName$Selector$VerPad"
        if (Test-Path $VerDir)
        {
            $VerPad = "$ver".PadLeft(3,"0")
            $VerDirPrev = "$DirVPath\$DirVName$Selector$VerPad"
            $ver ++
        }
        else 
        {
            $verok ++
            $ver ++
        }
}while ($Ver -le 99)

if (($Ver-$verok) -eq 0) 
{
   $b = [System.Windows.Forms.MessageBox]::Show("Biztos létrehozzam $VerDir ?" , "Version status!!!" , 4)
    if ($b -eq "YES" )
    {
        $VerDirPrev = "$DirVPath\$DirVName$Selector"+"000"
    } else {exit}
}

$a = [int]($VerDirPrev.Remove(0,($VerDirPrev.Length-3)))+1
$VerPad = "$a".PadLeft(3,"0")
$VerDir = "$DirVPath\$DirVName$Selector$VerPad"
write-host $VerDirPrev


New-Item $VerDir -ItemType directory -force | Out-Null

$items = (Get-ChildItem -Path "$Dir")
    foreach ($item in $items)
    {
        if ($item.Directory)
        {
            $FileName = ([io.fileinfo]"$item").Basename
            $Selector = "_V"
            if ($FileName.Trimend(".0123456789").Remove(0,$FileName.Trimend(".0123456789").Length-1) -eq "_") {$Selector = "V"}
            $a = ($FileName.Trimend("0123456789")).Trimend(".")
            $FileVName = $a+$Selector+$VerPad+'_'+$FileName.replace($a,'')+([io.fileinfo]"$item").Extension
            Write-Host $Dir'\'$item $VerDir'\'$FileVName 
            Move-Item -Path $Dir'\'$item -Destination $VerDir'\'$FileVName
        }   
    }

if((Get-ChildItem $Dir -force | Select-Object -First 1 | Measure-Object).Count -eq 0)
{
    Remove-Item $Dir -Force -Recurse
}

if ($b -eq "YES" )
    {
        Write-Host "`n`nCreate: $VerDir"
        Start-Sleep -s 5
        exit
    }
$Folder1 = Get-childitem $VerDirPrev
$Folder2 = Get-childitem $VerDir

if (Compare-Object $Folder1 $Folder2 -Property LastWriteTime)
    {
        Write-Host "`n`nCreate: $VerDir"
        Start-Sleep -s 5
        exit
    }
    else
    {
        Remove-Item $VerDir -Force -Recurse
        Write-Host "`n`nRemove:`t`t$Dir"
        Write-Host "`CurrentVersion:`t$VerDirPrev"
        Start-Sleep -s 5
    }
