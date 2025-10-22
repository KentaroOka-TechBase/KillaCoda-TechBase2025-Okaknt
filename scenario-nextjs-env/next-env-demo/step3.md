# Step 3: NEXT_PUBLICを外して挙動を確認

`.env.local` を編集し、`NEXT_PUBLIC_` の有無による差を確認しましょう。

```bash
sed -n '1,120p' /root/next-env-demo/.env.local || true
```
