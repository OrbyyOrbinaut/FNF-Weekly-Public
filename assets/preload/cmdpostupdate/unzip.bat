@echo off
cd %~dp0
cd ..
cd ..
echo Unziping... IGNORE ERRORS AND WAIT
tar.exe -xf FNF.Weekly.zip
DEL FNF.Weekly.zip
echo Now Open Your Game
pause
exit
