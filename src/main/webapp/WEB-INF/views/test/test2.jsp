<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript">
$(function(){
	
	// ckeditor 이미지 업로드 탭 설정.
	CKEDITOR.on('dialogDefinition', function(ev){
        var dialogName = ev.data.name;
        var dialog = ev.data.definition.dialog;
        var dialogDefinition = ev.data.definition;
        var editor = ev.editor;
        if (dialogName == 'image') {
            dialog.on('show', function (obj) {
                this.selectPage('Upload'); //업로드텝으로 바로 이동
            });
        }
        dialogDefinition.removeContents('advanced'); // 자세히 탭 삭제 
        dialogDefinition.removeContents('Link'); // 링크 탭 삭제 
       // ckeditor 설치 폴더에서 plugins/image/dialogs/image.js 이곳에서 해당 앨리먼트 확인
        var infoTab = dialogDefinition.getContents('info'); //info탭을 제거하면 이미지 업로드가 안된다.
        //infoTab.remove('txtUrl');
        infoTab.remove('txtHSpace');
        infoTab.remove('txtVSpace');
        infoTab.remove('txtBorder');
        //infoTab.remove('txtWidth');
        //infoTab.remove('txtHeight');
        infoTab.remove('ratioLock');
        infoTab.remove('cmbAlign');
    });
	CKEDITOR.on('instanceReady', function(evt) { // 이미지 태그에 클래스 추가.
		evt.editor.dataProcessor.htmlFilter.addRules( {
			elements: {
				img: function(el) {
					el.addClass('editorImageClass');
				}
			}
		});
	});
	
	/*****************************************************************************************
	 * PC CKEditor. > PC와 Mobile을 구분 하지 않을경우 toobar는 공통적으로 설정.
	 *****************************************************************************************/
	CKEDITOR.replace(
		'editor1',
		{
			//toolbar : 'Basic',
			toolbar : [
		      ['Font', 'FontSize'],
		      ['BGColor', 'TextColor'],
		      ['Bold', 'Italic', 'Strike', 'Superscript', 'Subscript', 'Underline', 'RemoveFormat'],   
		      ['BidiLtr', 'BidiRtl'],
		      '/',
		      ['Image', 'SpecialChar', 'Smiley'],
		      ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
		      ['Blockquote', 'NumberedList', 'BulletedList'],
		      ['Link', 'Unlink'],
		      ['Source'],
		      ['Undo', 'Redo']
		    ],
			filebrowserImageUploadUrl : '${url}/admin/base/editorFileUpload.lime?type=Images',
			//skin : 'moonocolor',
			width : '100%',
			height : '200'
		}
	);
	
	 /*****************************************************************************************
	 * 모바일 CKEditor. > 이미지 업로드만 있음. > PC와 Mobile을 구분 하지 않을경우 toobar는 공통적으로 설정.
	 *****************************************************************************************/
	CKEDITOR.replace(
		'editor2',
		{
			toolbar : [['Image']],
			removePlugins : 'elementspath', // 하단 태그 선택 삭제.
			filebrowserImageUploadUrl : '${url}/admin/base/editorFileUploadForMobile.lime?type=Images',
			width : '100%', // 공통설정
			height : '200', // 공통설정
		}
	);
});

function insertByForm(obj){
	$(obj).prop('disabled', true);
	
	var frmObj = $(obj).closest('form');
	
	var ckflag = dataValidation(frmObj);
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if(!confirm('저장 하시겠습니까?')){
		$(obj).prop('disabled', false);
		return;
	}
	
	formPostSubmit($(frmObj).attr('name'), '${url}/test/insertTestByForm.lime');
	$(obj).prop('disabled', false);
}

function insertByAjax(obj){
	$(obj).prop('disabled', true);
	
	var frmObj = $(obj).closest('form');
	
	var ckflag = dataValidation(frmObj);
	if(!ckflag) {
		$(obj).prop('disabled', false);
		return;
	}
	
	if(!confirm('저장 하시겠습니까?')){
		$(obj).prop('disabled', false);
		return;
	}
	
	$.ajax({
		async : false,
		data : {
			m_ts1 : $(frmObj).find('input[name="m_ts1"]').val()
			, m_ts2 : $(frmObj).find('input[name="m_ts2"]').val()
			, m_ts3 : $(frmObj).find('input[name="m_ts3"]').val()
		},
		type : 'POST',
		url : '${url}/test/insertTestByAjax.lime',
		success : function(data){
			if('0000' == data.RES_CODE){
				$('#listTbodyId').empty();
				var htmlBody = '';
				$(data.list).each(function(i,e){
					htmlBody += '<tr>';
					htmlBody += '	<td>'+e.ts_0+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_1)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_2)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_3)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_INDATE1)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_INDATE2)+'</td>';
					htmlBody += '</tr>';
				});
				$('#listTbodyId').append(htmlBody);

				alert(data.RES_MSG);
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			$(obj).prop('disabled', false);
		}
	});
}

function insertByAjaxSubmit(obj){
	$(obj).prop('disabled', true);
	
	var frmObj = $(obj).closest('form');
	
	var ckflag = dataValidation(frmObj);
	if(!ckflag) {
		$(obj).prop('disabled', false);
		return;
	}
	
	if(!confirm('저장 하시겠습니까?')){
		$(obj).prop('disabled', false);
		return;
	}
	
	$(frmObj).ajaxSubmit({
		dataType : 'json',
		type : 'post',
		url : '${url}/test/insertTestByAjax.lime',
		//url : '${url}/test/insertTestByAjaxSubmit.lime',
		//async : false, //사용x
		//data : param, //사용x
		success : function(data) {
			if(data.RES_CODE == '0000') {
				alert(data.RES_MSG);
				//window.location.reload();
			}
			return;
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			$(obj).prop('disabled', false);
		},
		/* 
		beforeSend: function(xhr){
			$('#ajax_indicator').show().fadeIn('fast');
		},
		uploadProgress: function(event, position, total, percentComplete){
		},
        complete: function( xhr ){
        	$('#ajax_indicator').fadeOut();
		}
		*/
	});
}

function dataValidation(frmObj){
	var ckflag = true;
	
	var m_ts3 = ('frm1' == $(frmObj).attr('name')) ? CKEDITOR.instances.editor1.getData() : CKEDITOR.instances.editor2.getData();
	$( 'input[name="m_ts3"]' ).val(m_ts3);
	
	if(ckflag) ckflag = validation($(frmObj).find('input[name="m_ts1"]')[0], '1번값', 'value');
	return ckflag;
}

</script>
</head>

<body>
	<form method="post" name="frm1">
	<table border="1">
		<tbody>
			<tr>
				<td colspan="2">### PC CKEditor > PC와 Mobile을 구분 하지 않을경우 toobar는 공통적으로 설정.</td>
			</tr>
			<tr>
				<td>
					<input class="" name="m_ts1" placeholder="필수값 VARCHAR2(10)" type="text" value="" onkeyup="checkByte(this, 10);" />
				</td>
				<td>
					<input class="" name="m_ts2" placeholder="VARCHAR2(200)" type="text" value="" onkeyup="checkByte(this, 200);" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<textarea id="editor1"></textarea>
					<input name="m_ts3" type="hidden" value="" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" onclick="insertByForm(this);">Insert By Form</button>
					<button type="button" onclick="insertByAjax(this);">Insert By Ajax</button>
					<button type="button" onclick="insertByAjaxSubmit(this);">Insert By AjaxSubmit</button>
				</td>
			</tr>
		</tbody>
	</table>
	</form>
	
	<br />
	
	<form method="post" name="frm2">
	<table border="1">
		<tbody>
			<tr>
				<td colspan="2">### Mobile CKEditor 이미지 업로드만 사용 > PC와 Mobile을 구분 하지 않을경우 toobar는 공통적으로 설정.</td>
			</tr>
			<tr>
				<td>
					<input class="" name="m_ts1" placeholder="필수값 VARCHAR2(10)" type="text" value="" onkeyup="checkByte(this, 10);" />
				</td>
				<td>
					<input class="" name="m_ts2" placeholder="VARCHAR2(200)" type="text" value="" onkeyup="checkByte(this, 200);" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<textarea id="editor2"></textarea>
					<input name="m_ts3" type="hidden" value="" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" onclick="insertByForm(this);">Insert By Form</button>
					<button type="button" onclick="insertByAjax(this);">Insert By Ajax</button>
					<button type="button" onclick="insertByAjaxSubmit(this);">Insert By AjaxSubmit</button>
				</td>
			</tr>
		</tbody>
	</table>
	</form>
	
	
</body>
</html>