<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">





//유효성 체크.
function dataValidationPop(){
	var ckflag = true;
	
	if(ckflag) ckflag = validation($('input[name="comment"]'), '주의사항', 'value,comment');

	return ckflag;
}

//저장 또는 수정.
function inUpDataPop(obj){
	$(obj).prop('disabled', true);

	var ckflag = dataValidationPop();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}

	if(confirm('${page_type} 하시겠습니까?')){
		$('form[name="frmPop"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/customer/insertUpdateCommentAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					window.opener.location.reload();
					window.open('about:blank', '_self').close();
				}
			}
		});
	}
	

}




</script>

</head>
<body class="bg-n">
	<form name="frmPop" method="post" enctype="multipart/form-data">
		<input name="r_shipto" type="hidden" value="${param.r_shiptocd}" /> <%-- 수정시 필수 --%>

	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						주의사항
						<div class="btnList writeObjectClass">
							<button class="btn btn-gray" onclick="inUpDataPop(this);" type="button" title="${page_type}">${page_type}</button>
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
									<th>납품처</th>
									<td>
										${shiptoMap.SHIPTO_NM}
									</td>
								</tr>
								<tr>
									<th>주의사항 *</th>
									<td>
										<textarea class="w-xxl" onkeyup="checkByte(this, '80');" name="comment" id="comment" cols="300" rows="7" >${shiptoMap.Comment}</textarea>
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