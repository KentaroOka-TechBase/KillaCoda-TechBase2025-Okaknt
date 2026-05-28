# Killercoda Scenario: AI支援ツールにより退避されたGit管理を復旧せよ

このディレクトリは、AI支援ツールの安全機能が誤作動して `.git` が `.git_disabled` に退避されたワークスペースを復旧する、短時間の Git 演習です。

## 内容

- `setup.sh` で `/root/lab/workspace` にデモリポジトリを作成する
- `git init` 済みの状態から `.git` を `.git_disabled` に退避する
- 受講者は隠しファイルを調べて、Git 管理を復旧する

## 受講者が触る主なファイル

- `/root/lab/workspace/.git_disabled`
- `/root/lab/workspace/app.py`
- `/root/lab/workspace/README.md`

## Killercoda で使う流れ

1. このディレクトリを GitHub リポジトリへ配置する
2. Killercoda Creator で対象リポジトリを登録する
3. `killercoda-ai-git-restore-lab` をシナリオとして公開またはプレビューする

## ローカル確認

```bash
cd /root/lab/workspace
ls -la
git status
mv .git_disabled .git
git status
```

初期状態では `git status` は失敗します。`.git_disabled` を `.git` に戻すと、Git 管理が復旧します。
