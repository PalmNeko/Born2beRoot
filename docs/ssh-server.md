# SSH Server

1. 管理者権限で`apt install openssh-server`を実行。

1. ポートを`4242`に絞るため、`/etc/ssh/sshd_config`ファイルを管理者権限で編集し、`Port 22`の部分を`Port 4242`に変更し保存する。（色々設定できるようである。）

1. 続けて、`DenyUsers root`ルールを作成して、rootでアクセスできないようにする。
> `/etc/ssh/sshd_confing.d/*.conf`を読み込むのでそこに`deny.conf`などのファイルを作ってルールを追加するのもよき。

1. ホストと通信するために、ネットワークをブリッジアダプターに変更する。（多分再起動必要）

1. （`systemctl restart ssh.service`でいけると思ったけど行けなかった。多分ネットワークの構成があってなかったから）

1. `ip address`でipv4のアドレスを確認する。

1. アクセスしたい場所から、`ssh -l login_name -p port -4 v4Address`のようなコマンド形式を使ってログインする。ログインできれば、構築完了。（いったん）	

# テスト

* rootでログインできないかどうか。
* ユーザーでログインできるかどうか。
