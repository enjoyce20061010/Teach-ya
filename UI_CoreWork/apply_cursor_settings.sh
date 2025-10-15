#!/bin/bash

# Cursor 中文輸入修復腳本
# 自動尋找並套用設定

echo "🔍 尋找 Cursor 設定目錄..."

# 可能的 Cursor 設定位置
CONFIG_DIRS=(
    "$HOME/Library/Application Support/Cursor/User"
    "$HOME/.config/cursor/User" 
    "$HOME/.cursor"
    "$APPDATA/Cursor/User"  # Windows
)

SETTINGS_FILE=""
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "找到設定目錄: $dir"
        SETTINGS_FILE="$dir/settings.json"
        break
    fi
done

if [ -z "$SETTINGS_FILE" ]; then
    echo "❌ 找不到 Cursor 設定目錄"
    echo "請手動開啟 Cursor 設定 (Cmd/Ctrl+,) 並貼上以下內容:"
    echo ""
    cat cursor_chinese_fix.json
    echo ""
    echo "然後重新啟動 Cursor"
    exit 1
fi

echo "✅ 設定檔案位置: $SETTINGS_FILE"

# 備份現有設定
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup"
    echo "📋 已備份原設定到: ${SETTINGS_FILE}.backup"
fi

# 套用新設定
cp cursor_chinese_fix.json "$SETTINGS_FILE"
echo "✅ 已套用中文輸入修復設定"

echo ""
echo "🎉 設定完成！請重新啟動 Cursor 讓設定生效"
echo ""
echo "測試方法："
echo "1. 重新開啟 Cursor"
echo "2. 開啟 chinese_input_test.html"
echo "3. 測試中文輸入是否正常"
EOF && chmod +x apply_cursor_settings.sh && echo "腳本已建立完成！"