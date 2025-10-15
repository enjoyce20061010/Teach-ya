# UI CoreWork 安裝指南 - 小白專用

## 🚀 超簡單安裝方法

### 方法 1：一鍵安裝（推薦）
1. 從 GitHub 下載最新版本
2. 找到 `simple_setup.bat` 檔案
3. **雙擊執行**它
4. 跟著螢幕指示操作

### 方法 2：手動安裝（如果一鍵安裝有問題）

#### 步驟 1：安裝 Python
```
開啟瀏覽器，前往：https://www.python.org/downloads/
下載 Python 3.11.5
安裝時記得勾選 "Add Python to PATH"
```

#### 步驟 2：安裝程式
```
開啟命令提示字元，進入專案資料夾：
cd C:\path\to\UI_CoreWork

執行安裝：
python -m venv venv
venv\Scripts\activate.bat
pip install -r backend\requirements.txt
cd database
python init_db.py create
cd ..
python backend\main.py
```

#### 步驟 3：開啟程式
```
在瀏覽器中開啟：http://localhost:8000
```

## ❓ 常見問題

### Q：為什麼要安裝 Python？
A：這個程式是用 Python 寫的，需要 Python 環境才能運行。

### Q：安裝時出現錯誤怎麼辦？
A：請檢查網路連接，確保有至少 500MB 可用空間。

### Q：程式跑不起來？
A：請確認 Python 已正確安裝，並且在 PATH 中。

## 📞 技術支援

如果安裝仍然有問題，請提供：
- Windows 版本
- 錯誤訊息截圖
- 你的操作步驟

## 🎯 功能介紹

安裝完成後，你可以：
- 🎨 繪圖創作
- 🤖 AI 智慧聊天
- 📱 設計協作
- 🔧 自訂設定


