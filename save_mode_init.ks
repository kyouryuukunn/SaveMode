
;�O�����Ɛݒ�
@iscript
var save = %[];
save.save_base = 'black'; //�Z�[�u��ʔw�i
save.load_base = 'black'; //���[�h��ʔw�i
save.save_button = 'save_button'; //�T���l�C���Ɠ����傫���̃{�^��
save.dummy = 'save_dummy'; //���Z�[�u�̎��̃T���l�C��
save.thumbnail_width  = 120; //�T���l�C���̕�
save.thumbnail_height =  90; //�T���l�C���ƍ���
save.line   = 4; //�T���l�C���̍s��
save.column = 2; //�T���l�C���̗�
save.base_x = 30; //�T���l�C������x���W
save.base_y = 80; //�T���l�C������y���W
save.width  = save.thumbnail_width + 260; //�T���l�C���̗�̕�
save.height = save.thumbnail_height + 30; //�T���l�C���̍s�̕�
save.message_x1 = 10 + save.thumbnail_width; //�Z�[�u�t�@�C���̌��o���̃T���l�C������̑���x���W
save.message_y1 = 0; //�Z�[�u�t�@�C���̌��o���̃T���l�C������̑���y���W
save.message_x2 = 10 + save.thumbnail_width; //�Z�[�u�t�@�C���̓��t�̃T���l�C������̑���x���W
save.message_y2 = save.thumbnail_height/2; //�Z�[�u�t�@�C���̓��t�̃T���l�C������̑���y���W
save.message_font = %['size' => 18, 'color' => 0xffffff]; // ���\���̃t�H���g
save.new = 'new'; //�ŐV�̃Z�[�u�ɕ\������}�[�N�摜
save.new_x = 0; //�}�[�N�̃T���l�C������̑���x���W
save.new_y = 0; //�}�[�N�̃T���l�C������̑���y���W
save.page_basex = kag.scWidth-400; //�y�[�W�{�^���̏���x���W
save.page_basey = 0;   //�y�[�W�{�^���̏���y���W
save.page_width = 20;  //�y�[�W�{�^���Ԃ̕�
save.page_height = 0;  //�y�[�W�{�^���Ԃ̍���
save.page_font = %['italic' => true]; //�y�[�W�{�^���̃t�H���g
save.autosave = 1; //�I�����ŃI�[�g�Z�[�u�����邩
save.close_x=kag.scWidth-150; //�����x���W
save.close_y=0; //�����y���W
save.close_font = %['italic' => true]; //����̃t�H���g
save.change = 1; //�Z�[�u���[�h��ʂő����Ɉړ�����
save.change_x=100; //x���W
save.change_y=0; //y���W
save.change_font = %['italic' => true]; //�t�H���g
save.maxpage = 3; //�y�[�W��

save.autocount = 1 + save.column*save.line*save.maxpage;
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
function save_title(n){
	// �Z�[�u�f�[�^�̌��o����Ԃ�
	return kag.getBookMarkPageName(n);
}
//��x�������s����
if (sf.save_init === void){
	sf.auto_save_count=0;
	sf.save_init=1;
}
function auto_save(){
	if (sf.auto_save_count > save.column*save.line - 1){
		sf.auto_save_count=0;
		sf.save_new = save.autocount + sf.auto_save_count;
		sf.save_page = save.maxpage + 1;
		kag.storeBookMark(save.autocount + sf.auto_save_count, false);
	}else{
		sf.auto_save_count+=1;
		sf.save_new = save.autocount + sf.auto_save_count;
		sf.save_page = save.maxpage + 1;
		kag.storeBookMark(save.autocount + sf.auto_save_count, false);
	}
}
@endscript

@macro name=autosave        
@save ask=false place=&auto_save()
@endmacro

@return
