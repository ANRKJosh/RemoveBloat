Echo off
cls
Write-Host "WARNING: PLEASE COPY & RUN THIS SCRIPT IN POWERSHELL ISE AS ADMINISTRATOR OTHERWISE THE SCRIPT WILL NOT RUN CORRECTLY."
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
Start-Sleep -Milliseconds 1550
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)
pause
cls
Write-Host "This PowerShell Script WILL remove a lot of Microsoft/Manufacturer UWP/App & HP .*exe bloat"
echo ''
Write-Host "You will get options at the end to install Ninite (Chrome & Runtimes) and Adobe Reader DC" 

#Pin-App function (grabbed from the internet) to unpin applications from start.
function Pin-App {    param(
        [string]$appname,
        [switch]$unpin
    )
    try{
        if ($unpin.IsPresent){
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Von "Start" lösen|Unpin from Start'} | %{$_.DoIt()}
            return "App '$appname' unpinned from Start"
        }else{
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'An "Start" anheften|Pin to Start'} | %{$_.DoIt()}
            return "App '$appname' pinned to Start"
        }
    }catch{
        Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
    }
}



pause
cls

#Remove Manufacturer and Security Bloat
$removewin32_bloat? = read-host "Remove Win32 Bloat? (Y/N) "

if ($removewin32_bloat? -contains "Y" -or $removewin32_bloat? -contains "y" -or $removewin32_bloat? -contains "yes"){

    $removeexebloat_brand = Read-Host "Input the Brand Name of the Machine"

    $brandguids = get-wmiobject -class win32_product | Where-Object {$_.Name -like "$removeexebloat_brand *"} | Where-Object {$_.Name -notmatch "client security manager" -and $_.Name -notlike "* Driver *"}

    foreach($guid in $brandguids){
    $id = $guid.IdentifyingNumber
    write-host "Attempting to remove "$guid.Name"."
    &cmd /c "msiexec /uninstall $($id) /qn /norestart"
    }

    $securityguids = Get-WmiObject -Class win32_product | Where-Object {$_.Name -like "McAfee *" -or $_.Name -like "Norton *" -or $_.Name -like "Avast *" -or $_.Name -like "AVG *" -or $_.Name -like "* AntiVirus *" -or $_.Name -like "* Anti-Virus *" -or $_.Name -like "Webroot *" -or $_.Name -like "McAfee" -or $_.Name -like "Avast" -or $_.Name -like "Norton" -or $_.Name -like "AVG" -or $_.Name -like "Webroot" } | Where-Object {$_.Name -notlike "Panda *" }
    
    foreach($guid in $securityguids){
    $id = $guid.IdentifyingNumber
    write-host "Attempting to remove "$guid.Name"."
    &cmd /c "msiexec /uninstall $($id) /qn /norestart"
    }

    $clientmanager = get-wmiobject -class win32_product | Where-Object {$_.Name -like "HP *"} | Where-Object {$_.Name -match "client security manager"}

    foreach($guid in $clientmanager){
    $id = $guid.IdentifyingNumber
    write-host "Attempting to remove "$guid.Name"."
    &cmd /c "msiexec /uninstall $($id) /qn /norestart"
    }

    $otherjunkguids = get-wmiobject -class win32_product | Where-Object {$_.Name -like "Energy Star" -or $_.Name -like "Dolby *" -or $_.Name -like "Driver Identifier" -or $_.Name -like "Deezer *" -or $_.Name -like "Music Creator" -or $_.Name -like "*Music*" -or $_.Name -like "Bonjour" -or $_.Name -like "Cyberlink *" -or $_.Name -like "HP ePrint SW" -or $_.Name -like "HP Documentation"  -or $_.Name -like "* HP Touchpoint *" -or $_.Name -like "Booking" -or $_.Name -like "Booking.com" -or $_.Name -like "Booking *"  -or $_.Name -like "PC Optimizer *"  -or $_.Name -like "PC Optimizer" -or $_.Name -like "One Click *" -or $_.Name -like "One Click" }

    foreach($guid in $otherjunkguids){
    $id = $guid.IdentifyingNumber
    write-host "Attempting to remove "$guid.Name"."
    &cmd /c "msiexec /uninstall $($id) /qn /norestart"
    }

    $HPePrint = get-wmiobject -class win32_product | Where-Object {$_.Name -like "HP ePrint SW"}

    foreach($guid in $HPePrint){
    $id = $guid.IdentifyingNumber
    write-host "Attempting to remove "$guid.Name" (Not Quietly - as this software has issues with being removed)."
    &cmd /c "msiexec /uninstall $($id) /norestart"
    }

    Write-Host "Removed *.exe Bloatware, please continue to remove Bloat UWP/Windows Apps"
}


pause
cls
Write-Host "Now Removing Bloat UWP/Apps"
#Remove Manufacturer Bloat
$Applist = Get-AppXProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*HP*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Dell*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Asus*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Lenovo*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Compaq*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*AVG*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*McAfee*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Avast*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Norton*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Amazon*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Booking*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Power Media*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Dolby*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Energy Star*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Dropbox*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Bonjour*"} | Remove-AppxProvisionedPackage -online
Get-AppxPackage -allusers *HP* | Remove-AppxPackage
Get-AppxPackage -allusers *Dell* | Remove-AppxPackage
Get-AppxPackage -allusers *Asus* | Remove-AppxPackage
Get-AppxPackage -allusers *Lenovo* | Remove-AppxPackage
Get-AppxPackage -allusers *Compaq* | Remove-AppxPackage
Get-AppxPackage -allusers *McAfee* | Remove-AppxPackage
Get-AppxPackage -allusers *Avast* | Remove-AppxPackage
Get-AppxPackage -allusers *Amazon* | Remove-AppxPackage
Get-AppxPackage -allusers *Booking* | Remove-AppxPackage
Get-AppxPackage -allusers *Dolby* | Remove-AppxPackage
Get-AppxPackage -allusers *Dropbox* | Remove-AppxPackage
Get-AppxPackage -allusers *Power Media* | Remove-AppxPackage
Get-AppxPackage -allusers *Norton* | Remove-AppxPackage
Get-AppxPackage -allusers *AVG* | Remove-AppxPackage
Get-AppxPackage -allusers *Energy Star* | Remove-AppxPackage
Get-AppxPackage -allusers *Bonjour* | Remove-AppxPackage
#Remove Current installs on all users.-all users removes the application from all current users. 
Get-AppxPackage -allusers *OneNote* | Remove-AppxPackage
Get-AppxPackage -allusers *Xbox* | Remove-AppxPackage
Get-AppxPackage -allusers *Office* | Remove-AppxPackage
Get-AppxPackage -allusers *getstarted* | Remove-AppxPackage
Get-AppxPackage -allusers *Get Started* | Remove-AppxPackage
Get-AppxPackage -allusers *tips* | Remove-AppxPackage
Get-AppxPackage -allusers *3D* | Remove-AppxPackage
Get-AppxPackage -allusers *3D* | Remove-AppxPackage
Get-AppxPackage -allusers *3D* | Remove-AppxPackage
Get-AppxPackage -allusers *3D* | Remove-AppxPackage
Get-AppxPackage -allusers *Paint 3D* | Remove-AppxPackage
Get-AppxPackage -allusers *Print 3D* | Remove-AppxPackage
Get-AppxPackage -allusers *3D Builder* | Remove-AppxPackage
Get-AppxPackage -allusers *3D Viewer* | Remove-AppxPackage
Get-AppxPackage -allusers *Mobile Plans* | Remove-AppxPackage
Get-AppxPackage -allusers *MobilePlans* | Remove-AppxPackage
Get-AppxPackage -allusers *App Installer* | Remove-AppxPackage
Get-AppxPackage -allusers *AppInstaller* | Remove-AppxPackage
#Define Vairiable and load package names
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*OneNote*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*XboxApp*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*xbox*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*MicrosoftOfficeHub*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*AppInstaller*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*App Installer*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*OneNote*"} | Remove-AppxProvisionedPackage –online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3DBuilder*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*BingFinance*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*BingNews*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*BingSports*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*CommsPhone*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*ConnectivityStore*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*BingSports*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*MSNWeather*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Remote*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Whiteboard*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Office Lens*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*getstarted*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Paint 3D*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D Viewer*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*3D Builder*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Print 3D*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*MicrosoftOfficeHub*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*MicrosoftSolitaireCollection*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*OneNote*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Sway*"} | Remove-AppxProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist = Get-AppXProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*Mobile Plans*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*MobilePlans*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*XboxApp*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*xbox*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*tips*"} | Remove-AppxProvisionedPackage -online
$Applist | WHere-Object {$_.packagename -like "*FarmVille*"} | Remove-AppxProvisionedPackage -online
// Ones that are giving issue when ran in line with other package removals
Get-appxpackage -allusers *Microsoft.BingWeather* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*BingWeather*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.Asphalt8Airborne* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Asphalt*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *king.com.CandyCrushSodaSaga* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*CandyCrushSodaSaga*"} | remove-appxprovisionedpackage –online
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*king.com.CandyCrushSodaSaga*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *FarmVille2CountryEscape* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*FarmVille2CountryEscape*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.DrawboardPDF* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Drawboard*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Facebook* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Facebook*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *BethesdaSoftworks.FalloutShelter* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*BethesdaSoftworks.FalloutShelter*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *FarmVille2CountryEscape* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*FarmVille2CountryEscape*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.WindowsFeedbackHub*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.Messaging* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Messaging*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.Wallet* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.Wallet*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.MicrosoftSolitaireCollection*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *MinecraftUWP* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Minecraft*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *bingfinance* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bing*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.BingNews* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*BingNews*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Netflix* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Netflix*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *PandoraMediaInc* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Pandora*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *flaregamesGmbH.RoyalRevolt2* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Royal*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.SkypeApp* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*SkypeApp*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *bingsports* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bingsports*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Office.Sway* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Office.Sway*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Twitter* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Twitter*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.BingWeather* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*BingWeather*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.XboxGameOverlay* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxGameOverlay*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.XboxApp* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxApp*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.XboxIdentityProvider* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XboxIdentityProvider*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *XboxOneSmartGlass* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*XboxOneSmartGlass*"} | remove-appxprovisionedpackage –online
Get-appxpackage -allusers *Microsoft.XboxSpeechToTextOverlay* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Microsoft.XSpeechToTextOverlay*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *King.com* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*king.com*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Solitairecollection* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*solitairecollection*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Pandora* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Pandora*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *radio* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*radio*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *People* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*People*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Thumbmunkeys* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Thumbmunkeys*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *fitbit* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*fitbit*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *DolbyLaboratories* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*DolbyLaboratories*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Dolby* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Dolby*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *LinkedIn* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*LinkedIn*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Web Media* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Web Media*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Tips* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Tips*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Mobile* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Mobile*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Plans* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Plans*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Paint 3D* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Paint 3D*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *3D* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*3D*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *3D* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*3D*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *3D Viewer* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*3D Viewer*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Viewer* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Viewer*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *LinkedIn* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*LinkedIn*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Mail* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Mail*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Recorder* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Recorder*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Voice* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Voice*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Voice Recorder* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Voice Recorder*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *To-Do* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*To-Do*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Whiteboard* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Whiteboard*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Lens* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Lens*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *News* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*News*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *MSN* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*MSN*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Weather* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Weather*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Remote* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Remote*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Network Speed* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Network Speed*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Drawboard PDF* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Drawboard PDF*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Getstarted* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Getstarted*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *commsphone* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*commsphone*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *mobile plans* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*mobile plans*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *mobileplans* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*mobileplans*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *App Installer* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*App Installer*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *mobileplans* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*mobileplans*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *mobile plans* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*mobile plans*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Music Creator* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Music Creator*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Deezer* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Deezer*"} | Remove-AppxProvisionedPackage -online
Get-appxpackage -allusers *Music* | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Music*"} | Remove-AppxProvisionedPackage -online
$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.Advertising.Xaml" 
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MinecraftUWP"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.Xbox.TCUI"

    
    
    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingTravel"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    "Microsoft.ScreenSketch"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"

    # non-Microsoft
    "9E2F88E3.Twitter"
    "PandoraMediaInc.29680B314EFC2"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "king.com.BubbleWitch3Saga"
    "king.com.*"
    "ClearChannelRadioDigital.iHeartRadio"
    "4DF9E0F8.Netflix"
    "6Wunderkinder.Wunderlist"
    "Drawboard.DrawboardPDF"
    "2FE3CB00.PicsArt-PhotoStudio"
    "D52A8D61.FarmVille2CountryEscape"
    "TuneIn.TuneInRadio"
    "GAMELOFTSA.Asphalt8Airborne"
    "TheNewYorkTimes.NYTCrossword"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "Facebook.Facebook"
    "flaregamesGmbH.RoyalRevolt2"
    "Playtika.CaesarsSlotsFreeCasino"
    "A278AB0D.MarchofEmpires"
    "KeeperSecurityInc.Keeper"
    "ThumbmunkeysLtd.PhototasticCollage"
    "XINGAG.XING"
    "89006A2E.AutodeskSketchBook"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "46928bounde.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "DolbyLaboratories.DolbyAccess"
    "SpotifyAB.SpotifyMusic"
    "A278AB0D.DisneyMagicKingdoms"
    "WinZipComputing.WinZipUniversal"
    "CAF9E577.Plex"  
    "7EE7776C.LinkedInforWindows"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "Fitbit.FitbitCoach"
    "DolbyLaboratories.DolbyAccess"
    "Microsoft.BingNews"
    "NORDCURRENT.COOKINGFEVER"
)

foreach ($app in $apps) {
    Write-Output "Trying to remove $app"

    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers

    Get-AppXProvisionedPackage -Online |
        Where-Object DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}
cls
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
Write-Host "Changing Current Power Plan to Balanced & Turn off Device when pressing the power button"

echo ''

write-host "Setting PowerPlan to Balanced aka. Automatic"
powercfg -SetActive 381b4222-f694-41f0-9685-ff5bb260df2e #Automatic aka. Balanced Power Plan GUID

echo ''

Write-Host "Setting On Battery Power Button to Turn Off the Machine" 
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

echo ''

Write-Host "Setting Plugged In Button to Turn Off the Machine"
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

echo ''

Write-Host "Setting Scheme to Active"
powercfg -SetActive SCHEME_CURRENT


cls
cls
cls
Write-Host "Finished removing UWP Apps!"
Write-Host "Continue to clear the start menu (Store App links etc)"
pause
Write-Host "Clearing the start menu"
Pin-App "Mail" -unpin
Pin-App "Mail" -unpin
Pin-App "Store" -unpin
Pin-App "Calendar" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Weather" -unpin
Pin-App "Phone Companion" -unpin
Pin-App "Twitter" -unpin
Pin-App "Skype Video" -unpin
Pin-App "Candy Crush Soda Saga" -unpin
Pin-App "xbox" -unpin
Pin-App "Groove music" -unpin
Pin-App "movies & tv" -unpin
Pin-App "microsoft solitaire collection" -unpin
Pin-App "money" -unpin
Pin-App "get office" -unpin
Pin-App "onenote" -unpin
Pin-App "news" -unpin
Pin-App "*Asphalt*" -unpin
Pin-App "*Township*" -unpin
Pin-App "*Candy Crush*" -unpin
Pin-App "*Candy Crush Soda Saga*" -unpin
Pin-App "*Minecraft*" -unpin
Pin-App Where-object {$_.name -like "Game"} -unpin
Pin-App Where-object {$_.name -like "Asphalt"} -unpin
Pin-App Where-object {$_.name -like "Township"} -unpin
Pin-App Where-object {$_.name -like "Candy Crush"} -unpin
Pin-App Where-object {$_.name -like "Minecraft"} -unpin

(New-Object -Com Shell.Application).
    NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
    Items() |
  %{ $_.Verbs() } |
  ?{$_.Name -match 'Un.*pin from Start'} |
  %{$_.DoIt()}


Start-Sleep -Milliseconds 200
Write-Host "Start menu has been cleared"
pause
cls

echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''

Write-Output "Installing Windows Photos (As this app may have been removed earlier in the process)"
Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Program Files\WindowsApps\Microsoft.Windows.Photos_15.1208.10480.0_x64__8wekyb3d8bbwe\AppxManifest.xml"}



Write-Output "Adding Registry Keys (DeliveryOptimization, Optimize Windows, Stop OEM bloat from installing"
Write-Output "Disable Game DVR and Game Bar"
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowgameDVR" 0
Write-Output "Setting default explorer view to This PC"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1
Write-Output "Stop Windows from installing OEM Content by default"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "FeatureManagementEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEverEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContentEnabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-314559Enabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v UxOption /t REG_DWORD /d 1 /f

Write-Output "Disable Some Heartbeat/Telemetry Tasks from starting"
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /disable
schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /disable
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /disable
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /disable
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /disable
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /disable
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable
schtasks /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /disable
schtasks /Change /TN "Microsoft\Windows\Clip\License Validation" /disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\LoginCheck" /disable
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitorToastTask" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /disable

Write-0utput "Disable Services that are not needed"
start sc stop DiagTrack
start sc stop XboxGipSvc
start sc stop xbgm
start sc stop XblAuthManager
start sc stop XblGameSave
start sc stop XboxNetApiSvc
start sc stop OneSyncSvc
start sc stop RetailDemo
start sc stop MessagingService

start sc config DiagTrack start= disabled
start sc config XboxGipSvcx start = disabled
start sc config xbgm start= disabled
start sc config XblAuthManager start = disabled
start sc config XblGameSave start= disabled
start sc config XboxNetApiSvc start = disabled
start sc config OneSyncSvc start= disabled
start sc config RetailDemo start= disabled
start sc config MessagingService start= disabled



$adobedownload = Read-Host "Download Adobe Reader? (y/n) "
if ($adobedownload -contains "y") {
    $url = "https://admdownload.adobe.com/bin/live/readerdc_uk_xa_crd_install.exe"
    $outpath = "C:\Xuper\readerdc_uk_xa_crd_install.exe"
    mkdir "c:\Xuper"
    Write-Host "Downloading Adobe Reader DC..."
    Invoke-WebRequest -Uri $url -OutFile $outpath
    Write-Host "Finished Downloading Adobe Reader DC!"
    Start-Sleep -m 500
    Write-Host "Opening Adobe Reader DC..."
    Start-Sleep -m 100
    start -Wait "c:\Xuper\readerdc_uk_xa_crd_install.exe"
    Start-Sleep -m 200
    Write-Host "Removing Adobe Reader Installer EXE file"
    Start-Sleep -m 500
    del "c:\Xuper\readerdc_uk_xa_crd_install.exe"
    Write-Host "Removed!"
    Start-Sleep -m 100

}


$ninitedownload = Read-Host "Download Ninite to install programs/runtimes(Java, .NET Framework, etc.)? (y/n)"
if ($ninitedownload -contains "y") {
    $url = "https://ninite.com/.net4.7.2-air-chrome-java8-silverlight/ninite.exe"
    $outpath = "c:\Xuper\Ninite.exe"
    mkdir "c:\Xuper\"
    Write-Host "Downloading Ninite..."
    Invoke-WebRequest -Uri $url -OutFile $outpath
    Write-Host "Finished Downloading Ninite!"
    Start-Sleep -m 500
    Write-Host "Opening Ninite"
    Start-Sleep -m 100
    start -Wait "c:\Xuper\Ninite.exe"
    Start-Sleep -m 200
    Write-Host "Removing Ninite/Runtime(s) Installer EXE file"
    Start-Sleep -m 500
    del "C:\Xuper\Ninite.exe"
    Write-Host "Removed!"
    Start-Sleep -m 100

}

$setdefaultapplications = Read-Host "Set Chrome and Adobe PDF as default? (y/n)"
if ($setdefaultapplications -contains "y") {

    #set Chrome as Default
	$chromePath = "${Env:ProgramFiles(x86)}\Google\Chrome\Application\" 
    $chromeApp = "chrome.exe"
    $chromeCommandArgs = "--make-default-browser"
    & "$chromePath$chromeApp" $chromeCommandArgs

    #set Adobe Reader as Default
	cmd assoc .pdf=AcrobatPDF
	cmd ftype AcrobatPDF="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" /u "%1"
	cmd ftype ChromeHTML="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -- "%1"
	cmd ftype acrobat="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" / u "%1"
	cmd ftype acrobat2018="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" /u "%1"
	cmd ftype AcroExch.acrobatsecuritysettings.1="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.Document="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.Document.DC="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.FDFDoc="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.pdfxml.1="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.XDPDoc="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
	cmd ftype AcroExch.XFDFDoc="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" "%1"
}

$restartmachine = Read-Host "Restart the Machine to Save Preferences (Y/N)"
if ($restartmachine -contains "y") {
    shutdown -r -f -t 10 -c "Script will shutdown your computer in 10 seconds" 
} 

