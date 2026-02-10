# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリの概要

このリポジトリはchezmoiを使用してdotfilesを管理している。chezmoiは複数のマシン間でdotfilesを安全に同期するためのツール。

## chezmoi の基本コマンド

### 日常的に使用するコマンド

```bash
# 現在のマシンにdotfilesを適用
chezmoi apply

# ソースディレクトリと実際の適用先の差分を確認
chezmoi diff

# 既存のファイルをchezmoiの管理下に追加
chezmoi add ~/.vimrc

# ファイルを編集（ソース状態を編集）
chezmoi edit ~/.vimrc

# ソース状態を再適用（変更したファイルを反映）
chezmoi re-add

# 状態確認
chezmoi status

# リモートから変更を取得して適用
chezmoi update
```

### ファイルの状態を確認

```bash
# 特定のファイルの内容を確認
chezmoi cat ~/.vimrc

# テンプレートデータを確認
chezmoi data
```

## ファイル命名規則

chezmoiでは、ソースディレクトリのファイル名に特殊なプレフィックスを使用して動作を制御する：

- `dot_` → `.`に変換（例: `dot_vimrc` → `~/.vimrc`）
- `private_` → ファイルのパーミッションを600に設定
- `symlink_` → シンボリックリンクとして作成（ファイル内容がリンク先のパス）

例:
- `dot_vimrc` → `~/.vimrc`
- `private_dot_gitconfig` → `~/.gitconfig`（パーミッション600）
- `symlink_dot_vim` → `~/.vim`（シンボリックリンク）

## 現在のdotfiles構成

### 主要なdotfiles

- **dot_vimrc**: Vim設定（dein、lightline、gitgutter等のプラグイン設定を含む）
- **dot_zshrc**: Zsh設定（zinit、vcs_info、peco、補完設定を含む）
- **private_dot_gitconfig**: Git設定（エイリアス、カラー設定、エディタ設定）
- **dot_gitignore**: グローバルgitignore
- **dot_claude/**: Claude Code関連の設定ファイル
  - `symlink_CLAUDE.md` → `/Users/sota1235/.dotfiles/claude/CLAUDE.md`へのシンボリックリンク
  - `symlink_commands` → `/Users/sota1235/.dotfiles/claude/commands`へのシンボリックリンク

### 外部依存関係

zshrcとvimrcは以下のファイルを読み込んでいる：

**Zsh:**
- `$HOME/.dotfiles/zsh/functions/keybind.zsh`
- `$HOME/.dotfiles/zsh/alias/alias.zsh`
- `$HOME/.dotfiles/zsh/lib/dircolors.ansi-universal`
- `$HOME/.zsh_own_config`
- `$HOME/.zsh_alias`

**Vim:**
- `runtime! userautoload/dein/*.vim`

これらのファイルは別リポジトリ（`~/.dotfiles/`）で管理されている可能性が高い。

## 開発ワークフロー

### dotfilesの変更を適用する手順

1. このリポジトリでファイルを編集
2. `chezmoi apply`で変更を適用
3. 動作確認
4. gitでコミット・プッシュ

### 既存ファイルをchezmoiに追加する手順

1. `chezmoi add <ファイルパス>` （例: `chezmoi add ~/.zshrc`）
2. 必要に応じて `--follow` オプションを使用してシンボリックリンクをフォロー

## Git設定の特徴

- デフォルトブランチ: `main`
- エディタ: vim
- ローカル設定: `~/.gitconfig_local`をインクルード
- 便利なエイリアス多数（`git alias`で一覧表示可能）

## 開発環境

- シェル: zsh（tmux自動起動、peco統合、vcs_info）
- エディタ: vim（dein、lightline、indent guides等）
- パッケージマネージャ: Homebrew (macOS)
- バージョン管理ツール:
  - anyenv（複数言語のバージョン管理）
  - rbenv（Ruby）
  - nvm（Node.js）
  - nodebrew（Node.js）
  - goenv（Go）
