---
paths:
  - ".github/workflows/*.yml"
  - ".github/workflows/*.yaml"
  - ".github/actions/**/action.yml"
  - ".github/actions/**/action.yaml"
  - "**/action.yml"
  - "**/action.yaml"
---

# GitHub Actions ワークフロー・Composite Action 編集ルール

GitHub Actionsのワークフローファイル（`.github/workflows/*.yml`）およびComposite Action（`action.yml`）を編集する際は、以下のルールに従うこと。これらは`ghalint`および`actionlint`のポリシーに準拠するためのルールである。

## ghalint ポリシー

### セキュリティ・権限

#### 1. ジョブごとに`permissions`を明示する（Policy 001）
- すべてのジョブに`permissions`フィールドを明示的に設定すること
- ワークフローレベルで`permissions: {}`が設定されている場合、またはジョブが1つだけでワークフローに`permissions`が定義済みの場合は例外

```yaml
# 良い例
jobs:
  build:
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps: ...

# 悪い例（permissionsが未指定）
jobs:
  build:
    runs-on: ubuntu-latest
    steps: ...
```

#### 2. `read-all`・`write-all`を使用しない（Policy 002, 003）
- 必要な権限のみを個別に指定すること

```yaml
# 良い例
permissions:
  contents: read
  pull-requests: write

# 悪い例
permissions: read-all
```

#### 3. `secrets: inherit`を使用しない（Policy 004）
- 再利用可能ワークフロー呼び出し時は、必要なシークレットを明示的に渡すこと

```yaml
# 良い例
jobs:
  call-workflow:
    uses: ./.github/workflows/reusable.yml
    secrets:
      token: ${{ secrets.MY_TOKEN }}

# 悪い例
jobs:
  call-workflow:
    uses: ./.github/workflows/reusable.yml
    secrets: inherit
```

#### 4. シークレットのスコープを最小限にする（Policy 005, 006）
- ワークフローレベルの`env`にシークレットを設定しない（単一ジョブの場合は例外）
- ジョブレベルの`env`にシークレットを設定しない（単一ステップの場合は例外）
- **ステップレベルの`env`でシークレットを設定する**

```yaml
# 良い例
steps:
  - name: Deploy
    run: ./deploy.sh
    env:
      API_KEY: ${{ secrets.API_KEY }}

# 悪い例（ワークフローレベル）
env:
  API_KEY: ${{ secrets.API_KEY }}
jobs: ...
```

#### 5. Actionの参照にはフルコミットSHAを使用する（Policy 008）
- タグ（`v3`等）ではなくフルレングスのコミットSHAで参照すること
- コメントでタグ情報を補足する

```yaml
# 良い例
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

# 悪い例
- uses: actions/checkout@v4
```

#### 6. `actions/checkout`で`persist-credentials: false`を設定する（Policy 013）
- クレデンシャルが後続のステップに残らないようにする

```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
  with:
    persist-credentials: false
```

#### 7. `timeout-minutes`を設定する（Policy 011）
- すべてのジョブに`timeout-minutes`を設定すること
- GitHubのデフォルト（6時間）で実行され続けることを防止する

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps: ...
```

#### 8. コンテナイメージに`latest`タグを使用しない（Policy 007）
- 特定のバージョンタグまたはダイジェスト（SHA）でピン留めすること

```yaml
# 良い例
jobs:
  build:
    container:
      image: node:20.11.0

# 悪い例
jobs:
  build:
    container:
      image: node:latest
```

#### 9. GitHub Appトークンの権限とリポジトリを制限する（Policy 009, 010）
- `actions/create-github-app-token`使用時は`repositories`と`permissions`を明示すること

### Composite Action固有

#### 10. `run`ステップに`shell`を明示する（Policy 012）
- Composite Actionの`run`ステップには必ず`shell`を指定すること

```yaml
# 良い例
steps:
  - run: echo "Hello"
    shell: bash

# 悪い例
steps:
  - run: echo "Hello"
```

## actionlint ポリシー

### 構文・構造

#### 1. YAMLキーの正確性
- キー名のタイポや大文字小文字の間違いに注意する
- 必須キーを漏らさない、重複キーを作らない

#### 2. ジョブID・ステップIDの一意性
- 同一ワークフロー内でジョブIDが重複しないようにする
- 同一ジョブ内でステップIDが重複しないようにする

### 式（`${{ }}`）の型安全性

#### 3. コンテキストの正しい使用
- `github`、`env`、`secrets`、`inputs`等のコンテキストを利用可能な場所でのみ使用する
- `steps.<step_id>.outputs`は該当ステップ実行後にのみアクセスする
- `matrix`変数はmatrix定義に基づいた正しい参照をする

#### 4. `needs`の正しい参照
- `needs:`で宣言したジョブの出力のみアクセスする
- 循環依存を作らない

### セキュリティ

#### 5. スクリプトインジェクションを防止する
- `run:`で信頼できない入力（`github.event.issue.title`等）を直接展開しない
- 環境変数経由で渡すこと

```yaml
# 良い例
- run: echo "$ISSUE_TITLE"
  env:
    ISSUE_TITLE: ${{ github.event.issue.title }}

# 悪い例（スクリプトインジェクション脆弱性）
- run: echo "${{ github.event.issue.title }}"
```

#### 6. ハードコードされたクレデンシャルを含めない
- パスワードやトークンをワークフローファイルに直接記述しない
- `secrets`コンテキストを使用する

### イベント・スケジュール

#### 7. 正しいイベント名とタイプを使用する
- 存在しないWebhookイベント名やイベントタイプを使用しない

#### 8. cronの構文を正しく記述する
- `schedule:`のcron式が有効であることを確認する

### Action参照

#### 9. `uses:`の形式を正しく記述する
- `owner/repo@ref`、`./local-path`、`docker://image`のいずれかの形式に従う

#### 10. 非推奨のワークフローコマンドを使用しない
- `set-output`、`save-state`は使用しない
- `$GITHUB_OUTPUT`、`$GITHUB_STATE`を使用する

```yaml
# 良い例
- run: echo "result=value" >> "$GITHUB_OUTPUT"

# 悪い例（非推奨）
- run: echo "::set-output name=result::value"
```

### シェルスクリプト

#### 11. `shell: bash`のスクリプトはshellcheckに準拠する
- shellcheckが指摘する問題（未クォートの変数展開等）を避ける

## チェックリスト

ワークフロー・Composite Actionを作成・編集した際は、以下を確認すること：

- [ ] すべてのジョブに`permissions`が設定されている
- [ ] すべてのジョブに`timeout-minutes`が設定されている
- [ ] Actionの参照はフルコミットSHAを使用し、コメントでタグを補足している
- [ ] `actions/checkout`に`persist-credentials: false`が設定されている
- [ ] シークレットはステップレベルの`env`で設定されている
- [ ] `run:`で信頼できない入力を直接展開していない（環境変数経由で渡している）
- [ ] 非推奨のワークフローコマンドを使用していない
- [ ] Composite Actionの`run`ステップに`shell`が指定されている
- [ ] コンテナイメージは特定バージョンでピン留めされている
