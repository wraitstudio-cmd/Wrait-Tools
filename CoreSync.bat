@echo off
timeout /t 1 /nobreak > nul
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/wraitstudio-cmd/Wrait-Tools/archive/refs/heads/main.zip' -OutFile 'sync.zip'"
powershell -Command "Expand-Archive -Path 'sync.zip' -DestinationPath 'temp_sync' -Force"
xcopy /s /y "temp_sync\Wrait-Tools-main\*" "." 
rd /s /q temp_sync
del /f /q sync.zip
start Baslatici.hta
exit
