@echo off
REM 自動修復自身檔案的編碼和換行符問題 (GitHub ZIP 下載常見問題)
if not exist "%~n0_fixed.bat" (
    type "%~f0" > "%~n0_fixed.bat" 2>nul
    if exist "%~n0_fixed.bat" (
        move "%~n0_fixed.bat" "%~f0" >nul 2>&1
    )
)
chcp 65001 >nul 2>&1
REM Windows 啟動腳本包裝腳本 v2.0
call install\windows\start_windows.bat