<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">

$(function(){

});

$(document).ready(function() {
	
});

// 자재주문서 출력 팝업.
function openOrderPaperPop(obj){
	var reqno = '${custOrderH.REQ_NO}';
	
	// 팝업 세팅.
	if(!isApp()){
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
		var popUrl = '${url}/front/base/orderPaperPop.lime';
		window.open('', 'orderPaperPop', options);
		$('form[name="frm_pop2"]').prop('action', popUrl);
		$('form[name="frm_pop2"]').submit().remove();
	}
	else{
		// 모달팝업
		//$('#orderPaperPopMId').modal('show');
		var link = '${url}/front/base/orderPaperPop.lime?ri_reqno='+reqno+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) { // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#orderPaperPopMId').modal({
			remote: link
		});
	}
}

function qmsOrderPop(obj,qmsTempId){
	// QMS 팝업 열기.
	var widthPx = 1000;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	var popup = window.open('qmsOrderPrePop.lime?qmsTempId='+qmsTempId, 'qmsOrderPrePop', options);
	popup.focus();
}

function moveOrderList(){
	formGetSubmit('${url}/front/order/orderList.lime', '');
}
</script>
</head>

<body>

<div id="subWrap" class="subWrap">
	
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<!-- Header -->

	<div class="container-fluid">
		<div class="full-content">
		
			<div class="row no-m">
				<div class="page-breadcrumb"><strong>웹주문상세</strong></div>
				
				<div class="page-location">
					<ul>
						<li><a href="#"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/order/orderList.lime">웹주문현황</a></li>
						<li><a href="${url}/front/order/orderView.lime?r_reqno=${param.r_reqno}">웹주문상세</a></li>
					</ul>
				</div>
			</div> <!-- Row -->
			
		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->
	
	<!-- Container -->
	<main class="container" id="container">
		
		<!-- Content -->
		<div class="content">
		
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
				
					<div class="boardViewArea details-box">
						<h2 class="title">
							<span class="state"><c:choose><c:when test="${'08' eq custOrderH.STATUS_CD}">확인중</c:when><c:otherwise><c:out value="${orderStatus[custOrderH.STATUS_CD]}" /></c:otherwise></c:choose></span>
							<em>${custOrderH.REQ_NO}</em>
							<div class="title-right little">
								<c:if test="${'99' ne custOrderH.STATUS_CD}">
								<c:if test="${not empty param.qmsTempId and param.qmsTempId ne 'null'}">
									<button type="button" class="btn btn-warning writeObjectClass" onclick="qmsOrderPop(this,'${param.qmsTempId}')" >QMS 수정</button>
								</c:if>
								<button type="button" class="btn btn-green" onclick="openOrderPaperPop(this);">자재주문서</button>
								</c:if>
								<!-- <button type="button" class="btn btn-yellow">주문접수</button> -->
								<button type="button" class="btn-list" onclick="location.href='${url}/front/order/orderList.lime'"><img src="${url}/include/images/front/common/icon_list@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardView">
							<ul>
								<li class="half">
									<label class="view-h">거래처명</label>
									<div class="view-b">
										${custOrderH.CUST_NM}(${custOrderH.CUST_CD})
									</div>
								</li>
								<li class="half">
									<label class="view-h">납품처 / 주문자</label>
									<div class="view-b">
									<c:choose>
										<c:when test="${empty custOrderH.SHIPTO_CD or '0' eq custOrderH.SHIPTO_CD}">미등록 </c:when>
										<c:otherwise>${custOrderH.SHIPTO_NM}(${custOrderH.SHIPTO_CD}) </c:otherwise>
									</c:choose>
									/ ${custOrderH.USER_NM}(${custOrderH.USERID})
									</div>
								</li>
								<li class="half">
									<label class="view-h">주문일자</label>
									<div class="view-b">
									<c:choose>
										<c:when test="${empty custOrderH.INDATE}">-</c:when>
										<c:otherwise>${fn:substring(custOrderH.INDATE, 0, 16)}</c:otherwise>
									</c:choose>
									</div>
								</li>
								<li class="half">
									<label class="view-h">납품요청일</label>
									<div class="view-b">
										<c:choose>
											<c:when test="${empty custOrderH.REQUEST_DT}">-</c:when>
											<c:otherwise>
												${fn:substring(custOrderH.REQUEST_DT, 0, 4)}-${fn:substring(custOrderH.REQUEST_DT, 4, 6)}-${fn:substring(custOrderH.REQUEST_DT, 6, 8)} 
												${fn:substring(custOrderH.REQUEST_TIME, 0, 2)}:${fn:substring(custOrderH.REQUEST_TIME, 2, 4)}
											</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li class="half">
									<label class="view-h">인수자명</label>
									<div class="view-b">
										<c:choose>
											<c:when test="${empty custOrderH.RECEIVER}">-</c:when>
											<c:otherwise>${custOrderH.RECEIVER}</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li class="half">
									<label class="view-h">연락처 / 연락처2</label>
									<div class="view-b">
										${custOrderH.TEL1} / 
										<c:choose>
											<c:when test="${empty custOrderH.TEL2}">-</c:when>
											<c:otherwise>${custOrderH.TEL2}</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li class="half">
									<label class="view-h">영업담당자</label>
									<div class="view-b">
										<c:choose>
											<c:when test="${empty custOrderH.SALESUSERID}">-</c:when>
											<c:otherwise>${custOrderH.SALESUSER_NM}(${custOrderH.SALESUSERID})</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li class="half">
									<label class="view-h">운송수단</label>
									<div class="view-b">
										<c:if test="${'AA' eq custOrderH.TRANS_TY}">기본운송</c:if>
										<c:if test="${'AB' eq custOrderH.TRANS_TY}">자차운송(주문처운송)</c:if>
									</div>
								</li>
								<li>
									<label class="view-h">납품주소</label>
									<div class="view-b">
										<c:choose>
											<c:when test="${'AA' eq custOrderH.TRANS_TY}">
												[${custOrderH.ZIP_CD}] ${custOrderH.ADD1} ${custOrderH.ADD2}
											</c:when>
											<c:otherwise>
												<!-- 자차운송(주문처운송) -->
												<%-- [${custOrderH.ZIP_CD}] ${custOrderH.ADD1} ${custOrderH.ADD2} --%>
												${custOrderH.ADD1} ${custOrderH.ADD2} <%-- 우편번호는 90000이 되어서 출력 필요 없을듯. --%>
											</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li>
									<label class="view-h">요청사항</label>
									<div class="view-b">
										<td colspan="3">${custOrderH.REMARK}</td>
									</div>
								</li>
								<li>
									<label class="view-h">거래처 주의사항</label>
									<div class="view-b">
										<td colspan="3">
											<c:if test="${!empty orderConfirmD}">${orderConfirmD[0].CUSTOMMATTER}</c:if>
										</td>
									</div>
								</li>
								<c:if test="${'02' eq custOrderH.STATUS_CD or '03' eq custOrderH.STATUS_CD}">
									<li>
									<label class="view-h">
										<c:if test="${'02' eq custOrderH.STATUS_CD}">CS취소 사유</c:if>
										<c:if test="${'03' eq custOrderH.STATUS_CD}">CS반려 사유</c:if>
									</label>
									<div class="view-b">
										<td colspan="3">[${custOrderH.RETURN_REASON}]&nbsp;${custOrderH.RETURN_DESC}</td>
									</div>
								</li>
								</c:if>
							</ul>
						</div> <!-- boardView -->
						
					</div> <!-- boardViewArea -->
					
					<div class="boardListArea">
						<h2 class="title">
							주문품목
							<div class="title-right little">
								<%-- <button type="button" class="btn btn-line" onclick="alert('${custOrderH.RETURN_DESC}');">CS취소 확인</button> --%>
							</div>
						</h2>
						
						<div class="boardList">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="8%" />
									<col width="17%" />
									<col width="50%" />
									<col width="10%" />
									<col width="15%" />
								</colgroup>
								<thead>
									<tr>
										<th>NO</th>
										<th>품목코드</th>
										<th>품목명</th>
										<th>단위</th>
										<th>수량</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${custOrderD}" var="list" varStatus="status">
										<tr>
											<td><fmt:formatNumber value="${status.count}" pattern="#,###" /></td>
											<td>${list.ITEM_CD}</td>
											<td class="text-left">${list.DESC1}</td>
											<td>${list.UNIT}</td>
											<td class="text-right">
												<fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" />
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							
						</div> <!-- boardList -->
						
					</div> <!-- boardListArea -->
					
					<c:if test="${!empty orderConfirmD}">
					<%-- <c:if test="${'99' ne custOrderH.STATUS_CD and '00' ne custOrderH.STATUS_CD and '01' ne custOrderH.STATUS_CD}"> --%>
					<div class="boardListArea">
						<h2 class="title">
							주문확정품목
							<div class="title-right little">
								<!-- <button type="button" class="btn btn-line" onclick="popup('productSearchPop.html', 955, 655);">CS반려(전체)</button> -->
							</div>
						</h2>
						
						<div class="boardList">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
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
								</colgroup>
								<thead>
									<tr>
										<th>주문번호</th>
										<th>라인</th>
										<th>출고지</th>
										<th>품목코드</th>
										<th>품목명</th>
										<th>단위</th>
										<th>출고수량</th>
										<th>주차</th>
										<th>피킹일시</th>
										<th>기타</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${orderConfirmD}" var="list" varStatus="status">
										<c:set var="now_custpo" value="${list.CUST_PO}" />
										<c:set var="pre_custpo" value="" />
										<c:if test="${0 eq status.index }"><c:set var="pre_custpo" value="" /></c:if>
										<c:if test="${0 ne status.index }"><c:set var="pre_custpo" value="${orderConfirmD[status.index-1].CUST_PO}" /></c:if>
										
										<tr>
											<td class="text-left">
												<c:if test="${pre_custpo ne now_custpo}">${list.CUST_PO}</c:if>
											</td>
											<td class="text-center">${list.LINE_NO}</td>
											<td class="text-left">${list.PT_NAME}</td>
											<td class="text-left">${list.ITEM_CD}</td>
											<td class="text-left">${list.ITEM_NAME}</td>
											<td class="text-left">${list.UNIT}</td>
											
											<c:choose>
											<%-- 품목 --%>
											<c:when test="${'W1' ne list.ITEM_CD and 'R1' ne list.ITEM_CD and 'P1' ne list.ITEM_CD and 'F3' ne list.ITEM_CD and 'F2' ne list.ITEM_CD and 'F1' ne list.ITEM_CD}">
											
												<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" /></td>
												<td class="text-left">
													<c:if test="${!empty list.DRSPHD}">${list.DRSPHD}년 ${list.DRDL01}</c:if>
													<c:if test="${empty list.DRSPHD}">-</c:if>
												</td>
												<td class="text-left">
													<c:if test="${!empty list.PICKING_DT}">${fn:substring(list.PICKING_DT, 0, 4)}-${fn:substring(list.PICKING_DT, 4, 6)}-${fn:substring(list.PICKING_DT, 6, 8)}</c:if>
													<c:if test="${empty list.PICKING_DT}">-</c:if>
												</td>
											</c:when>
											<%-- 배송비 --%>
											<c:otherwise>
												<td colspan="3" class="text-left">운송비 금액   <fmt:formatNumber value="${list.PRICE}" type="number" pattern="#,###.##" /></td>
											</c:otherwise>
											</c:choose>
											
											<td class="text-right">
												<%-- CS반려 --%>
												<c:if test="${'03' eq list.OCD_STATUSCD}">
													<button type="button" class="btn btn-gray" onclick="alert('[${list.ITEM_RETURN_REASON}] ${list.OCD_RETURNMSG}');">CS반려</button>
												</c:if>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="*" />
									<col width="*" />
									<col width="*" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th>주문번호</th>
										<th>출고지</th>
										<th>품목명</th>
										<th>피킹일시</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${orderConfirmD}" var="list" varStatus="status">
										<c:set var="now_custpo" value="${list.CUST_PO}" />
										<c:set var="pre_custpo" value="" />
										<c:if test="${0 eq status.index }"><c:set var="pre_custpo" value="" /></c:if>
										<c:if test="${0 ne status.index }"><c:set var="pre_custpo" value="${orderConfirmD[status.index-1].CUST_PO}" /></c:if>
										
										<tr>
											<td class="text-left">
												<c:if test="${pre_custpo ne now_custpo}">${list.CUST_PO}</c:if>
											</td>
											<td class="text-left">${list.PT_NAME}</td>
											<td class="text-left">${list.ITEM_NAME}</td>
											
											<c:choose>
											<%-- 품목 --%>
											<c:when test="${'W1' ne list.ITEM_CD and 'R1' ne list.ITEM_CD and 'P1' ne list.ITEM_CD and 'F3' ne list.ITEM_CD and 'F2' ne list.ITEM_CD and 'F1' ne list.ITEM_CD}">
												<td class="text-left">
													<c:if test="${!empty list.PICKING_DT}">${fn:substring(list.PICKING_DT, 0, 4)}-${fn:substring(list.PICKING_DT, 4, 6)}-${fn:substring(list.PICKING_DT, 6, 8)}</c:if>
													<c:if test="${empty list.PICKING_DT}">-</c:if>
												</td>
											</c:when>
											</c:choose>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div> <!-- boardList -->
						
					</div> <!-- boardListArea -->
					</c:if>
					
				</div> <!-- Col-md-12 -->
			</div> <!-- Row -->
			
		</div> <!-- Content -->
	</main> <!-- Container -->
	
	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>
	
	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
	
	<!-- Modal -->
	<div class="modal fade" id="orderPaperPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content paper">
				
			</div>
		</div>
	</div>
</div> <!-- Wrap -->

</body>
</html>