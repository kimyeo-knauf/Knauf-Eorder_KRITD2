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

});

/**
 * 데이터 유효성 체크
 */
function dataValidation(){
	if (!$('input[name="m_tsctitle"]').val()) {
		alert('제목을 입력하여 주십시오.');
		$('input[name="m_tsctitle"]').focus();
		return false;
	}
	
	var m_tsccontent = CKEDITOR.instances.editor1.getData();
	$('input[name="m_tsccontent"]').val(m_tsccontent);
	
	if (!m_tsccontent) {
		alert('내용을 입력하여 주십시오.');		
		return false;
	}
	
	return true;
}

/**
 * 약관관리 등록/수정
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
		$frmPop.attr('action', '${url}/admin/board/insertUpdateTosConfigAjax.lime');
		
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

</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	
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
						<input type="hidden" name=r_tscseq value="${param.r_tscseq }" />
						<input type="hidden" name="r_processtype" value="" />
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
								<c:if test="${empty tosConfigOne}">
									<h4 class="panel-title">약관등록</h4>
								</c:if>
								<c:if test="${!empty tosConfigOne}">
									<h4 class="panel-title">약관수정</h4>
								</c:if>
								
								<div class="btnList writeObjectClass">
								 <c:if test="${empty tosConfigOne}">
								 	<button class="btn btn-info" onclick="dataInUp(this,'ADD');" type="button" title="저장">저장</button>
								</c:if>
								<c:if test="${!empty tosConfigOne}">
									<button class="btn btn-info" onclick="dataInUp(this,'EDIT');" type="button" title="저장">저장</button>
								</c:if>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="tableSearch top-view3">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목</label>
												<div class="search-c">
													<input type="text" class="search-input" name="m_tsctitle" value="${tosConfigOne.TSC_TITLE}" onkeyup="checkByte(this, 160);"/>
												</div>
											</li>
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													<c:choose>
														<c:when test="${empty tosConfigOne}">
															<input type="text" class="search-input" name="" value="${sessionScope.loginDto.userNm}" readonly="readonly" />
														</c:when>
														<c:otherwise>
															<input type="text" class="search-input" name="" value="${tosConfigOne.USER_NM}" readonly="readonly" />	
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
															<input type="text" class="search-input p-r-md" name="" value="${fn:substring(tosConfigOne.TSC_INDATE,0,10)}" readonly="readonly" />	
														</c:otherwise>
													</c:choose>
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li class="blank">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title">내용</h5>
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td class="p-v-sm">
													<textarea id="editor1">${tosConfigOne.TSC_CONTENT}</textarea>
													<input type="hidden" name="m_tsccontent" value="" />
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