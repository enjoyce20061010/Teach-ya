@echo off
REM UI CoreWork 簡單一鍵安裝腳本 - 經過測試的穩定版本
REM 直接步驟執行，無需複雜配置

chcp 65001 >nul 2>&1
title UI CoreWork 簡單安裝程式

echo.
echo ===============================================
echo     🚀 UI CoreWork 簡單一鍵安裝
echo ===============================================
echo.
echo 此腳本將執行以下步驟：
echo 1. 檢查網路連接
echo 2. 下載並安裝 Python 3.11.5
echo 3. 建立虛擬環境
echo 4. 安裝專案依賴
echo 5. 初始化資料庫
echo 6. 建立桌面捷徑
echo 7. 啟動應用程式
echo.
echo 按任意鍵開始安裝...
pause >nul
echo.

REM 步驟 1: 檢查網路
echo 📋 步驟 1/7: 檢查網路連接...
ping -n 1 google.com >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ 網路連接失敗
    echo 💡 請檢查網路設定後重試
    echo.
    echo 🔗 如果無法上網，請手動下載：
    echo    https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe
    echo    並放置到此目錄，命名為 python-installer.exe
    echo.
    goto :error
)
echo ✅ 網路連接正常
echo.

REM 步驟 2: 下載 Python
echo 📋 步驟 2/7: 下載 Python 3.11.5...
if exist "python-installer.exe" (
    echo ℹ️  Python 安裝程式已存在，跳過下載
) else (
    echo 📥 正在下載 Python (使用 bitsadmin)...
    bitsadmin /transfer "PythonDownload" /download /priority normal "https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe" "%CD%\python-installer.exe"
    if %errorLevel% neq 0 (
        echo ❌ Python 下載失敗
        echo.
        echo 💡 請手動下載：
        echo    1. 開啟瀏覽器訪問：
        echo       https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe
        echo    2. 下載並儲存為 python-installer.exe
        echo    3. 重新運行此安裝腳本
        echo.
        goto :error
    )
)
echo ✅ Python 下載完成
echo.

REM 步驟 3: 安裝 Python
echo 📋 步驟 3/7: 安裝 Python...
python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_launcher=1
if %errorLevel% neq 0 (
    echo ❌ Python 安裝失敗
    goto :error
)

REM 等待安裝完成並重新載入環境
timeout /t 10 /nobreak >nul
call refreshenv.cmd 2>nul || (
    REM 如果 refreshenv 不可用，手動設定 PATH
    set "PATH=%PATH%;C:\Python311\;C:\Python311\Scripts\"
)

REM 驗證 Python
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ Python 安裝驗證失敗
    goto :error
)
echo ✅ Python 安裝成功
echo.

REM 步驟 4: 建立虛擬環境
echo 📋 步驟 4/7: 建立虛擬環境...
python -m venv venv
if %errorLevel% neq 0 (
    echo ❌ 虛擬環境建立失敗
    goto :error
)
echo ✅ 虛擬環境建立完成
echo.

REM 步驟 5: 安裝依賴
echo 📋 步驟 5/7: 安裝專案依賴...
call venv\Scripts\activate.bat
if %errorLevel% neq 0 (
    echo ❌ 虛擬環境啟動失敗
    goto :error
)

pip install --upgrade pip --quiet
pip install -r backend\requirements.txt --quiet
if %errorLevel% neq 0 (
    echo ❌ 依賴安裝失敗
    goto :error
)
echo ✅ 專案依賴安裝完成
echo.

REM 步驟 6: 初始化資料庫
echo 📋 步驟 6/7: 初始化資料庫...
if not exist "database" (
    echo ❌ 找不到 database 目錄
    goto :error
)
cd database
python init_db.py create
if %errorLevel% neq 0 (
    echo ❌ 資料庫初始化失敗
    cd ..
    goto :error
)
cd ..
echo ✅ 資料庫初始化完成
echo.

REM 步驟 7: 建立捷徑
echo 📋 步驟 7/7: 建立桌面捷徑...
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = oWS.ExpandEnvironmentStrings("%%USERPROFILE%%\Desktop\UI CoreWork.lnk") >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%CD%\start_windows.bat" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%CD%" >> CreateShortcut.vbs
echo oLink.Description = "UI CoreWork - 智慧設計協作平台" >> CreateShortcut.vbs
echo oLink.IconLocation = "%CD%\assets\images\favicon.ico" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs >nul 2>&1
del CreateShortcut.vbs >nul 2>&1
echo ✅ 桌面捷徑建立完成
echo.

REM 安裝完成
echo ===============================================
echo         🎉 安裝完成！
echo ===============================================
echo.
echo ✅ 所有步驟都成功完成
echo.
echo 📂 應用程式已準備就緒
echo 🔗 服務器地址: http://localhost:8000
echo 📁 桌面捷徑: UI CoreWork.lnk
echo.
echo 🚀 正在啟動應用程式...
echo.

REM 延遲開啟瀏覽器
timeout /t 3 /nobreak >nul
start http://localhost:8000

REM 啟動服務器
python backend/main.py

goto :end

:error
echo.
echo ===============================================
echo         ❌ 安裝失敗
echo ===============================================
echo.
echo 💡 請檢查上述錯誤訊息
echo 🔧 常見解決方案：
echo    • 確認網路連接正常
echo    • 以管理員權限運行
echo    • 檢查磁碟空間（需要至少 500MB）
echo    • 關閉防毒軟體
echo.
pause
exit /b 1

:end
