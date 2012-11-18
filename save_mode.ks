
@call storage=save_mode.ks target=*initialize

*save_mode
@iscript

//マウス自動移動
var i;
for (i = sf.save_page*save.column*save.line+1; i < 1+(sf.save_page+1)*save.column*save.line; i++){
	if (kag.getBookMarkDate(i) == ''){
		break;
	}
}
if (i == 1+(sf.save_page+1)*save.column*save.line) i = sf.save_page*save.column*save.line+1;
i = i - sf.save_page*save.column*save.line;

//現在のページ内での行列を求める
save.temp_line = i%save.line  == 0 ? save.line - 1 : i%save.line - 1;
save.temp_column = save.temp_line == save.line - 1 ? i/save.line - 1 : (int)(i/save.line);

kag.fore.base.cursorX = save.base_x + save.temp_column*save.width + 10;
kag.fore.base.cursorY = save.base_y + save.temp_line*save.height + 10;
//マウスホイール用にセーブ画面がロード画面かの目印をつける
save.in_save_mode = 1;
@endscript

@call storage=save_mode.ks target=*draw
@s


;セーブ、ロード共通サブルーチン
*initialize
@locksnapshot
@tempsave
@rclick enabled=true jump=true storage=save_mode.ks target=*back
@history enabled=false output=false
@iscript
// システムボタンを使っていて、メッセージレイヤが表示されている時は onMessageHiddenStateChanged を呼び出します
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(true);
// SetMessageOpacityを使っていて、メッセージレイヤが表示されている時は onMessageHiddenStateChanged を呼び出します
if (typeof(global.SetMessageOpacity_object) != 'undefined' && kag.fore.messages[0].visible)
	SetMessageOpacity_object.onMessageHiddenStateChanged(true);
// 全てのメッセージレイヤを非表示にします
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(%[visible:false]);

//マウスホイールの動作を一時的に変える
save.onMouseWheel_org = kag.onMouseWheel;
kag.onMouseWheel = function(){
	save.onMouseWheel_org(...);
	save.onMouseWheel(...);
} incontextof kag;
//セーブ、ロード画面ではメニューからのセーブ、ロード無効化
kag.restoreMenu.enabled = false;
kag.storeMenu.enabled = false;
@endscript
@laycount layers="&kag.numCharacterLayers + 2" messages="&kag.numMessageLayers + 1"
;すべてのレイヤより上に表示
;背景
@layopt index="&2000000+100" layer="&kag.numCharacterLayers-2"
;Newマーク
@layopt index="&2000000+101" layer="&kag.numCharacterLayers-1"
@layopt index="&2000000+103" layer="&'message' + (kag.numMessageLayers-1)"
@position opacity=0 marginb=0 margint=0 marginl=0 marginr=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 layer="&'message' + (kag.numMessageLayers - 1)" visible=true
@current layer="&'message' + (kag.numMessageLayers - 1)"
@return


;サムネイル描画
*draw
@image layer="&kag.numCharacterLayers-2" storage=&save.save_base visible=true
@layopt layer="&kag.numCharacterLayers-1" visible=false
@er
@eval exp="save.temp_column = 0"
*column
	@eval exp="save.temp_line = 0"
*line
		;透明なボタンを表示
		@locate x="&save.base_x + save.temp_column * save.width" y="&save.base_y + save.temp_line * save.height"
			@button graphic=&save.save_button storage=save_mode.ks target=*play exp="&'save.playing = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line )" onenter="&'save_info_show(' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line ) + ')'" onleave="save_info_del()"
		;セーブデータがあるか
		@if exp="kag.getBookMarkDate(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line) != ''"
			;サムネイルを表示
			@pimage storage="&kag.getBookMarkFileNameAtNum(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line)" layer="&kag.numCharacterLayers-2" dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
			@image storage=&save.new layer="&kag.numCharacterLayers-1" page=fore opacity=255 visible=true left="&save.base_x + save.temp_column * save.width + save.new_x" top="&save.base_y + save.temp_line * save.height + save.new_y" cond="sf.save_new == 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line"
			;情報を表示
			@if exp="!save.message_only"
				@nowait
				@eval exp="kag.tagHandlers.font(save.message_font)"
				@locate x="&save.base_x + save.temp_column * save.width + save.message_x1" y="&save.base_y + save.temp_line * save.height + save.message_y1"
				@emb exp="kag.getBookMarkPageName(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line)"
				@locate x="&save.base_x + save.temp_column * save.width + save.message_x2" y="&save.base_y + save.temp_line * save.height + save.message_y2"
				@emb exp="save_date(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line)"
				@resetfont
				@endnowait
			@endif
		@else
			@pimage storage=&save.dummy layer="&kag.numCharacterLayers-2" dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
		@endif
	@jump storage=save_mode.ks target=*line cond="++save.temp_line < save.line"
@jump storage=save_mode.ks target=*column cond="++save.temp_column < save.column"

;ぺージ番号描画
@if exp="save.maxpage > 0"
	@eval exp="save.pagecount = 0"
*pagedraw
		@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
		@nowait
		@if exp="save.pagecount != sf.save_page"
			@if exp="save.page_cg.count > 0"
				@button storage=save_mode.ks target=*sub_draw graphic="&save.page_cg[save.pagecount]" exp="&'sf.save_page = ' + save.pagecount"
			@else
				@link storage=save_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
				@eval exp="kag.tagHandlers.font(save.page_font)"
				@emb exp="save.pagecount + 1"
				@resetfont
				@endlink
			@endif
		@else
			@if exp="save.page_cg.count > 0"
				@pimage dx="&save.page_basex + save.page_width * save.pagecount" dy="&save.page_basey + save.page_height * save.pagecount" storage=&save.nowpage_cg[save.pagecount] layer="&kag.numCharacterLayers-2"
			@else
				@eval exp="kag.tagHandlers.font(save.page_font)"
				@font color=0x666666
				@emb exp="save.pagecount + 1"
				@resetfont
			@endif
		@endif
		@endnowait
	@jump storage=save_mode.ks target=*pagedraw cond="++save.pagecount < (save.maxpage + 1)"
@endif
; 選択肢で自動セーブ用
@if exp="save.autosave"
	@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
	@nowait
	@if exp="sf.save_page != save.pagecount"
		@if exp="save.page_cg.count > 0"
			@button storage=save_mode.ks target=*sub_draw graphic="&save.page_cg[save.pagecount]" exp="&'sf.save_page = ' + save.pagecount"
		@else
			@link storage=save_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
			@eval exp="kag.tagHandlers.font(save.page_font)"
			Auto
			@resetfont
			@endlink
		@endif
	@else
		@if exp="save.page_cg.count > 0"
			@pimage dx="&save.page_basex + save.page_width * save.pagecount" dy="&save.page_basey + save.page_height * save.pagecount" storage=&save.nowpage_cg[save.pagecount] layer="&kag.numCharacterLayers-2"
		@else
			@eval exp="kag.tagHandlers.font(save.page_font)"
			@font color=0x666666
			Auto
			@resetfont
		@endif
	@endif
	@endnowait
@endif

@locate x=&save.close_x y=&save.close_y
@if exp="save.close_button != ''"
	@button storage=save_mode.ks target=*back graphic="&save.close_button"
@else
	@link storage=save_mode.ks target=*back
	@nowait
	@eval exp="kag.tagHandlers.font(save.close_font)"
	close
	@resetfont
	@endnowait
	@endlink
@endif

@if exp=save.change
	@locate x=&save.change_x y=&save.change_y
	@if exp="save.change_to_load_button != ''"
		@button storage=load_mode.ks target=*load_mode graphic="&save.change_to_load_button"
	@else
		@link storage=load_mode.ks target=*load_mode
		@nowait
		@eval exp="kag.tagHandlers.font(save.change_font)"
		ロード
		@resetfont
		@endnowait
		@endlink
	@endif
@endif

;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@return


; サムネイルがクリックされた時に実行されるサブルーチン
*play
@unlocklink
; すでにセーブデータがある場合は上書き確認します
; セーブデータが存在しないかまたは上書き確認ダイアログボックスで「はい」が選択された場合はセーブします
@if exp="kag.getBookMarkDate(save.playing) == ''"
	; データをセーブします
	@save place="&save.playing"
	@eval exp="sf.save_new = save.playing"
	; サムネイルの表示を更新します
	@call storage=save_mode.ks target=*draw
@else
	@if exp="sf.saveAsk==1"
		@if exp="askYesNo('セーブデータを上書きしますか？')"
			; データをセーブします
			@save place="&save.playing"
			@eval exp="sf.save_new = save.playing"
			; サムネイルの表示を更新します
			@call storage=save_mode.ks target=*draw
		@endif
	@else
		; データをセーブします
		@save place="&save.playing"
		@eval exp="sf.save_new = save.playing"
		; サムネイルの表示を更新します
		@call storage=save_mode.ks target=*draw
	@endif
@endif
;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s


;linkからサブルーチンをするため
*sub_draw
@call storage=save_mode.ks target=*draw
@s

*back
@tempload bgm=0
@unlocksnapshot
@iscript
//システムボタン、メッセージ枠ともに以前の可視、不可視を記録している
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(false);
if (typeof(global.SetMessageOpacity_object) != 'undefined' && kag.fore.messages[0].visible)
	SetMessageOpacity_object.onMessageHiddenStateChanged(false);
//マウスホイールの動作を戻す
kag.onMouseWheel = save.onMouseWheel_org;
//メニューからのセーブ、ロード有効化
kag.restoreMenu.enabled = true;
kag.storeMenu.enabled = true;
@endscript
;各自設定する
;@rclick enabled=true jump=true storage=title.ks target=*title
@history enabled=true output=true cond="kag.canStore()"
@return

