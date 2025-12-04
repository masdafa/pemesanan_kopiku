@echo off
REM 🚀 PUSH_TO_GITHUB.bat
REM Quick script untuk push Kopi Kang Dafa ke GitHub (Windows)

REM ⚠️  SEBELUM MENJALANKAN SCRIPT INI:
REM 1. Buat repository baru di https://github.com/new
REM 2. Copy repository URL
REM 3. Edit REPO_URL di bawah dengan URL Anda

setlocal enabledelayedexpansion

set REPO_URL=https://github.com/YOUR_USERNAME/pemesanan_kopiku.git
set PROJECT_NAME=Kopi Kang Dafa

echo 🚀 Starting push to GitHub for: %PROJECT_NAME%
echo.

REM Step 1: Verify git status
echo 📋 Checking git status...
git status
echo.

REM Step 2: Add remote if not exists
echo 🔗 Setting up remote repository...
git remote remove origin 2>nul
git remote add origin %REPO_URL%

REM Step 3: Rename branch to main (GitHub standard)
echo 🔄 Renaming branch to 'main'...
git branch -M main

REM Step 4: Push to GitHub
echo 📤 Pushing code to GitHub...
git push -u origin main

REM Step 5: Verify
echo.
echo ✅ Done! Check your repository at:
echo    %REPO_URL%
echo.
echo 🎉 Project '%PROJECT_NAME%' is now on GitHub!
echo.
pause
