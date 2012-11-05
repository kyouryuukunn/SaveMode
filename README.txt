
よくあるセーブロードを実装する

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい
当然なにかあっても責任は取れないけど

全部入りサンプルをskydriveで公開している
https://skydrive.live.com/#cid=8F8EF4D2142F33D4&id=8F8EF4D2142F33D4!257

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

save_mode.ksの*backにある右クリックの設定を
各自の環境にあわせてする
次に5行目からの次の変数を設定する
save.save_base = 'black'; //セーブ画面背景、透明部分があれば、直前のゲーム画面が見える
save.load_base = 'black'; //ロード画面背景、透明部分があれば、直前のゲーム画面が見える
save.save_button = 'save_button'; //サムネイルと同じ大きさのボタン
save.dummy = 'save_dummy'; //未セーブの時のサムネイル
save.thumbnail_width  = 120; //サムネイルの幅
save.thumbnail_height =  90; //サムネイルと高さ
save.line   = 4; //サムネイルの行数
save.column = 2; //サムネイルの列数
save.base_x = 30; //サムネイル初期x座標
save.base_y = 80; //サムネイル初期y座標
save.width  = save.thumbnail_width + 260; //サムネイルの列の幅
save.height = save.thumbnail_height + 30; //サムネイルの行の幅
save.message_only = 1; //セーブファイルの情報をサムネイルごとに表示するか、ひとつだけにするか
save.message_only_x1 = 10; //セーブファイルの見出しのx座標
save.message_only_y1 = kag.scHeight - 100; //セーブファイルの見出しのy座標
save.message_only_x2 = 10; //セーブファイルの日付のx座標
save.message_only_y2 = kag.scHeight - 50; //セーブファイルの日付のy座標
save.message_x1 = 10 + save.thumbnail_width; //セーブファイルの見出しのサムネイルからの相対x座標
save.message_y1 = 0; //セーブファイルの見出しのサムネイルからの相対y座標
save.message_x2 = 10 + save.thumbnail_width; //セーブファイルの日付のサムネイルからの相対x座標
save.message_y2 = save.thumbnail_height/2; //セーブファイルの日付のサムネイルからの相対y座標
save.message_font = %['size' => 18, 'color' => 0xffffff]; // 情報表示のフォント
save.new = 'new'; //最新のセーブに表示するマーク画像
save.new_x = 0; //マークのサムネイルからの相対x座標
save.new_y = 0; //マークのサムネイルからの相対y座標
save.page_basex = kag.scWidth-400; //ページボタンの初期x座標
save.page_basey = 0;   //ページボタンの初期y座標
save.page_width = 20;  //ページボタン間の幅
save.page_height = 0;  //ページボタン間の高さ
save.page_font = %['italic' => true]; //ページボタンのフォント
save.autosave = 1; //選択肢でオートセーブをするか
save.close_x=kag.scWidth-150; //閉じるのx座標
save.close_y=0; //閉じるのy座標
save.close_font = %['italic' => true]; //閉じるのフォント
save.change = 1; //セーブロード画面で他方に移動する
save.change_x=100; //x座標
save.change_y=0; //y座標
save.change_font = %['italic' => true]; //フォント
save.maxpage = 3; //ページ数

後はfirst.ksあたりで
@call storage=save_mode_init.ks
をして、save_mode.ks, load_mode.ksをあたまから呼び出せばいい
kag.canStore()の結果でタイトル画面にいるかどうか判断している
のでちゃんとdisablestoreすること

@autosave
を使えば、Autoページに勝手に順番に保存し、
ページが一杯なら古いものから消していく
選択肢で使ってくれ、実際にはAutoページに順番に
保存しているだけなので選択肢以外にも使える
