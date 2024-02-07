Write-Host "What would you like to do ?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with saved Baseline?"

$response = Read-Host -Prompt "Please enter 'A' or 'B'"

Write-Host "User entered $($response)"

Function Calculate-File-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt

    if ($baselineExists) {
    #Delete it 
    Remove-Item -Path .\baseline.txt
    }
}

if ($response -eq "A".ToUpper()){
   Write-Host "Calculate Hashes, make new baseline.txt"-ForegroundColor Cyan 
   #Delete Baseline if it already exists
   Erase-Baseline-If-Already-Exists

   #calculate Hash from target files and store in baseline.txt
    
   #Collect files in target folder
   $files =Get-ChildItem -Path .\Files
   
   # For file,calculate the hash and write to baseline.txt 
   foreach($f in $files){
       $hash = Calculate-File-Hash $f.FullName
       "$($hash.Path)|$($hash.Hash)" | Out-File .\baseline.txt -Append
   } 

   }
   elseif ($response -eq "B".ToUpper()){
        $fileHashDictionary = @{}
        $alertedFiles = @{}
       #Load file|hash from baseline.txt and store them in a dictionary 
        $filePathsAndHashes = Get-Content -Path .\baseline.txt
        
        foreach($f in $filePathsAndHashes){
          $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
        }

       #Begin continuously monitoring files with saved baseline
       Write-Host "Read existing baseline.txt,start monitoring files"-ForegroundColor Yellow
       while($true){
          Start-Sleep -Seconds 1
           $files =Get-ChildItem -Path .\Files
   
   # For file,calculate the hash and write to baseline.txt 
   foreach($f in $files){
       $hash = Calculate-File-Hash $f.FullName

       #Notify if a new file has been created
       if($fileHashDictionary[$hash.Path] -eq $null) {
       #A new file has been created!
       Write-Host "$($hash.Path)has been created!" -ForegroundColor Green
       "$($hash.Path)|$($hash.Hash)" | Out-File .\baseline.txt -Append
       $fileHashDictionary.add($hash.Path, $hash.Hash)
           }
           else{
           
           #Notify if a new file has been changed
           if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
             #File has not changed
           }
           else{
              #File has been compromised!,notify user
              if($alertedFiles[$hash.Path] -eq $null){
                Write-Host "$($hash.Path) has been changed!" -ForegroundColor Red
                "$($hash.Path)|$($hash.Hash)" | Out-File .\baseline.txt -Append
                $fileHashDictionary[$hash.Path] = $hash.Hash
                $alertedFiles.add($hash.Path, $true)
              }
               }
           }
           
          
        } 
         foreach($key in $fileHashDictionary.Keys){
           $baselineFileStillExists = Test-Path -Path $key
           if (-Not $baselineFileStillExists -and $alertedFiles[$key] -eq $null){
           #One of the baseine files must have been deleted,notify the user
           Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
           $alertedFiles.add($key, $true)
             }
           }
      }
   }
