# Pull Request作成ルール

GitHub Pull Requestを作成する際は、以下のルールに必ず従ってください。

## 必須事項

### 1. Draft Pull Requestとして作成
- **必ずdraft pull requestとして作成すること**
- レビュー準備が整ってからdraftを解除する

### 2. Assigneeの設定
- **自分自身をassigneeに追加すること**
- 担当者を明確にする

### 3. 日本語で作成
- **タイトルと本文は日本語で記載すること**
- 英語のみのPRは作成しない

### 4. Issue連携
- issueを元に作成したpull requestの場合は、以下のキーワードとともにissue linkを本文に貼ること：
  - `Resolves #123`
  - `Fixes #456`
  - `Closes #789`
- これにより、PRがマージされた際に自動的にissueがクローズされる

### 5. Pull Request Template
- pull request templateがある場合には**必ずそれを利用すること**
- 複数のテンプレートがある場合は、最も適したtemplateを選択する

## 実装例

```bash
# Draft PRの作成例
gh pr create --draft --assignee @me --title "タイトル" --body "$(cat <<'EOF'
## 概要
変更内容の説明

## 関連Issue
Resolves #123

## テストプラン
- [ ] テスト項目1
- [ ] テスト項目2
EOF
)"
```

## 注意事項

- これらのルールはすべてのプロジェクトで適用される
- ルールに従わないPRは作成しない
- 不明な点がある場合は、ユーザーに確認する
