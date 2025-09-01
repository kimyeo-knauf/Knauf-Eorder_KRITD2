<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
</c:if>

<script type="text/javascript">
$(document).ready(function() {
});


// 비밀번호 찾기
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
					
					<c:if test="${!isLayerPop}">
						window.open('about:blank', '_self').close();
					</c:if>
					<c:if test="${isLayerPop}">
						$('#userPswdSearchPopMId').modal('hide');
					</c:if>
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

<body> <!-- 팝업사이즈 615 * 435 -->

	<!-- Wrap -->
	<div id="wrap" class="popup-wrapper">
	
		<!-- Container Fluid -->
		<div class="container-fluid idpwsearch">
		
			<button type="button" class="close" onclick="Close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			
			<div class="login-panel-title">
				<h4>비밀번호 찾기</h4>
			</div>
			
			<div class="login-panel-body">
				<form name="searchPop" class="idpw-form">
				<input name="popType" type="hidden" value="F" />
				
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="27%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th>아이디</th>
								<td>
									<input type="text" name="r_userid" value="" class="form-control" />
								</td>
							</tr>
							<tr>
								<th>휴대폰번호</th>
								<td>
									<input type="text" name="r_cellno" value="" class="form-control" placeholder="숫자만 입력해 주세요" />
								</td>
							</tr>
							<tr>
								<th>이메일</th>
								<td>
									<input type="text" name="r_useremail" value="" class="form-control" placeholder="등록된 이메일을 입력해 주세요" />
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="button">
						<button type="button" onclick="dataSearch(this);" class="login-btn btn-green">비밀번호 찾기</button>
					</div>
				</form>
				
			</div>
			
		</div> <!-- Container Fluid -->
		
	</div> <!-- Wrap -->

</body>
</html>