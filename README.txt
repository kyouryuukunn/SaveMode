
よくあるセーブロードを実装する

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい
当然なにかあっても責任は取れないけど

全部入りサンプルをskydriveで公開している
https://skydrive.live.com/#cid=8F8EF4D2142F33D4&id=8F8EF4D2142F33D4!257

機能
変数を設定することでかなりレイアウトを好きに
変更出来る
選択肢で自動セーブも可能
セーブ番号は1から順に記録する

save_mode.ksの166行目の右クリックの設定を
各自の環境にあわせてする
次に5行目からの次の変数を設定する
save.save_base = 'black'; //セーブ画面背景
save.load_base = 'black'; //ロード画面背景
save.save_button = 'save_button'; //サムネイルと同じ大きさのボタン
save.dummy = 'save_dummy'; //未セーブの時のサムネイル
save.thumbnail_width  = 120; //サムネイルの幅
save.thumbnail_height =  90; //サムネイルと高さ
save.line   = 4; //横の数
save.column = 2; //縦の数
save.base_x = 30; //初期x座標
save.base_y = 80; //初期y座標
save.width  = save.thumbnail_width + 260; //サムネイル間の幅
save.height = save.thumbnail_height + 30; //サムネイル間の高さ
save.message_x1 = 10 + save.thumbnail_width; //セーブファイルの見出しのサムネイルからの相対x座標
save.message_y1 = 0; //セーブファイルの見出しのサムネイルからの相対y座標
save.message_x2 = 10 + save.thumbnail_width; //セーブファイルの日付のサムネイルからの相対x座標
save.message_y2 = save.thumbnail_height/2; //セーブファイルの日付のサムネイルからの相対y座標
save.message_font = %['size' => 18, 'color' => 0xffffff]; // 情報表示のフォント
save.new = 'checked'; //最新のセーブに表示するマーク
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

@autosave
を使えば、Autoページに勝手に順番に保存し、
ページが一杯なら古いものから消していく
選択肢で使ってくれ
