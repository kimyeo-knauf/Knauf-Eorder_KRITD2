<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">
$(function(){
});

//비밀번호 찾기
function dataSearch(obj){
	$(obj).prop('disabled', true);
	var ckflag = true;
	
	if(ckflag) ckflag = validation($('input[name="r_userid"]')[0], '아이디', 'value');
	if(ckflag) ckflag = validation($('input[name="r_cellno"]')[0], '휴대폰번호', 'value,phone');
	if(ckflag) ckflag = validation($('input[name="r_useremail"]')[0], '이메일', 'value,email');
	
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('처리 하시겠습니까?')){
		$('form[name="searchPop"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/common/userPswdSearchAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0318') {
					alert(data.RES_MSG);
					window.open('about:blank', '_self').close();
				}else{
					$('input[name="r_userid"]').val('');
					$('input[name="r_cellno"]').val('');
					$('input[name="r_useremail"]').val('');
					
					$('input[name="r_userid"]').focus();
				}
				
				$(obj).prop('disabled', false);
				return;
			},
			complete: function(xhr, status) {
				var data = xhr.responseJSON;
				if (data && data.RES_CODE && data.RES_CODE != '0000' && data.RES_CODE != '0318') {
					alert(data.RES_MSG);
				}
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
	
	<form name="searchPop" method="post">
	<input name="popType" type="hidden" value="A" />	
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						비밀번호 찾기
						<div class="btnList">
							<button class="btn btn-info" onclick="dataSearch(this);" type="button" title="비밀번호 찾기">비밀번호 찾기</button>
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
									<td>
										<input type="text" name="r_userid" value="" />
									</td>
								</tr>
								<tr>
									<th>휴대폰번호</th>
									<td>
										<input type="text" name="r_cellno" value="" placeholder="숫자만 입력해 주세요" />
									</td>
								</tr>
								<tr>
									<th>이메일</th>
									<td>
										<input type="text" name="r_useremail" value="" placeholder="등록된 이메일을 입력해 주세요" />
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