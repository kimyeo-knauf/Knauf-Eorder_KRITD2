<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<%--
### 
--%>

<script type="text/javascript">
var splitName = replaceAll(getContextPath(), '/', ''); //쿠키명 구분값

$(function(){
	getLogin();
});

function sendLogin() {
	if (!$('#r_mbid').val()) {
		alert('아이디를 입력하여 주십시오.');
		$('#r_mbid').focus();
		return false;
	}
	
	if (!$('#r_mbpswd').val()) {
		alert('비밀번호를 입력하여 주십시오.');
		$('#r_mbpswd').focus();
		return false;
	}
	
	$.ajax({
		async : false,
		data : {r_mbid:$('#r_mbid').val(), r_mbpswd:$('#r_mbpswd').val(), loginToken:$('#loginToken').val()},
		type : 'POST',
		url : './loginAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				loginCookie();
				//document.location.href = '${url}/user/index/index.lime';
			}
		}
	});
}

//아이디 저장
function loginCookie(){
	var r_mbid = $('input[name="r_mbid"]').val();
	if($('input[name="c_saveid"]').prop('checked')){ //아이디 저장을 체크하였을때
		setCookie("id_"+splitName, r_mbid, 30); //30일동안 저장
	}
	else{
		setCookie("id_"+splitName, r_mbid, 0); //날짜를 0으로 저장하여 쿠키 삭제
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
	 
	 	$('input[name="r_mbid"]').val(mb_id);
	 	$('input[name="c_saveid"]').prop('checked', true);
	 	$.uniform.update('input[name="c_saveid"]');
	 	$('input[name="r_mbpswd"]').focus();
	
	 }else{
		 $('input[name="r_mbid"]').focus();
	 } 
	 
	 //메뉴쿠키 삭제
	 setCookie("mnSeq", '', 0); 
	 setCookie("mnBtn", '', 0); 
}
</script>
</head>

<body>
	<form method="post" name="frm">
	<input type="hidden" name="loginToken" id="loginToken" value="${loginToken}" />
	
	<table border="1">
		<thead>
			<tr>
				<td colspan="2">### LogIn.</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<input class="" name="r_mbid" id="r_mbid" placeholder="아이디" onkeypress="if(event.keyCode == 13 && this.value){$('#r_mbpswd').focus();}" type="text" value="" />
				</td>
				<td>
					<input class="" name="r_mbpswd" id="r_mbpswd" placeholder="비밀번호" onkeypress="if(event.keyCode == 13){sendLogin();}" type="password" value="" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<label class="" for="c_saveid">
						<input class="" name="c_saveid" id="c_saveid" type="checkbox" value="Y" />
						<span class="">아이디저장</span>
					</label>
					<button class="" onclick="sendLogin();" type="button">login</button>
				</td>
			</tr>
		</tbody>
	</table>
	
	</form>
</body>
</html>