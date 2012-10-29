
@call storage=save_mode.ks target=*initialize

*load_mode

@call storage=load_mode.ks target=*load_draw
@call storage=save_mode.ks target=*page_draw
@call storage=load_mode.ks target=*change_draw
@s


;サブルーチン

;サムネイル描画
*load_draw
@image layer=base storage=&save.load_base
@layopt layer=0 visible=false
@er
@eval exp="save.temp_column = 0"
*column
	@eval exp="save.temp_line = 0"
*line
		;セーブデータがあるか
		@if exp="kag.getBookMarkDate(1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line) != ''"
			;透明なボタンを表示
			@locate x="&save.base_x + save.temp_column * save.width" y="&save.base_y + save.temp_line * save.height"
			@button graphic=&save.save_button storage=load_mode.ks target=*play exp="&'save.playing = ' + ( 1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line )"
			;サムネイルを表示
			@pimage storage="&kag.getBookMarkFileNameAtNum(1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line)" layer=base dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
			@image storage=&save.new layer=0 page=fore visible=true left="&save.base_x + save.temp_column * save.width + scene.new_x" top="&save.base_y + save.temp_line * save.height + scene.new_y" cond="sf.save_new == 1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line"
			@nowait
			@eval exp="kag.tagHandlers.font(save.message_font)"
			@locate x="&save.base_x + save.temp_column * save.width + save.message_x1" y="&save.base_y + save.temp_line * save.height + save.message_y1"
			@emb exp="save_title(1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line)"
			@locate x="&save.base_x + save.temp_column * save.width + save.message_x2" y="&save.base_y + save.temp_line * save.height + save.message_y2"
			@emb exp="save_date(1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line)"
			@resetfont
			@endnowait
		@else
			@pimage storage=&save.dummy layer=base dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
		@endif
	@jump storage=load_mode.ks target=*line cond="++save.temp_line < save.line"
@jump storage=load_mode.ks target=*column cond="++save.temp_column < save.column"
@return

*change_draw
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
@s


;linkからサブルーチンをするため
*sub_draw
@call storage=load_mode.ks target=*load_draw
@call storage=save_mode.ks target=*page_draw
@call storage=load_mode.ks target=*change_draw
@s
