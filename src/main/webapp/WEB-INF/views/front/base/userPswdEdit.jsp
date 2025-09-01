<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
//저장
function dataUp(obj, type){
	$(obj).prop('disabled', true);
	
	var ckflag = true;
	
	if('UP' == type){
		if(ckflag) ckflag = validation($('input[name="r_userpwd"]')[0], '현재비밀번호', 'value');
		if(ckflag) ckflag = validation($('input[name="m_userpwd"]')[0], '변경할 비밀번호', 'value');
		if(ckflag) ckflag = validation($('input[name="c_userpwd"]')[0], '변경할 비밀번호', 'value');
		
		// 비밀번호 체크.
		if(ckflag && !passWordCheck('EDIT', '1', 'm_userpwd', 'c_userpwd')){
			ckflag = false; 
		}
	}
	
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	$('input[name="r_processtype"]').val(type); //UP,AFTER
	
	if('UP' == type){
		if(confirm('저장 하시겠습니까?')){
			dataAjax(obj, type);
		}else{
			$(obj).prop('disabled', false);
		}
	}else{
		dataAjax(obj, type);
	}
}

function dataAjax(obj, type){
	$('form[name="frm"]').ajaxSubmit({
		dataType : 'json',
		type : 'post',
		url : '${url}/common/updateUserPswdAjax.lime',
		success : function(data) {
			if(data.RES_CODE == '0000' || data.RES_CODE == '0315') {
				if('UP' == type){
					alert(data.RES_MSG);
				}
				document.location.href = '${url}/front/index/index.lime';
				
			}else{
				$('input[name="r_userpwd"]').val('');
				$('input[name="m_userpwd"]').val('');
				$('input[name="c_userpwd"]').val('');
				
				$('input[name="r_userpwd"]').focus();
			}
			
			$(obj).prop('disabled', false);
			return;
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		},
	});
}

//임시 비밀번호일때 [다음에하기]는 저장되지 않음
function onceSkipIndex(){
	document.location.href = '${url}/front/index/index.lime';
}

</script>
</head>

<body class="popup-wrapper page-wrapper">

	<!-- Wrap -->
	<div id="wrap">
	
		<!-- Container Fluid -->
		<div class="container-fluid idpwchange">
			<div class="login-panel-title">
				<h4>
					<strong>비밀번호 변경</strong>
					${param.resMsg}<br />회원정보를 안전하게 보호하기 위해 비밀번호 변경을 권장합니다.
				</h4>
			</div>
			
			<div class="login-panel-body">
				<form name="frm" class="idpw-form">
					<input name="r_processtype" type="hidden" value="" /> <%-- 필수 --%>
					
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
							<col width="40%" />
							<col width="60%" />
						</colgroup>
						<tbody>
							<tr>
								<th>아이디</th>
								<td>${sessionScope.loginDto.userId}</td>
							</tr>
							<tr>
								<th>현재 비밀번호 *</th>
								<td>
									<input type="password" class="form-control" name="r_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="현재(기존) 비밀번호" />
								</td>
							</tr>
							<tr>
								<th>변경 비밀번호 *</th>
								<td>
									<input type="password" class="form-control" name="m_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문, 숫자, 특수문자 조합" />
								</td>
							</tr>
							<tr>
								<th>변경 비밀번호확인 *</th>
								<td>
									<input type="password" class="form-control" name="c_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문, 숫자, 특수문자 조합" />
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="buttons2">
						<button type="button" onclick="dataUp(this,'UP');" class="login-btn btn-green">저장하기</button>
						
						<!-- 비밀번호 변경일이 지났을때 -->
						<c:if test="${param.resCode eq '0312'}"> 
							<button type="button" onclick="dataUp(this,'AFTER');" class="login-btn btn-gray">${fn:substring(param.resMsg,6,9)} 이후 변경하기</button>
						</c:if>
						
						<!-- 임시 비밀번호일때 -->
						<c:if test="${param.resCode eq '0317'}"> 
							<button type="button" onclick="onceSkipIndex();" class="login-btn btn-gray">다음에 하기</button>
						</c:if>
					</div>
				</form>
				
			</div>
			
		</div> <!-- Container Fluid -->
		
	</div> <!-- Wrap -->

</body>
</html>