# Step 2: アプリを起動して動作確認

演習の開始前に、演習環境を準備します。
セットアップはバックグラウンドで進行中です。2分ほど待機し、以下のメッセージが表示されるまで待機してください。

```
Setup completed successfully!
You can now run: cd /root/next-env-demo && npm run dev
```

その後、 ls -a　を実行し、`next-env-demo` が表示されれば初期セットアップは完了です。


続いて、next-env-demoのフォルダに入り、アプリケーションを起動しましょう。
以下のコマンドを実行して、next-env-demoフォルダ配下に移動し、npm run dev と入力してください。

```bash
cd next-env-demo
npm run dev
```

数分待機することで、サーバが立ち上がります。
found 0 vulnerabilities　というメッセージが表示されたら、以下のリンクをクリックしてください。
すると、サーバを開くことができます。

<!-- [▶ 開発サーバーを開く (http://localhost:3000)](http://localhost:3000)** -->
[開発サーバーを開く]({{TRAFFIC_HOST1_3000}})

サーバーが開けたら、表示されている文字列を読んでみましょう。
ここに表示される文字列は、
```bash
/next-env-demo
```
/配下の .env.localフォルダで設定している環境変数を用い、
```bash
/next-env-demo/src/components/EnvViewer.tsx
```
によって環境変数を読みだして表示されています。