@echo off
REM UI CoreWork 基礎安裝程式 - 給完全小白的版本
REM 這個版本只做最基本的事情

echo.
echo ===============================================
echo     🐢 UI CoreWork 小白安裝程式
echo ===============================================
echo.
echo 這個程式會一步步告訴你該做什麼
echo.

echo 步驟 1: 檢查我們在正確的目錄
echo 當前目錄: %CD%
echo.
echo 如果上面顯示的是你的 UI_CoreWork 資料夾，按任意鍵繼續...
pause

echo.
echo 步驟 2: 檢查檔案是否存在
if exist "install_config.json" (
    echo ✅ 找到設定檔案
) else (
    echo ❌ 找不到設定檔案
    echo 請確認你在 UI_CoreWork 資料夾裡
    pause
    exit /b 1
)

if exist "backend\requirements.txt" (
    echo ✅ 找到程式檔案
) else (
    echo ❌ 找不到程式檔案
    echo 專案可能不完整
    pause
    exit /b 1
)

echo.
echo 步驟 3: 檢查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有找到 Python
    echo.
    echo 請手動下載並安裝 Python:
    echo 1. 開啟瀏覽器
    echo 2. 去 https://www.python.org/downloads/
    echo 3. 下載 Python 3.11.5
    echo 4. 安裝時記得勾選 "Add Python to PATH"
    echo 5. 安裝完成後，重新執行這個程式
    echo.
    start https://www.python.org/downloads/
    pause
    exit /b 1
) else (
    echo ✅ Python 已安裝
    python --version
)

echo.
echo 步驟 4: 建立程式環境
echo 正在建立虛擬環境...
if not exist "venv" (
    python -m venv venv
    if errorlevel 1 (
        echo ❌ 建立環境失敗
        pause
        exit /b 1
    )
)

echo.
echo 步驟 5: 啟動環境並安裝程式
echo 正在啟動環境...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 啟動環境失敗
    pause
    exit /b 1
)

echo 正在安裝需要的程式庫...
pip install -r backend\requirements.txt
if errorlevel 1 (
    echo ❌ 安裝程式庫失敗
    echo 請檢查網路連接
    pause
    exit /b 1
)

echo.
echo 步驟 6: 設定資料庫
echo 正在設定資料庫...
cd database
python init_db.py create
cd ..
if errorlevel 1 (
    echo ⚠️ 資料庫設定可能有問題，但繼續執行
)

echo.
echo 🎉 安裝完成！
echo.
echo 現在可以啟動程式了
echo 按任意鍵啟動 UI CoreWork...
pause

echo 🚀 啟動 UI CoreWork...
echo 程式將在 http://localhost:8000 運行
echo 請在瀏覽器中開啟這個網址
echo.
timeout /t 3 /nobreak >nul
start http://localhost:8000
python backend/main.py

echo.
echo 程式已停止運行
pause


