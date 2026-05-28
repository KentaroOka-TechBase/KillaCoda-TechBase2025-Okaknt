# Step 1: 状態を調べる

作業ディレクトリへ移動してください。

```bash
cd /root/lab/workspace
```

まず、隠しファイルを含めて中身を確認します。

```bash
ls -la
```

ここで `.git_disabled` が見つかるはずです。`git status` を試すと、Git 管理が壊れていることも分かります。

```bash
git status
```

## 気づくポイント

- コード本体ではなく、Git の管理情報だけがおかしい
- `.git_disabled` は退避された Git メタデータに見える
- ワークスペースを元の状態に戻せば `git` が使える可能性が高い

## 次にやること

`.git_disabled` を元の名前に戻して、Git 管理を復旧してください。

```bash
mv .git_disabled .git
```

復旧後、もう一度 `git status` を実行してみてください。
