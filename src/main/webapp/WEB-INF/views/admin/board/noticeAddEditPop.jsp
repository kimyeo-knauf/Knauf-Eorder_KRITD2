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
	
	
	//파일다운로드 세팅
	$('.dropify-filename-inner').each(function(i,e){
		var fileInputName = $(e).closest('li').find('input').attr('name');
		var isMbdFile = 'm_bdfile' == fileInputName;	// false = m_bdimage
		
		var fileName = (isMbdFile) ? '${boardOne.BD_FILE}' : '${boardOne.BD_IMAGE}';	
		var fileType = (isMbdFile) ? '${boardOne.BD_FILETYPE}' : '${boardOne.BD_IMAGETYPE}';
		
		var textHtml = '<a href="javascript:;" onclick=\'fileDown("'+fileName+'","'+fileType+'");\'>'+fileName+'</a>';
		
		$(e).html(textHtml);		
	});

	// dropify 파일 확장자,크기 체크
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileExtension', function(evt, el){
	    alert('gif,png,jpg,jpeg 파일만 업로드 할 수 있습니다.');
	    evt.stopImmediatePropagation();
	});
	drEvent.on('dropify.error.fileSize', function(evt, el){
	    alert('로그인출력 이미지는 10MB 이하로 등록해 주세요.');
	    evt.stopImmediatePropagation();
	});
	
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
	
	var m_bdcontent = CKEDITOR.instances.editor1.getData();
	$('input[name="m_bdcontent"]').val(m_bdcontent);
	
	if (!m_bdcontent) {
		alert('내용을 입력하여 주십시오.');		
		return false;
	}
	
	//중요공지 체크박스
	if($('input[name="notichk"]').is(":checked") == true){
		$('input[name="m_bdnoticeyn"]').val('Y');
	}else{
		$('input[name="m_bdnoticeyn"]').val('N');
	}

	if($('input:radio[name="m_bddisplaytype"]:checked').val() == 'login'){
		var bd_image =  ('${boardOne.BD_IMAGE}') ? '${boardOne.BD_IMAGE}' : $('input[name="m_bdimage"]').get(0).files.length;

		if(bd_image === 0){
			alert('로그인출력 이미지를 업로드 해주세요.');
			return false;
		}
	}

	return true;
}

/**
 * 공지사항 등록/수정
 */
function dataInUp(obj,processType){ //processType ADD : 등록 , EDIT : 수정
	$(obj).prop('disabled', true);
	
	if(!dataValidation()){
		$(obj).prop('disabled', false);
		return;
	}
	
	$('input[name="r_processtype"]').val(processType);
	if(confirm('저장하시겠습니까?')){
		var $frmPop = $('form[name="frmPop"]')		
		$frmPop.attr('action', '${url}/admin/board/insertUpdateNoticeAjax.lime');
		
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
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/noticeFileDown.lime">';
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
						<input type="hidden" name="m_bdid" value="notice" />
						<input type="hidden" name="r_processtype" value="" />
						<input type="hidden" name="r_bdseq" value="${param.r_bdseq}" />						
						<input type="hidden" name="m_bdnoticeyn" value="${boardOne.BD_NOTICEYN}" />
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
								<c:if test="${empty boardOne}">
									<h4 class="panel-title">공지사항등록</h4>
								</c:if>
								<c:if test="${!empty boardOne}">
									<h4 class="panel-title">공지사항수정</h4>
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
														<input type="file" class="dropify" name="m_bdfile" value="" <c:if test="${ !empty boardOne.BD_FILE }">data-default-file="${ url }/data/board/${boardOne.BD_FILE}"</c:if> data-max-file-size="10M" data-show-errors="false"/>
												</div>
											</li>
											<li>
												<label class="search-h">출력여부 *</label>
												<div class="search-c radio">
													<c:if test="${boardOne.BD_DISPLAYTYPE eq 'user' || empty boardOne }"><c:set var='user' value="checked='checked'"/></c:if>
													<c:if test="${boardOne.BD_DISPLAYTYPE eq 'login' }"><c:set var='login' value="checked='checked'"/></c:if>
													<label><input type="radio" name="m_bddisplaytype" value="user" ${user} />거래처출력</label>
													<label><input type="radio" name="m_bddisplaytype" value="login" ${login} />로그인출력</label>
												</div>
											</li>
											<li class="blank">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li>
											<li>
												<label class="search-h">로그인출력 이미지</label>
												<div class="search-c">
														<input type="file" class="dropify" name="m_bdimage" value="${boardOne.BD_IMAGE}"  <c:if test="${ !empty boardOne.BD_IMAGE }">data-default-file="${ url }/data/board/${boardOne.BD_IMAGE}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false"/>
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
											<li class="blank3">
												<label class="search-h"></label>
												<div class="search-c"></div>
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
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>

</html>