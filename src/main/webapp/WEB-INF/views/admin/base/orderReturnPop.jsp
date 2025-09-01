<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<c:set value="" var="cancelName" />
<c:if test="${'custCancel' eq param.cancel_type}"><c:set value="고객취소" var="cancelName" /></c:if> <%-- 고객취소=01 --%>
<c:if test="${'csCancel' eq param.cancel_type}"><c:set value="CS취소" var="cancelName" /></c:if> <%-- CS취소=02 --%>
<c:if test="${'csReturn' eq param.cancel_type}"><c:set value="CS반려" var="cancelName" /></c:if> <%-- CS반려=03 --%>
<c:if test="${'csAllReturn' eq param.cancel_type}"><c:set value="CS전체반려" var="cancelName" /></c:if> <%-- CS반려=03 --%>

<script>
var page_type = '${param.page_type}'; // ADD,EDIT,VIEW.
var cancel_type = '${param.cancel_type}'; // csReturn=품목별CS반려, csAllReturn=CS전체반려.
var r_settrid = '${param.r_settrid}'; // 부모창 tr ID. 빈값인 경우=CS전체반려

$(function(){
	
});


// 반려 사유 저장.
function dataSet(obj){
	var v_ocdreturncd = $('select[name="v_ocdreturncd"] option:selected').val(); 
	var v_ocdreturnmsg = $('textarea[name="v_ocdreturnmsg"]').val();
	
	if('' == v_ocdreturncd){
		alert('반려사유를 선택해 주세요.');
		$('select[name="v_ocdreturncd"]').focus();
		return;
	}
	
	if('csReturn' == cancel_type){
		var returnData = {
			OCD_RETURNCD : v_ocdreturncd
			, OCD_RETURNMSG : v_ocdreturnmsg
		};
		
		opener.setOrderReturnFromPop(returnData, r_settrid);
	}
	else if('csAllReturn' == cancel_type){
		var returnData = {
			RETURN_CD : v_ocdreturncd
			, RETURN_DESC : v_ocdreturnmsg
		};
		if(confirm('전체반려 하시겠습니까?')){
			opener.setOrderAllReturnFromPopProcess(returnData);
		}
	} 
	
	
	window.open('about:blank', '_self').close();
}

</script>
</head>

<body class="bg-n">
	<div class="overlay"></div>
	
	<!-- Modal -->
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						${cancelName}사유 <c:choose><c:when test="${'ADD' eq param.page_type}">등록</c:when><c:when test="${'EDIT' eq param.page_type}">수정</c:when><c:otherwise>확인</c:otherwise></c:choose>
						<div class="btnList writeObjectClass">
							<c:if test="${'ADD' eq param.page_type}">
								<button type="button" class="btn btn-info" onclick="dataSet(this);">등록</button>
							</c:if>
							<c:if test="${'EDIT' eq param.page_type}">
								<button type="button" class="btn btn-gray" onclick="dataSet(this);">수정</button>
							</c:if>
						</div>
					</h4>
				</div>
				
				<form name="frmPop" method="post">
				<div class="modal-body no-p-t">
					<div class="table-responsive" id="addDivId">
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="15%" />
								<col width="85%" />
							</colgroup>
							<tbody>
								<tr>
									<th>등록자</th>
									<td>
										<input type="text" class="w-sm" name="v_insertname" value="${sessionScope.loginDto.userNm}" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th>등록일</th>
									<td><fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" /></td>
								</tr>
								<tr>
									<th>${cancelName}사유</th>
									<td>
										<select class="w-sm" name="v_ocdreturncd">
											<!-- <option value="">선택하세요</option> -->
											<c:forEach items="${cancelList}" var="list">
												<option value="${list.CC_CODE}" <c:if test="${param.v_ocdreturncd eq list.CC_CODE}">selected="selected"</c:if>>${list.CC_NAME}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>사유입력</th>
									<td>
										<textarea class="form-control m-t-xxs" rows="5" name="v_ocdreturnmsg" id="v_ocdreturnmsg" onkeyup="checkByte(this, 100);" placeholder="${cancelName}사유를 100자 이내로 입력해 주세요.">${param.v_ocdreturnmsg}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				</form>
				
			</div>
		</div>
	</div>
</body>
</html>