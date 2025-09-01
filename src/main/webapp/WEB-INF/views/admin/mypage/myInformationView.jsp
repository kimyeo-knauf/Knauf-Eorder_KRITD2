<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script>
$(document).ready(function() { 
	
});

//저장 또는 수정.
function dataUp(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('저장 하시겠습니까?')){
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/mypage/myInformationUpdateAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					location.reload();
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
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
	}else{
		$(obj).prop('disabled', false);
	}
}

//유효성 체크.
function dataValidation(){
	var ckflag = true;
	
	//if(ckflag) ckflag = validation($('input[name="m_usernm"]')[0], '성명', 'value');
	if(ckflag) ckflag = validation($('input[name="m_cellno"]')[0], '휴대폰번호', 'value,phone');
	if(ckflag) ckflag = validation($('input[name="m_telno"]')[0], '전화번호', 'value,tel');
	if(ckflag) ckflag = validation($('input[name="m_useremail"]')[0], '이메일', 'value,email');
	
	if('' != $('input[name="m_userpwd"]').val()){
		if(!passWordCheck('EDIT', '0', 'm_userpwd', '')){ 
			ckflag = false; 
		}
	}
	
	return ckflag;
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
					나의정보
					<div class="page-right">
						<%-- 
						<button type="button" class="btn btn-line f-black" title="목록" ><i class="fa fa-list-ul"></i><em>목록</em></button>
						<button type="button" class="btn btn-line text-default" title="검색"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line text-default" title="엑셀다운로드"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
						--%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm"  method="post" enctype="multipart/form-data">
				
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
					
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<h4 class="panel-title">기본정보</h4>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" onclick="dataUp(this);">저장</button>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="table-responsive">
								<form name="frm" method="post" enctype="multipart/form-data">
									<input name="m_mbdpcode" type="hidden" value="${member.MB_DPCODE}" />
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="13%" />
											<col width="18%" />
											<col width="*" />
										</colgroup>
										<tbody>
											<tr>
												<td rowspan="6" class="profile-img2">
													<em>프로필 이미지</em>
													<input type="file" class="dropify" name="m_userfile" value="" <c:if test="${!empty adminUser.USER_FILE}">data-default-file="${url}/data/user/${adminUser.USER_FILE}"</c:if> />
												</td>
												<th>권한</th>
												<td>
													<c:if test="${'AD' eq adminUser.AUTHORITY}">관리</c:if>
													<c:if test="${'CS' eq adminUser.AUTHORITY}">CS</c:if>
													<c:if test="${'MK' eq adminUser.AUTHORITY}">마케팅</c:if>
													<c:if test="${'SH' eq adminUser.AUTHORITY or 'SM' eq adminUser.AUTHORITY or 'SR' eq adminUser.AUTHORITY}">
														영업 ${adminUser.AUTHORITY} ${adminUser.USER_NM}
													</c:if>
												</td>
											</tr>
											<tr>
												<th>성명</th>
												<td>
													${adminUser.USER_NM}
													<%-- <input type="text" class="w-md" onkeyup="checkByte(this, 40);" name="m_usernm" value="${adminUser.USER_NM}" readonly="readonly" /> --%>
												</td>
											</tr>
											<tr>
												<th>직책</th>
												<td>
													<input type="text" class="w-md" onkeyup="checkByte(this, 100);" name="m_userposition" value="${adminUser.USER_POSITION}" />
												</td>
											</tr>
											<tr>
												<th>휴대폰번호 *</th>
												<td>
													<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_cellno" value="${adminUser.CELL_NO}" placeholder="숫자만 입력해 주세요." />
													<c:if test="${!empty adminUser.CELL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
												</td>
											</tr>
											<tr>
												<th>전화번호 *</th>
												<td>
													<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_telno" value="${adminUser.TEL_NO}" placeholder="숫자만 입력해 주세요." />
													<c:if test="${!empty adminUser.TEL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
												</td>
											</tr>
											<tr>
												<th>이메일 *</th>
												<td>
													<input type="text" class="w-md" onkeyup="checkByte(this, 50);" name="m_useremail" value="${adminUser.USER_EMAIL}" />
												</td>
											</tr>
										</tbody>
									</table>
									
									<h5 class="table-title">계정</h5>
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="15%" />
											<col width="35%" />
											<col width="15%" />
											<col width="35%" />
										</colgroup>
										<tbody>
											<tr>
												<th>아이디 </th>
												<td>
													${adminUser.USERID} <input type="hidden" name="r_userid" value="${adminUser.USERID}" readonly="readonly" />
													<%-- <input type="text" name="r_userid" value="${adminUser.USERID}" readonly="readonly" /> --%>
												</td>
												<th>비밀번호 *</th>
												<td>
													<input type="password" name="m_userpwd" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
												</td>
											</tr>
										</tbody>
									</table>
								</form>
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