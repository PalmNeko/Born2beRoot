

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

question "ufwが有効かどうかは？" "sudo ufw status"
question "SSHが有効かどうかは？" "sudo systemctl status ssh"
question "グループがあるかどうかの確認は？" "cat /etc/group"
question "ユーザの追加は？" "sudo adduser <username>"
question "グループの追加は？" "sudo groupadd <groupname>"
question "ユーザをグループに追加は？" "sudo usermod -aG <groupname> <username>"
question "パスワードの有効期限ルールを確認" "sudo chage -l <username>"
question "ホスト名の確認は？" "hostname"
question "ホスト名の変更は？" "hostnamectl set-hostname new_hostname と /etc/hostsを編集する"
question "ブロックデバイスを一覧表示するには？" "lsblk"
question "リブートは？" "sudo reboot"
question "インストールされているかどうかの確認は？" "apt list | grep '確認したいプログラム名'"
question "UFWの設定内容表示" "sudo ufw status"
question "UFWの許可設定" "sudo ufw allow <port>"
question "UFWの許可設定の削除" "sudo ufw delete allow <port>"
question "SSH接続" "ssh -l <username> -p <port> -4 <ipaddress>"
