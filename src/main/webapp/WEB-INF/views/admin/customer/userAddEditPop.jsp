<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">
var pate_type = toStr('${page_type}'); // ADD/EDIT/VIEW
if('ADD' != pate_type && 'EDIT' != pate_type && 'VIEW' != pate_type) window.open('about:blank', '_self').close(); 

$(function(){
	if('VIEW' == pate_type){
		$('form[name="frmPop"]').find(':input,select,checkbox,radio').prop('disabled', true);
	}
	
	if('ADD' != pate_type && 'VIEW' != pate_type){
		//$('#select2-chosen-1').append(toStr('${csSalesMap.SALESUSER_NAME}')+'('+toStr('${csSalesMap.SALESUSERID}')+')'); // select2.js 소싱그룹 세팅.
		////$('input[type="checkbox"]').uniform('refresh');
	} //End.
});

// 저장 또는 수정.
function inUpDataPop(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidationPop();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	confirmText = ('ADD' != pate_type) ? '수정 하시겠습니까?' : '저장 하시겠습니까?';
	
	if(confirm(confirmText)){
		$('form[name="frmPop"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/customer/insertUpdateUserAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					
					if($('input[name="r_authority"]').val() == 'CT'){
						if('ADD' == pate_type) opener.reloadGridList('2'); //납품처계정
						else opener.dataSearch('2');	
					}else{
						if('ADD' == pate_type) opener.reloadGridList(''); //거래처계정
						else opener.dataSearch('');
					}
					window.open('about:blank', '_self').close();
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

// 유효성 체크.
function dataValidationPop(){
	var ckflag = true;
	
	if(ckflag && 'ADD' == pate_type){
		// 아이디 체크.
		if(ckflag) ckflag = validation($('input[name="m_userid"]')[0], '아이디', 'value');
		if(ckflag && $('input[name="m_userid"]').val() != $('input[name="c_dupcheckedid"]').val()) {
			alert('아이디 중복체크를 해주세요.');
			ckflag = false;
		}
		if(ckflag && $('input[name="h_exist"]').val() != 'N') {
			alert('잘못된 아이디입니다.');
			$('input[name="m_userid"]').focus();
			ckflag = false;
		}
		
		// 비밀번호 체크.
		if(ckflag && !passWordCheck('ADD', '0', 'm_userpwd', '')){ 
			ckflag = false; 
		}
	}
	
	if(ckflag && 'EDIT' == pate_type){
		if('' != $('input[name="m_userpwd"]').val()){
			if(!passWordCheck('EDIT', '0', 'm_userpwd', '')){ 
				ckflag = false; 
			}
		}
	}
	
	if(ckflag) ckflag = validation($('input[name="m_usernm"]')[0], '담당자명', 'value');
	if(ckflag) ckflag = validation($('input[name="m_cellno"]')[0], '휴대폰번호', 'value,phone');
	if(ckflag) ckflag = validation($('input[name="m_telno"]')[0], '전화번호', 'value,tel');
	if(ckflag) ckflag = validation($('input[name="m_useremail"]')[0], '이메일', 'value,email');
	
	return ckflag;
}

// 아이디 체크.
function idCheck(obj) {
	$(obj).prop('disabled', true);
	
	var objVal = $('input[name="m_userid"]').val();
	objVal = objVal.replace(/ /gi, ""); // 아이디 공백제거.
	
	$('input[name="m_userid"]').val(objVal);
	$('input[name="c_dupcheckedid"]').val(objVal);
	
	var ckflag = true;
	if(ckflag) ckflag = validation($('input[name="m_userid"]')[0], '아이디', 'value,userid');
	if(!ckflag){
		$('input[name="m_userid"]').val('');
		$(obj).prop('disabled', false);
		return;	
	}
	
	$.ajax({
		async : false,
		url : '${url}/common/checkUserIdAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : {
			r_userid : objVal
		},
		success : function(data){
			if('0000' == data.RES_CODE){
				alert('사용 가능한 아이디 입니다.');
				$('input[name="h_exist"]').val("N");
			}
			else{
				//alert(data.RES_MSG);
				$('input[name="h_exist"]').val("Y");
				$('input[name="m_userid"]').focus();
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});
}
</script>
</head>

<body class="bg-n">
	
	<c:set var="text1" value="등록" />
	<c:set var="text2" value="저장" />
	<c:if test="${'EDIT' eq  page_type}">
		<c:set var="text1" value="수정" />
		<c:set var="text2" value="수정" />
	</c:if>
	<c:if test="${'VIEW' eq  page_type}">
		<c:set var="text1" value="확인" />
		<c:set var="text2" value="" />
	</c:if>
	
	<form name="frmPop" method="post" enctype="multipart/form-data">
		<input name="r_userid" type="hidden" value="${param.r_userid}" /> <%-- 수정시 필수 --%>
		<input name="r_custcd" type="hidden" value="${param.r_custcd}" /> <%-- 수정시 필수 --%>
		<input name="r_authority" type="hidden" value="${userMap.AUTHORITY}" />
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						계정생성
						<div class="btnList writeObjectClass">
							<button class="btn btn-gray" onclick="inUpDataPop(this);" type="button" title="${text2}">${text2}</button>
						</div>
					</h4>
				</div>
				<div class="modal-body">
					<div class="table-responsive">
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="15%" />
								<col width="35%" />
							</colgroup>
							<tbody>
								<tr>
									<th>조직</th>
									<td>
										${param.r_custnm}
										<c:if test="${userMap.AUTHORITY eq 'CT'}">-${userMap.SHIPTO_NM}</c:if>
									</td>
								</tr>
								<tr>
									<th>ID *</th>
									<td>
										<input type="hidden" name="c_dupcheckedid" value="" /><%--중복체크한 ID--%>
										<input type="hidden" name="h_exist" value="" />
										
										<c:if test="${'ADD' eq page_type}">
											<input type="text" class="w-md" name="m_userid" value="" onkeyup="checkByte(this, 10);" />
											<button type="button" class="btn btn-default btn-xs m-r-xs" onclick="idCheck(this);">중복체크</button>
										</c:if>
										<c:if test="${'ADD' ne page_type}">
											<input type="text" class="w-md" name="m_userid" value="${userMap.USERID}" readonly="readonly" />
										</c:if>
									</td>
								</tr>
								<tr>
									<th>PW *</th>
									<td>
										<input type="password" class="w-md" name="m_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
									</td>
								</tr>
								<tr>
									<th>담당자명 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 100);" name="m_usernm" value="${userMap.USER_NM}" />
									</td>
								</tr>
								<tr>
									<th>휴대폰번호 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_cellno" value="${userMap.CELL_NO}" placeholder="숫자만 입력해 주세요." />
										<c:if test="${!empty userMap.CELL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
									</td>
								</tr>
								<tr>
									<th>전화번호 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_telno" value="${userMap.TEL_NO}" placeholder="숫자만 입력해 주세요." />
										<c:if test="${!empty userMap.TEL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
									</td>
								</tr>
								<tr>
									<th>이메일 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 50);" name="m_useremail" value="${userMap.USER_EMAIL}" />
									</td>
								</tr>
							</tbody>
						</table>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
	
</body>
</html>