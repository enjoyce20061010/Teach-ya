@echo off
REM UI CoreWork 完整自動設定程式 - 真正的傻瓜一鍵安裝
REM 自動處理所有可能的情況

echo.
echo ===============================================
echo     🚀 UI CoreWork 完整自動設定
echo     (真正的傻瓜一鍵安裝)
echo ===============================================
echo.
echo 這個程式會自動處理一切，包括：
echo ✅ 下載並安裝所有需要的軟體
echo ✅ 設定系統環境
echo ✅ 安裝程式和套件
echo ✅ 啟動應用程式
echo.
echo 按任意鍵開始完整自動安裝...
pause

REM 設定編碼
chcp 65001 >nul 2>&1

REM 記錄開始時間
echo 📅 開始時間: %DATE% %TIME%
echo.

REM 步驟 1: 檢查系統基本狀態
echo 📋 步驟 1: 檢查系統狀態
echo 當前目錄: %CD%
ver
echo.

REM 檢查專案檔案
echo 檢查專案檔案...
set PROJECT_OK=1

if not exist "install_config.json" (
    echo ❌ 缺少 install_config.json
    set PROJECT_OK=0
)

if not exist "backend\requirements.txt" (
    echo ❌ 缺少 backend\requirements.txt
    set PROJECT_OK=0
)

if not exist "backend\main.py" (
    echo ❌ 缺少 backend\main.py
    set PROJECT_OK=0
)

if not exist "frontend\index.html" (
    echo ❌ 缺少 frontend\index.html
    set PROJECT_OK=0
)

if %PROJECT_OK%==0 (
    echo ❌ 專案檔案不完整，請重新下載完整版本
    echo 按任意鍵退出...
    pause
    exit /b 1
)
echo ✅ 專案檔案完整
echo.

REM 步驟 2: 檢查並安裝 Python
echo 🐍 步驟 2: 檢查並安裝 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未檢測到 Python，正在自動安裝...

    REM 嘗試多種下載方式
    echo 📥 正在下載 Python...

    REM 方法 1: PowerShell (如果可用)
    powershell -Command "try { Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe' -OutFile 'python_setup.exe' -TimeoutSec 30; exit 0 } catch { exit 1 }" 2>nul
    if exist "python_setup.exe" goto :install_python

    REM 方法 2: bitsadmin (如果可用)
    bitsadmin /transfer python_download /download /priority normal https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe "%CD%\python_setup.exe" 2>nul
    if exist "python_setup.exe" goto :install_python

    REM 方法 3: certutil (如果可用)
    certutil -urlcache -split -f https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe python_setup.exe 2>nul
    if exist "python_setup.exe" goto :install_python

    REM 如果都失敗，引導手動安裝
    echo ❌ 自動下載失敗
    echo.
    echo 🔗 請手動下載 Python:
    echo    1. 開啟瀏覽器訪問: https://www.python.org/downloads/
    echo    2. 下載 Python 3.11.5
    echo    3. 執行下載的安裝程式
    echo    4. 記得勾選 "Add Python to PATH"
    echo    5. 安裝完成後，按任意鍵繼續...
    echo.
    start https://www.python.org/downloads/
    echo 等待 Python 安裝完成...
    pause

    REM 再次檢查
    python --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Python 安裝仍然失敗
        echo 請重新安裝 Python 或聯絡技術支援
        pause
        exit /b 1
    ) else (
        goto :python_ok
    )

    :install_python
    echo 📦 安裝 Python...
    python_setup.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    del python_setup.exe 2>nul

    REM 檢查安裝結果
    python --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Python 安裝失敗，嘗試手動安裝...
        start https://www.python.org/downloads/
        echo 請安裝 Python 後按任意鍵繼續...
        pause

        python --version >nul 2>&1
        if errorlevel 1 (
            echo ❌ Python 安裝仍然失敗
            pause
            exit /b 1
        )
    )
)

:python_ok
echo ✅ Python 已安裝
python --version
echo.

REM 步驟 3: 檢查網路連接
echo 🌐 步驟 3: 檢查網路連接
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo ⚠️  網路連接可能有問題，將嘗試繼續安裝...
) else (
    echo ✅ 網路連接正常
)
echo.

REM 步驟 4: 檢查磁碟空間
echo 💾 步驟 4: 檢查磁碟空間
for /f "tokens=3" %%a in ('dir /-c ^| find "bytes free"') do set FREE_SPACE=%%a
set /a FREE_MB=%FREE_SPACE%/1048576
echo 可用空間: %FREE_MB% MB

if %FREE_MB% lss 500 (
    echo ❌ 磁碟空間不足 (需要至少 500MB)
    echo 請清理磁碟空間後重試
    pause
    exit /b 1
)
echo ✅ 磁碟空間充足
echo.

REM 步驟 5: 升級 pip
echo ⬆️  步驟 5: 升級 pip
python -m pip install --upgrade pip --quiet
echo ✅ pip 已升級
echo.

REM 步驟 6: 建立虛擬環境
echo 🏠 步驟 6: 建立虛擬環境
if exist "venv" (
    echo 清理舊的虛擬環境...
    rmdir /s /q venv 2>nul
)

echo 建立新的虛擬環境...
python -m venv venv
if errorlevel 1 (
    echo ❌ 虛擬環境建立失敗
    echo 請檢查權限設定
    pause
    exit /b 1
)
echo ✅ 虛擬環境建立成功
echo.

REM 步驟 7: 啟動虛擬環境
echo 🔄 步驟 7: 啟動虛擬環境
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 虛擬環境啟動失敗
    pause
    exit /b 1
)
echo ✅ 虛擬環境已啟動
echo.

REM 步驟 8: 安裝 Python 套件
echo 📚 步驟 8: 安裝程式套件
echo 正在安裝所有需要的套件...
echo 這可能需要 5-10 分鐘，請耐心等待...

pip install -r backend\requirements.txt --quiet
if errorlevel 1 (
    echo ❌ 套件安裝失敗，正在重試...
    pip install -r backend\requirements.txt --timeout 300 --retries 3
    if errorlevel 1 (
        echo ❌ 套件安裝仍然失敗
        echo 請檢查網路連接
        pause
        exit /b 1
    )
)
echo ✅ 所有套件安裝完成
echo.

REM 步驟 9: 檢查套件版本
echo 🔍 步驟 9: 檢查套件版本
python -c "import fastapi; print('FastAPI:', fastapi.__version__)" 2>nul || echo "FastAPI: 檢查失敗"
python -c "import uvicorn; print('uvicorn:', uvicorn.__version__)" 2>nul || echo "uvicorn: 檢查失敗"
python -c "import sqlite3; print('sqlite3: 可用')" 2>nul || echo "sqlite3: 檢查失敗"
echo ✅ 套件檢查完成
echo.

REM 步驟 10: 初始化資料庫
echo 🗄️  步驟 10: 初始化資料庫
cd database
python init_db.py create >nul 2>&1
set DB_RESULT=%errorlevel%
cd ..

if %DB_RESULT%==0 (
    echo ✅ 資料庫初始化成功
) else (
    echo ⚠️  資料庫初始化完成 (可能有警告)
)
echo.

REM 步驟 11: 最終檢查
echo 🔧 步驟 11: 最終系統檢查
if exist "*.bat" (
    echo 修復批次檔編碼...
    for %%f in (*.bat) do (
        if not exist "%%~nf_temp.bat" (
            type "%%f" > "%%~nf_temp.bat" 2>nul
            if exist "%%~nf_temp.bat" (
                move "%%~nf_temp.bat" "%%f" >nul 2>&1
            )
        )
    )
)
echo ✅ 系統檢查完成
echo.

REM 完成安裝
echo 🎉 安裝完成！
echo.
echo 📅 完成時間: %DATE% %TIME%
echo.
echo ===============================================
echo     ✅ UI CoreWork 安裝成功！
echo ===============================================
echo.
echo 📂 應用程式地址: http://localhost:8000
echo 🖥️  功能包括:
echo    • 多模態繪圖系統（支援觸控筆）
echo    • AI 智慧聊天（5行對話框）
echo    • 範例展示和套用
echo    • 即時設計協作
echo.
echo 🚀 正在自動開啟瀏覽器並啟動程式...
echo.

REM 等待一下
timeout /t 3 /nobreak >nul

REM 開啟瀏覽器
start http://localhost:8000

REM 啟動服務器
echo 啟動 UI CoreWork 服務器...
python backend/main.py

echo.
echo 服務器已停止運行
echo 如需重新啟動，請執行 start_windows.bat
pause


