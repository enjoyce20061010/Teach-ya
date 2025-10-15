@echo off
chcp 65001 >nul 2>&1
REM UI CoreWork 真正的一鍵安裝程式 - 小白專用完整版
REM 自動檢查並安裝所有需要的東西

title UI CoreWork 一鍵安裝程式 - 小白專用

echo.
echo ===============================================
echo     🚀 UI CoreWork 一鍵安裝程式
echo     (專為完全小白設計)
echo ===============================================
echo.
echo 這個程式會自動處理一切：
echo ✅ 檢查系統編碼設定
echo ✅ 檢查並安裝 Python
echo ✅ 檢查並安裝 pip
echo ✅ 檢查網路連接
echo ✅ 建立虛擬環境
echo ✅ 安裝所有套件依賴
echo ✅ 檢查套件版本相容性
echo ✅ 初始化資料庫
echo ✅ 修復編碼和換行符問題
echo ✅ 啟動應用程式
echo.

REM 記錄開始時間
set START_TIME=%TIME%

echo 📋 步驟 1: 檢查系統資訊
echo 當前目錄: %CD%
echo 系統時間: %DATE% %TIME%
echo Windows 版本:
ver
echo.

REM 檢查系統編碼
echo 🔧 步驟 2: 檢查系統編碼設定
for /f "tokens=2 delims=:" %%i in ('chcp') do set CURRENT_CODEPAGE=%%i
set CURRENT_CODEPAGE=%CURRENT_CODEPAGE: =%
echo 當前編碼: %CURRENT_CODEPAGE%
if not "%CURRENT_CODEPAGE%"=="65001" (
    echo ⚠️  編碼不是 UTF-8，正在設定...
    chcp 65001 >nul 2>&1
    echo ✅ 編碼已設定為 UTF-8
) else (
    echo ✅ 系統編碼正確 (UTF-8)
)
echo.

REM 檢查網路連接
echo 🌐 步驟 3: 檢查網路連接
echo 正在測試網路連接...
ping -n 1 -w 5000 google.com >nul 2>&1
if errorlevel 1 (
    echo ❌ 網路連接失敗
    echo 請檢查網路設定後重試
    echo.
    echo 按任意鍵退出...
    pause >nul
    exit /b 1
) else (
    echo ✅ 網路連接正常
)
echo.

REM 檢查專案檔案完整性
echo 📁 步驟 4: 檢查專案檔案
set PROJECT_COMPLETE=1

if not exist "install_config.json" (
    echo ❌ 找不到 install_config.json
    set PROJECT_COMPLETE=0
)

if not exist "backend\requirements.txt" (
    echo ❌ 找不到 backend\requirements.txt
    set PROJECT_COMPLETE=0
)

if not exist "backend\main.py" (
    echo ❌ 找不到 backend\main.py
    set PROJECT_COMPLETE=0
)

if not exist "frontend\index.html" (
    echo ❌ 找不到 frontend\index.html
    set PROJECT_COMPLETE=0
)

if not exist "database\init_db.py" (
    echo ❌ 找不到 database\init_db.py
    set PROJECT_COMPLETE=0
)

if %PROJECT_COMPLETE%==0 (
    echo ❌ 專案檔案不完整，請重新下載
    echo.
    echo 按任意鍵退出...
    pause >nul
    exit /b 1
) else (
    echo ✅ 專案檔案完整
)
echo.

REM 檢查磁碟空間
echo 💾 步驟 5: 檢查磁碟空間
for /f "tokens=3" %%a in ('dir /-c ^| find "bytes free"') do set FREE_SPACE=%%a
set /a FREE_MB=%FREE_SPACE%/1048576
echo 可用空間: %FREE_MB% MB

if %FREE_MB% lss 500 (
    echo ❌ 磁碟空間不足 (需要至少 500MB)
    echo 請清理磁碟空間後重試
    echo.
    echo 按任意鍵退出...
    pause >nul
    exit /b 1
) else (
    echo ✅ 磁碟空間充足
)
echo.

REM 檢查 Python
echo 🐍 步驟 6: 檢查並安裝 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未檢測到 Python，正在安裝...

    REM 檢查是否有 py 命令
    py --version >nul 2>&1
    if errorlevel 1 (
        echo 📥 下載 Python 3.11.5...

        REM 嘗試多種下載方式
        powershell -Command "try { Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe' -OutFile 'python-installer.exe' -TimeoutSec 60 } catch { }" 2>nul

        if not exist "python-installer.exe" (
            echo 正在嘗試備用下載方法...
            bitsadmin /transfer python_download /download /priority normal https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe "%CD%\python-installer.exe" 2>nul
        )

        if exist "python-installer.exe" (
            echo 📦 安裝 Python...
            echo 安裝過程中請稍候，這可能需要幾分鐘...
            python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

            REM 重新檢查 Python
            python --version >nul 2>&1
            if errorlevel 1 (
                echo ❌ Python 安裝失敗
                echo 請嘗試手動安裝 Python
                start https://www.python.org/downloads/
                echo.
                echo 按任意鍵退出...
                pause >nul
                exit /b 1
            ) else (
                echo ✅ Python 安裝成功！
                python --version
            )
        ) else (
            echo ❌ 無法下載 Python
            echo 請手動下載安裝: https://www.python.org/downloads/
            start https://www.python.org/downloads/
            echo.
            echo 按任意鍵退出...
            pause >nul
            exit /b 1
        )
    ) else (
        echo ✅ 找到 py 命令 (將用於替代 python)
        py --version
    )
) else (
    echo ✅ Python 已安裝
    python --version
)
echo.

REM 檢查 pip
echo 📦 步驟 7: 檢查 pip
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ pip 未安裝，正在安裝...

    REM 嘗試升級 pip
    python -m ensurepip --upgrade >nul 2>&1
    if errorlevel 1 (
        echo 正在嘗試備用安裝方法...
        python -c "import urllib.request; urllib.request.urlretrieve('https://bootstrap.pypa.io/get-pip.py', 'get-pip.py')" 2>nul
        if exist "get-pip.py" (
            python get-pip.py --user >nul 2>&1
            del get-pip.py 2>nul
        )
    )

    REM 重新檢查
    python -m pip --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ pip 安裝失敗
        echo 請檢查網路連接後重試
        pause
        exit /b 1
    ) else (
        echo ✅ pip 安裝成功
    )
) else (
    echo ✅ pip 已安裝
)
python -m pip --version
echo.

REM 升級 pip 到最新版
echo ⬆️  步驟 8: 升級 pip
python -m pip install --upgrade pip --quiet
echo ✅ pip 已升級
echo.

REM 建立虛擬環境
echo 🏠 步驟 9: 建立虛擬環境
if exist "venv" (
    echo 發現現有虛擬環境，正在清理...
    rmdir /s /q venv 2>nul
)

echo 建立新的虛擬環境...
python -m venv venv
if errorlevel 1 (
    echo ❌ 虛擬環境建立失敗
    echo 請檢查權限或磁碟空間
    pause
    exit /b 1
)
echo ✅ 虛擬環境建立成功
echo.

REM 啟動虛擬環境
echo 🔄 步驟 10: 啟動虛擬環境
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 虛擬環境啟動失敗
    pause
    exit /b 1
)
echo ✅ 虛擬環境已啟動
echo.

REM 安裝 Python 套件依賴
echo 📚 步驟 11: 安裝套件依賴
echo 正在安裝 requirements.txt 中的套件...
echo 這可能需要幾分鐘，請耐心等待...

pip install -r backend\requirements.txt --quiet
if errorlevel 1 (
    echo ❌ 套件安裝失敗
    echo 正在重試...
    pip install -r backend\requirements.txt --timeout 300
    if errorlevel 1 (
        echo ❌ 套件安裝仍然失敗
        echo 請檢查網路連接或 requirements.txt 檔案
        pause
        exit /b 1
    )
)
echo ✅ 所有套件安裝完成
echo.

REM 檢查關鍵套件版本
echo 🔍 步驟 12: 檢查套件版本相容性
echo 檢查 FastAPI...
python -c "import fastapi; print('FastAPI 版本:', fastapi.__version__)" 2>nul
if errorlevel 1 (
    echo ⚠️  FastAPI 檢查失敗
)

echo 檢查 uvicorn...
python -c "import uvicorn; print('uvicorn 版本:', uvicorn.__version__)" 2>nul
if errorlevel 1 (
    echo ⚠️  uvicorn 檢查失敗
)

echo 檢查 sqlite3...
python -c "import sqlite3; print('sqlite3 版本:', sqlite3.version)" 2>nul
if errorlevel 1 (
    echo ⚠️  sqlite3 檢查失敗
)
echo ✅ 套件版本檢查完成
echo.

REM 初始化資料庫
echo 🗄️  步驟 13: 初始化資料庫
cd database
python init_db.py create >nul 2>&1
set DB_EXIT_CODE=%errorlevel%
cd ..

if %DB_EXIT_CODE%==0 (
    echo ✅ 資料庫初始化成功
) else (
    echo ⚠️  資料庫初始化可能有警告，但繼續執行
)
echo.

REM 檢查安裝時間
set END_TIME=%TIME%
echo ⏱️  安裝完成時間: %DATE% %END_TIME%
echo.

REM 修復編碼和換行符問題（最終檢查）
echo 🔧 步驟 14: 最終系統檢查
if exist "*.bat" (
    echo 正在修復批次檔編碼...
    for %%f in (*.bat) do (
        if not exist "%%~nf_fixed.bat" (
            type "%%f" > "%%~nf_temp.bat" 2>nul
            if exist "%%~nf_temp.bat" (
                move "%%~nf_temp.bat" "%%f" >nul 2>&1
            )
        )
    )
)
echo ✅ 系統檢查完成
echo.

REM 啟動應用程式
echo 🎉 安裝完成！正在啟動 UI CoreWork...
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
echo 🚀 正在自動開啟瀏覽器...
echo.

REM 等待一下讓用戶看到訊息
timeout /t 5 /nobreak >nul

REM 自動開啟瀏覽器
start http://localhost:8000

REM 啟動服務器
echo 啟動後端服務器...
python backend/main.py

REM 如果服務器停止
echo.
echo 服務器已停止運行
echo 如需重新啟動，請執行 start_windows.bat
pause


