

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

question "/etc/hosts とは？" "IPアドレスとホスト名の対応を書いておくファイル"
question "/etc/group とは？" "グループ一覧が記載されているファイル"
question "/etc/passwd とは？" "ユーザが一覧で記載されているファイル"
question "/etc/pam.d/common-password とは？" "PAMで使われる際に読み込まれる設定ファイルの一つ。パスワードの認証情報に関して記載がある。"
question "/etc/sudoers とは？" "sudoで使われる設定ファイル"
question "/etc/ssh/sshd_config とは？" "sshサーバーで使われる設定ファイル"
question "/etc/fstab とは？" "デバイスをどこにマウントするかを確認するコマンド"

