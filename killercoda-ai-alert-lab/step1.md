# Step 1: 障害を調査する

作業ディレクトリへ移動してください。

```bash
cd /root/lab/lab-files
```

今回の終了条件は次の2つです。

- 実障害ログ `sample_logs/real_incident.log` ではアラートになる
- ノイズログ `sample_logs/noise.log` ではアラートにならない

## ヒント

まずは以下を見て、何が起きているかを整理してみてください。

```bash
cat ai_note.md
cat monitor/alert_rules.conf
docker compose ps
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/real_incident.log"
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/noise.log"
```

## 期待される気づき

- AIの提案には「決済ノイズを広く抑制する」意図がある
- 現在の抑制ルールは広すぎる
- 本来は通知対象である `ERROR` まで無視されている

## 修正

`monitor/alert_rules.conf` を編集して、**本当に無視したいノイズだけ**を残してください。

編集後は再度チェックします。

```bash
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/real_incident.log"
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/noise.log"
```
