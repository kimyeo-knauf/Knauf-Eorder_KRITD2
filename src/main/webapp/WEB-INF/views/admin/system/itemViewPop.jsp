<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>
<script type="text/javascript">
$(function(){
	// 연관검색어 디폴트 세팅 > 품목코드,품목명1,품목명2,SEARCH_TEXT,구매단위,두께명,길이명,폭명,약칭코드
	
	$('.dropify-filename-inner').each(function(i,e){
		var tdObj = $(e).closest('td');
		var fileNum = toStr($(tdObj).attr('fileNumAttr'));
		var fileName = toStr($(tdObj).attr('fileNameAttr'));
		var fileType = toStr($(tdObj).attr('fileTypeAttr'));
		
		//var fileObj = $(tdObj).find('input:file[name="m_itifile'+fileNum+'"]').wrap('div').parent().html();
		
		if('' != fileName){
			textHtml = '<a href="javascript:;" onclick=\'fileDown("${item.ITI_ITEMCD}", "'+fileNum+'","'+fileName+'","'+fileType+'");\' ><i class="fa fa-download"></i>'+fileName+'</a>';
			//textHtml = '<a href="javascript:;" onclick=\'fn_previewImg("m_itifile'+fileNum+'", "imgId", "imgPId");\' ><i class="fa fa-download"></i>'+fileName+'</a>';
		}
		else{
			textHtml = '<a href="javascript:;" onclick=\'fn_previewImg("m_itifile'+fileNum+'", "imgId", "imgPId");\' >'+fileName+'</a>';
		}

		$(e).html(textHtml);
	});	
	
	
	// dropify 이미지 업로드 제한 조건 세팅.
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileExtension', function(evt, el){
	    alert('gif,png,jpg,jpeg 파일만 업로드 할 수 있습니다.');
	    evt.stopImmediatePropagation();
	});
	drEvent.on('dropify.error.fileSize', function(evt, el){
	    alert('이미지는 10MB 이하로 등록해 주세요.');
	    evt.stopImmediatePropagation();
	});
});

$(document).ready(function() {
	setImage('m_itifile1', '${item.ITI_FILE1}');
});

//이미지 미리보기 세팅.
function setImage(objName, fileName){
	if ('' != toStr(fileName)) {
		var imgSrc = '${url}/data/fireproof/'+fileName;
		var imgOnerror = 'this.src=\'${url}/include/images/admin/list_noimg.gif\'';
		$('#imgId').attr('src', imgSrc);
		$('#imgId').attr('onerror', imgOnerror);
	}
}

//이미지 미리보기.
function fn_previewImg(name, img, imgDiv){ //img=img ID, imgDiv=div ID
	var obj = $('input[name="'+name+'"]')[0];
	console.log('obj : ', $('.dropify-filename-inner').text());

	
	if($(obj).val() != ''){
		if(window.FileReader){
			 /*IE 9 이상에서는 FileReader  이용*/
			var reader = new FileReader();
			reader.onload = function (e) {
				$('#'+img).attr('src', e.target.result);
			};
			reader.readAsDataURL(obj.files[0]);
			return obj.files[0].name;  // 파일명 return
		}
		else{
			/* IE8 전용 이미지 미리보기 */
			var preImgDiv = document.getElementById(imgDiv);
			var preImg = document.getElementById(img);
			if( preImgDiv ) {
				 preImgDiv.removeChild(preImg);
			}

			obj.select();
			var src = obj.value;
			//var src = document.selection.createRange().text;
			$('#'+img).attr('src',src);
			var afterImg = document.getElementById(imgDiv);
			afterImg.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ src + "', sizingMethod='scale')";
		}
	}
	<c:set var="ITI_FILE1" value="EEE, d MMM yyyy h:mm:ss aa" />
	
}

//이미지 삭제.
function delImage(obj, objName, fileName){
	console.log(obj);
	console.log(objName);
	console.log(toStr(fileName));
	if('' == toStr(fileName)) return;
	
	$('input[name="'+objName+'_delyn"]').val('Y');
	var drEvent = $('input[name="'+objName+'"]').dropify();
	drEvent = drEvent.data('dropify');
	drEvent.resetPreview();
	drEvent.clearElement();
	drEvent.settings['defaultFile'] = '${url}/include/images/admin/list_noimg.gif';
	drEvent.destroy();
	drEvent.init();
}


//저장.
function dataUp(obj) {
	$(obj).prop('disabled', true);
	
	if (confirm('저장 하시겠습니까?')) {
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/system/updateFireproofImageAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					//window.location.reload();
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
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
	} else {
		$(obj).prop('disabled', false);
		return;
	}
}


</script>
	
</head>

<body class="bg-n">
	
	<!-- Modal -->
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title">품목상세
						<div class="page-right">
							<button type="button" class="btn btn-info" onclick="dataUp(this);">저장</button>
						</div>					
					</h4>
					
				</div>
				<div class="modal-body">
					<div class="table-responsive">
					
						<form action="" enctype="multipart/form-data" method="post" name="frm">
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="15%" />
								<col width="20%" />
								<col width="15%" />
								<col width="*" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<td rowspan="6" colspan="2" class="profile-img text-center">
										<p id="imgPId" style="margin: 0; height: 242px;">
											<img class="full-height b b-light-gray" id="imgId" src="${url}/include/images/admin/list_noimg.gif" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" alt="image" />
										</p>
									</td>
									<th>품목코드</th>
									<td colspan="3">
									<c:if test="${!empty item.KEYCODE}">${item.KEYCODE}</c:if> 
									</td>
								</tr>
								<tr>
									<th>내화구조타입</th>
									<td colspan="3">
									<c:if test="${!empty item.FIREPROOFTYPE}">${item.FIREPROOFTYPE}</c:if> 
									</td>
								</tr>
								<tr>
									<th>설명1</th>
									<td colspan="3">
									<c:if test="${!empty item.DESC1}">${item.DESC1}</c:if> 
									</td>
								</tr>
								<tr>
									<th>설명2</th>
									<td colspan="3">
									<c:if test="${!empty item.DESC2}">${item.DESC2}</c:if> 
									</td>
								</tr>
								<tr>
									<th>시간</th>
									<td colspan="3">
									<c:if test="${!empty item.FIRETIME}">${item.FIRETIME}</c:if> 
									</td>
								</tr>
								<tr>
									<th>Active</th>
									<td>${item.ACTIVE}</td>
									<th>Display 순서</th>
									<td>${item.DISPLAYORDER}</td>
								</tr>
 								<!-- <tr> 
									<th>SEARCH-TEXT</th>
									<td colspan="3">${item.SEARCH_TEXT}</td>
								</tr> -->
								<tr>
									<input type="hidden" name="r_itemcd" value="${param.r_itemcd}" />
									<td style="text-align: right;"><button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile1', '${item.ITI_FILE1}');">삭제하기</button></td>
									<td colspan="3" fileNumAttr="1" fileNameAttr="${item.ITI_FILE1}" fileTypeAttr="${item.ITI_FILE1TYPE}">
										<input type="file" class="dropify" id="m_itifile1" name="m_itifile1" <c:if test="${!empty item.ITI_FILE1}">data-default-file="${url}/data/fireproof/${item.ITI_FILE1}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile1', 'imgId', 'imgPId');" />
										<input type="hidden" name="m_itifile1_delyn" value="N" />
									</td>
									<th>등록일</th>
									<td>${item.CREATEDATE2}</td>
								</tr>
							</tbody>
						</table>
						</form>
					
					</div>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>