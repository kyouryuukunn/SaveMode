
;前処理と設定
@iscript
var save = %[];
//ここを書き換える↓------------------------------------------------------- 
save.save_base = 'black'; //セーブ画面背景、透明部分があれば、直前のゲーム画面が見える
save.load_base = 'black'; //ロード画面背景、透明部分があれば、直前のゲーム画面が見える
save.save_button = 'save_button'; //サムネイルと同じ大きさのボタン
save.dummy = 'save_dummy'; //未セーブの時のサムネイル
save.thumbnail_width  = 120; //サムネイルの幅
save.thumbnail_height =  90; //サムネイルと高さ
save.line   = 3; //サムネイルの行数
save.column = 4; //サムネイルの列数
save.base_x = 30; //サムネイル初期x座標
save.base_y = 80; //サムネイル初期y座標
save.width  = save.thumbnail_width + 50; //サムネイルの列の幅
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
save.message_font = %['size' => 25, 'color' => 0xffffff]; // 情報表示のフォント
save.new = 'new'; //最新のセーブに表示するマーク画像
save.new_x = 0; //マークのサムネイルからの相対x座標
save.new_y = 0; //マークのサムネイルからの相対y座標
save.page_basex = kag.scWidth-100; //ページボタンの初期x座標
save.page_basey = 100;   //ページボタンの初期y座標
save.page_width = 0;  //ページボタン間の幅
save.page_height = 50;  //ページボタン間の高さ
save.page_cg = ['1', '2', 'Auto'];  	//ページボタンに使用するボタン画像, この配列が空なら文字そうでないなら画像を表示する
					//例 save.page_cg = ['1', '2'] 前から順に使用する分だけ指定する(Autoぺージを使用するならそれも最後指定する)
save.nowpage_cg = ['off_1', 'off_2', 'off_Auto'];	//ページボタンに画像を使用するときはここに現在のページの画像を指定する
save.page_font = %['italic' => true];  //ページボタンに文字を使うときのフォント
save.autosave = 1; //選択肢でオートセーブをするか
save.close_x=kag.scWidth-150; //閉じるのx座標
save.close_y=kag.scHeight-50; //閉じるのy座標
save.close_button = '';	//閉じるにボタン画像を使用するなら指定する。空のときは文字を使う
save.close_font = %['italic' => true];	//閉じるに文字を使用するときのフォント
					//(ユーザーがフォントを変更すると不味いのでちゃんと指定すること)
save.change = 1; //セーブロード画面で他方に移動するボタンを表示するか
save.change_to_save_button = '';	//ボタン画像を使用するなら指定する。空のときは文字を使う
save.change_to_load_button = '';	//ボタン画像を使用するなら指定する。空のときは文字を使う
save.change_x=100; //x座標
save.change_y=0; //y座標
save.change_font = %['italic' => true]; //フォント
save.maxpage = 2; //ページ数
//ここを書き換える↑------------------------------------------------------- 

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
function save_info_show(num){
	if (save.message_only && kag.getBookMarkDate(num) != ''){
		kag.tagHandlers.current(%['layer'=>'message' + (kag.numMessageLayers - 2)]);
		kag.tagHandlers.er();
		kag.tagHandlers.nowait();
		kag.tagHandlers.font(save.message_font);
		kag.tagHandlers.locate(%['x'=>save.message_only_x1, 'y'=>save.message_only_y1]);
		kag.current.processCh(kag.getBookMarkPageName(num));
		kag.tagHandlers.locate(%['x'=>save.message_only_x2, 'y'=>save.message_only_y2]);
		kag.tagHandlers.ch(%['text'=>save_date(num)]);
		kag.tagHandlers.resetfont();
		kag.tagHandlers.endnowait();
		kag.tagHandlers.current(%['layer'=>'message' + (kag.numMessageLayers - 1)]);
	}
}
function save_info_del(){
	if (save.message_only){
		kag.tagHandlers.current(%['layer'=>'message' + (kag.numMessageLayers - 2)]);
		kag.tagHandlers.er();
		kag.tagHandlers.current(%['layer'=>'message' + (kag.numMessageLayers - 1)]);
	}
}
//マウスホイール用関数
save.onMouseWheel = function(shift, delta, x, y){
	if (save.in_save_mode){
		if (delta < 0){
			if  (save.change){
				if  (sf.save_page > save.maxpage){
					sf.save_page = 0;
				}else{
					sf.save_page += 1;
				}
			}else{
				if  (sf.save_page >= save.maxpage){
					sf.save_page = 0;
				}else{
					sf.save_page += 1;
				}
			}
			kag.process('save_mode.ks', '*sub_draw');
		}else if(delta > 0){
			if  (save.change){
				if  (sf.save_page <= 0){
					sf.save_page = save.maxpage + 1;
				}else{
					sf.save_page -= 1;
				}
			}else{
				if  (sf.save_page <= 0){
					sf.save_page = save.maxpage;
				}else{
					sf.save_page -= 1;
				}
			}
			kag.process('save_mode.ks', '*sub_draw');
		}
	}else{
		if (delta < 0){
			if  (save.change){
				if  (sf.save_page > save.maxpage){
					sf.save_page = 0;
				}else{
					sf.save_page += 1;
				}
			}else{
				if  (sf.save_page >= save.maxpage){
					sf.save_page = 0;
				}else{
					sf.save_page += 1;
				}
			}
			kag.process('load_mode.ks', '*sub_draw');
		}else if(delta > 0){
			if  (save.change){
				if  (sf.save_page <= 0){
					sf.save_page = save.maxpage + 1;
				}else{
					sf.save_page -= 1;
				}
			}else{
				if  (sf.save_page <= 0){
					sf.save_page = save.maxpage;
				}else{
					sf.save_page -= 1;
				}
			}
			kag.process('load_mode.ks', '*sub_draw');
		}
	}
} incontextof global;
@endscript

@macro name=autosave        
;Autoページに順番に記録する
@eval exp="auto_save(save.maxpage + 2, 'auto_save_count')"
@endmacro

@return
