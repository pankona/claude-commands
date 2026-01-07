# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

これは Claude Code 用のプラグインリポジトリです。`claude plugin install pankona/claude-commands` でインストール可能なツールキットを提供します。

## ディレクトリ構成

- `.claude-plugin/` - プラグイン設定ディレクトリ
  - `plugin.json` - プラグインのメタデータ（名前、説明、作者、hooks 参照）
  - `marketplace.json` - プラグインマーケットプレイス用の配布設定
- `hooks/` - Hooks 設定ディレクトリ
- `scripts/` - Hook から呼び出されるスクリプト

## プラグイン開発

### コマンドの追加

カスタムコマンドは `commands/` ディレクトリに Markdown ファイル（`.md`）として配置します。

### Hooks の追加

イベント駆動の自動処理は `hooks/` ディレクトリに `hooks.json` として設定します。
`plugin.json` の `hooks` フィールドで参照します（例: `"hooks": "../hooks/hooks.json"`）。

### MCP サーバーの追加

MCP サーバー統合は `mcp-servers/` ディレクトリに設定します。
