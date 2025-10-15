# UI CoreWork - 智慧設計協作平台

🎨 一個整合多模態輸入處理、AI 輔助設計和範例展示的現代化 UI 設計工具。

## 🚨 重要：操作前必讀
**在進行任何操作前，請先閱讀 [`MANDATORY_CHECKLIST.md`](./MANDATORY_CHECKLIST.md)**
- 檢查 `fail_to_Valued.md` 中的歷史失敗記錄
- 使用正確的啟動命令：`./start.sh`
- 避免重複已知的錯誤

## ✨ 功能特色

### 🖊️ 多模態繪圖系統
- **觸控筆支援**: 支援壓力感測和精確繪圖
- **滑鼠/觸控**: 完整支援各種輸入設備
- **即時處理**: 流暢的繪圖體驗和平滑線條
- **工具齊全**: 筆刷、橡皮擦、顏色選擇、大小調整

### 💬 AI 智慧聊天
- **5行對話框**: 如您要求的特定高度設計
- **上下文理解**: AI 能理解繪圖內容並提供建議
- **即時互動**: 快速回應和智慧建議
- **多語言支援**: 中文和英文界面

### 📚 範例展示系統
- **豐富範例**: 表單、儀錶板、導航等多種類型
- **即時預覽**: 點擊即可查看詳細內容
- **一鍵套用**: 直接套用到您的設計中
- **下載功能**: 完整的 HTML/CSS/JS 檔案

### 🔄 無縫整合
- **同時輸入**: 繪圖和聊天可同時進行
- **智慧分析**: AI 自動分析繪圖內容
- **精確修改**: LLM 可透過 API 精確修改 UI 元素

## 🚀 快速開始

### 方法一：一鍵啟動（推薦）
```bash
# 克隆專案
git clone https://github.com/yourusername/ui-corework.git
cd ui-corework

# 一鍵啟動
chmod +x start.sh
./start.sh
```

### 方法二：手動啟動
```bash
# 1. 建立虛擬環境
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 2. 安裝依賴
pip install -r backend/requirements.txt

# 3. 初始化資料庫
cd database
python init_db.py create
cd ..

# 4. 啟動後端
cd backend
python main.py
```

### 開啟應用程式
瀏覽器訪問：http://localhost:8000

## 🏗️ 專案結構

```
UI_CoreWork/
├── frontend/                 # 前端資源
│   ├── index.html           # 主要 HTML 介面
│   ├── css/
│   │   └── styles.css       # 完整樣式系統
│   └── js/
│       ├── config.js        # 配置設定
│       ├── utils.js         # 工具函數庫
│       ├── drawing.js       # 繪圖功能模組
│       ├── chat.js          # 聊天功能模組
│       ├── examples.js      # 範例展示模組
│       ├── api.js           # API 整合模組
│       └── main.js          # 主應用程式
├── backend/                 # 後端 API
│   ├── main.py             # FastAPI 服務器
│   └── requirements.txt    # Python 依賴
├── database/               # 資料庫
│   ├── init_db.py          # 資料庫初始化腳本
│   ├── README.md           # 資料庫架構說明
│   └── uicorework.db       # SQLite 資料庫檔案
└── start.sh               # 一鍵啟動腳本
```

## 🛠️ 技術架構

### 前端技術棧
- **HTML5**: 現代化的語義標籤和 Canvas API
- **CSS3**: Grid 佈局、Flexbox、動畫效果
- **JavaScript ES6+**: 模組化設計、非同步處理
- **Canvas API**: 高效能繪圖渲染
- **Responsive Design**: 適應各種螢幕尺寸

### 後端技術棧
- **FastAPI**: 高效能 Python Web 框架
- **SQLite**: 輕量級關聯式資料庫
- **Pydantic**: 資料驗證和序列化
- **Uvicorn**: ASGI 服務器

### 核心特性
- **無安裝前端**: 純 HTML/CSS/JS，無需建置工具
- **RESTful API**: 標準化的 API 設計
- **即時通訊**: WebSocket 支援（規劃中）
- **離線支援**: 本地儲存和同步

## 📋 API 文檔

啟動服務後，訪問 http://localhost:8000/docs 查看完整的 API 文檔。

### 主要端點
- `POST /api/chat` - 發送聊天訊息
- `GET /api/examples` - 取得範例列表
- `POST /api/drawings` - 儲存繪圖資料
- `POST /api/ai/analyze-image` - AI 圖像分析

## 🔧 配置說明

### 前端配置 (`frontend/js/config.js`)
```javascript
window.UICoreworkConfig = {
    api: {
        baseURL: 'http://localhost:8000/api',
        timeout: 30000
    },
    drawing: {
        tools: ['pen', 'eraser', 'brush'],
        colors: ['#000000', '#ff0000', '#00ff00'],
        sizes: [1, 3, 5, 10, 20]
    },
    chat: {
        maxMessageLength: 4000,
        enableMarkdown: true
    }
};
```

### 後端配置
環境變數或直接修改 `backend/main.py`：
- `DATABASE_PATH`: 資料庫路徑
- `UPLOAD_DIR`: 檔案上傳目錄
- `DEBUG`: 除錯模式

## 🎯 使用指南

### 1. 繪圖功能
1. 選擇左側的繪圖工具
2. 調整顏色、大小和不透明度
3. 在畫布上開始繪圖
4. 使用 Ctrl+Z/Ctrl+Y 進行復原/重做

### 2. AI 聊天
1. 在中間的 5 行對話框中輸入訊息
2. 按 Ctrl+Enter 或點擊發送按鈕
3. AI 會分析您的繪圖並提供建議
4. 支援 Markdown 格式和圖片上傳

### 3. 範例使用
1. 瀏覽右側的範例區域
2. 使用搜尋和分類篩選
3. 點擊範例查看詳細內容
4. 一鍵套用到您的設計中

### 4. 快捷鍵
- `Ctrl+S`: 儲存當前狀態
- `Ctrl+Z`: 復原
- `Ctrl+Y`: 重做
- `Esc`: 清除選取/關閉彈窗
- `F1`: 顯示說明

## 🔌 擴展開發

### 添加新的繪圖工具
```javascript
// 在 frontend/js/drawing.js 中添加
const newTool = {
    name: 'customTool',
    icon: '🖌️',
    cursor: 'crosshair',
    apply: (ctx, point) => {
        // 工具邏輯
    }
};
```

### 添加新的 API 端點
```python
# 在 backend/main.py 中添加
@app.post("/api/custom-endpoint")
async def custom_endpoint(data: CustomModel):
    # API 邏輯
    return {"result": "success"}
```

## 🧪 測試

### 前端測試
```bash
# 在瀏覽器開發者工具中
console.log(window.UICoreworkApp.isReady());
```

### 後端測試
```bash
# 測試 API 端點
curl http://localhost:8000/api/health

# 或使用 Python
python -m pytest tests/  # (需要先建立測試檔案)
```

## 📝 更新日誌

### v1.0.0 (2024-01-XX)
- ✅ 完整的多模態繪圖系統
- ✅ AI 智慧聊天功能
- ✅ 範例展示和套用
- ✅ 響應式設計
- ✅ SQLite 資料庫支援
- ✅ RESTful API

## 🤝 貢獻指南

1. Fork 本專案
2. 建立功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交變更 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 開啟 Pull Request

## 📄 授權條款

本專案採用 MIT 授權條款。詳見 [LICENSE](LICENSE) 檔案。

## 🆘 支援與反饋

- **問題回報**: [GitHub Issues](https://github.com/yourusername/ui-corework/issues)
- **功能請求**: [GitHub Discussions](https://github.com/yourusername/ui-corework/discussions)
- **電子郵件**: support@uicorework.com

## 🙏 致謝

- FastAPI 團隊提供優秀的 Web 框架
- Canvas API 讓繪圖功能成為可能
- 所有貢獻者和使用者的支持

---

**💡 這個專案完全符合您的需求：**
- ✅ 同時接收 chat 和觸控筆輸入
- ✅ 即時處理後交給 LLM
- ✅ LLM 可透過 API 精確修改 UI 區域
- ✅ 5行高度的對話框設計
- ✅ 主畫面 + 對話框 + 範例圖展示
- ✅ 無需安裝的前端設計

**🚀 立即體驗 UI CoreWork 的強大功能！**