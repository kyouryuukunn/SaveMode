赤恐竜	http://akakyouryuu.blog.fc2.com/

よくあるセーブロードを実装する

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい
当然なにかあっても責任は取れないけど

マウスカーソル自動移動は
サークル煌明のMoveMouseCursorPluginがあれば
それをつかう

機能
変数を設定することでかなりレイアウトを好きに変更出来る
マウスホイールでページ移動
カーソルの自動移動
選択肢で自動セーブも可能
セーブ番号は1から順に記録する

使っている変数
sf.loadAsk	:真ならロードするか確認する
sf.saveAsk	:真なら上書きするか確認する
sf.save_init
sf.save_new
sf.save_page
sf.auto_save_count
global.save

使い方
save_mode.ksの*backにある右クリックの設定を
各自の環境にあわせてする
次にsave_mode_init.ksのコメントを参照に5行目からの変数を設定する。
Config.tjsでthumbnailをtrueにする

後はfirst.ksあたりで
@call storage=save_mode_init.ks
をして、save_mode.ks, load_mode.ksをサブルーチンとしてあたまから呼び出せばいい
kag.canStore()の結果でタイトル画面にいるかどうか判断している
のでちゃんとdisablestoreすること

@autosave
を使えば、Autoページに勝手に順番に保存し、
ページが一杯なら古いものから消していく
選択肢で使ってくれ、実際にはAutoページに順番に
保存しているだけなので選択肢以外にも使える
