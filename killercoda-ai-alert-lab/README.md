# Killercoda Scenario: AI-Suggested Alert Rule Fix

このディレクトリは Killercoda に取り込める最小シナリオです。

## 内容

- Docker Compose で `monitor` コンテナを起動
- AI提案由来の広すぎる抑制ルールを見直す
- 実障害は通知し、ノイズは無視する状態へ戻す

## 受講者が触る主なファイル

- `lab-files/ai_note.md`
- `lab-files/monitor/alert_rules.conf`

## Killercoda で使う流れ

1. このディレクトリを GitHub リポジトリへ配置する
2. Killercoda Creator で対象リポジトリを登録する
3. `killercoda-ai-alert-lab` をシナリオとして公開またはプレビューする

## ローカル確認

```bash
cd lab-files
docker compose up -d
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/real_incident.log"
docker compose exec -T monitor sh -lc "cd /lab && sh ./check_alert.sh sample_logs/noise.log"
```

初期状態では誤った設定のため、`real_incident.log` でもアラートになりません。`monitor/alert_rules.conf` を修正すると解けます。
