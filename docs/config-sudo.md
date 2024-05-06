
# sudo

> `visudo` 実行時に`vim`で起動したい場合は、`sudo update-alternatives --config editor`を実行して、`vim.tiny`を選択する。

1. 管理者権限で`apt install sudo`を実行。

1. もしも、ユーザー権限でログインした後`su`を実行して、`/etc/sudoers`を編集する際は、`-`オプションをつけて管理者権限用の環境変数に変更する。
もしくは、`root`でログインし直す。

1. `/etc/sudoers`を`visudo`コマンドを実行して、編集開始する。

## `sudo` コマンドを使った認証は３回まで行うことができます。

1. `Defaults	passwd_tries=3`を追加して、パスワードの認証回数を制限する。

## `sudo`を使って、パスワードを間違えた場合、選択したカスタムメッセージを表示すること？。

1. パスワードを間違えた時のメッセージをカスタマイズする。`Defaults	badpass_message="パスワードを間違えた時に表示したいメッセージ"`の行を追加して、保存する。

## `sudo`を使った全ての実行は、入力、出力ともに、`/var/log/sudo/` フォルダにアーカイブする必要がある。

1. `Defaults	log_input` を追加して、入力のロギングを有効にする。

1. `Defaults	log_output` を追加して、出力のロギングを有効にする。

1. `Defaults	logfile="/var/log/sudo/"` を追加して、出力されるログのパスを指定する。

## セキュリティの観点で、`TTY`モードは有効にする必要がある。

1. `Defaults	requiretty` を設定することで、ttyを必須にする。

## セキュリティの観点で、`sudo`でも　`/usr/local/sbin`, `/usr/local/bin`, `/usr/sbin`, `/usr/bin`, `/sbin`, `/bin`, `/snap/bin`
のようなパスに、制限する必要がある。

1. secure_pathの行を `Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"`

## テスト

`sudo apt list`を実行して結果を確認する。
>  `usermod -aG sudo [user name]`でユーザーをsudoグループに追加する必要がある。

## ログの再生

`/etc/sudoers`のiolog_dirのパスを-dオプションで渡すことでログの再生などができるようになる。

* `sudoreplay -d /var/log/sudo -l` でログの一覧を表示
* `sudoreplay -d /var/log/sudo TSID` でログの再生ができる。
