#!/usr/bin/env bash
set -euo pipefail

# エラーが発生しても hook 全体を失敗させない (exit 0 で終了)
trap 'exit 0' ERR

# セッション情報を stdin から JSON として読み取る
SESSION_DATA=$(cat)

# 必要な情報を抽出
SESSION_ID=$(echo "$SESSION_DATA" | jq -r '.session_id // "unknown"')
TRANSCRIPT_PATH=$(echo "$SESSION_DATA" | jq -r '.transcript_path // "N/A"')
CWD=$(echo "$SESSION_DATA" | jq -r '.cwd // "N/A"')
REASON=$(echo "$SESSION_DATA" | jq -r '.source // "unknown"')

# 設定ファイルを読み込む（バージョンに依存しない場所）
CONFIG_DIR="${HOME}/.config/claude-commands"
CONFIG_FILE="${CONFIG_DIR}/slack.config"

# 設定ファイルが存在しない場合はスキップ
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[Slack通知] 設定ファイルが見つかりません: $CONFIG_FILE" >&2
  exit 0
fi

# 設定を読み込み
source "$CONFIG_FILE"

# 必須設定の確認
if [[ -z "${SLACK_BOT_TOKEN:-}" ]] || [[ -z "${SLACK_USER_ID:-}" ]]; then
  echo "[Slack通知] SLACK_BOT_TOKEN または SLACK_USER_ID が設定されていません" >&2
  exit 0
fi

# DM チャンネル ID を取得 (初回のみ API 呼び出し、以降はキャッシュ)
CACHE_FILE="${CONFIG_DIR}/.slack_dm_cache"
if [[ -f "$CACHE_FILE" ]]; then
  CHANNEL_ID=$(cat "$CACHE_FILE")
else
  # conversations.open API で DM チャンネルを開く
  CHANNEL_ID=$(curl -s -X POST "https://slack.com/api/conversations.open" \
    -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"users\":\"$SLACK_USER_ID\"}" \
    | jq -r '.channel.id // empty')

  if [[ -z "$CHANNEL_ID" ]]; then
    echo "[Slack通知] DM チャンネルの取得に失敗しました" >&2
    exit 0
  fi

  # キャッシュに保存
  echo "$CHANNEL_ID" > "$CACHE_FILE"
fi

# メッセージを構築
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MESSAGE=$(cat <<EOF
:white_check_mark: *Claude 応答完了*

*Session ID:* \`${SESSION_ID}\`
*作業ディレクトリ:* \`${CWD}\`
*Transcript:* \`${TRANSCRIPT_PATH}\`
*完了時刻:* ${TIMESTAMP}
EOF
)

# Slack API でメッセージを送信
RESPONSE=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"channel\":\"$CHANNEL_ID\",\"text\":$(echo "$MESSAGE" | jq -Rs .)}")

# 送信結果を確認
if echo "$RESPONSE" | jq -e '.ok' > /dev/null; then
  echo "[Slack通知] 送信成功: Session $SESSION_ID" >&2
else
  ERROR=$(echo "$RESPONSE" | jq -r '.error // "unknown error"')
  echo "[Slack通知] 送信失敗: $ERROR" >&2
fi

# 常に成功として終了 (hook の失敗を防ぐ)
exit 0
