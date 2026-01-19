---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(gh pr:*), Bash(gh api:*), Bash(npm show), Bash(find:*), Bash(npm ls:*)
description: Resolve dependabot alerts
---

# Claude コマンド: Resolve Dependabot Alerts

このコマンドは、現在作業しているリポジトリのDependabot alertsを自動的に取得し、可能な範囲で修正を試み、Pull Requestを作成します。

## 使い方

Dependabot alertsを解決するには、次のように入力してください:
```
/resolve-dependabot-alerts
```

## このコマンドの動作

1. **Dependabot alertsの取得**:
   - `gh api` を使用して現在のリポジトリのDependabot alertsを全て取得
   - alertsの内容を分析（パッケージ名、現在のバージョン、推奨バージョン、脆弱性の深刻度など）
   - alertsが存在しない場合は、その旨を報告して終了

2. **修正の試行**:
   - プロジェクトの種類を判定（package.json、Gemfile、go.mod、requirements.txt、Cargo.toml など）
   - 各プロジェクトタイプに応じた適切な修正方法を実行:
     - **Node.js/npm/yarn/pnpm**: `package.json`と`package-lock.json`/`yarn.lock`/`pnpm-lock.lock`を更新
     - **Ruby/Bundler**: `Gemfile`と`Gemfile.lock`を更新
     - **Go**: `go.mod`と`go.sum`を更新
     - **Python/pip**: `requirements.txt`または`setup.py`を更新
     - **Rust/Cargo**: `Cargo.toml`と`Cargo.lock`を更新
   - 各alertに対して以下を実行:
     - 依存関係を推奨バージョンに更新
     - テストが存在する場合は実行して、変更が問題を起こさないことを確認
     - テストが失敗した場合は、その旨を記録し次のalertに進む

3. **Pull Requestの作成**:
   - 修正が成功したalertをまとめて1つのブランチにコミット
   - ブランチ名: `fix/dependabot-alerts-YYYY-MM-DD`
   - コミットメッセージ形式:
     ```
     fix: resolve dependabot alerts

     - パッケージ名1: v1.0.0 → v1.0.1 (脆弱性の深刻度)
     - パッケージ名2: v2.0.0 → v2.1.0 (脆弱性の深刻度)
     ```
   - **draft Pull Requestとして作成**（CLAUDE.mdの規約に準拠）
   - **自分自身をassigneeに追加**
   - **日本語でPRを作成**
   - PR本文には以下を含める:
     - 修正されたalertの一覧
     - 各alertの詳細（CVE ID、脆弱性の説明、深刻度）
     - 修正できなかったalertがある場合、その理由
     - テスト結果のサマリー

## 修正方針とベストプラクティス

### 自動修正の対象

以下の条件を満たすalertは自動修正を試みます:

1. **メジャーバージョンが変わらない更新**: セマンティックバージョニングに従い、破壊的変更のリスクが低い
2. **パッチバージョンまたはマイナーバージョンの更新**: 後方互換性が保たれる可能性が高い
3. **明確な修正パスが存在**: Dependabotが推奨バージョンを提示している

### 慎重な対応が必要なケース

以下の場合は、自動修正を試みた後、ユーザーに確認を求めます:

1. **メジャーバージョンアップが必要**: 破壊的変更が含まれる可能性
2. **テストが失敗**: 更新によって既存の機能が壊れている可能性
3. **複数の依存関係に影響**: 依存関係ツリー全体の更新が必要
4. **ロックファイルの競合**: 他の変更と競合する可能性

### プロジェクトタイプごとの更新コマンド

- **Node.js (npm)**: `npm update <package-name>` または `npm install <package-name>@<version>`
- **Node.js (yarn)**: `yarn upgrade <package-name>` または `yarn add <package-name>@<version>`
- **Node.js (pnpm)**: `pnpm update <package-name>` または `pnpm add <package-name>@<version>`
- **Ruby (Bundler)**: `bundle update <package-name>`
- **Go**: `go get -u <package-name>@<version>`
- **Python (pip)**: `pip install --upgrade <package-name>==<version>` と requirements.txt の更新
- **Rust (Cargo)**: `cargo update <package-name>`

## エラーハンドリング

以下のエラーが発生した場合の対応:

1. **GitHub API認証エラー**: `gh auth login` を実行してログインするよう促す
2. **依存関係の競合**: 競合の詳細をログに記録し、手動での解決が必要な旨を通知
3. **テストの失敗**: 失敗したテストの詳細を記録し、PRの本文に含める
4. **ロックファイルの生成エラー**: パッケージマネージャーのバージョンや設定を確認するよう促す

## 実装の詳細

### Dependabot Alerts APIの使用

```bash
# alertsの一覧を取得
gh api repos/{owner}/{repo}/dependabot/alerts \
  --jq '.[] | {number, state, security_advisory: .security_advisory.summary, package: .security_vulnerability.package.name, vulnerable_version_range: .security_vulnerability.vulnerable_version_range, first_patched_version: .security_vulnerability.first_patched_version.identifier, severity: .security_advisory.severity}'
```

### 修正の実行フロー

1. リポジトリのルートディレクトリを確認
2. プロジェクトタイプを判定（複数のプロジェクトタイプが混在する場合もある）
3. 各alertについて:
   - パッケージの現在のバージョンを確認
   - 推奨バージョンへの更新コマンドを実行
   - ロックファイルの変更を確認
   - テストが存在する場合は実行
4. すべての変更をステージング
5. コミットメッセージを作成
6. 新しいブランチにプッシュ
7. draft PRを作成

## 重要な注意事項

- **GitHub CLI (`gh`) が必要**: このコマンドは `gh` コマンドを使用するため、事前に `gh auth login` でログインしておく必要があります
- **テストの実行**: 可能な限りテストを実行して、変更が既存の機能を壊さないことを確認します
- **段階的な対応**: すべてのalertを一度に修正するのではなく、修正可能なものから順番に対応します
- **手動確認の推奨**: 自動修正後も、変更内容を手動で確認することを推奨します
- **draft PRとして作成**: PRはdraftとして作成されるため、レビュー準備ができたらready for reviewに変更してください
- **破壊的変更の可能性**: メジャーバージョンアップが含まれる場合、APIの変更や破壊的変更が含まれる可能性があるため、十分な確認が必要です
- **ロックファイルのコミット**: 依存関係の更新後、必ずロックファイル（package-lock.json、yarn.lock、Gemfile.lock など）もコミットします
- **CI/CDの確認**: PR作成後、CI/CDが正常に動作することを確認してください

## セキュリティに関する考慮事項

- **脆弱性の深刻度**: 深刻度が高い（high、critical）alertは優先的に修正を試みます
- **パッチの検証**: 可能な限り、パッチが脆弱性を実際に修正していることを確認します
- **依存関係の信頼性**: 更新先のパッケージバージョンが信頼できるソースから提供されていることを確認します

## 例

### 成功例

```
Dependabot alertsを3件検出しました:
1. lodash: 4.17.15 → 4.17.21 (high)
2. axios: 0.21.0 → 0.21.4 (medium)
3. express: 4.17.0 → 4.17.3 (high)

修正を試みます...

✅ lodash: 4.17.21に更新しました
✅ axios: 0.21.4に更新しました
✅ express: 4.17.3に更新しました

テストを実行中...
✅ すべてのテストが成功しました

draft Pull Requestを作成しています...
✅ PR #123 を作成しました: https://github.com/user/repo/pull/123
```

### 部分的な成功例

```
Dependabot alertsを3件検出しました:
1. lodash: 4.17.15 → 4.17.21 (high)
2. webpack: 4.0.0 → 5.0.0 (medium) - メジャーバージョンアップ
3. axios: 0.21.0 → 0.21.4 (medium)

修正を試みます...

✅ lodash: 4.17.21に更新しました
⚠️  webpack: 5.0.0への更新はメジャーバージョンアップのため、手動確認が必要です
✅ axios: 0.21.4に更新しました

テストを実行中...
✅ すべてのテストが成功しました

draft Pull Requestを作成しています...
✅ PR #123 を作成しました: https://github.com/user/repo/pull/123

注意: webpack のメジャーバージョンアップは手動で対応してください。
```

## トラブルシューティング

### gh コマンドが見つからない

```bash
# Homebrewでインストール
brew install gh

# 認証
gh auth login
```

### 依存関係の競合が発生

- ロックファイルを削除して再生成を試みる
- パッケージマネージャーのキャッシュをクリアする
- 依存関係ツリーを確認して、競合の原因を特定する

### テストが失敗

- 変更内容を詳細に確認
- 失敗したテストのログを分析
- 必要に応じて、段階的に依存関係を更新

### PR作成に失敗

- GitHub CLIの認証状態を確認
- リポジトリへの書き込み権限を確認
- ブランチ名の競合がないか確認
