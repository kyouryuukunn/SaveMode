
@call storage=save_mode.ks target=*initialize

*load_mode
@iscript
kag.fore.messages[kag.numMessageLayers - 1].onMouseWheel = function(shift, delta, x, y){
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
};
//マウス自動移動
var i;
for (i = sf.save_page*save.column*save.line+1; i < 1+(sf.save_page+1)*save.column*save.line; i++){
	if (kag.getBookMarkDate(i) != ''){
		break;
	}
}
if (i == 1+(sf.save_page+1)*save.column*save.line) i = sf.save_page*save.column*save.line+1;
	i = i - sf.save_page*save.column*save.line;
//現在のページに新しいセーブがあったらそこに移動
if (sf.save_page*save.column*save.line < sf.save_new && sf.save_new < 1+(sf.save_page+1)*save.column*save.line)
	i = sf.save_new;

//現在のページ内での行列を求める
save.temp_line = i%save.line  == 0 ? save.line - 1 : i%save.line - 1;
save.temp_column = save.temp_line == save.line - 1 ? i/save.line - 1 : (int)(i/save.line);

kag.fore.base.cursorX = save.base_x + save.temp_column*save.width + 10;
kag.fore.base.cursorY = save.base_y + save.temp_line*save.height + 10;
@endscript

@call storage=load_mode.ks target=*draw
@s


;サブルーチン

;サムネイル描画
*draw
@image layer="&kag.numCharacterLayers-2" visible=true storage=&save.load_base
@layopt layer="&kag.numCharacterLayers-1" visible=false
@er
@eval exp="save.temp_column = 0"
*column
	@eval exp="save.temp_line = 0"
*line
		;セーブデータがあるか
		@if exp="kag.getBookMarkDate(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line) != ''"
			;透明なボタンを表示
			@locate x="&save.base_x + save.temp_column * save.width" y="&save.base_y + save.temp_line * save.height"
			@button graphic=&save.save_button storage=load_mode.ks target=*play exp="&'save.playing = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line )" onenter="&'save.temp_show = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line ) + ', kag.process(\'save_mode.ks\', \'*show\')'" onleave="&'save.temp_show = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line ) + ', kag.process(\'save_mode.ks\', \'*dishow\')'"
			;サムネイルを表示
			@pimage storage="&kag.getBookMarkFileNameAtNum(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line)" layer="&kag.numCharacterLayers-2" dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
			@image storage=&save.new layer="&kag.numCharacterLayers-1" page=fore visible=true left="&save.base_x + save.temp_column * save.width + save.new_x" top="&save.base_y + save.temp_line * save.height +save.new_y" cond="sf.save_new == 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line"
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
	@jump storage=load_mode.ks target=*line cond="++save.temp_line < save.line"
@jump storage=load_mode.ks target=*column cond="++save.temp_column < save.column"

;ぺージ番号描画
@if exp="save.maxpage > 0"
	@eval exp="save.pagecount = 0"
	;@locate x="&save.page_basex" y="&save.page_basey"
	;@nowait
	;@eval exp="kag.tagHandlers.font(save.page_font)"
	;page
	;@resetfont
	;@endnowait
*pagedraw
		@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
		@nowait
		@if exp="save.pagecount != sf.save_page"
			@link storage=load_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
			@eval exp="kag.tagHandlers.font(save.page_font)"
			@emb exp="save.pagecount + 1"
			@resetfont
			@endlink
		@else
			@eval exp="kag.tagHandlers.font(save.page_font)"
			@font color=0x666666
			@emb exp="save.pagecount + 1"
			@resetfont
		@endif
		@endnowait
	@jump storage=load_mode.ks target=*pagedraw cond="++save.pagecount < (save.maxpage + 1)"
@endif
; 選択肢で自動セーブ用
@if exp="save.autosave"
	@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
	@nowait
	@if exp="sf.save_page != save.pagecount"
		@link storage=load_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
		@eval exp="kag.tagHandlers.font(save.page_font)"
		Auto
		@resetfont
		@endlink
	@else
		@eval exp="kag.tagHandlers.font(save.page_font)"
		@font color=0x666666
		Auto
		@resetfont
	@endif
	@endnowait
@endif

@locate x=&save.close_x y=&save.close_y
@link storage=save_mode.ks target=*back
@nowait
@eval exp="kag.tagHandlers.font(save.close_font)"
close
@resetfont
@endnowait
@endlink

@if exp="save.change && kag.canStore()"
	@locate x=&save.change_x y=&save.change_y
	@link storage=save_mode.ks target=*save_mode
	@nowait
	@eval exp="kag.tagHandlers.font(save.change_font)"
	セーブ
	@resetfont
	@endnowait
	@endlink
@endif

;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@return

; サムネイルがクリックされた時に実行されるサブルーチン
*play
@unlocklink
@if exp="sf.loadAsk==1"
	@if exp="askYesNo('セーブデータをロードしますか？')"
		; データをセーブします
		@load place="&save.playing"
	@endif
@else
	@load place="&save.playing"
@endif
;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s


;linkからサブルーチンをするため
*sub_draw
@call storage=load_mode.ks target=*draw
@s
