
@call storage=save_mode.ks target=*initialize

*save_mode
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
};
//�}�E�X�����ړ�
var i;
for (i = sf.save_page*save.column*save.line+1; i < 1+(sf.save_page+1)*save.column*save.line; i++){
	if (kag.getBookMarkDate(i) == ''){
		break;
	}
}
if (i == 1+(sf.save_page+1)*save.column*save.line) i = sf.save_page*save.column*save.line+1;
i = i - sf.save_page*save.column*save.line;

//���݂̃y�[�W���ł̍s������߂�
save.temp_line = i%save.line  == 0 ? save.line - 1 : i%save.line - 1;
save.temp_column = save.temp_line == save.line - 1 ? i/save.line - 1 : (int)(i/save.line);

kag.fore.base.cursorX = save.base_x + save.temp_column*save.width + 10;
kag.fore.base.cursorY = save.base_y + save.temp_line*save.height + 10;
@endscript

@call storage=save_mode.ks target=*draw
@s


;�T�u���[�`��
*initialize
@locksnapshot
@tempsave
@rclick enabled=true jump=true storage=save_mode.ks target=*back
@history enabled=false output=false
@iscript
// �V�X�e���{�^�����g���Ă��āA���b�Z�[�W���C�����\������Ă��鎞�� onMessageHiddenStateChanged ���Ăяo���܂�
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(true);
var i;
var elm = %["visible" => false];
// �S�Ẵ��b�Z�[�W���C�����\���ɂ��܂�
for(i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(elm);

@endscript
@laycount layers="&kag.numCharacterLayers + 2" messages="&kag.numMessageLayers + 2"
;���ׂẴ��C������ɕ\��
@layopt index="&2000000+100" layer="&kag.numCharacterLayers-2"
@layopt index="&2000000+101" layer="&kag.numCharacterLayers-1"
@layopt index="&2000000+103" layer="&'message' + (kag.numMessageLayers-1)"
@layopt index="&2000000+103" layer="&'message' + (kag.numMessageLayers-2)"
@position opacity=0 marginb=0 margint=0 marginl=0 marginr=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 layer="&'message' + (kag.numMessageLayers - 1)" visible=true
@position opacity=0 marginb=0 margint=0 marginl=0 marginr=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 layer="&'message' + (kag.numMessageLayers - 2)" visible=true
@current layer="&'message' + (kag.numMessageLayers - 1)"
@return


;�T���l�C���`��
*draw
@image layer="&kag.numCharacterLayers-2" storage=&save.save_base visible=true
@layopt layer="&kag.numCharacterLayers-1" visible=false
@er
@eval exp="save.temp_column = 0"
*column
	@eval exp="save.temp_line = 0"
*line
		;�����ȃ{�^����\��
		@locate x="&save.base_x + save.temp_column * save.width" y="&save.base_y + save.temp_line * save.height"
		@button graphic=&save.save_button storage=save_mode.ks target=*play exp="&'save.playing = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line )" onenter="&'save.temp_show = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line ) + ', kag.process(\'save_mode.ks\', \'*show\')'" onleave="&'save.temp_show = ' + ( 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line ) + ', kag.process(\'save_mode.ks\', \'*dishow\')'"
		;�Z�[�u�f�[�^�����邩
		@if exp="kag.getBookMarkDate(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line) != ''"
			;�T���l�C����\��
			@pimage storage="&kag.getBookMarkFileNameAtNum(1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line)" layer="&kag.numCharacterLayers-2" dx="&save.base_x + save.temp_column * save.width" dy="&save.base_y + save.temp_line * save.height"
			@image storage=&save.new layer="&kag.numCharacterLayers-1" page=fore opacity=255 visible=true left="&save.base_x + save.temp_column * save.width + save.new_x" top="&save.base_y + save.temp_line * save.height + save.new_y" cond="sf.save_new == 1 + sf.save_page*save.column*save.line + save.temp_column*save.line + save.temp_line"
			;����\��
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

;�؁[�W�ԍ��`��
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
			@link storage=save_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
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
; �I�����Ŏ����Z�[�u�p
@if exp="save.autosave"
	@locate x="&save.page_basex + save.page_width * save.pagecount" y="&save.page_basey + save.page_height * save.pagecount"
	@nowait
	@if exp="sf.save_page != save.pagecount"
		@link storage=save_mode.ks target=*sub_draw exp="&'sf.save_page = ' + save.pagecount"
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

;�}�E�X�z�C�[�����g�����߂ɁA�t�H�[�J�X�ݒ�
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@return

*show
;����\��
@if exp="save.message_only && kag.getBookMarkDate(save.temp_show) != ''"
	@current layer="&'message' + (kag.numMessageLayers - 2)"
	@er
	@nowait
	@eval exp="kag.tagHandlers.font(save.message_font)"
	@locate x="&save.message_only_x1" y="&save.message_only_y1"
	@emb exp="kag.getBookMarkPageName(save.temp_show)"
	@locate x="&save.message_only_x2" y="&save.message_only_y2"
	@emb exp="save_date(save.temp_show)"
	@resetfont
	@endnowait
	@current layer="&'message' + (kag.numMessageLayers - 1)"
@endif
@s
*dishow
@if exp="save.message_only"
	@current layer="&'message' + (kag.numMessageLayers - 2)"
	@er
	@current layer="&'message' + (kag.numMessageLayers - 1)"
@endif
@s


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
	@call storage=save_mode.ks target=*draw
@else
	@if exp="sf.saveAsk==1"
		@if exp="askYesNo('�Z�[�u�f�[�^���㏑�����܂����H')"
			; �f�[�^���Z�[�u���܂�
			@save place="&save.playing"
			@eval exp="sf.save_new = save.playing"
			; �T���l�C���̕\�����X�V���܂�
			@call storage=save_mode.ks target=*draw
		@endif
	@else
		; �f�[�^���Z�[�u���܂�
		@save place="&save.playing"
		@eval exp="sf.save_new = save.playing"
		; �T���l�C���̕\�����X�V���܂�
		@call storage=save_mode.ks target=*draw
	@endif
@endif
;�}�E�X�z�C�[�����g�����߂ɁA�t�H�[�J�X�ݒ�
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s


;link����T�u���[�`�������邽��
*sub_draw
@call storage=save_mode.ks target=*draw
@s

*back
@tempload bgm=0
@unlocksnapshot
@iscript
// �V�X�e���{�^�����g���Ă��āA�R���t�B�O��ʂ�\������O�Ƀ��b�Z�[�W���C�����\������Ă������� onMessageHiddenStateChanged ���Ăяo���܂�
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(false);
@endscript
;�e���ݒ肷��
;@rclick enabled=true jump=true storage=title.ks target=*title
@history enabled=true output=true
@return

