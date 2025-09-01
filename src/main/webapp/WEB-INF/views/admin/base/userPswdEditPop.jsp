<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">
$(function(){
	opener.location.href = '${url}/admin/index/index.lime';
});

// 저장
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
	
	if(confirm('저장 하시겠습니까?')){
		$('form[name="frmPop"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/common/updateUserPswdAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000' || data.RES_CODE == '0315') {
					alert(data.RES_MSG);
					//opener.location.href = '${url}/admin/index/index.lime';
					window.open('about:blank', '_self').close();
					
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
	}else{
		$(obj).prop('disabled', false);
	}
}

</script>
</head>

<body class="bg-n">
	
	<form name="frmPop" method="post" enctype="multipart/form-data">
		<input name="r_userid" type="hidden" value="${param.p_userid}" /> <%-- 필수 --%>
	    <input name="r_processtype" type="hidden" value="" /> <%-- 필수 --%>
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						비밀번호 변경
						<div class="btnList">
							<button class="btn btn-github" onclick="dataUp(this,'AFTER');" type="button" title="다음에하기">다음에하기</button>
							<button class="btn btn-info" onclick="dataUp(this,'UP');" type="button" title="저장">저장</button>
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
									<th>아이디</th>
									<td>${param.p_userid}</td>
								</tr>
								<tr>
									<th>현재 패스워드 *</th>
									<td>
										<input type="password" name="r_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
									</td>
								</tr>
								<tr>
									<th>변경 패스워드 *</th>
									<td>
										<input type="password" name="m_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
									</td>
								</tr>
								<tr>
									<th>변경 패스워드확인 *</th>
									<td>
										<input type="password" name="c_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
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