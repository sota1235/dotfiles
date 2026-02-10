# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリの概要

このリポジトリは個人用のdotfilesで、zsh、git、vim、tmuxの設定を管理しています。主にmacOS環境を対象としており、Homebrewを使用したパッケージ管理とシンボリックリンクによる設定ファイルの配置を行います。

## インストールと管理コマンド

### 初回インストール
```bash
./install
```

オプションでgitのユーザー名とメールアドレスを指定可能:
```bash
./install -u {git user name} -e {git e-mail address}
```

### dotfilesの更新
```bash
dot_update
```
対話的にdotfilesを最新版に更新します（git pull + 設定ファイルのコピー）。

### dotfilesのアンインストール
```bash
dot_uninstall
```

## アーキテクチャと構成

### ディレクトリ構造

- **install**: メインインストールスクリプト。各種設定ファイルのシンボリックリンク作成とOS別のセットアップを実行
- **tool/**: 共通ユーティリティスクリプト（colors.sh、backup.sh、judge_os.sh、usage_exit.sh）
- **zsh/**: zsh関連の設定
  - `zshrc.zsh`: メイン設定ファイル（プロンプト、vcs_info、補完、履歴など）
  - `zshenv.zsh`: 環境変数設定
  - `alias/`: エイリアス定義（alias.zsh、functions.zsh）
  - `functions/`: キーバインド設定（keybind.zsh）
  - `bin/`: カスタムコマンド（dot_update、dot_uninstall）
- **vim/**: vim設定
  - `vimrc`: メインvim設定ファイル
  - `vimfiles/`: vim設定ディレクトリ（deinプラグインマネージャを使用）
- **gitfiles/**: git設定テンプレート
  - `gitconfig`: メインgit設定
  - `gitignore`: グローバルgitignore
  - `gitconfig_local`: ユーザー固有設定（インストール時に生成）
- **tmux/**: tmux設定
  - `tmux.conf`: tmux設定ファイル
- **init/**: OS別初期化スクリプト
  - `macos.sh`: macOS用セットアップスクリプト
  - `macos/Brewfile.sh`: Homebrewパッケージインストールスクリプト
  - `macos/os_setup.sh`: macOSシステム設定

### インストールフロー

1. **tool/tools.sh**を読み込み、共通ユーティリティ関数を利用可能にする
2. OSを判定（Mac/Linux）
3. 各アプリケーションの設定ファイルをバックアップ後、シンボリックリンクまたはコピーで配置:
   - vim: `~/.vimrc`、`~/.vim`をシンボリックリンク
   - IdeaVim: `~/.ideavimrc`をコピー
   - git: `~/.gitconfig`、`~/.gitignore`をコピー、`~/.gitconfig_local`を生成
   - zsh: `~/.zshrc`、`~/.zshenv`をシンボリックリンク、`~/.zsh_own_config`と`~/.zsh_alias`を生成
   - tmux: `~/.tmux.conf`をコピー
4. macOSの場合、`init/macos.sh`を実行:
   - Homebrewインストール（未インストール時）
   - Brewfile.shによるパッケージインストール
   - os_setup.shによるシステム設定変更
   - nodebrewインストール

### zsh設定の構造

- **zinit**: プラグインマネージャとして使用（`~/.local/share/zinit/`に配置）
- **vcs_info**: Gitリポジトリ情報をプロンプトに表示（ブランチ、ステージング状態、push状態、stash数など）
- **peco統合**:
  - `Ctrl+r`: 履歴検索
  - `Ctrl+g`: ghqで管理しているリポジトリへのcd
- **anyenv/rbenv/nvm**: 複数言語のバージョン管理ツールサポート
- **direnv**: ディレクトリごとの環境変数管理

### Homebrewパッケージ

**init/macos/Brewfile.sh**に定義されている主要パッケージ:
- CLI tools: git, peco, tig, tmux, zsh, gh, ghq, jq, bat, direnv, awscli, terraform, deno
- 開発ツール: yarn, nodebrew, docker, mysql, mycli, pgcli
- GUIアプリ: iterm2, google-chrome, visual-studio-code, jetbrains-toolbox, alfred
- Mac App Store apps: Slack, Xcode, Keynote, LINE, Magnet

## 開発時の注意点

### ファイル編集時の方針

- **zsh設定変更**: `zsh/zshrc.zsh`または`zsh/alias/alias.zsh`を編集。個人固有の設定は`~/.zsh_own_config`または`~/.zsh_alias`に記述
- **git設定変更**: `gitfiles/gitconfig`を編集。ユーザー名/メールアドレスは`~/.gitconfig_local`で管理
- **vim設定変更**: `vim/vimrc`またはdein用の設定ファイル（`vim/vimfiles/userautoload/dein/*.toml`）を編集
- **バックアップ**: installスクリプトは既存ファイルを`.old`拡張子付きでバックアップ（`tool/backup.sh`の`backupDotFiles`関数）

### カスタムコマンド

- **dot_update**: `zsh/bin/dot_update`で定義。git pullでdotfilesを更新し、設定ファイルを再コピー
- **dot_uninstall**: `zsh/bin/dot_uninstall`で定義。インストールしたdotfilesを削除

### エイリアス

主要なエイリアスは`zsh/alias/alias.zsh`に定義:
- Git: `gst` (git status), `gl` (git log), `gci` (git commit), `gco` (git checkout), `wip` (空コミット)
- ディレクトリ: `...` (cd ../..), `....` (cd ../../..)
- ls: `lsa` (ls -lah), `l`/`ll` (ls -lh)
- その他: `v` (vim), `e` (exit), `g` (git), `b` (brew), `rm` (trash - macOS)

### プラグイン管理

- **vim**: deinプラグインマネージャを使用。プラグインは`vim/vimfiles/userautoload/dein/dein.toml`および`dein_lazy.toml`で管理
- **zsh**: zinitプラグインマネージャを使用。現在`azu/ni.sh`を読み込み

## サポートライブラリ

このdotfilesは以下のツールとの統合をサポート:
- pyenv: Python バージョン管理
- rbenv: Ruby バージョン管理
- nvm: Node.js バージョン管理
- peco: インタラクティブフィルタリング
- ghq: リポジトリ管理
- direnv: ディレクトリごとの環境変数
- kubectl: Kubernetes CLI（自動補完有効）
