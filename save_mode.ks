
@call storage=save_mode.ks target=*initialize

*save_mode

@call storage=save_mode.ks target=*save_draw
@call storage=save_mode.ks target=*page_draw
@call storage=save_mode.ks target=*change_draw
@s


;�T�u���[�`��
*initialize
@locksnapshot
@tempsave
@laycount messages="&kag.numMessageLayers + 1"
@rclick enabled=true jump=true storage=save_mode.ks target=*back
@history enabled=false output=false

@iscript
save.playing = 0;
var elm = %["visible" => false];
// �S�Ă̑O�i���C�����\���ɂ��܂�
for(var i=0;i<kag.numCharacterLayers;i++)
	kag.fore.layers[i].setOptions(elm);
// �S�Ẵ��b�Z�[�W���C�����\���ɂ��܂�
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(elm);
@endscript

@current layer="&'message' + (kag.numMessageLayers - 1)"
@position opacity=0 marginb=0 margint=0 marginl=0 marginr=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 layer=message visible=true
@return


;�T���l�C���`��
*save_draw
@image layer=base storage=&save.save_base
@layopt layer=0 visible=false
@er
@eval exp="save.temp_column = 0"
*column
	@eval exp="save.temp_line = 0"
*line
		;�����ȃ{�^����\��
		@locate x="&save.base_x + save.temp_column * save.width" y="&save.base_y + save.temp_line * save.height"
		@button graphic=&save.save_button storage=save_mode.ks target=*play exp="&'save.playing = ' + ( 1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line )"
		;�Z�[�u�f�[�^�����邩
		@if exp="kag.getBookMarkDate(1 + save.page*save.column*save.line + save.temp_column*save.line + save.temp_line) != ''"
			;�T���l�C����\��
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
	@jump storage=save_mode.ks target=*line cond="++save.temp_line < save.line"
@jump storage=save_mode.ks target=*column cond="++save.temp_column < save.column"
@return

*page_draw
;�؁[�W�ԍ��`��
@if exp="save.maxpage > 0"
	@eval exp="save.pagecount = 0"
	@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
	@nowait
	@eval exp="kag.tagHandlers.font(save.page_font)"
	page
	@resetfont
	@endnowait
*pagedraw
		@locate x="&save.page_basex + save.page_width * save.pagecount + 100" y="&save.page_basey + save.page_height * save.pagecount"
		@nowait
		@if exp="save.pagecount != save.page"
			@link storage=save_mode.ks target=*sub_draw exp="&'save.page = ' + save.pagecount"
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
	@jump storage=save_mode.ks target=*pagedraw cond="++save.pagecount < (save.maxpage + 1)"
@endif

@locate x=&save.close_x y=&save.close_y
@link storage=save_mode.ks target=*back
@nowait
@eval exp="kag.tagHandlers.font(save.close_font)"
close
@resetfont
@endnowait
@endlink
@return

*change_draw
@if exp=save.change
	@locate x=&save.change_x y=&save.change_y
	@link storage=load_mode.ks target=*load_mode
	@nowait
	@eval exp="kag.tagHandlers.font(save.change_font)"
	���[�h
	@resetfont
	@endnowait
	@endlink
@endif
@return

; �T���l�C�����N���b�N���ꂽ���Ɏ��s�����T�u���[�`��
*play
@unlocklink
; ���łɃZ�[�u�f�[�^������ꍇ�͏㏑���m�F���܂�
; �Z�[�u�f�[�^�����݂��Ȃ����܂��͏㏑���m�F�_�C�A���O�{�b�N�X�Łu�͂��v���I�����ꂽ�ꍇ�̓Z�[�u���܂�
@if exp="kag.getBookMarkDate(save.playing) == ''"
	; �f�[�^���Z�[�u���܂�
	@save place="&save.playing"
	@eval exp="sf.save_new = save.playing"
	; �T���l�C���̕\�����X�V���܂�
	@call storage=save_mode.ks target=*save_draw
	@call storage=save_mode.ks target=*page_draw
	@call storage=save_mode.ks target=*change_draw
@else
	@if exp="sf.saveAsk==1"
		@if exp="askYesNo('�Z�[�u�f�[�^���㏑�����܂����H')"
			; �f�[�^���Z�[�u���܂�
			@save place="&save.playing"
			@eval exp="sf.save_new = save.playing"
			; �T���l�C���̕\�����X�V���܂�
			@call storage=save_mode.ks target=*save_draw
			@call storage=save_mode.ks target=*page_draw
			@call storage=save_mode.ks target=*change_draw
		@endif
	@else
		; �f�[�^���Z�[�u���܂�
		@save place="&save.playing"
		; �T���l�C���̕\�����X�V���܂�
		@call storage=save_mode.ks target=*save_draw
		@call storage=save_mode.ks target=*page_draw
		@call storage=save_mode.ks target=*change_draw
	@endif
@endif
[s]


;link����T�u���[�`�������邽��
*sub_draw
@call storage=save_mode.ks target=*save_draw
@call storage=save_mode.ks target=*page_draw
@call storage=save_mode.ks target=*change_draw
@s

*back
@tempload
@unlocksnapshot
;@rclick enabled=true jump=true storage=title.ks target=*title
@history enabled=true output=true
@return

