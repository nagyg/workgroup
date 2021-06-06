#LastWirite V1.0 KNM


$Dir = $args
#$Dir = "M:\tmp\"


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
$host.ui.rawui.WindowTitle = "LastWirite: $Dir"
Clear-Host


$script:showWindowAsync = Add-Type –memberDefinition @” 
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

$files = Get-ChildItem $Dir\*.*
$a = (Get-Item $Dir).LastWriteTime

foreach($file in $files)
{
    if ( (Get-Item $file).LastWriteTime -gt $a )
    {
        $a = (Get-Item $file).LastWriteTime
        Write-Host New: $file $a
    }
}

Get-Childitem -force $Dir | Foreach-Object { $_.LastWriteTime = $a }
$b = Get-Item -force $Dir
$b.LastWriteTime = $a
Start-Sleep -s 5
