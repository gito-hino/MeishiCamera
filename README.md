# MeishiCamera (名刺カメラ) 📇

MeishiCameraは、Flutter、Google Apps Script (GAS)、Gemini APIを活用したモダンな名刺管理アプリケーションです。

## 🌟 主な機能
- **名刺撮影**: カメラで名刺を撮影し、即座にデジタル化。
- **AI OCR解析**: Gemini Vision APIを使用して、名前、会社名、連絡先を高精度に抽出。
- **クラウド保存**: 抽出したデータはGoogleスプレッドシートに自動保存され、どこからでもアクセス可能。
- **ギャラリー取り込み**: 既に撮影済みの名刺画像からも情報を取り込めます。

## 🚀 開発ロードマップ

### Phase 1: 基盤構築 ✅
- プロジェクト初期化
- ホーム画面のUI構築
- ドキュメント整備

### Phase 2: カメラ機能 (Next)
- カメラパッケージの導入
- 名刺撮影フローの実装
- 撮影結果の確認画面

### Phase 3: GAS連携基盤
- スプレッドシート連携APIの作成
- データ送信の実装

### Phase 4: Gemini OCR
- Gemini Vision APIによる画像解析
- 名刺データの自動構造化

### Phase 5: 一覧表示＋完成
- 登録済み名刺の一覧表示
- ギャラリー連携
- 初回設定フローの追加

## 🛠 技術スタック
- **Frontend**: Flutter (Riverpod)
- **Backend**: Google Apps Script
- **Database**: Google Sheets
- **AI**: Gemini API (Google Generative AI)

## 📱 動作環境
- iOS / Android 対応
