# Step 1: 状態を調べる

作業ディレクトリへ移動し、Git が使えなくなった原因を調査してください。

```bash
cd /root/lab/workspace
git status
```

コード本体だけでなく、Git が管理情報を保持する場所にも注目して、ワークスペースの状態を確認しましょう。

原因を特定できたら、Git 管理を復旧してください。復旧後に `git status` がエラーなく実行できれば、このステップは完了です。

## 困ったときのヒント

<details>
<summary>ヒント 1: Git の管理情報はどこにある？</summary>

Git は作業ディレクトリ内の隠しディレクトリに、履歴やブランチなどの管理情報を保存します。
</details>

<details>
<summary>ヒント 2: 隠しファイルを含めて確認するには？</summary>

通常の `ls` では、名前が `.` で始まるファイルやディレクトリは表示されません。`ls` のオプションを使って、隠しファイルを含む一覧を確認してみましょう。
</details>

<details>
<summary>ヒント 3: 見つけたディレクトリをどう扱う？</summary>

`.git` に似た名前のディレクトリがあり、その中身が Git の管理情報に見える場合は、本来の名前へ戻すことで復旧できる可能性があります。
</details>


<details>
<summary>それでも解決できないときのBrainのご紹介</summary>

画面右上の Brain を使うと、現在の演習について質問できます。
step2の`CHECK` に2回失敗した場合、CHECKボタンの下にBrainへヒントを求める案内が表示されます。

Brain には、例えば次のように質問してみてください。

```text
Git status says this is not a Git repository.
What should I investigate first?
英語で質問すると、より安定して回答を得られます。
</details>
```

<details>
<summary>ヒント 4: 解決手順を確認する（最終手段）</summary>

ワークスペースにある `.git_disabled` は、Git の管理情報を退避したディレクトリです。次のコマンドで本来の名前に戻し、復旧を確認できます。

```bash
mv .git_disabled .git
git status
```

`git status` がエラーなく実行できれば復旧成功です。続けて Step 2 の `CHECK` を実行してください。
</details>
