# Step 2: 復旧を確認する

Git 管理を戻したら、次のコマンドで確認してください。

```bash
cd /root/lab/workspace
git status
git log --oneline -1
```

望ましい状態は次のとおりです。

- `git status` がエラーなく実行できる
- 作業ツリーがクリーンである
- `.git_disabled` が残っていない

もしまだ `git` が壊れているなら、`.git_disabled` が `.git` に戻っているかをもう一度確認してください。

```bash
ls -la
```
