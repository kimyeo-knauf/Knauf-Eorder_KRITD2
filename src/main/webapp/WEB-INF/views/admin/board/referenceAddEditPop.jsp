<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy.MM.dd" var="nowDate" />
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>
<style type="text/css">
/* .ui-jqgrid-btable .ui-state-highlight { background: gray; } */
.cke_screen_reader_only {height: 0 !important;}
#pageInnerDiv {padding-top: 0;}
</style>

<script type="text/javascript">

$(function(){	
	var accessDevice = '${sessionScope.loginDto.accessDevice}';
	var editImageUploadApi = 'editorFileUpload';
	if('mobile' == accessDevice) editImageUploadApi = 'editorFileUploadForMobile';
	
	CKEDITOR.replace('editor1',{
		toolbar : 'Basic',
		filebrowserImageUploadUrl : '${url}/admin/base/'+editImageUploadApi+'.lime',
		width : '100%',
		height : '410',
	});		

	CKEDITOR.on('dialogDefinition', function ( ev ){
		   if(ev.data.name == 'link'){
		      ev.data.definition.getContents('target').get('linkTargetType')['default']='_blank';
		   }
		}); 
	
	$('.dropify-filename-inner').each(function(i,e){
		var fileInputName = $(e).closest('li').find('input').attr('name');
		var fileName = '${boardOne.BD_FILE}';
		var fileType = '${boardOne.BD_FILETYPE}';
		
		var textHtml = '<a href="javascript:;" onclick=\'fileDown("'+fileName+'","'+fileType+'");\'>'+fileName+'</a>';
		
		$(e).html(textHtml);		
	});

	// dropify 파일 확장자,크기 체크
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileSize', function(evt, el){
		// 2025-03-26 hsg Diving body press : 첨부파일은 300MB 이하로 -> 첨부파일은 200MB 이하로 으로 변경ㄴ
	    alert('첨부파일은 200MB 이하로 등록해 주세요.');
	    evt.stopImmediatePropagation();
	});
	
	
	var linkUse = "${boardOne.BD_LINKUSE}";
	if(linkUse != null && linkUse == 'Y'){
		$('#m_bdlink').show();
	} else {
		$('#m_bdlink').hide();
	}
	
});

/**
 * 데이터 유효성 체크
 */
function dataValidation(){
	if (!$('input[name="m_bdtitle"]').val()) {
		alert('제목을 입력하여 주십시오.');
		$('input[name="m_bdtitle"]').focus();
		return false;
	}
	
	if (!$('select[name="m_bdtype"] option:selected').val()) {
		alert('유형을 선택해주세요.');		
		return false;
	}
	
	var m_bdcontent = CKEDITOR.instances.editor1.getData();
	$('input[name="m_bdcontent"]').val(m_bdcontent);
	
	if (!m_bdcontent) {
		alert('내용을 입력하여 주십시오.');		
		return false;
	}
	
	//중요공지 체크박스
	if($("input[name='notichk']").is(":checked") == true){
		$('input[name="m_bdnoticeyn"]').val('Y');
	}else{
		$('input[name="m_bdnoticeyn"]').val('N');
	}
	
	//2025-05-14 정보공유 자료실 링크여부 추가. 링크 사용시 URL 체크 ijy
	if($('#m_bdlinkuse').is(':checked')){
		if(!$('#m_bdlink').val()){
			alert('URL을 입력해주세요.');
			$('#m_bdlink').focus();
			return false;
		} else {
			if(!isValidURL($('#m_bdlink').val())){
				alert('유효하지 않은 URL입니다. URL 정보를 다시 확인해 주세요.');
				return false;
			}
		}
		
	}
	
	return true;
}

//url 유효성 검사
function isValidURL(url) {
  const urlRegex = /^(http|https):\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$/;
  return urlRegex.test(url);
}

/**
 * 자료실 등록/수정
 */
function dataInUp(obj,processType){ //processType ADD : 등록 , EDIT : 수정
	$(obj).prop('disabled', true);
	
	if(!dataValidation()){
		$(obj).prop('disabled', false);
		return;
	}

	const categ3 = $('select[name="m_bdtype3"]').val();
	if( (categ3 == null) || (categ3 == '') ) {
		alert('유형 3을 선택해 주세요.');

		$(obj).prop('disabled', false);
		return;
	}
	
	$('input[name="r_processtype"]').val(processType);
	if(confirm('저장하시겠습니까?')){
		var $frmPop = $('form[name="frmPop"]')		
		$frmPop.attr('action', '${url}/admin/board/insertUpdateReferenceAjax.lime');
		
		//링크 미사용시 기존 입력된 URL 정보 제거
		if($('#m_bdlinkuse').is(':checked')){
			var m_link = $('#m_bdlink').val().replace(':','&#58;'); //이 특수기호만 개발서버에서 오류 발생. 치환해서 전달 후 컨트롤러에서 재치환. 톰캣 버전 차이로 인한 현상으로 보여짐.
			$('#m_bdlink').val(m_link);
			
		} else {
			$('#m_bdlink').val('');
		}
		
		$frmPop.ajaxForm({		
			type : 'POST',
			cache : false,
			success: function(data) {	
				
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					opener.reloadGridForPop();
					window.open('about:blank', '_self').close();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}		
		}).submit();		
	}else{
		$(obj).prop('disabled', false);
	}
}

 /**
  * 파일다운로드
  */
 function fileDown(file_name,file_type){		
	 $('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');
		
 	// 파일 다운로드.
 	var fileFormHtml = '';
 	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/referenceFileDown.lime">';
 	fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
 	fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
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


 function categorySelected(listType) {
	categorySelectedNum = listType
	if(listType == 1) {
		$('select[name="m_bdtype2"]').empty();
		var textHtml = '<option value="">선택해 주세요.</option>';
		$('select[name="m_bdtype2"]').append(textHtml);

		$('select[name="m_bdtype3"]').empty();
		var textHtml = '<option value="">선택해 주세요.</option>';
		$('select[name="m_bdtype3"]').append(textHtml);
	} else if(listType == 2) {
		$('select[name="m_bdtype3"]').empty();
		var textHtml = '<option value="">선택해 주세요.</option>';
		$('select[name="m_bdtype3"]').append(textHtml);
	}

	var params = {
			r_bdtype : $('select[name="m_bdtype"]').val(),
			r_bdtype2 : $('select[name="m_bdtype2"]').val(),
			r_bdtype3 : $('select[name="m_bdtype3"]').val(),
	}

	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : '${url}/admin/board/getPopupReferenceListAjax.lime',
		success : function( data ){
			var categ = data.referenceCategoryList;
			var categ2 = data.referenceCategory2List;
			var categ3 = data.referenceCategory3List;

			var textHtml = '';
			if(categorySelectedNum == 1) {
				$('select[name="m_bdtype2"]').empty();
				$('select[name="m_bdtype3"]').empty();

				textHtml += '<option value="">선택해 주세요.</option>';
				$(categ2).each(function(i,e){
					textHtml += '<option value="'+e.CC_CODE+'">'+e.CC_NAME+'</option>';
				});
				
				$('select[name="m_bdtype2"]').append(textHtml);

				textHtml = '';
				textHtml += '<option value="">선택해 주세요.</option>';
				$('select[name="m_bdtype3"]').append(textHtml);
			}
			
			if(categorySelectedNum == 2) {
				$('select[name="m_bdtype3"]').empty();

				textHtml = '';
				textHtml += '<option value="">선택해 주세요.</option>';
				$(categ3).each(function(i,e){
					textHtml += '<option value="'+e.CC_CODE+'">'+e.CC_NAME+'</option>';
				});
				
				$('select[name="m_bdtype3"]').append(textHtml);
			}

		},
		error : function(request,status,error){
		}
	});
}

//링크 사용시에만 URL 노출
function toggledByCheckYn() {
	if($('#m_bdlinkuse').is(':checked')){
		$('#m_bdlink').show();
	}else{
		$('#m_bdlink').hide();
	}
}
</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
		<!-- Page Inner -->
		<div class="page-inner" id="pageInnerDiv">
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">									
					
					<form name="frmPop" method="post" enctype="multipart/form-data">
						<input type="hidden" name="m_bdid" value="reference" />
						<input type="hidden" name="r_processtype" value="" />
						<input type="hidden" name="r_bdseq" value="${param.r_bdseq}" />						
						<input type="hidden" name="m_bdnoticeyn" value="${boardOne.BD_NOTICEYN}" />
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
								<c:if test="${empty boardOne}">
									<h4 class="panel-title">자료실등록</h4>
								</c:if>
								<c:if test="${!empty boardOne}">
									<h4 class="panel-title">자료실수정</h4>
								</c:if>
								
								<div class="btnList writeObjectClass">
								 <c:if test="${empty boardOne}">
								 	<button class="btn btn-info" onclick="dataInUp(this,'ADD');" type="button" title="저장">저장</button>
								</c:if>
								<c:if test="${!empty boardOne}">
									<button class="btn btn-info" onclick="dataInUp(this,'EDIT');" type="button" title="저장">저장</button>
								</c:if>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="tableSearch top-view3">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목 *</label>
												<div class="search-c">
													<input type="text" class="search-input form-md-s" name="m_bdtitle" value="${boardOne.BD_TITLE}" onkeyup="checkByte(this, 160);"/>
													<div class="checkbox pull-left" id="div_bdnoticeynId">
<%-- 														<c:if test="${boardOne.BD_NOTICEYN eq 'Y' || empty boardOne }"><c:set var='checked' value="checked='checked'"/></c:if> --%>
														<c:if test="${boardOne.BD_NOTICEYN eq 'Y'}"><c:set var='checked' value="checked='checked'"/></c:if>
														<label class="no-p-r"><input type="checkbox" name="notichk" value="Y" ${checked} />공지여부</label>
													</div>												
												</div>
												
											</li>
											<li>
												<label class="search-h">첨부파일</label>
												<div class="search-c">
														<input type="file" class="dropify" name="m_bdfile" value="" <c:if test="${ !empty boardOne.BD_FILE }">data-default-file="${ url }/data/board/${boardOne.BD_FILE}"</c:if> data-max-file-size="200M" data-show-errors="false"/><!-- 2025-03-26 hsg Diving body press : data-max-file-size값을 300 -> 200 으로 변경 -->
														<a href="${url}/admin/board/boardFileDown.lime?m_bdfile=${boardOne.BD_FILE}" class="dropify-file hide m-t-xxxxs m-l-xxs"><i class="fa fa-arrow-circle-down pull-left m-t-xxs m-r-xxxs f-s-15"></i>${boardOne.BD_FILE}</a> <!-- IE9 -->
												</div>
											</li>
											<li>
												<label class="search-h">출력여부 *</label>
												<div class="search-c radio">
													<c:if test="${boardOne.BD_DISPLAYTYPE eq 'user' || empty boardOne }"><c:set var='user' value="checked='checked'"/></c:if>
													<c:if test="${boardOne.BD_DISPLAYTYPE eq 'admin' }"><c:set var='admin' value="checked='checked'"/></c:if>
													<label><input type="radio" name="m_bddisplaytype" value="user" ${user} />거래처출력</label>
<%--													<label><input type="radio" name="m_bddisplaytype" value="admin" ${admin} />로그인출력</label>													--%>
												</div>
											</li>
											<li class="blank">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li>
											<li>
												<label class="search-h">유형1 *</label>
												<div class="search-c">
													<select class="form-control" name="m_bdtype" onchange="categorySelected(1)">
														<c:forEach items="${referenceCategoryList}" var="list" varStatus="stat">
															<c:if test="${stat.first}">
																<option value="">선택하세요</option>
															</c:if>														
															<option value="${list.CC_CODE}" <c:if test="${boardOne.BD_TYPE eq list.CC_CODE }">selected</c:if>>${list.CC_NAME}</option>														
													 	</c:forEach>
													</select>
												</div>
											</li>
											<li>
												<label class="search-h">유형2 *</label>
												<div class="search-c">
													<select class="form-control" name="m_bdtype2" onchange="categorySelected(2)">
														<c:forEach items="${referenceCategory2List}" var="list" varStatus="stat">
															<c:if test="${stat.first}">
																<option value="">선택하세요</option>
															</c:if>														
															<option value="${list.CC_CODE}" <c:if test="${boardOne.BD_TYPE2 eq list.CC_CODE }">selected</c:if>>${list.CC_NAME}</option>														
													 	</c:forEach>
													</select>
												</div>
											</li>
											<li>
												<label class="search-h">유형3 *</label>
												<div class="search-c">
													<select class="form-control" name="m_bdtype3" onchange="categorySelected(3)">
														<c:forEach items="${referenceCategory3List}" var="list" varStatus="stat">
															<c:if test="${stat.first}">
																<option value="">선택하세요</option>
															</c:if>														
															<option value="${list.CC_CODE}" <c:if test="${boardOne.BD_TYPE3 eq list.CC_CODE }">selected</c:if>>${list.CC_NAME}</option>														
													 	</c:forEach>
													</select>
												</div>
											</li>
											
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													<c:choose>
														<c:when test="${empty boardOne}">
															<input type="text" class="search-input" name="" value="${sessionScope.loginDto.userNm}" readonly="readonly" />
														</c:when>
														<c:otherwise>
															<input type="text" class="search-input" name="" value="${boardOne.USER_NM}" readonly="readonly" />
														</c:otherwise>
													</c:choose>
												</div>
											</li>
											<li>
												<label class="search-h">등록일</label>
												<div class="search-c">
													<c:choose>
														<c:when test="${empty boardOne}">
															<input type="text" class="search-input form-md-d" name="" value="${nowDate}" readonly="readonly" />
														</c:when>
														<c:otherwise>
															<input type="text" class="search-input p-r-md" name="" value="${fn:substring(boardOne.BD_INDATE,0,10)}" readonly="readonly" />	
														</c:otherwise>
													</c:choose>
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<!--  2025-05-14 정보공유 자료실 링크여부 추가 ijy -->
											<li>
												<label class="search-h">링크 여부
													<c:if test="${boardOne.BD_LINKUSE eq 'Y'}"><c:set var='linkYn' value="checked='checked'"/></c:if>
													<label class="no-p-r"> <input type="checkbox" id="m_bdlinkuse" name="m_bdlinkuse" value="Y" ${linkYn} onclick="toggledByCheckYn()" /></label>
												</label>
												<div class="search-c">
													<!--  2025-05-15 정보공유 자료실 링크 길이 제한 제거 ijy -->
													<input type="text" class="search-input form-md-s" id="m_bdlink" name="m_bdlink" value="${boardOne.BD_LINK}" style="display:none;" placeholder="예시)https://www.knauf.com" />
												</div>
											</li>
											
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title">내용 *</h5>
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td class="p-v-sm">
													<textarea id="editor1">${boardOne.BD_CONTENT}</textarea>
													<input type="hidden" name="m_bdcontent" value="" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
						</div>
					</form>
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