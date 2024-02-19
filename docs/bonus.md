# Bonus

# LVMの変更

## VG名の変更

> デフォルトでは、`ホスト名-vg`という名前になっているようである。

1. `vgrename 前の名前 新しい名前`を実行して名前を変更する。

1. `/etc/fstab`ファイル（どこにマウントするかの設定ファイル）を編集し、古い`VG`を新しい`VG`に変更する。

1. `grub-editenv - set "kernelopts=root=/dev/mapper/hoge-root ro crashkernel=auto resume=/dev/mapper/hoge-swap rd.lvm.lv=hoge/root rd.lvm.lv=hoge/swap rhgb quiet`を実行して、`kernelopts`を変更する。`hoge`は任意のVGになるはず。ただし、`lsblk`や、`ls /dev/mapper`を実行して、正しいパスを指定すること。（起動オプションが変更されるはず。）

1. `/boot/grub/grub.cfg`の`VG`名も同様に全部変更する。

1. 普段通りに再起動して、起動すればOK.

## VGのパーティションを変更

### homeのサイズを切り詰める

1. `umount /dev/mapper/[home]`を実行してアンマウントする。

1. `lvresize --size [任意のサイズ]M /dev/mapper/[home] --resizefs`を実行して、論理ボリュームのサイズを変更する。

1. `mount /dev/mapper/[home] /home`を実行して、論理ボリュームをマウントする。

### 新規作成

1. 今からマウントする場所にファイルがある場合は、事前にバックアップを取っておく。例：`mkdir /var_backup ; cp -r /var /var_backup`

1. `lvcreate --name var --size [任意のサイズ]M [VG名]`を実行する。

1. `lvcreate --name srv --size [任意のサイズ]M [VG名]`を実行する。

1. `lvcreate --name tmp --size [任意のサイズ]M [VG名]`を実行する。

1. `lvcreate --name var-log --size [任意のサイズ]M [VG名]`を実行する。

1. `mkfs.ext4 /dev/mapper/[VG名]-[作成したLV名]`を作成したLV分実行する。

1. `/etc/fstab`を編集して、
`/dev/mapper/[VG名]-[作成したLV名] マウント先 ext4 0 2`を作成したLV分追加する。

1. 再起動する。問題なく動くことを確認したら終了

# Wordpressを構成

## install

1. `apt install curl`を実行する。

1. `apt install curl`を実行する。

1. `curl -OL https://ja.wordpress.org/latest-ja.tar.gz`を実行してダウンロードする。

1. `tar -xf latest-ja.tar.gz`を実行。

1. 作成された、`wordpress`ディレクトリを`/srv/wordpress`に移動させる。

## lighttpd の設定

1. `apt install lighttpd`を実行する。

1. `/etc/lighttpd/lighttpd.conf`を編集して、`server.document-root`を`/srv/wordpress`に、`server.port`を`8080`に変更する。

1. `systemctl restart lighttpd`を実行して、変更した設定ファイルを読み込ませる。

1. `ufw allow in 8080`を実行して、インバウンド設定を追加する。

## wordpress用のmariadb を設定

1. `apt install mariadb-server`を実行する。

1. `mariadb -u root` を実行して、シェルにログイン

1. `alter user 'root'@'localhost' identified by 'ルートのパスワード';`を実行してパスワードの設定

1. `exit`を実行して、一度ログアウト

1. `mysql -u root -p`を実行してログイン

1.  `create database wordpress;` wordpressという名前のデータベースを作成。

1. `create user wordpressuser@localhost identified by 'ユーザーのパスワード';`を実行して、wordpressuserという名前のユーザーを作成。

1. `grant all privileges on wordpress.* to wordpressuser@localhost;`wordpressuserにデータベースの全ての権限を付与。


## cgiの設定

1. `apt install y php-cgi php-mysql`を実行する。

1. `/etc/lighttpd/lighttpd.conf`を編集して、`server.modules`に`mod_cgi`を追加。最後の行に、`cgi.assign = ( ".php" => "/usr/bin/php-cgi" )`の行を追加。

1. `systemctl restart lighttpd`を実行して、変更した設定ファイルを読み込ませる。

1. `/etc/php/[バージョン]/cgi/php.ini`ファイルを編集して、`cgi.fix_pathinfo=1`のコメントアウトを外す。

1. 同じく、`extension=mysqli`のコメントアウトを外して、mysqliの拡張機能を有効にする。

## VMのポートフォワーディングの設定

1. 新しく、ホストの`8080`をVMの`8080`になるように設定。

## wordpressの初期設定

1. ホストのブラウザで、`localhost:8080`にアクセスする。

1. データベース接続の設定について聞かれるので、データベース名は`wordpress`、ユーザ名は`wordpressuser`, パスワードはデータベースの設定で設定したもの、その他は、そのままにして、`送信`をクリックする。

1. `/srv/wordpress/wp-config.php`が作成できない場合は、エラー画面に飛ぶ。もしも飛んだら、指示に従って、`/srv/wordpress/wp-config.php`を作成して、貼り付ける。<= その後インストールの実行

1. ユーザ名、パスワード、メールアドレスの確認と入力を促されるので、それを入力。

1. `WordPressをインストール`をクリックして、終了。
