

### 情報

1. `monitoring.sh`を作成し、`root`のホームディレクトリに保存する。

1. `crontab -e -u root`を実行して、`cron`の設定ファイルを開く。

1. `*/10 * * * * bash ~/monitoring.sh`の行を追加して、保存し閉じる。

1. １０分後に情報が表示されればOK。
