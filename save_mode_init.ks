
;�O�����Ɛݒ�
@iscript
var save = %[];
//���������������遫------------------------------------------------------- 
save.save_base = 'black'; //�Z�[�u��ʔw�i�A��������������΁A���O�̃Q�[����ʂ�������
save.load_base = 'black'; //���[�h��ʔw�i�A��������������΁A���O�̃Q�[����ʂ�������
save.save_button = 'save_button'; //�T���l�C���Ɠ����傫���̃{�^��
save.dummy = 'save_dummy'; //���Z�[�u�̎��̃T���l�C��
save.thumbnail_width  = 120; //�T���l�C���̕�
save.thumbnail_height =  90; //�T���l�C���ƍ���
save.line   = 3; //�T���l�C���̍s��
save.column = 4; //�T���l�C���̗�
save.base_x = 30; //�T���l�C������x���W
save.base_y = 80; //�T���l�C������y���W
save.width  = save.thumbnail_width + 50; //�T���l�C���̗�̕�
save.height = save.thumbnail_height + 30; //�T���l�C���̍s�̕�
save.message_only = 1; //�Z�[�u�t�@�C���̏����T���l�C�����Ƃɕ\�����邩�A�ЂƂ����ɂ��邩
save.message_only_x1 = 10; //�Z�[�u�t�@�C���̌��o����x���W
save.message_only_y1 = kag.scHeight - 100; //�Z�[�u�t�@�C���̌��o����y���W
save.message_only_x2 = 10; //�Z�[�u�t�@�C���̓��t��x���W
save.message_only_y2 = kag.scHeight - 50; //�Z�[�u�t�@�C���̓��t��y���W
save.message_x1 = 10 + save.thumbnail_width; //�Z�[�u�t�@�C���̌��o���̃T���l�C������̑���x���W
save.message_y1 = 0; //�Z�[�u�t�@�C���̌��o���̃T���l�C������̑���y���W
save.message_x2 = 10 + save.thumbnail_width; //�Z�[�u�t�@�C���̓��t�̃T���l�C������̑���x���W
save.message_y2 = save.thumbnail_height/2; //�Z�[�u�t�@�C���̓��t�̃T���l�C������̑���y���W
save.message_font = %['size' => 25, 'color' => 0xffffff]; // ���\���̃t�H���g
save.new = 'new'; //�ŐV�̃Z�[�u�ɕ\������}�[�N�摜
save.new_x = 0; //�}�[�N�̃T���l�C������̑���x���W
save.new_y = 0; //�}�[�N�̃T���l�C������̑���y���W
save.page_basex = kag.scWidth-100; //�y�[�W�{�^���̏���x���W
save.page_basey = 100;   //�y�[�W�{�^���̏���y���W
save.page_width = 0;  //�y�[�W�{�^���Ԃ̕�
save.page_height = 50;  //�y�[�W�{�^���Ԃ̍���
save.page_cg = ['1', '2', 'Auto'];  	//�y�[�W�{�^���Ɏg�p����{�^���摜, ���̔z�񂪋�Ȃ當�������łȂ��Ȃ�摜��\������
					//�� save.page_cg = ['1', '2'] �O���珇�Ɏg�p���镪�����w�肷��(Auto�؁[�W���g�p����Ȃ炻����Ō�w�肷��)
save.nowpage_cg = ['off_1', 'off_2', 'off_Auto'];	//�y�[�W�{�^���ɉ摜���g�p����Ƃ��͂����Ɍ��݂̃y�[�W�̉摜���w�肷��
save.page_font = %['italic' => true];  //�y�[�W�{�^���ɕ������g���Ƃ��̃t�H���g
save.autosave = 1; //�I�����ŃI�[�g�Z�[�u�����邩
save.close_x=kag.scWidth-150; //�����x���W
save.close_y=kag.scHeight-50; //�����y���W
save.close_button = '';	//����Ƀ{�^���摜���g�p����Ȃ�w�肷��B��̂Ƃ��͕������g��
save.close_font = %['italic' => true];	//����ɕ������g�p����Ƃ��̃t�H���g
					//(���[�U�[���t�H���g��ύX����ƕs�����̂ł����Ǝw�肷�邱��)
save.change = 1; //�Z�[�u���[�h��ʂő����Ɉړ�����{�^����\�����邩
save.change_to_save_button = '';	//�{�^���摜���g�p����Ȃ�w�肷��B��̂Ƃ��͕������g��
save.change_to_load_button = '';	//�{�^���摜���g�p����Ȃ�w�肷��B��̂Ƃ��͕������g��
save.change_x=100; //x���W
save.change_y=0; //y���W
save.change_font = %['italic' => true]; //�t�H���g
save.maxpage = 2; //�y�[�W��
//���������������遪------------------------------------------------------- 

save.maxpage -= 1;
// ���t��Ԃ�
function save_date(n){
	var saveDate = kag.getBookMarkDate(n);  // �Z�[�u�f�[�^�̓��t���擾���� saveDate �ɑ�����܂�
	if(saveDate != "")
	{
		// �Z�[�u�f�[�^������ꍇ
		var d = new Date(saveDate);  // �Z�[�u�f�[�^�̓��t������ Date �N���X�̃I�u�W�F�N�g�𐶐����܂�
		// : TIME �̍��ڂɕ\�������� �� �Z�[�u�f�[�^�̍쐬����
		return "%d/%d/%d/%02d:%02d".sprintf(d.getYear(), (d.getMonth() + 1), d.getDate(), d.getHours(), d.getMinutes());
	}
}
//��x�������s����
if (sf.save_init === void){
	sf.save_init=1;
}
//��������page�Ŕԍ��̏��������̂��珇��
//�Z�[�u���Ă����A�y�[�W�����܂�����A
//���l�̏��ɏ㏑�����Ă���
//count�ɂ̓V�X�e���ϐ������w��
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
//�}�E�X�z�C�[���p�֐�
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
;Auto�y�[�W�ɏ��ԂɋL�^����
@eval exp="auto_save(save.maxpage + 2, 'auto_save_count')"
@endmacro

@return
