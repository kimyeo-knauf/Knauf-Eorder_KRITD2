<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<!-- https://craftpip.github.io/jquery-confirm/ -->
<script src="${url}/include/js/common/jquery-confirm/jquery-confirm.js"></script>
<link href="${url}/include/js/common/jquery-confirm/css/jquery-confirm.css" rel="stylesheet" />

<script type="text/javascript">
console.log('Order View');
$(function(){
	
});

//상태값 체크후 처리 폼으로 이동.
function checkOrderEditStatus(obj, req_no){
	$(obj).prop('disabled', true);
	$.ajax({
		async : false,
		url : '${url}/admin/order/checkOrderEditStatusAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { r_reqno : req_no },
		success : function(data){
			if('0000' == data.RES_CODE){
				formGetSubmit('${url}/admin/order/orderEdit.lime', 'r_reqno='+req_no);
			} else if('0330' == data.RES_CODE) {
				alert(data.RES_MSG);
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});	
}

//수정 - 주문상세로 이동 (주문완료시에는 x)
function dataUp(obj, req_no, status){ // status : 90=임시저장 삭제, 01=고객취소(전체), 99=임시저장 수정 또는 주문접수 또는 보류(08) 상태변경 폼으로 이동/주문접수 수정 폼.
	$(obj).prop('disabled', true);
	
	if('99' == status || '00' == status || '08' == status){
		formGetSubmit('${url}/admin/order/orderAdd.lime', 'r_reqno='+req_no+'&status='+status);
		return;
	}
}

// 자재주문서 출력 팝업.
function openOrderPaperPop(obj){
	var reqno = '${orderHeader.REQ_NO}';
	
	// 팝업 세팅.
	var widthPx = 900;
	var heightPx = 750;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;

	
	$('form[name="frm_pop2"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop2" method="post" target="orderPaperPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="ri_reqno" value="'+reqno+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/orderPaperPop.lime';
	window.open('', 'orderPaperPop', options);
	$('form[name="frm_pop2"]').prop('action', popUrl);
	$('form[name="frm_pop2"]').submit().remove();
}

function csReturnReasonPop(returnReason, returnMsg){
	$.alert({
	    title: '['+returnReason+']',
	    content: ''+returnMsg+'',
	    buttons: {
	    	cancel: {
	        	text: '닫기',
	        	btnClass: 'btn btn-gray',
	        },
	    }
	});
}

function qmsOrderPop(obj,qmsTempId){
	// QMS 팝업 열기.
	var widthPx = 1000;
	var heightPx = 800;
	var r_reqno = $('#r_reqno').val();
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	var popup = window.open('qmsOrderPrePop.lime?qmsTempId='+qmsTempId+'&r_reqno='+r_reqno, 'qmsOrderPrePop', options);
	popup.focus();
}
function moveOrderList(){
	
}
</script>
</head>

<body class="page-header-fixed pace-done compact-menu searchHidden">
	<div class="overlay"></div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<%-- 팝업 전송 form --%>
		<form name="frm_pop" method="post" target="orderPaperPop" width="800" height="600">
			<input name="ri_reqno" type="hidden" value="" />
			<input id="r_reqno" name="r_reqno" type="hidden"  value="${param.r_reqno}" />  
		</form>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>${orderStatus[orderHeader.STATUS_CD]} ${orderHeader.REQ_NO} <%-- 상태값 & 주문번호 --%>
					<div class="page-right">
						<button type="button" class="btn btn-line w100 w-s" onclick="openOrderPaperPop(this);" >자재주문서 출력</button>
						<button type="button" class="btn btn-line f-black" title="목록" onclick="location.href='${url}/admin/order/orderList.lime?fromOrderView=Y';"><i class="fa fa-list-ul"></i><em>목록</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm" method="post">
							
							<div class="panel-body">
								<h5 class="table-title">주문정보</h5>
								<div class="btnList writeObjectClass">
									<c:if test="${'00' eq orderHeader.STATUS_CD or '08' eq orderHeader.STATUS_CD}">
										<c:if test="${not empty param.qmsTempId and param.qmsTempId ne 'null'}">
											<button type="button" class="btn btn-warning writeObjectClass" onclick="qmsOrderPop(this, '${param.qmsTempId}')" >QMS 수정</button>
										</c:if>
										<button type="button" class="btn btn-info writeObjectClass" onclick="dataUp(this, '${orderHeader.REQ_NO}', '${orderHeader.STATUS_CD}');">수정</button>
										<button type="button" class="btn btn-info writeObjectClass" onclick="checkOrderEditStatus(this, '${param.r_reqno}')" >주문처리</button>
									</c:if>
								</div>
								<div class="table-responsive">
									<table id="" class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="12%" />
											<col width="38%" />
											<col width="12%" />
											<col width="38%" />
										</colgroup>
										<tbody>
											<tr>
												<th>거래처명</th>
												<td>${orderHeader.CUST_NM}(${orderHeader.CUST_CD})</td>
												<th>납품처</th>
												<td>
													<c:choose>
														<c:when test="${empty orderHeader.SHIPTO_CD or '0' eq orderHeader.SHIPTO_CD}">미등록</c:when>
														<c:otherwise>${orderHeader.SHIPTO_NM}(${orderHeader.SHIPTO_CD})</c:otherwise>
													</c:choose>
												</td>
											</tr>
											<tr>
												<th>주문자 / 주문일자</th>
												<td>
													${orderHeader.USER_NM}(${orderHeader.USERID}) / 
													<c:choose>
														<c:when test="${empty orderHeader.INDATE}">-</c:when>
														<c:otherwise>${fn:substring(orderHeader.INDATE, 0, 16)}</c:otherwise>
													</c:choose>
												</td>
												<th>납품요청일</th>
												<td>
													<c:choose>
														<c:when test="${empty orderHeader.REQUEST_DT}">-</c:when>
														<c:otherwise>
															${fn:substring(orderHeader.REQUEST_DT, 0, 4)}-${fn:substring(orderHeader.REQUEST_DT, 4, 6)}-${fn:substring(orderHeader.REQUEST_DT, 6, 8)} 
															${fn:substring(orderHeader.REQUEST_TIME, 0, 2)}:${fn:substring(orderHeader.REQUEST_TIME, 2, 4)}
														</c:otherwise>
													</c:choose>
												</td>
											</tr>
											<tr>
												<th>인수자명</th>
												<td>
													<c:choose>
														<c:when test="${empty orderHeader.RECEIVER}">-</c:when>
														<c:otherwise>${orderHeader.RECEIVER}</c:otherwise>
													</c:choose>
												</td>
												
												<th>연락처1 / 연락처2</th>
												<td>
													${orderHeader.TEL1} / 
													<c:choose>
														<c:when test="${empty orderHeader.TEL2}">-</c:when>
														<c:otherwise>${orderHeader.TEL2}</c:otherwise>
													</c:choose>
												</td>
											</tr>
											<tr>
												<th>영업담당자</th>
												<td>
													<c:choose>
														<c:when test="${empty orderHeader.SALESUSERID}">-</c:when>
														<c:otherwise>${orderHeader.SALESUSER_NM}(${orderHeader.SALESUSERID})</c:otherwise>
													</c:choose>
												</td>
												<th>운송수단</th>
												<td>
													<c:if test="${'AA' eq orderHeader.TRANS_TY}">기본운송</c:if>
													<c:if test="${'AB' eq orderHeader.TRANS_TY}">자차운송(주문처운송)</c:if>
												</td>
											</tr>
											<tr>
												<th>납품주소</th>
												<!-- <td colspan="3"> -->
												<td>
													<c:choose>
														<c:when test="${'AA' eq orderHeader.TRANS_TY}">
															[${orderHeader.ZIP_CD}] ${orderHeader.ADD1} ${orderHeader.ADD2}
														</c:when>
														<c:otherwise>
															<!-- 자차운송(주문처운송) -->
															<%-- [${orderHeader.ZIP_CD}] ${orderHeader.ADD1} ${orderHeader.ADD2} --%>
															${orderHeader.ADD1} ${orderHeader.ADD2} <%-- 우편번호는 90000이 되어서 출력 필요 없을듯. --%>
														</c:otherwise>
													</c:choose>
												</td>
												<th>Quotation QT</th>
												<td> ${orderHeader.QUOTE_QT}</td>
											</tr>
											<tr>
												<th>요청사항</th>
												<td colspan="3">${orderHeader.REMARK}</td>
											</tr>
											<tr>
												<th>거래처 주의사항</th>
												<td colspan="3">
													<!-- 2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가. SHIP_TO Table에 Comment(VARCHAR(80)) 추가. CUSTOMMATTER -> Comment로 변경 -->
													<%-- c:if test="${!empty orderConfirmDetailList}">${orderConfirmDetailList[0].CUSTOMMATTER}</c:if --%>
													<c:if test="${!empty orderHeader }">${orderHeader.COMMENT }</c:if>
												</td>
											</tr>
											<c:if test="${'02' eq orderHeader.STATUS_CD or '03' eq orderHeader.STATUS_CD}">
												<tr>
													<th>
														<c:if test="${'02' eq orderHeader.STATUS_CD}">CS취소 사유</c:if>
														<c:if test="${'03' eq orderHeader.STATUS_CD}">CS반려 사유</c:if>
													</th>
													<td colspan="3">[${orderHeader.RETURN_REASON}]&nbsp;${orderHeader.RETURN_DESC}</td>
												</tr>
											</c:if>
										</tbody>
									</table>
								</div>
							
								<h5 class="table-title">주문품목</h5>
								<div class="table-responsive m-t-xs">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="5%" />
											<col width="10%" />
											<col width="6%" />
											<col width="10%" />
											<col width="*" />
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>품목코드</th>
												<th>단위</th>
												<th>수량</th>
												<th class="text-left p-l-xxxl">품목명</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${orderDetailList}" var="list" varStatus="status">
											<tr>
												<td class="text-center"><fmt:formatNumber value="${status.count}" pattern="#,###" /></td>
												<td class="text-center">${list.ITEM_CD}</td>
												<td class="text-center">${list.UNIT}</td>
												<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" /></td>
												<td class="text-left p-l-xxxl">${list.DESC1}</td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								
								<c:if test="${!empty orderConfirmDetailList}">
								<h5 class="table-title">주문확정품목</h5>
								<div class="table-responsive m-t-xs">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
											<col width="*" />
										</colgroup>
										<thead>
											<tr>
												<th>주문번호</th>
												<th>라인</th>
												<th>출고지</th>
												<th>품목코드</th>
												<th>품목명</th>
												<th>단위</th>
												<th>ROUTE</th>
												<th>출고수량</th>
												<th>피킹일시</th>
												<th>요청일시</th>
												<th>확정 요청사항</th>
												<th>기타</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${orderConfirmDetailList}" var="list" varStatus="status">
												<c:set var="now_custpo" value="${list.CUST_PO}" />
												<c:set var="pre_custpo" value="" />
												<c:if test="${0 eq status.index }"><c:set var="pre_custpo" value="" /></c:if>
												<c:if test="${0 ne status.index }"><c:set var="pre_custpo" value="${orderConfirmDetailList[status.index-1].CUST_PO}" /></c:if>
												
												<tr>
													<td class="text-left">
														<c:if test="${pre_custpo ne now_custpo}">${list.CUST_PO}</c:if>
													</td>
													<td class="text-center">${list.LINE_NO}</td>
													<td class="text-left">${list.PT_NAME}</td>
													<td class="text-left">${list.ITEM_CD}</td>
													<td class="text-left">${list.ITEM_NAME}</td>
													<td class="text-center">${list.UNIT}</td>
													<td class="text-center">${list.ROUTE}</td>
													<c:choose>
													<%-- 품목 --%>
													<c:when test="${'W1' ne list.ITEM_CD and 'R1' ne list.ITEM_CD and 'P1' ne list.ITEM_CD and 'F3' ne list.ITEM_CD and 'F2' ne list.ITEM_CD and 'F1' ne list.ITEM_CD}">
													
														<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" /></td>
														<%-- 2024-12-18 hsg Cattle Mutilation 당일착/익일착 구분은 헤더에 없으므로 주석처리함 --%>
														<%-- <td class="text-center">
															<c:if test="${!empty list.DRSPHD}">${list.DRSPHD}년 ${list.DRDL01}</c:if>
															<c:if test="${empty list.DRSPHD}">-</c:if>
														</td> --%>
														<td class="text-center">
															<c:if test="${!empty list.PICKING_DT}">${fn:substring(list.PICKING_DT, 0, 4)}-${fn:substring(list.PICKING_DT, 4, 6)}-${fn:substring(list.PICKING_DT, 6, 8)}</c:if>
															<c:if test="${empty list.PICKING_DT}">-</c:if>
														</td>
														<td class="text-center">
															<c:choose>
																<c:when test="${empty list.REQUEST_DT}">-</c:when>
																<c:otherwise>
																	${fn:substring(list.REQUEST_DT, 0, 4)}-${fn:substring(list.REQUEST_DT, 4, 6)}-${fn:substring(list.REQUEST_DT, 6, 8)} 
																	${fn:substring(list.REQUEST_TIME, 0, 2)}:${fn:substring(list.REQUEST_TIME, 2, 4)}
																</c:otherwise>
															</c:choose>
														</td>
														<td class="text-left">
															${list.REMARK}
														</td>
													</c:when>
													<%-- 배송비 --%>
													<c:otherwise>
														<td colspan="5" class="text-left">운송비 금액   <fmt:formatNumber value="${list.PRICE}" type="number" pattern="#,###.##" /></td>
													</c:otherwise>
													</c:choose>
													
													<td class="text-center">
														<%-- CS반려 --%>
														<c:if test="${'03' eq list.OCD_STATUSCD}">
															<button type="button" class="btn btn-gray" onclick="csReturnReasonPop('${list.ITEM_RETURN_REASON}', '${list.OCD_RETURNMSG}');">CS반려사유</button>
<%-- 															<button type="button" class="btn btn-gray" onclick="alert('[${list.ITEM_RETURN_REASON}] ${list.OCD_RETURNMSG}');">CS반려사유</button> --%>
														</c:if>
														<c:if test="${'02' eq list.OCD_STATUSCD}">
															<c:if test="${'03' eq list.OCD_RETURNCD}">
																<button type="button" class="btn btn-gray" onclick="csReturnReasonPop('${list.ITEM_RETURN_REASON}', '${list.OCD_RETURNMSG}');">CS취소사유</button>
															</c:if>
														</c:if>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								</c:if>
								
							</form>
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
	<div class="cd-overlay"></div>
</body>
</html>