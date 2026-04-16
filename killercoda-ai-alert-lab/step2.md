# Step 2: 修正を検証する

修正後、右上の `Check` を押してください。

ローカルでも次のコマンドで確認できます。

```bash
cd /root/lab/lab-files
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/real_incident.log"
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/noise.log"
```

望ましい結果は次のとおりです。

- `real_incident.log` は `ALERT`
- `noise.log` は `OK`

もし通らない場合は、`monitor/alert_rules.conf` の抑制条件が広すぎないか見直してください。
