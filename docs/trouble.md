
# vgrename して再起動したら起動しなくなった件。

## 問題

`root`を含むLG名を、`LVMGroup`に変更したら、起動しなくなった。

## 解決までの試行錯誤

## section
よくある問題に、起動引数が指定されていたため、`cat /proc/cmdline`を実行して確認。
見た所、変更前のLG名が記載されていた、ここが問題であるよう。すぐに変更してエラーになっても辛いので、待機。

もう一つの確認事項に、モジュールが読み込めない、と記載があったように思うので、推奨コマンドの`cat /proc/modules`を実行して確認。問題なさそう。

さらに、`ls /dev`も実行してみてねと書いてあったので実行。
色々表示された。

`cat /proc/cmdline`を実行時のパスが存在しているかどうかを確認したところ、存在していなかった。

`/proc/cmdline`を`vi`で変更しようとしたところ、変更不可能だった。
どうも、`/proc/cmdline`は起動時にどのようなオプションを指定されたかが表示され流ようである。

## 解決法

1. VMでは、起動時に起動プロファイルのようなものを選択できるようである、advancedがあれば、それを選択して、リカバリーのプロファイルを`e`を押して編集する。

1. 引数`root`が過去の`VG`になっているはずなので、それを修正して、とりあえず起動するようにする。

1. ずっと待っていると、ログイン可能な画面に移動する。（はず）（５分ほど待って反応がなければ、Enterを押す。）

1. `root`ユーザーのログインパスワードを入力して、ログインする。

1. `/etc/fstab`ファイル（どこにマウントするかの設定ファイル）を編集し、古い`VG`を新しい`VG`に変更する。

1. `grub-editenv - set "kernelopts=root=/dev/mapper/hoge-root ro crashkernel=auto resume=/dev/mapper/hoge-swap rd.lvm.lv=hoge/root rd.lvm.lv=hoge/swap rhgb quiet`を実行して、`kernelopts`を変更する。`hoge`は任意のVGになるはず。ただし、`lsblk`や、`ls /dev/mapper`を実行して、正しいパスを指定すること。（起動オプションが変更されるはず。）

1. `/boot/grub/grub.cfg`の`VG`名も同様に全部変更する。

1. 普段通りに再起動して、起動すればOK.

## 参考

> https://www.kimullaa.com/posts/202005202238/#%E3%83%96%E3%83%BC%E3%83%88%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF

> https://iranatilark.com/archives/2020/08/08-2225.php

> https://blog.future.ad.jp/-almalinux8.6-%E3%83%9C%E3%83%AA%E3%83%A5%E3%83%BC%E3%83%A0%E3%82%B0%E3%83%AB%E3%83%BC%E3%83%97%E5%90%8D%E3%81%AE%E5%A4%89%E6%9B%B4


# `apt install`がうまく動かない件。

## 問題

`apt install`を実行してもうまくインストールされない。

## 解決策

* 一度新規で設定したマウントを全て外して、実行してみる。この時はこれでなんとかなった。
