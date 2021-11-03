Function Get-FolderPath($title)                                                             #Function for directory selection dialog
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        SelectedPath = 'D:\Git\PSscripts'
        #SelectedPath = '\\OFFICE-SRV\shared\Projekte\SCAPIS\MainTrial'
    }
    $FolderBrowserDialog.Description = $title
    $FolderBrowserDialog.ShowDialog() | Out-Null
    $FolderBrowserDialog.SelectedPath
}



$path = Get-FolderPath("TeX-File")
#$path = "D:\Git\PSscripts"

if ($path -eq ""){
    break
}
Write-Host $path

Set-Location -Path $path       

$textfile = (Get-Childitem $path | Where-Object{$_.Extension -eq ".txt"}).FullName

$textfile | ForEach-Object{
    if ($_ -ccontains "_Sleep" -or $_ -ccontains "_Event"){
        Write-Host "split files found"
    } else {
        $content = Get-Content $_
        $fname = $_.Split(".")
    
        $outSleepName = $fname[0] + "_Sleep." + $fname[1]
        $outEventsName = $fname[0] + "_Event." + $fname[1]

        New-Item -Path $outSleepName -ItemType File -Force
        New-Item -Path $outEventsName -ItemType File -Force

        $splitflag = $false

        $content | ForEach-Object{
            if ($splitflag -eq $false){
                $_ | Out-File $outSleepName -Append
                $_ | Out-File $outEventsName -Append
                if (($_ -match "Events Included:")-xor($_ -match "Sleep Stage")){
                    $splitflag = $true
                }
            }else{
                if ($_ -match "SLEEP"){
                    $_ | Out-File $outSleepName -Append
                }elseif ($_ -match "Scoring Session:") {
                    "`n"+ $_ | Out-File $outSleepName -Append
                    $_ | Out-File $outEventsName -Append
                    $splitflag = $false
                }else{
                    $_ | Out-File $outEventsName -Append
                }
            }
        }
    }
}
