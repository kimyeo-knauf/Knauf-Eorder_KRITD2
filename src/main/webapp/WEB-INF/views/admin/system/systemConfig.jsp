<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript">
$(function(){
	$('.dropify-filename-inner').each(function() {
		var fileName = $(this).html();
		var cfid = $(this).closest('td').find('input[name="cfid"]').val();
		var textHtml = '<a href="${url}/admin/system/fileDown.lime?r_cfid='+cfid+'"></a>'; //'+fileName+'
		$(this).html(textHtml);
	});
});


// 저장.
function dataUp(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if (confirm('저장 하시겠습니까?')) {
		formPostSubmit('', '${url}/admin/system/updateSystemConfig.lime');
	}
	
	$(obj).prop('disabled', false);
}

// 유효성 체크.
function dataValidation(){
	var ckflag = true;
	if(ckflag) ckflag = validation($('input[name="m_browsertitle"]')[0], '브라우저 타이틀', 'value');
	if(ckflag) ckflag = validation($('input[name="m_usernm"]')[0], '시스템 관리자명', 'value');
	return ckflag;
}

// 파일 다운로드.
function fileDown(r_cfid){
	formGetSubmit('${url}/admin/system/fileDown.lime', 'r_cfid='+r_cfid );
}

</script>
</head>

<body class="page-header-fixed compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		 
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					환경설정
					<!-- <div class="page-right"></div> -->
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="post" enctype="multipart/form-data">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<h4 class="panel-title no-title"></h4>
								<div class="btnList writeObjectClass">
									<button class="btn btn-info" onclick="dataUp(this);" type="button">저장</button>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="5%" />
											<col width="20%" />
											<col width="75%" />
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>구분</th>
												<th>환경설정</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th class="text-center">1</th>
												<td>브라우저타이틀</td>
												<td><input type="text" class="search-input" name="m_browsertitle" value="${configList.BROWSERTITLE}" onkeyup="checkByte(this, 3000);" /></td>
											</tr>
											<tr>
												<th class="text-center">2</th>
												<td>시스템관리자</td>
												<td>
													<input type="text" class="search-input w-20" name="r_systemadmin" value="${configList.SYSTEMADMIN}" readonly="readonly" />
													<input type="password" class="search-input w-20" name="m_userpwd" value="" placeholder="변경할 비밀번호" />
													<input type="text" class="search-input w-20" name="m_usernm" value="${systemAdmin.USER_NM}" placeholder="시스템관리자명" onkeyup="checkByte(this, 40);" />
												</td>
											</tr>
											<tr>
												<th class="text-center">3</th>
												<td>로고 이미지</td>
												<td>
													<input type="hidden" name="cfid" value="SYSTEMLOGO" />
													<input type="file" class="dropify" name="m_systemlogo" value="" <c:if test="${!empty configList.SYSTEMLOGO}">data-default-file="${url}/data/config/${configList.SYSTEMLOGO}"</c:if> />
													<a class="dropify-file hide m-t-xxxxs m-l-xxs" href="javascript:;" onclick="fileDown('SYSTEMLOGO');"><i class="fa fa-arrow-circle-down pull-left m-t-xxs m-r-xxxs f-s-15"></i>${configList.SYSTEMLOGO}</a> <!-- IE9 -->
												</td>
											</tr>
											<tr>
												<th class="text-center">4</th>
												<td>대표자 직인 이미지</td>
												<td>
													<input type="hidden" name="cfid" value="CEOSEAL" />
													<input type="file" class="dropify" name="m_ceoseal" value="" <c:if test="${!empty configList.CEOSEAL}">data-default-file="${url}/data/config/${configList.CEOSEAL}"</c:if> />
													<a class="dropify-file hide m-t-xxxxs m-l-xxs" href="javascript:;" onclick="fileDown('CEOSEAL');"><i class="fa fa-arrow-circle-down pull-left m-t-xxs m-r-xxxs f-s-15"></i>${configList.CEOSEAL}</a> <!-- IE9 -->
												</td>
											</tr>
											<tr>
												<th class="text-center">5</th>
												<td>내부사용자 ${configList.USERPSWDMONTH}개월 단위 비밀번호 변경</td>
												<td  class="radio">
													<label><input type="radio" name="m_userpswdmonthadminuse" value="Y" <c:if test="${configList.USERPSWDMONTHADMINUSE eq 'Y'}">checked="checked"</c:if> />사용</label>
													<label><input type="radio" name="m_userpswdmonthadminuse" value="N" <c:if test="${configList.USERPSWDMONTHADMINUSE eq 'N'}">checked="checked"</c:if> />미사용</label>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- //Row -->
				</form>
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>

</html>