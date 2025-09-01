<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript">
var isEdit = ('' != toStr('${item.ITI_ITEMCD}')) ? true : false; // false=최초 ItemInfo 인서트인경우.

$(function(){
	// 연관검색어 디폴트 세팅 > 품목코드,품목명1,품목명2,SEARCH_TEXT,구매단위,두께명,길이명,폭명,약칭코드
	var itiSearchWord = $('input[name="m_itisearchword"]').val();
	var m_itisearchword = '';
	if('' == itiSearchWord){
		m_itisearchword += toStr('${item.ITEM_CD}');
		if('' != toStr('${item.DESC1}')) m_itisearchword += ',' + toStr('${item.DESC1}');
		if('' != toStr('${item.DESC2}')) m_itisearchword += ',' + toStr('${item.DESC2}');
		if('' != toStr('${item.SEARCH_TEXT}')) m_itisearchword += ',' + toStr('${item.SEARCH_TEXT}');
		if('' != toStr('${item.UNIT4}')) m_itisearchword += ',' + toStr('${item.UNIT4}');
		if('' != toStr('${item.THICK_NM}')) m_itisearchword += ',' + toStr('${item.THICK_NM}');
		if('' != toStr('${item.LENGTH_NM}')) m_itisearchword += ',' + toStr('${item.LENGTH_NM}');
		if('' != toStr('${item.WIDTH_NM}')) m_itisearchword += ',' + toStr('${item.WIDTH_NM}');
		if('' != toStr('${item.SHORT_CD}')) m_itisearchword += ',' + toStr('${item.SHORT_CD}');
		
		$('input[name="m_itisearchword"]').val(escapeXss(m_itisearchword));
	}

	$('.dropify-filename-inner').each(function(i,e){
		var tdObj = $(e).closest('td');
		var fileNum = toStr($(tdObj).attr('fileNumAttr'));
		var fileName = toStr($(tdObj).attr('fileNameAttr'));
		var fileType = toStr($(tdObj).attr('fileTypeAttr'));
		
		//var fileObj = $(tdObj).find('input:file[name="m_itifile'+fileNum+'"]').wrap('div').parent().html();
		var textHtml = '';
		
		if(!isEdit){
			textHtml = '<a href="javascript:;" onclick=\'fn_previewImg("m_itifile'+fileNum+'", "imgId", "imgPId");\' >'+fileName+'</a>';
		}
		else{
			if('' != fileName){
				textHtml = '<a href="javascript:;" onclick=\'fileDown("${item.ITI_ITEMCD}", "'+fileNum+'","'+fileName+'","'+fileType+'");\' ><i class="fa fa-download"></i>'+fileName+'</a>';
				//textHtml = '<a href="javascript:;" onclick=\'fn_previewImg("m_itifile'+fileNum+'", "imgId", "imgPId");\' ><i class="fa fa-download"></i>'+fileName+'</a>';
			}
			else{
				textHtml = '<a href="javascript:;" onclick=\'fn_previewImg("m_itifile'+fileNum+'", "imgId", "imgPId");\' >'+fileName+'</a>';
			}
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

function fileDown(file_code, file_num, file_name, file_type){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');
	
	setImage('m_itifile'+file_num, file_name);
	
	// 파일 다운로드.
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/item/itemFileDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_filecode" value="'+file_code+'" />';
	fileFormHtml += '	<input type="hidden" name="r_filenum" value="'+file_num+'" />';
	fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
	// fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
	fileFormHtml += '	<input type="hidden" name="filetoken" value="'+token+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); // common.js 위치.
	
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        //console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}

// 이미지 미리보기 세팅.
function setImage(objName, fileName){
	if ('' != toStr(fileName)) {
		var imgSrc = '${url}/data/item/'+fileName;
		var imgOnerror = 'this.src=\'${url}/include/images/admin/list_noimg.gif\'';
		$('#imgId').attr('src', imgSrc);
		$('#imgId').attr('onerror', imgOnerror);
	}
}

// 이미지 미리보기.
function fn_previewImg(name, img, imgDiv){ //img=img ID, imgDiv=div ID
	var obj = $('input[name="'+name+'"]')[0];
	console.log('obj : ', obj);
	
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
}

// 이미지 삭제.
function delImage(obj, objName, fileName){
	if('' == toStr(fileName)) return;
	
	// 이미지1은 2,3,4,5가 있는경우 삭제 할수 없음.
	if('m_itifile1' == objName){
		if('none' != $('input[name="m_itifile2"]').closest('td').find('.dropify-preview').css('display')
			|| 'none' != $('input[name="m_itifile3"]').closest('td').find('.dropify-preview').css('display')
			|| 'none' != $('input[name="m_itifile4"]').closest('td').find('.dropify-preview').css('display')
			|| 'none' != $('input[name="m_itifile5"]').closest('td').find('.dropify-preview').css('display')
		){
			alert('이미지2,3,4,5가 없는 경우에만 삭제 가능 합니다.');
			return;
		}
	}
	
	$('input[name="'+objName+'_delyn"]').val('Y');
	var drEvent = $('input[name="'+objName+'"]').dropify();
	drEvent = drEvent.data('dropify');
	drEvent.resetPreview();
	drEvent.clearElement();
}

// 저장.
function dataUp(obj) {
	$(obj).prop('disabled', true);
	
	var checkTf = dataValidation();
	if (!checkTf) {
		$(obj).prop('disabled', false);
		return;
	}
	
	if (confirm('저장 하시겠습니까?')) {
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/item/updateItemAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					window.location.reload();
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

// 품목 선택 팝업 띄우기.
function openItemPop(obj){
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').find('input[name="page_type"]').val('recommend');
	$('form[name="frm_pop"]').find('input[name="r_multiselect"]').val('true');
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/itemListPop.lime';
	window.open('', 'itemListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit();
}

// return 품목 팝업에서 다중 선택.
function setItemFromPop(jsonArray){
	//console.log('jsonArray : ', jsonArray);
	
	// 디폴트 행 삭제.
	if('' == $('#recommendTbodyId tr').find('input[name="m_itrrecitemcd"]').val()){
		$('#recommendTbodyId tr').find('input[name="m_itrrecitemcd"]').closest('tr').remove();
	}
	
	// 행 추가.
	for(var i=0,j=jsonArray.length; i<j; i++){
		var textHtml = '';
		var nowRowCnt = getItemRow();
		
		if(9 >= nowRowCnt){ // 10개까지 등록 가능.
			var itemCd = jsonArray[i]['ITEM_CD'];
			var desc1 = jsonArray[i]['DESC1'];
			var desc2 = jsonArray[i]['DESC2'];
			var desc = desc1+' '+desc2;
			
			// 중복체크 + 노출순서 세팅.
			var check = true;
			var maxSort = 1;
			$('#recommendTbodyId tr').each(function(i,e){
				if(itemCd == $(e).find('input[name="m_itrrecitemcd"]').val()){
					check = false;
				}
				maxSort = toInt($(e).find('input[name="m_itrsort"]').val())+1;
			});
			if(!check) continue;
			
			textHtml += '<tr>';
			textHtml += '	<td>';
			textHtml += '		<input type="text" name="v_desc" class="full-width" readonly="readonly" value="'+desc+'" placeholder="품목을 선택해 주세요. 최대 10개까지 등록 가능 합니다." />';
			textHtml += '		<input type="hidden" name="m_itrrecitemcd" value="'+itemCd+'" />';
			textHtml += '	</td>';
			textHtml += '	<td class="text-center">';
			textHtml += '		<input type="text" name="m_itrsort" class="full-width text-right numberClass" value="'+maxSort+'" onchange=\'checkByte(this, "5");\' />';
			textHtml += '	</td>';
			textHtml += '	<td>';
			textHtml += '		<input type="button" class="btn btn-xs btn-default" value="삭제" onclick="delItemRow(this);" />';
			textHtml += '	</td>';
			textHtml += '</tr>';
			
			$('#recommendTbodyId').append(textHtml);
			
			$('.numberClass').autoNumeric('init', aNNumberOption);
		}
	}
}

// return 관련품목 로우 개수.
function getItemRow(){
	var rowCnt = 0; 
	$('#recommendTbodyId tr').each(function(i,e){
		if('' !== $(e).find('input[name="m_itrrecitemcd"]').val()){
			rowCnt++;
		}
	});
	return rowCnt;
}

// 관련품목 로우 삭제 하기.
function delItemRow(obj){
	var nowRowCnt = getItemRow();
	if(1 >= nowRowCnt){
		$(obj).closest('tr').find('input[name="v_desc"]').val('');
		$(obj).closest('tr').find('input[name="m_itrrecitemcd"]').val('');
		$(obj).closest('tr').find('input[name="m_itrsort"]').val('');
		return;
	}
	$(obj).closest('tr').remove();
}
 
/** 
 * 유효성체크
 */
function dataValidation() {
	var ckflag = true;
	
	// 관련품목 노출순서 입력여부 체크.
	if(ckflag){
		$('#recommendTbodyId > tr').each(function(i,e){
			if('' != $(e).find('input[name="m_itrrecitemcd"]').val() && '' == $(e).find('input[name="m_itrsort"]').val()){
				alert('관련품목의 노출순서를 입력해 주세요.');
				$(e).find('input[name="m_itrsort"]').focus();
				ckflag = false;
			}
		});
	}

	var m_itisearchword = $('input[name="m_itisearchword"]').val();
	if(ckflag && m_itisearchword === ''){
		alert('연관검색어를 입력해주세요.');
		ckflag = false;
	}

	return ckflag;
}
</script>
</head>

<body class="page-header-fixed pace-done compact-menu searchHidden">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
	
		<%-- 팝업 전송 form --%>
		<form name="frm_pop" method="post" target="itemListPop" width="800" height="600">
			<input name="pop" type="hidden" value="1" />
			<input name="page_type" type="hidden" value="" />
			<input name="r_multiselect" type="hidden" value="true" /> <%-- 행 단위 선택 가능여부 T/F --%>
		</form>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					품목수정
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="목록" onclick="location.href ='${url}/admin/item/itemList.lime'"><i class="fa fa-list-ul"></i><em>목록</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
						
							<form action="" enctype="multipart/form-data" method="post" name="frm">
							<input type="hidden" name="r_itemcd" value="${param.r_itemcd}" />
							
							<div class="panel-body">
								<h5 class="table-title">품목관리</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" onclick="dataUp(this);">저장</button>
								</div>
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="12%" />
											<col width="38%" />
											<col width="12%" />
											<col width="38%" />
										</colgroup>
										<tbody>
											<tr>
												<th>분류</th>
												<td>
													${item.SALES_CD1_NM}
													<c:if test="${!empty item.SALES_CD2_NM}"> > ${item.SALES_CD2_NM}</c:if>
													<c:if test="${!empty item.SALES_CD3_NM}"> > ${item.SALES_CD3_NM}</c:if>
 													<%-- <c:if test="${!empty item.SALES_CD4_NM}"> > ${item.SALES_CD4_NM}</c:if> --%>
												</td>
												<th>품목코드</th>
												<td>${item.ITEM_CD}</td>
											</tr>
											<tr>
												<th>품목명1</th>
												<td>${item.DESC1}</td>
												<th>품목명2</th>
												<td>${item.DESC2}</td>
											</tr>
											<tr>
												<th>SEARCH-TEXT</th>
												<td colspan="3">${item.SEARCH_TEXT}</td>
											</tr>
											<tr>
												<th>구매단위</th>
												<td>${item.UNIT4}</td>
												<th>재고유형</th>
												<td>${item.STOCK_TY}</td>
											</tr>
											<tr>
												<th>두께명</th>
												<td>${item.THICK_NM}</td>
												<th>폭명</th>
												<td>${item.WIDTH_NM}</td>
											</tr>
											<tr>
												<th>길이명</th>
												<td>${item.LENGTH_NM}</td>
												<th>약칭코드</th>
												<td>${item.SHORT_CD}</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title">기타 e-Ordering 품목관리</h5>
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="12%" />
											<col width="9.33333333%" />
											<col width="15%" />
											<col width="24.33333333%" />
											<col width="15%" />
											<col width="24.33333333%" />
										</colgroup>
										<tbody>
											<tr>
												<th>관련품목 (최대10개)</th>
												<td colspan="5">
													<table border="1" style="float: left; width: 84%; border-color: #dddddd;">
														<colgroup>
															<col width="80%" />
															<col width="15%" />
															<col width="20%" />
														</colgroup>
														<thead>
															<tr>
																<th class="text-center">품목 *</th>
																<th class="text-center">노출순서 *</th>
																<th class="text-center">삭제</th>
															</tr>
														</thead>
														<tbody id="recommendTbodyId">
															<c:choose>
																<c:when test="${empty itemRecommendList}">
																<tr>
																	<td>
																		<input type="text" name="v_desc" class="full-width" readonly="readonly" placeholder="품목을 선택해 주세요. 최대 10개까지 등록 가능 합니다." />
																		<input type="hidden" name="m_itrrecitemcd" value="" />
																	</td>
																	<td class="text-center">
																		<input type="text" name="m_itrsort" class="full-width text-right numberClass" onchange="checkByte(this, '5');" placeholder="숫자만 입력" />
																	</td>
																	<td>
																		<input type="button" class="btn btn-xs btn-default" value="삭제" onclick="delItemRow(this);" />
																	</td>
																</tr>
																</c:when>
																
																<c:otherwise>
																	<c:forEach items="${itemRecommendList}" var="list">
																	<tr>
																		<td>
																			<input type="text" name="v_desc" class="full-width" readonly="readonly" value="${list.DESC1} ${list.DESC2}" placeholder="품목을 선택해 주세요. 최대 10개까지 등록 가능 합니다." />
																			<input type="hidden" name="m_itrrecitemcd" value="${list.ITR_RECITEMCD}" />
																		</td>
																		<td class="text-center">
																			<input type="text" name="m_itrsort" class="full-width text-right numberClass" value="${list.ITR_SORT}" onchange="checkByte(this, '5');" placeholder="숫자만 입력" />
																		</td>
																		<td>
																			<input type="button" class="btn btn-xs btn-default" value="삭제" onclick="delItemRow(this);" />
																		</td>
																	</tr>
																	</c:forEach>
																</c:otherwise>
															</c:choose>
														</tbody>
													</table>
													
													<input type="button" class="btn btn-md btn-line m-l-xxs" value="품목선택" onclick="openItemPop(this);" />
												</td>
											</tr>
											
											<tr>
												<th rowspan="3">이미지</th>
												<td rowspan="3">
													<p id="imgPId" style="margin: 0; height: 97px;">
														<img class="full-height b b-light-gray" id="imgId" src="${url}/include/images/admin/list_noimg.gif" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" alt="image" />
													</p>
												</td>
												<th>이미지1 <button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile1', '${item.ITI_FILE1}');">삭제</button></th>
												<td fileNumAttr="1" fileNameAttr="${item.ITI_FILE1}" fileTypeAttr="${item.ITI_FILE1TYPE}">
													<input type="file" class="dropify" id="m_itifile1" name="m_itifile1" <c:if test="${!empty item.ITI_FILE1}">data-default-file="${url}/data/item/${item.ITI_FILE1}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile1', 'imgId', 'imgPId');" />
													<input type="hidden" name="m_itifile1_delyn" value="N" />
												</td>
												<th>이미지2 <button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile2', '${item.ITI_FILE2}');">삭제</button></th>
												<td fileNumAttr="2" fileNameAttr="${item.ITI_FILE2}" fileTypeAttr="${item.ITI_FILE2TYPE}">
													<input type="file" class="dropify" name="m_itifile2" <c:if test="${!empty item.ITI_FILE2}">data-default-file="${url}/data/item/${item.ITI_FILE2}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile2', 'imgId', 'imgPId');" />
													<input type="hidden" name="m_itifile2_delyn" value="N" />
												</td>
											</tr>
											<tr>
												<th>이미지3 <button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile3', '${item.ITI_FILE3}');">삭제</button></th>
												<td fileNumAttr="3" fileNameAttr="${item.ITI_FILE3}" fileTypeAttr="${item.ITI_FILE3TYPE}">
													<input type="file" class="dropify" name="m_itifile3" <c:if test="${!empty item.ITI_FILE3}">data-default-file="${url}/data/item/${item.ITI_FILE3}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile3', 'imgId', 'imgPId');" />
													<input type="hidden" name="m_itifile3_delyn" value="N" />
												</td>
												<th>이미지4 <button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile4', '${item.ITI_FILE4}');">삭제</button></th>
												<td fileNumAttr="4" fileNameAttr="${item.ITI_FILE4}" fileTypeAttr="${item.ITI_FILE4TYPE}">
													<input type="file" class="dropify" name="m_itifile4" <c:if test="${!empty item.ITI_FILE4}">data-default-file="${url}/data/item/${item.ITI_FILE4}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile4', 'imgId', 'imgPId');" />
													<input type="hidden" name="m_itifile4_delyn" value="N" />
												</td>
											</tr>
											<tr>
												<th>이미지5 <button type="button" class="btn btn-xs btn-default m-l-xxs" onclick="delImage(this, 'm_itifile5', '${item.ITI_FILE5}');">삭제</button></th>
												<td fileNumAttr="5" fileNameAttr="${item.ITI_FILE5}" fileTypeAttr="${item.ITI_FILE5TYPE}">
													<input type="file" class="dropify" name="m_itifile5" <c:if test="${!empty item.ITI_FILE5}">data-default-file="${url}/data/item/${item.ITI_FILE5}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" onchange="fn_previewImg('m_itifile5', 'imgId', 'imgPId');" />
													<input type="hidden" name="m_itifile5_delyn" value="N" />
												</td>
												<td colspan="2"></td>
											</tr>
											
											<tr>
												<th>연관검색어</th>
												<td colspan="5">
													<input type="text" class="full-width" name="m_itisearchword" placeholder="" onchange="checkByte(this, '2000');" value="${item.ITI_SEARCHWORD}" />
												</td>
											</tr>
											<tr>
												<th>파레트적재단위</th>
												<td colspan="5">
													<input type="text" class="w-11 text-right amountClass2" name="m_itipallet" placeholder="" value="${item.ITI_PALLET}" />
												</td>
											</tr>
											<tr>
												<th>링크</th>
												<td colspan="5">
													<input type="text" class="full-width" name="m_itilink" placeholder="" value="${item.ITI_LINK}" onchange="checkByte(this, '300');"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								
							</div>
							
							</form>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>
</html>