@echo off
REM UI CoreWork 安裝指南程式
REM 提供完整的安裝指示

echo.
echo ===============================================
echo     📚 UI CoreWork 安裝指南
echo ===============================================
echo.
echo 這個程式會告訴你如何安裝 UI CoreWork
echo 不會自動安裝任何東西，只提供指示
echo.

echo 📋 檢查你的系統...
echo 當前目錄: %CD%
ver
echo.

REM 檢查檔案
echo 檢查檔案是否存在...
if not exist "install_config.json" (
    echo ❌ 錯誤：找不到 install_config.json
    echo 請確認你在 UI_CoreWork 資料夾裡
    echo.
    echo 按任意鍵退出...
    pause >nul
    exit /b 1
)
echo ✅ 檔案檢查通過
echo.

echo 🐍 安裝 Python 的方法：
echo.
echo 方法 1：線上安裝（推薦）
echo ------------------
echo 1. 按 Win + R 開啟執行
echo 2. 輸入: msedge https://www.python.org/downloads/
echo 3. 下載 Python 3.11.5
echo 4. 執行安裝程式
echo 5. 安裝時勾選 "Add Python to PATH"
echo 6. 安裝完成後，重新執行這個程式
echo.

echo 方法 2：離線安裝（如果你沒有網路）
echo ------------------
echo 1. 在另一台有網路的電腦上下載 Python
echo 2. 複製安裝檔案到這台電腦
echo 3. 執行 python-3.11.5-amd64.exe
echo 4. 安裝時勾選 "Add Python to PATH"
echo.

echo 📦 安裝程式套件的方法：
echo.
echo 1. 確保 Python 已安裝
echo 2. 開啟命令提示字元
echo 3. 進入這個資料夾
echo 4. 執行以下命令：
echo.
echo    python -m venv venv
echo    venv\Scripts\activate.bat
echo    pip install -r backend\requirements.txt
echo    cd database
echo    python init_db.py create
echo    cd ..
echo    python backend\main.py
echo.

echo 🌐 開啟程式的步驟：
echo.
echo 1. 安裝完成後
echo 2. 開啟瀏覽器
echo 3. 前往: http://localhost:8000
echo.

echo ❓ 如果遇到問題：
echo.
echo 1. 檢查網路連接
echo 2. 確保有至少 500MB 空間
echo 3. 確認 Python 在 PATH 中
echo 4. 重新啟動命令提示字元
echo.

echo 🎯 程式功能：
echo • 繪圖創作系統
echo • AI 智慧聊天
echo • 設計協作工具
echo • 即時預覽功能
echo.

echo 📞 需要幫助？
echo 請截圖錯誤訊息，並說明你的 Windows 版本
echo.

echo 按任意鍵開始 Python 安裝...
pause

REM 嘗試開啟瀏覽器
echo 正在開啟 Python 下載頁面...
start https://www.python.org/downloads/ 2>nul
if errorlevel 1 (
    echo 如果瀏覽器沒有開啟，請手動開啟：
    echo https://www.python.org/downloads/
)

echo.
echo 安裝完成 Python 後，請重新執行這個程式
echo 或者執行 simple_setup.bat 繼續安裝
echo.
pause


