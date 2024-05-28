

ANS_LOG="ans-log.txt"
touch "$ANS_LOG"
function question() {
    QUESTION="$1"
    EXAMPLE="$2"

    printf "$QUESTION ans> "
    read ANS
    echo "example: $EXAMPLE"
    echo "$ANS" >> "$ANS_LOG"
}

question "なぜDebianを選んだのか" "インストールと設定に関するドキュメントが豊富でわかりやすかったから。"
question "DebianとRockyの違いは？" "RockyはRedHat系のOSで管理者が使うであろうコマンドや豊富なセキュリティ設定を利用できる。"
question "aptitudeとaptの違いは？" "aptitudeは未使用のパッケージを自動的に削除したり、依存パッケージのインストールを提案したりするのに対し、APTはコマンドラインで明示的に指示されたことだけを実行する"
question "AppArmorとは？" "プログラム単位でリソース制限ができるソフトウェア"
question "パスワードルールについて" "common-passwordとlogin.defsがある"
question "UFWとは" "ファイアウォールを管理するユーザに使いやすいインターフェースを提供するプログラム"
question "SSHとは？" "リモートログインのためのプログラムで、通信内容が暗号化されている。"
question "Cronとは？" "特定の日時に実行や繰り返し実行を行うプログラムである。"
question "crontabとは？" "cronで使われる設定ファイルのこと。"
questioin "PAM とは？" "プラグイン導入可能な認証プログラム"