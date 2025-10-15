#!/bin/bash

echo "🎨 UI CoreWork - 智慧設計協作平台啟動中..."

# 使用現有的虛擬環境
VENV_PATH="/Users/jianjunneng/0908test/.venv"

echo "✅ 使用虛擬環境: $VENV_PATH"

# 確保依賴套件已安裝
echo "📦 檢查依賴套件..."
$VENV_PATH/bin/pip install fastapi uvicorn[standard] python-multipart pydantic --quiet

# 初始化資料庫
echo "🗄️ 初始化資料庫..."
cd database
$VENV_PATH/bin/python init_db.py create > /dev/null 2>&1
echo "✅ 資料庫初始化完成"
cd ..

echo ""
echo "🚀 啟動 UI CoreWork 服務器..."
echo "📂 服務器地址: http://localhost:8000"
echo "🎨 功能包含:"
echo "   • 多模態繪圖系統（觸控筆支援）"
echo "   • AI 智慧聊天（5行對話框）"
echo "   • 範例展示和套用"
echo "   • 即時設計協作"
echo ""
echo "🔧 按 Ctrl+C 停止服務器"
echo ""

# 延遲開啟瀏覽器
(sleep 3 && open http://localhost:8000) &

# 啟動服務器 - 從專案根目錄執行
exec $VENV_PATH/bin/python backend/main.py