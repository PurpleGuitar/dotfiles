rem get IP of Windows host
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set HostIP=%%a

rem Run client
docker run ^
       --rm ^
       --interactive ^
       --tty ^
       --hostname debian-dev ^
       --env DISPLAY=%HostIP%:0 ^
       --volume C:/:/mnt/host ^
       --volume %USERPROFILE%:/root/host-home ^
       debian-dev ^
       bash
