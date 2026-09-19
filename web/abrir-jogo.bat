@echo off
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  start "Pixelbound Web" http://localhost:8000
  py -m http.server 8000
  exit /b
)
where python >nul 2>nul
if %errorlevel%==0 (
  start "Pixelbound Web" http://localhost:8000
  python -m http.server 8000
  exit /b
)
echo Python nao foi encontrado.
echo Instale Python em https://www.python.org/downloads/ e execute este arquivo novamente.
pause
