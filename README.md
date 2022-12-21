# PowerShell いろいろテスト

## 001_logging_tcp_connection

- どこに TCP 接続しているかのサマリを得るためのスクリプト
- 1秒ごとに `Get-NetTCPConnection` を実行し，ユーザ名やコマンドラインと共に出力
- 重複するエントリは削除．つまり一度でも接続したことがある接続がリストされる

## 002_print_ip_address

- 機械的に IPv4 アドレスリストを作成するサンプル
- リストの使い方，foreach の入れ子等のテスト