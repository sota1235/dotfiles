---
name: resolve-pr-comments
description: 現在のブランチのPull Requestについた未解決のレビューコメントを取得し、コード修正・コミット・プッシュ・返信コメント投稿を自動で行います。
disable-model-invocation: true
allowed-tools: Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git rev-parse:*), Bash(gh pr *), Bash(gh api *)
argument-hint: [--dry-run]
---

# Resolve PR Comments

現在のブランチに紐づくPull Requestの未解決レビューコメントに対して、コード修正・コミット・プッシュ・返信コメントを自動で行うスキルです。

## 実行フロー

### 1. PRの特定

現在のブランチからPRを特定する:

```bash
gh pr view --json number,url,headRefName
```

PRが見つからない場合は、その旨を報告して終了する。

### 2. 未解決レビューコメントの取得

GitHub APIを使用して未解決（unresolved）のレビューコメントを取得する:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments \
  --jq '[.[] | select(.in_reply_to_id == null)] | map({id, path, line, side, body, diff_hunk, created_at, user: .user.login})'
```

さらにレビュースレッドの解決状態を確認する:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            comments(first: 10) {
              nodes {
                id
                databaseId
                body
                path
                line
                author { login }
              }
            }
          }
        }
      }
    }
  }
'
```

未解決のスレッドのみを抽出して対応対象とする。

コメントが0件の場合は「未解決のレビューコメントはありません」と報告して終了する。

### 3. コメントの分析と対応

各未解決コメントに対して以下を実行する:

1. **コメント内容の分析**: 指摘内容を理解し、対応方針を決定
2. **該当ファイルの読み込み**: コメントが指すファイルと行を特定して読み込む
3. **コード修正**: 指摘に基づいてコードを修正
4. **コミット作成**: コメントごとに個別のコミットを作成
   - コミットメッセージ形式: `fix: <修正内容の要約> (PR #<number>)`
   - Co-Authored-Byを付与
5. **プッシュ**: 修正をリモートにプッシュ
6. **返信コメント投稿**: 修正コミットへのリンク付きで返信

### 4. 返信コメントの形式

修正に成功した場合:

```
修正しました: <修正内容の簡潔な説明>

対応コミット: <commit SHA>
```

対応できない場合:

```
自動修正が困難なため、手動での対応が必要です。

理由: <対応できない理由の説明>
```

### 5. 返信コメントの投稿

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments \
  -f body="<返信内容>" \
  -F in_reply_to=<元のコメントID>
```

## オプション

- `--dry-run`: 実際のコード修正・コミット・プッシュ・コメント投稿を行わず、対応方針のみを表示する

`$ARGUMENTS` に `--dry-run` が含まれている場合はドライランモードで実行する。

## 対応方針

### 自動修正を試みるケース

- 変数名・関数名の変更
- フォーマット・スタイルの修正
- コメントの追加・修正
- 単純なロジック修正
- importの追加・削除
- 型の修正
- エラーハンドリングの追加

### 手動対応が必要なケース（返信のみ投稿）

- 設計レベルの変更を求めるコメント
- 大規模なリファクタリングが必要
- ビジネスロジックの判断が必要
- コメントの意図が不明確

## 処理の順序

1. コメントをファイルパスでグループ化する
2. 同一ファイルへのコメントはまとめて修正してから個別にコミットする
3. コミットごとにプッシュする（コンフリクト回避のため）

## エラーハンドリング

- **PRが見つからない**: 現在のブランチにPRが紐づいていない旨を報告
- **コメントの取得失敗**: GitHub APIの認証状態を確認するよう促す
- **コード修正の失敗**: 該当コメントをスキップし、手動対応が必要な旨を返信
- **プッシュの失敗**: リモートとの差分を確認し、pullが必要な場合は実行

## 重要な注意事項

- **GitHub CLI (`gh`) が必要**: 事前に `gh auth login` でログインしておくこと
- **コミット単位**: 1つのレビューコメントに対して1つのコミットを作成する
- **プッシュの安全性**: force pushは絶対に行わない
- **返信コメントの言語**: レビューコメントと同じ言語で返信する
- **コミットメッセージの言語**: リポジトリの慣習に従う
- **既存のテストへの影響**: 修正がテストに影響する可能性がある場合はユーザーに確認する
