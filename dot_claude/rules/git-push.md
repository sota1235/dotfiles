# Git Push ルール

コードをGitHubにpushする際のルールを定義します。

## 基本方針

コードをpushする前に、現在のブランチに関連するPull Requestが既に存在するかを確認すること。

## 手順

### 1. Pull Requestの存在確認

現在のブランチに対してPull Requestが既に存在するかを確認する：

```bash
gh pr list --head <current-branch> --json number,title,url
```

### 2. Pull Requestが存在する場合

既にPull Requestが存在する場合：
- **新しいPRを作成しない**
- 変更をコミットして既存のブランチにpushする
- これにより、既存のPRに新しいコミットが自動的に追加される
- 必要に応じて、PRの説明を更新する（`gh pr edit`コマンドを使用）

```bash
# 変更をコミット
git add <files>
git commit -m "commit message"

# 既存のブランチにpush（既存のPRが自動更新される）
git push

# 必要に応じてPRの説明を更新
gh pr edit <PR番号> --body "更新された説明"
```

### 3. Pull Requestが存在しない場合

Pull Requestが存在しない場合のみ、新しいPRを作成する：

```bash
# ブランチを作成（必要な場合）
git checkout -b <branch-name>

# 変更をコミット
git add <files>
git commit -m "commit message"

# リモートにpush
git push -u origin <branch-name>

# 新しいPRを作成
gh pr create --draft --assignee @me --title "タイトル" --body "説明"
```

## 重要な注意事項

1. **既存のPRがある場合は新しいPRを作成しない**
   - これは非常に重要です
   - 同じブランチに対して複数のPRを作成すると、混乱を招きます

2. **PRの確認を必ず実施**
   - pushする前に `gh pr list --head <branch>` で確認すること
   - または `gh pr status` でも確認可能

3. **PRの更新通知**
   - 既存のPRにコミットを追加した場合、ユーザーにPRのURLを伝えて更新したことを明示する

## 実装例

```bash
# 現在のブランチ名を取得
current_branch=$(git branch --show-current)

# PRが存在するか確認
pr_exists=$(gh pr list --head "$current_branch" --json number --jq '.[0].number')

if [ -n "$pr_exists" ]; then
  echo "既存のPR #$pr_exists が存在します。このPRを更新します。"

  # 変更をコミットしてpush
  git add <files>
  git commit -m "commit message"
  git push

  # PRのURLを表示
  gh pr view "$pr_exists" --json url --jq '.url'
else
  echo "PRが存在しません。新しいPRを作成します。"

  # 新規PR作成フロー
  git add <files>
  git commit -m "commit message"
  git push -u origin "$current_branch"
  gh pr create --draft --assignee @me --title "タイトル" --body "説明"
fi
```

## 関連ドキュメント

- [pull-request.md](./pull-request.md) - PR作成時の詳細ルール
