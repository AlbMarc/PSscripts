Function Get-FolderPath($title)                                                             #Function for directory selection dialog
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        SelectedPath = 'D:\GoogleDrive\Vorlesungen'
        #SelectedPath = '\\OFFICE-SRV\shared\Projekte\SCAPIS\MainTrial'
    }
    $FolderBrowserDialog.Description = $title
    $FolderBrowserDialog.ShowDialog() | Out-Null
    $FolderBrowserDialog.SelectedPath
}



$path = Get-FolderPath("TeX-File")

if ($path -eq ""){
    break
}
Write-Host $path

Set-Location -Path $path       

$textfile = (Get-Childitem $path | Where{$_.Extension -eq ".txt"}).FullName

$str = Get-Content $textfile