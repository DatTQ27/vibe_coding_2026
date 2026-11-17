@echo off
cd /d "%~dp0"
echo MintClub: http://localhost:8600
py -m http.server 8600 --bind 127.0.0.1
pause
