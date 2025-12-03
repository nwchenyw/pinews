@echo off
REM Setup script for PiNews Demo Mode (Windows)
REM This script copies static files to wwwroot directory

echo Setting up PiNews static files...
echo.

REM Create wwwroot if it doesn't exist
if not exist wwwroot mkdir wwwroot

REM Copy static files
echo Copying CSS files...
xcopy /E /I /Y css wwwroot\css

echo Copying images...
xcopy /E /I /Y img wwwroot\img

echo Copying Semantic UI...
xcopy /E /I /Y semantic wwwroot\semantic

echo.
echo Static files copied successfully!
echo.
echo You can now run the application with:
echo   dotnet run
echo.
echo Then open http://localhost:5000 in your browser
pause
