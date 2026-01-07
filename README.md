# claude-commands

Claude Code 用の便利なコマンド・ツールキットです。

## インストール

```bash
claude plugin install pankona/claude-commands
```

## 概要

このプラグインは、Claude Code を便利に使うための自分用のツールキット置き場です。

## 機能

### Slack 通知 (SessionEnd Hook)

Claude Code セッション終了時に、自動的に Slack DM で通知を受け取ることができます。

#### セットアップ

1. **Slack App の作成**

   [Slack API](https://api.slack.com/apps) で新しいアプリを作成し、以下の権限を付与:
   - `chat:write`
   - `im:write`

2. **Bot Token の取得**

   OAuth & Permissions → Bot User OAuth Token (`xoxb-...`) をコピー

3. **User ID の取得**

   Slack アプリで自分のプロフィール → ⋯ → "Copy member ID"

4. **設定ファイルの作成**

   プラグインをインストール後:
   ```bash
   cd ~/.claude/plugins/user/claude-commands
   cp config/slack.config.template config/slack.config
   nano config/slack.config
   chmod 600 config/slack.config
   ```

5. **動作確認**

   Claude Code を起動し、セッションを終了すると Slack DM が届きます。

#### 通知内容

- Session ID
- 終了理由 (exit, clear, logout など)
- 作業ディレクトリ
- Transcript パス
- 終了時刻

#### トラブルシューティング

- **通知が届かない**: 設定ファイルのパスと内容を確認
- **権限エラー**: Slack App の Scopes を再確認
- **User ID が不明**: Slack プロフィール → ⋯ → "Copy member ID"

---

## 今後の拡張予定

- **カスタムコマンド**: よく使うワークフローのコマンド化
- **追加 hooks**: その他のイベント駆動自動処理
- **MCP サーバー**: 独自の MCP サーバー統合

## 作者

pankona

## ライセンス

MIT
