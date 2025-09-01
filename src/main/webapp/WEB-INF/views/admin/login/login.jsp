<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script    src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
var splitName = replaceAll(getContextPath(), '/', ''); //쿠키명 구분값

$(function(){
	getLogin();
});

function sendLogin(obj) {
	$(obj).prop('disabled', true);
	
	if (!$('#r_userid').val()) {
		alert('아이디를 입력하여 주십시오.');
		$('#r_userid').focus();
		$(obj).prop('disabled', false);
		return false;
	}
	
	if (!$('#r_userpwd').val()) {
		alert('비밀번호를 입력하여 주십시오.');
		$('#r_userpwd').focus();
		$(obj).prop('disabled', false);
		return false;
	}

    var passphrase = "Knauf2023";
    var encryptedText = CryptoJS.AES.encrypt($('#r_userpwd').val(), passphrase);
	
	$.ajax({
		async : false,
		data : {r_userid:$('#r_userid').val(), 
			r_userpwd: encryptedText.toString(), 
			loginToken:$('#loginToken').val(), 
			pageType:'A'},
		type : 'POST',
		url : './loginAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				loginCookie();
				formPostSubmit('frm', '${url}/admin/index/index.lime');
				//document.location.href = '${url}/admin/index/index.lime';
			}
			else if(data.RES_CODE == '0106'){
				if(confirm('이미 접속중 입니다.\n기존의 접속을 종료 하시겠습니까?')){
					disconnectPreLogin(obj);
					$(obj).prop('disabled', false);
					return;
				}
			}
			else if(data.RES_CODE == '0312' || data.RES_CODE == '0317'){ //비밀번호 변경요청 팝업 (관리자변경,초기화,권장변경일)
				loginCookie();
			
				$('form[name="frm"]').append('<input type="hidden" name="resMsg" value="'+data.RES_MSG+'" />');
				$('form[name="frm"]').append('<input type="hidden" name="resCode" value="'+data.RES_CODE+'" />');
				formPostSubmit('frm', '${url}/admin/base/userPswdEdit.lime');
				
				//$('input[name="resMsg"]').val(data.RES_MSG);
				//$('input[name="resCode"]').val(data.RES_CODE);
				//formPostSubmit('pfrm', '${url}/admin/base/userPswdEdit.lime');
			
			}else if(data.RES_CODE == '0316'){ //최초 로그인시 마이페이지로 이동
				loginCookie();
				formPostSubmit('frm', '${url}/admin/mypage/myInformationView.lime');
				//document.location.href = '${url}/admin/mypage/myInformationView.lime';
			}
			
			$(obj).prop('disabled', false);
		},
		complete: function(xhr, status) {
			var data = xhr.responseJSON;
			if (data && data.RES_CODE && data.RES_CODE != '0000' && data.RES_CODE != '0106' && data.RES_CODE != '0312' && data.RES_CODE != '0317' && data.RES_CODE != '0316') {
				alert(data.RES_MSG);
				if(data.RES_CODE == '0101' || data.RES_CODE == '0104'){
					location.href=getContextPath()+'/admin/login/login.lime';
				}
			}
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});
}

// 기존 연결 종료.
function disconnectPreLogin(obj){
	$.ajax({
		async : false,
		data : {r_userid:$('#r_userid').val()},
		type : 'POST',
		url : '${url}/common/disconnectPreLoginAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				$('input[name="loginToken"]').val(data.loginToken);
				sendLogin(obj);
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

//아이디 저장
function loginCookie(){
	var r_userid = $('input[name="r_userid"]').val();
	if($('input[name="c_saveid"]').prop('checked')){ //아이디 저장을 체크하였을때
		setCookie("id_"+splitName, r_userid, 30); //30일동안 저장
	}
	else{
		setCookie("id_"+splitName, r_userid, 0); //날짜를 0으로 저장하여 쿠키 삭제
	}
}

//아이디저장 체크하기
function getLogin(){
	 if (getCookie("id_"+splitName)){
	 	var mb_id = getCookie("id_"+splitName).split(";");
	 	
	 	mb_id += ",";
	 	if( mb_id.split(",").length > 1 ){
	 		mb_id = mb_id.split(",")[0];
	 	}
	 
	 	$('input[name="r_userid"]').val(mb_id);
	 	$('input[name="c_saveid"]').prop('checked', true);
	 	$.uniform.update('input[name="c_saveid"]');
	 	$('input[name="r_userpwd"]').focus();
	
	 }else{
		 $('input[name="r_userid"]').focus();
	 } 
	 
	 //메뉴쿠키 삭제
	 setCookie("mnSeq", '', 0); 
	 setCookie("mnBtn", '', 0); 
}


//비밀번호 찾기 팝업
function userPswdSearchPop(){
	// 팝업 세팅.
	var widthPx = 600; 
	var heightPx = 300;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/common/userPswdSearchPop.lime';
	window.open('', 'userPswdSearchPop', options);
	$('form[name="searchPop"]').prop('action', popUrl);
	$('form[name="searchPop"]').submit();
}

</script>
</head>

<body class="page-login-user">
	<section>

	<%-- 비밀번호 변경페이지로 이동 --%>
	<form name="pfrm" method="post">
		<input name="resCode" type="hidden" value="" />
		<input name="resMsg" type="hidden" value="" />
	</form>
	
	<%-- 팝업 전송 form --%>
	<form name="searchPop" method="post" target="userPswdSearchPop">
		<input name="pop" type="hidden" value="1" />
	</form>
		
		<div class="login-form">
			<div class="layer">
				<div class="wrapper">
					<div class="login-inner-cont">
						<div class="login-form-info">
							<h2><strong>e-Ordering</strong> 로그인</h2>
							<p>본 사이트는 인가된 사용자만 사용할 수 있으며, 사용자 접속모니터링 및 로그를 기록하고 있습니다.</p>
						</div>
						<div class="form-center">

							<form name="frm" method="post">
								<input type="hidden" name="loginToken" id="loginToken" value="${loginToken}" />
								<div class="forms-gds">
									<div class="form-input">
										<input class="form-control-login" name="r_userid" id="r_userid" type="text" onkeypress="if(event.keyCode == 13 && this.value){$('#r_userpwd').focus();}" placeholder="아이디" value="" />
									</div>
									<div class="form-input">
										<input class="form-control-login" name="r_userpwd" id="r_userpwd" type="password" onkeypress="if(event.keyCode == 13){sendLogin();}" placeholder="비밀번호" value="" />
									</div>
									<div class="form-input"><button type="button" class="btn" onclick="sendLogin(this);">login</button></div>
								</div>
								<h6 class="already">
									<div class="form-group"> 
										<span class="checkbox">
											<label class="lol-label-checkbox" for="c_saveid">
												<input type="checkbox" class="lol-checkbox" id="c_saveid" name="c_saveid" value="Y" />
												<span class="lol-text-checkbox">아이디저장</span>
											</label>
										</span>
										<span>
											<a href="javascript:userPswdSearchPop();">비밀번호 찾기</a>
										</span>
									</div>
								</h6>
								
							</form>

						</div>
						<div class="copyright text-center">
							<p>Copyright© 2022 KNAUF. All rights reserved.</p>
						</div>
					</div>

				</div>
				<h1>
					<div class="triangle-border"></div>
					<a href="${url}/admin/login/login.lime" class="logo"><img src="${url}/data/config/logo.png" alt="logo" /></a>
				</h1>
			</div>
		</div>
	</section>

</body>
</html>