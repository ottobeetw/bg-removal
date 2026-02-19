# BG-Removal 專案（瀏覽器端 AI 去背）

## 📍 位置
- **主機目錄**: `~/otta.workspace/bg-removal/`
- **Docker**: `bg-removal` container（nginx）
- **網址**: https://bg-removal.3mi.tw/

## 🏗️ 架構
- **前端**: 純靜態 HTML + Alpine.js + TailwindCSS
- **AI Library**: `@imgly/background-removal@1.7.0`（瀏覽器端 WebAssembly）
- **模型**: isnet_fp16（~88MB，第一次使用時下載）
- **Server**: Docker + nginx（靜態檔案服務）

## 🔧 技術細節
1. 模型在瀏覽器端執行，不會上傳圖片到伺服器
2. 使用 jsDelivr CDN 加載 library
3. 需要 WebAssembly 支援（Chrome/Edge 較佳）

## 📝 更新日誌

### 2026-02-20
- **問題**: "AI 模型尚未載入" 錯誤
- **原因**: 
  1. 原本用 `.default` export，但 library 是用 named export `{ removeBackground }`
  2. 版本從 1.5.8 升級到 1.7.0
- **修復**: 
  ```javascript
  // 錯誤
  const imgly = await import('...');
  window.removeBg = imgly.default;
  
  // 正確
  const { removeBackground } = await import('...');
  window.removeBg = removeBackground;
  ```
- **狀態**: Library 載入成功，模型下載成功，但實際去背仍有 `TypeError: undefined is not iterable` 錯誤

### 初始版本
- 使用 nginx docker container
- 前端用 Alpine.js + TailwindCSS
- 引用 @imgly/background-removal CDN

## ⚠️ 已知問題
- 實際執行去背時會出错（library 內部問題）
- 可能是 CDN + CORS + WebAssembly 的兼容性問題

## 🚀 部署指令
```bash
# Build
docker build -t bg-removal ~/otta.workspace/bg-removal/

# Run
docker run -d -p 80:80 --name bg-removal bg-removal

# 更新 index.html
docker cp ~/otta.workspace/bg-removal/index.html bg-removal:/usr/share/nginx/html/index.html
```

## 📦 相關檔案
- `Dockerfile`: Docker 映像建置
- `nginx.conf`: nginx 設定
- `index.html`: 主頁面（已修復 library import）
- `dist/`: AI 模型相關靜態資源
