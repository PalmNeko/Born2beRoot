# install for virtual box

1. debianのイメージをダウンロードする。

1. Virtual Boxを立ち上げて、`新規`を押す。

1. 名前に`debian`と入力して、そのままでよければ、OKをクリックする。（マシンフォルダーに保存される。）ディスクサイズは８GBあればいけるはず。

1. 作成されたマシンイメージの設定をひらく。ストレージのCDのようなマークをクリックして、ダウンロードしたOSイメージを選択する。

1. 選択されたことを確認して、VMを起動

1. 今回は、`Install`を選択。言語、地域、キー配列を英語にする。＜＝インストール後のエラーログが文字化けしない。

1. ホスト名をユーザー名と接尾語として42をつけたものを設定する。

1. ドメイン名は無しでもいいと思われる。

1. ルートのパスワードは後で変更するためなんでも良いが予測されやすいものはよろしくない。

1. ユーザー名は`root`とは別に設定する。例：イントラ名

1. ユーザーのパスワードもなんでも良い。

1. 全ての領域を使う。後から変更する予定。

1. パーティショニング無し。後から変更する予定。

1. そのままインストールする。

1. 追加のメディアの検査って何？とりあえず、いいえ。

1. アーカイブミラーは`ftp.riken.jp`を選択。ドメインが、jpで、理研ってなんとなく良さそうだから。

1. 情報提出は無し。する必要ないと判断。

1. 追加のソフトウェアは何も無し。チェックを全て外す。

1. 多分GRUBブートローダーがないとOS起動しないので、インストール。場所は、手動以外のを選択。

1. 再起動するかどうか聞かれるので再起動する。

1. 完了

# man

1. 管理者権限で`apt install man`を実行。

# グループの追加

1. 管理者権限で、`groupadd user42`を実行して、`user42`グループを追加する。
