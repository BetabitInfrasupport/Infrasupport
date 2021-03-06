# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $MyInvocation.MyCommand.Definition
  Exit
}
}

# Ask what software needs to be installed
$software = @{
       "7Zip"                         = "7zip.7zip";
       ".Net"                         = "Microsoft.dotnet";
       "Azure CLI"                    = "Microsoft.AzureCLI";
       "Azure Storage Explorer"       = "Microsoft.AzureStorageExplorer";
       "Chrome"                       = "Google.Chrome";
       "Docker"                       = "Docker.DockerDesktop";
       "Fiddler"                      = "Telerik.Fiddler";
       "Filezilla"                    = "TimKosse.FilezillaClient";
       "Foxit Reader"                 = "Foxit.FoxitReader";
       "FontBase"                     = "FontBase.FontBase";
       "GIMP"                         = "GIMP.GIMP";
       "Git"                          = "Git.Git";
       "Inkscape"                     = "Inkscape.Inkscape";
       "NodeJS"                       = "OpenJS.NodeJS";
       "Notepad++"                    = "Notepad++.Notepad++";
       "OpenSLL Light"                = "ShiningLight.OpenSSLLight";
       "OBS Studio"                   = "OBSProject.OBSStudio";
       "Postman"                      = "Postman.Postman";
       "PuTTY"                        = "PuTTY.PuTTY";
       "SQL Server Management Studio" = "Microsoft.SQLServerManagementStudio";
       "Slack"                        = "SlackTechnologies.Slack";
       "Sourcetree"                   = "Atlassian.Sourcetree";
       "Teams"                        = "Microsoft.Teams";
       "Telegram"                     = "Telegram.TelegramDesktop";
       "Terminal"                     = "Microsoft.WindowsTerminal";
       "Visual Studio Code"           = "Microsoft.VisualStudioCode";
       "Visual Studio Enterprise"     = "Microsoft.VisualStudio.Enterprise";
       "WhatsApp"                     = "WhatsApp.WhatsApp";
       "WinSCP"                       = "WinSCP.WinSCP";
       "WSL with Ubuntu"              = "Canonical.Ubuntu";
} | Out-GridView -Title "Select applications to install" -PassThru

#install winget if it's not available yet
#todo : default to latest version
if ((Get-AppxPackage -Name Microsoft.DesktopAppInstaller) -eq $null) {
       Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.0.11451/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle" -OutFile ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
       Add-AppxPackage -Path ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
       Remove-Item -path ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
}

#install selected programs
Foreach($program in $software) {
       "installing "+$program.name
       winget install -e --id $program.value
       #todo : program-specific configuration
}

#todo : install windows features like WSL, virtualization
#todo : set WSL2 as default
#todo : configure code
#todo : install fonts 
