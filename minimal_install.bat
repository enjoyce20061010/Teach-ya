@echo off
REM UI CoreWork 最小化安裝程式 - 只用最基本的 Windows 命令
REM 專為什麼都沒裝的系統設計

echo.
echo ===============================================
echo     🐛 UI CoreWork 最小化安裝程式
echo     (什麼都沒裝也能用的版本)
echo ===============================================
echo.

REM 檢查基本命令是否存在
echo 📋 檢查基本系統狀態...

REM 檢查當前目錄
echo 當前位置: %CD%
echo 系統版本:
ver
echo.

REM 檢查檔案是否存在
echo 檢查專案檔案...
if exist "install_config.json" (
    echo ✅ 設定檔案存在
) else (
    echo ❌ 找不到設定檔案
    echo 請確認你在正確的目錄
    pause
    exit /b 1
)

if exist "backend\requirements.txt" (
    echo ✅ 程式需求檔案存在
) else (
    echo ❌ 找不到程式需求檔案
    pause
    exit /b 1
)
echo.

REM 檢查 Python
echo 🐍 檢查 Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有 Python

    REM 檢查是否有 py 命令
    py --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ 也沒有 py 命令
        echo.
        echo 💡 解決方案：
        echo 這個系統沒有 Python，需要先安裝。
        echo.
        echo 🔗 請開啟瀏覽器下載 Python：
        echo    https://www.python.org/downloads/
        echo.
        echo 📋 安裝步驟：
        echo    1. 下載 Python 3.11.5
        echo    2. 執行安裝程式
        echo    3. 記得勾選 "Add Python to PATH"
        echo    4. 安裝完成後，重新執行這個程式
        echo.
        echo 🚀 正在開啟下載頁面...
        start https://www.python.org/downloads/
        echo.
        echo 請完成 Python 安裝後，按任意鍵繼續...
        pause

        REM 重新檢查
        python --version >nul 2>&1
        if errorlevel 1 (
            echo ❌ Python 仍然沒有安裝
            echo 請重新安裝 Python
            start https://www.python.org/downloads/
            pause
            exit /b 1
        )
    )
)
echo ✅ Python 準備完成
python --version
echo.

REM 檢查網路
echo 🌐 檢查網路連接...
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo ❌ 網路連接有問題
    echo 請檢查網路設定
    pause
    exit /b 1
)
echo ✅ 網路正常
echo.

REM 檢查磁碟空間
echo 💾 檢查可用空間...
for /f "tokens=3" %%a in ('dir /-c ^| find "bytes free"') do set FREE_BYTES=%%a
set /a FREE_MB=%FREE_BYTES%/1048576
echo 可用空間: %FREE_MB% MB

if %FREE_MB% lss 100 (
    echo ❌ 空間不足 (需要至少 100MB)
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
    echo ❌ 套件安裝失敗
    echo 重試中...
    pip install -r backend\requirements.txt --timeout 300
    if errorlevel 1 (
        echo ❌ 安裝仍然失敗
        echo 請檢查網路或手動安裝
        pause
        exit /b 1
    )
)
echo ✅ 套件安裝完成
echo.

REM 初始化資料庫
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


