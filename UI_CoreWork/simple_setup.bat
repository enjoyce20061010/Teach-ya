@echo off
REM UI CoreWork 超簡單安裝程式 - 只用最基本的命令
REM 專為什麼工具都沒有的系統設計

echo.
echo ===============================================
echo     🐤 UI CoreWork 超簡單安裝
echo     (保證什麼都不需要)
echo ===============================================
echo.
echo 這個程式只用 Windows 內建命令，
echo 不需要任何額外的工具或軟體。
echo.

echo 📋 檢查系統狀態...
echo 當前目錄: %CD%
ver
echo.

REM 檢查專案檔案
echo 檢查檔案是否存在...
if not exist "install_config.json" (
    echo ❌ 找不到設定檔案
    echo 請確認你在正確的資料夾
    pause
    exit /b 1
)

if not exist "backend\requirements.txt" (
    echo ❌ 找不到程式需求檔案
    pause
    exit /b 1
)
echo ✅ 檔案檢查通過
echo.

REM 檢查 Python
echo 🐍 檢查 Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有 Python
    echo.
    echo 🔗 請開啟瀏覽器下載 Python：
    echo    https://www.python.org/downloads/
    echo.
    echo 📋 安裝步驟：
    echo    1. 點擊 "Download Python 3.11.5"
    echo    2. 執行下載的 .exe 檔案
    echo    3. 安裝時勾選 "Add Python to PATH"
    echo    4. 安裝完成後，按任意鍵繼續
    echo.
    echo 🚀 正在開啟下載頁面...
    start https://www.python.org/downloads/
    echo.
    pause

    REM 重新檢查 Python
    python --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Python 仍然沒有安裝
        echo 請重新安裝，然後重新執行這個程式
        start https://www.python.org/downloads/
        pause
        exit /b 1
    )
) else (
    echo ✅ Python 已安裝
    python --version
)
echo.

REM 檢查網路
echo 🌐 檢查網路...
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo ⚠️  網路可能有問題，但繼續安裝
) else (
    echo ✅ 網路正常
)
echo.

REM 檢查空間
echo 💾 檢查磁碟空間...
for /f "tokens=3" %%a in ('dir /-c ^| find "bytes free"') do set FREE_BYTES=%%a
set /a FREE_MB=%FREE_BYTES%/1048576
echo 可用空間: %FREE_MB% MB

if %FREE_MB% lss 100 (
    echo ❌ 空間不足 (需要 100MB)
    pause
    exit /b 1
)
echo ✅ 空間充足
echo.

REM 建立環境
echo 🏠 建立程式環境...
if exist "venv" (
    echo 清理舊環境...
    rmdir /s /q venv 2>nul
)

echo 建立新環境...
python -m venv venv
if errorlevel 1 (
    echo ❌ 環境建立失敗
    pause
    exit /b 1
)
echo ✅ 環境建立成功
echo.

REM 啟動環境
echo 🔄 啟動環境...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 環境啟動失敗
    pause
    exit /b 1
)
echo ✅ 環境啟動成功
echo.

REM 安裝套件
echo 📦 安裝程式套件...
echo 這可能需要幾分鐘，請稍等...
pip install -r backend\requirements.txt --quiet
if errorlevel 1 (
    echo ❌ 套件安裝失敗，重試中...
    pip install -r backend\requirements.txt --timeout 300
    if errorlevel 1 (
        echo ❌ 安裝仍然失敗
        echo 請檢查網路連接後重試
        pause
        exit /b 1
    )
)
echo ✅ 套件安裝完成
echo.

REM 設定資料庫
echo 🗄️ 設定資料庫...
cd database
python init_db.py create >nul 2>&1
cd ..
echo ✅ 資料庫設定完成
echo.

REM 完成
echo 🎉 安裝完成！
echo.
echo 📂 程式地址: http://localhost:8000
echo 🚀 正在啟動程式...
echo.
timeout /t 3 /nobreak >nul
start http://localhost:8000
python backend/main.py

echo.
echo 程式已停止
pause


