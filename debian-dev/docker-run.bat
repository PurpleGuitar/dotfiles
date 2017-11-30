@echo off

rem If you'd like to share dotfiles between the host and client, then set
rem the environment variable DOTFILES_LOC to point to the host directory
rem where they live.
rem 
rem Or if you'd prefer the client keeps its own private copy of the
rem dotfiles, then create a volume and set DOTFILES_LOC to the name of the
rem volume.
rem
rem If you'd prefer not to set an environment variable at all, you can
rem uncomment the next line and set it in this script.
rem DOTFILES_LOC=docker-dotfiles-volume

rem get IP of Windows host
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set HostIP=%%a

rem Run client
docker run ^
       --rm ^
       --interactive ^
       --tty ^
       --hostname debian-dev ^
       --env DISPLAY=%HostIP%:0 ^
       --volume %DOTFILES_LOC%:/root/dotfiles ^
       --volume C:/:/mnt/host ^
       --volume %USERPROFILE%:/root/host-home ^
       debian-dev ^
       bash %*
