<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>

<script type="text/javascript">
var pate_type = toStr('${page_type}'); // ADD/EDIT/VIEW
if('ADD' != pate_type && 'EDIT' != pate_type && 'VIEW' != pate_type){
	<c:if test="${!isLayerPop}">
		window.open('about:blank', '_self').close();
	</c:if>
	<c:if test="${isLayerPop}">
		$('#userAddEditPopMId').modal('hide');
	</c:if>
}

$(function(){
	if('VIEW' == pate_type){
		$('form[name="frmPop"]').find(':input,select,checkbox,radio').prop('disabled', true);
	}
});

//저장 또는 수정.
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
			url : '${url}/front/mypage/insertUpdateUserAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					<c:if test="${!isLayerPop}">
						opener.location.reload();
						window.open('about:blank', '_self').close();
					</c:if>
					<c:if test="${isLayerPop}">
						$('#userAddEditPopMId').modal('hide');
						location.reload();
					</c:if>
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			},
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

<body>

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">
<form name="frmPop" method="post" >
		<input name="r_userid" type="hidden" value="${param.r_userid}" /> <%-- 수정시 필수 --%>
		<input name="r_custcd" type="hidden" value="${param.r_custcd}" /> <%-- 수정시 필수 --%>
		<input name="r_authority" type="hidden" value="${userMap.AUTHORITY}" />
	
	<!-- Container Fluid -->
	<div class="container-fluid idpwsearch">
	
		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="login-panel-title">
			<h4>
				계정생성
				<div style="float: right;">
					<button type="button" class="btn btn-green" onclick="inUpDataPop(this);">저장</button>
				</div>
			</h4>
		</div>
		
		<div class="login-panel-body">
			
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="27%" />
						<col width="*" />
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
									<input type="text" class="form-control pull-left" name="m_userid" value="" onkeyup="checkByte(this, 10);" />
									<button type="button" class="btn btn-sm btn-default pull-left marL5" onclick="idCheck(this);" >중복체크</button>
								</c:if>
								<c:if test="${'ADD' ne page_type}">
									<input type="text" class="form-control" name="m_userid" value="${userMap.USERID}" readonly="readonly"/>
								</c:if>
							</td>
						</tr>
						<tr>
							<th>PW *</th>
							<td>
								<input type="password" class="form-control" name="m_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
							</td>
						</tr>
						<tr>
							<th>담당자명 *</th>
							<td>
								<input type="text" class="form-control" onkeyup="checkByte(this, 100);" name="m_usernm" value="${userMap.USER_NM}" />
							</td>
						</tr>
						<tr>
							<th>휴대폰번호 *</th>
							<td>
								<input type="text" class="form-control pull-left" onkeyup="checkByte(this, 20);" name="m_cellno" value="${userMap.CELL_NO}" placeholder="숫자만 입력해 주세요." />
								<c:if test="${!empty userMap.CELL_NO}"><span class="warning"><i class="icon-necessary">※</i>숫자만 입력해 주세요.</span></c:if>
							</td>
						</tr>
						<tr>
							<th>전화번호 *</th>
							<td>
								<input type="text" class="form-control pull-left" onkeyup="checkByte(this, 20);" name="m_telno" value="${userMap.TEL_NO}" placeholder="숫자만 입력해 주세요." />
								<c:if test="${!empty userMap.TEL_NO}"><span class="warning"><i class="icon-necessary">※</i>숫자만 입력해 주세요.</span></c:if>
							</td>
						</tr>
						<tr>
							<th>이메일 *</th>
							<td>
								<input type="text" class="form-control" onkeyup="checkByte(this, 50);" name="m_useremail" value="${userMap.USER_EMAIL}" />
							</td>
						</tr>
					</tbody>
				</table>
				
			
		</div> <!-- boardListArea -->
		
	</div> <!-- Container Fluid -->

</form>
	
</div> <!-- Wrap -->
</body>
</html>