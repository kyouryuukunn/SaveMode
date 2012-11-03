
;前処理と設定
@iscript
var save = %[];
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


save.maxpage -= 1;
// 日付を返す
function save_date(n){
	var saveDate = kag.getBookMarkDate(n);  // セーブデータの日付を取得して saveDate に代入します
	if(saveDate != "")
	{
		// セーブデータがある場合
		var d = new Date(saveDate);  // セーブデータの日付を持つ Date クラスのオブジェクトを生成します
		// : TIME の項目に表示する情報 → セーブデータの作成日時
		return "%d/%d/%d/%02d:%02d".sprintf(d.getYear(), (d.getMonth() + 1), d.getDate(), d.getHours(), d.getMinutes());
	}
}
//一度だけ実行する
if (sf.save_init === void){
	sf.save_init=1;
}
//引き数のpageで番号の小さいものから順に
//セーブしていく、ページが埋まったら、
//同様の順に上書きしていく
//countにはシステム変数名を指定
function auto_save(page, count){
	var start = 1 + save.column*save.line*(page-1);
	if (sf[count] > save.column*save.line - 1){
		sf[count]=0;
		sf.save_new = start + sf[count];
		sf.save_page = page - 1;
		kag.storeBookMark(start + sf[count], false);
	}else{
		sf.save_new = start + sf[count];
		sf.save_page = page - 1;
		kag.storeBookMark(start + sf[count], false);
		sf[count]+=1;
	}
}
@endscript

@macro name=autosave        
;Autoページに順番に記録する
@eval exp="auto_save(save.maxpage + 2, 'auto_save_count')"
@endmacro

@return
