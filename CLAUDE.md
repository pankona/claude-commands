# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

これは Claude Code 用のプラグインリポジトリです。`claude plugin install pankona/claude-commands` でインストール可能なツールキットを提供します。

## ディレクトリ構成

- `.claude-plugin/` - プラグイン設定ディレクトリ
  - `plugin.json` - プラグインのメタデータ（名前、説明、作者）
  - `marketplace.json` - プラグインマーケットプレイス用の配布設定

## プラグイン開発

### コマンドの追加

カスタムコマンドは `.claude-plugin/commands/` ディレクトリに Markdown ファイル（`.md`）として配置します。

### Hooks の追加

イベント駆動の自動処理は `.claude-plugin/hooks/` ディレクトリに設定します。

### MCP サーバーの追加

MCP サーバー統合は `.claude-plugin/mcp-servers/` ディレクトリに設定します。
