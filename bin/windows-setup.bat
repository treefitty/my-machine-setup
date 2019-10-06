

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n=allowGlobalConfirmation

choco install cmder
choco install office365business
choco install gimp
choco install dotnetcore-sdk
choco install adobereader
choco install 7zip.install
choco install git.install
choco install openssh
choco install sysinternals
choco install jdk8
choco install vscode
choco install virtualbox
choco install steam
choco install slack
choco install spotify




