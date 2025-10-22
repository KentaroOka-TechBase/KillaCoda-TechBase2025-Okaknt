# Step 3: NEXT_PUBLICを外して挙動を確認

`.env.local` ファイルを次のように変更します。

```bash
SECRET_MESSAGE="This is a secret server-side message"
# NEXT_PUBLIC_MESSAGE="This is a public client-side message"
MESSAGE="This is now missing NEXT_PUBLIC"
```

サーバーを再起動します：

```bash
npm run dev
```

再び `http://localhost:3000` を開くと、以下のように表示が変わります：

```
Client-side (NEXT_PUBLIC_MESSAGE): (not available)
Server-side (SECRET_MESSAGE): This is a secret server-side message
```
