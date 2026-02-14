# CLAUDE.md

This file provides global guidance to Claude Code across all projects.

## 基本方針

- 日本語でのコミュニケーションを優先する
- コードの可読性と保守性を重視する
- 変更前には必ず既存のコードを確認する

## コーディング規約

### 共通
- インデントは2スペースを使用
- 意味のある変数名・関数名を使用
- コメントは必要最小限にし、コード自体を自己説明的にする

### Git コミットメッセージ
- プレフィックスを使用: `add:`, `modify:`, `fix:`, `remove:` など
- 簡潔で具体的な内容を記載
- 必要に応じて詳細を本文に記載

### GitHub Pull Request
- **必ずdraft pull requestとして作成すること**
- **自分自身をassigneeに追加すること**
- **日本語で作成すること**（タイトル、本文ともに）
- issueを元に作成したpull requestの場合は、`resolve`、`fixes`、`closes`などのキーワードとともにissue linkを本文に貼ること
  - 例: `Resolves #123` または `Fixes #456`
- pull request templateがある場合には必ずそれを利用すること
  - 複数のテンプレートがある場合は最も適したtemplateを選択してください

## ツール・環境

- シェル: zsh
- エディタ: vim
- バージョン管理: git
- パッケージマネージャ (macOS): Homebrew
