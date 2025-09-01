<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>
<script type="text/javascript">

//배송추적
function openTruckMapPop_pop(obj, truck_no, deli_type, plantDesc, actualShipDt, driverPhone, driverName, add1, orderno, orderty, line_no){
	<c:if test="${!isLayerPop}">
		opener.openTruckMapPop(obj, truck_no, deli_type, plantDesc, actualShipDt, driverPhone, driverName, add1, orderno, orderty, line_no);
		self.close();
	</c:if>
	<c:if test="${isLayerPop}">
		$('#salesOrderViewPopMId').modal('hide');
		openTruckMapPop(obj, truck_no, deli_type, plantDesc, actualShipDt, driverPhone, driverName, add1, orderno, orderty, line_no);
		
		$(document).on('shown.bs.modal', function (e) {
			$(e.target).parents('body').addClass('modal-open');
		});
	</c:if>
}

//거래명세표
function orderPaperPop_pop(obj, orderno, custpo){
	<c:if test="${!isLayerPop}">
		opener.orderPaperPop(obj, orderno, custpo);
		self.close();
	</c:if>
	<c:if test="${isLayerPop}">
		$('#salesOrderViewPopMId').modal('hide');
		orderPaperPop(obj, orderno, custpo);
	</c:if>
}
	
</script>

</head>

<body> <!-- 팝업사이즈 615 * 650 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">
	<!-- Container Fluid -->
	<div class="container-fluid product-search product-detail">
	
		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="panel-title">
			<h2>
				출고상세
			</h2>
		</div>
		<div class="boardViewArea">
			<div class="tableView">
				<c:if test="${param.page_type eq 'salesOrderViewPop'}">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="15%">
						<col width="85%">
					</colgroup>
					<tbody>
					<tr>
						<th>오더번호</th>
						<td>
							${salesOrder.ORDERNO}
						</td>
					</tr>
					<tr>
						<th>주문번호</th>
						<td>
							${salesOrder.CUST_PO}
						</td>
					</tr>
					<tr>
						<th>오더코드</th>
						<td>
							${salesOrder.ORDERTY}
						</td>
					</tr>
					<tr>
						<th>품목코드</th>
						<td>
							${salesOrder.ITEM_CD}
						</td>
					</tr>
					<tr>
						<th>품목명</th>
						<td>
							${salesOrder.ITEM_DESC}
						</td>
					</tr>
					<tr>
						<th>수량</th>
						<td>
							<fmt:formatNumber value="${salesOrder.ORDER_QTY}" type="number" pattern="#,###.##" />
						</td>
					</tr>
					<tr>
						<th>단위</th>
						<td>
							${salesOrder.UNIT}
						</td>
					</tr>
					<tr>
						<th>오더상태</th>
						<td>
							${salesOrder.STATUS_DESC}
						</td>
					</tr>
					<tr>
						<th>납품처명</th>
						<td>
							${salesOrder.SHIPTO_NM}
						</td>
					</tr>
					<tr>
						<th>납품주소</th>
						<td>
							${salesOrder.ADD1}
						</td>
					</tr>
					<tr>
						<th>출하지</th>
						<td>
							${salesOrder.PLANT_DESC}
						</td>
					</tr>
					<tr>
						<th>헤베수량</th>
						<td>
							${salesOrder.PRIMARY_QTY}
						</td>
					</tr>
					<tr>
						<th>기사TEL</th>
						<td>
							${salesOrder.DRIVER_PHONE}
						</td>
					</tr>
					<tr>
						<th>납품요청일</th>
						<td>
							<c:if test="${!empty salesOrder.REQUEST_DT}">
								<fmt:parseDate value="${salesOrder.REQUEST_DT}" var="requestDate" pattern="yyyyMMdd"/>
								<fmt:formatDate value="${requestDate}" pattern="yyyy-MM-dd"/>
							</c:if>
							<c:if test="${!empty salesOrder.REQUEST_TIME}">
								<fmt:parseDate value="${salesOrder.REQUEST_TIME}" var="requestTime" pattern="HHmm"/>
								<fmt:formatDate value="${requestTime}" pattern="HH:mm"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>출하일자</th>
						<td>
							<c:if test="${!empty salesOrder.ACTUAL_SHIP_DT}">
								<fmt:parseDate value="${salesOrder.ACTUAL_SHIP_DT}" var="actualShipDt" pattern="yyyyMMdd"/>
								<fmt:formatDate value="${actualShipDt}" pattern="yyyy-MM-dd"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td>
							${salesOrder.ADD3}
						</td>
					</tr>
					<tr>
						<th>보류코드</th>
						<td>
							${salesOrder.HOLD_CODE}
						</td>
					</tr>
					<tr>
						<th>접수자</th>
						<td>
							${salesOrder.SALESREP_NM}
						</td>
					</tr>
					<tr>
						<th>기능</th>
						<td>
							<c:if test="${530 <= salesOrder.STATUS2}">
								<button type="button" class="btn btn-line" onclick="orderPaperPop_pop(this, '${salesOrder.ORDERNO}', '${salesOrder.CUST_PO}');">거래명세표</button>
							</c:if>
							
							<c:set var="truckNo" value="" />
							<c:set var="driverName" value="" />
							<c:if test="${!empty salesOrder.TRUCK_NO}">
								<c:set var="truckNo" value="${fn:substring(salesOrder.TRUCK_NO, 0, 9)}" />
								<c:set var="driverName" value="${fn:substring(salesOrder.TRUCK_NO, 9, fn:length(salesOrder.TRUCK_NO))}" />
							</c:if>
							<c:if test="${!empty salesOrder.TRUCK_NO and (salesOrder.DUMMY eq 'H' or salesOrder.DUMMY eq 'D') and '출하완료' eq salesOrder.STATUS_DESC}">
								<button type="button" class="btn btn-gray" onclick="openTruckMapPop_pop(this, '${truckNo}', '${salesOrder.DUMMY}', '${salesOrder.PLANT_DESC}', '${salesOrder.ACTUAL_SHIP_DT}', '${salesOrder.DRIVER_PHONE}', '${driverName}', '${salesOrder.ADD1}', '${salesOrder.ORDERNO}', '${salesOrder.ORDERTY}', '${salesOrder.LINE_NO}');">배송추적</button>
							</c:if>
						</td>
					</tr>
				</table>
				</c:if>
				<c:if test="${param.page_type eq 'salesOrderMainViewPop'}">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tbody>
						<tr>
							<th>출고일자</th>
							<td>
								<c:if test="${!empty salesOrder.ACTUAL_SHIP_DT}">
									<fmt:parseDate value="${salesOrder.ACTUAL_SHIP_DT}" var="actualShipDt" pattern="yyyyMMdd"/>
									<fmt:formatDate value="${actualShipDt}" pattern="yyyy-MM-dd"/>
								</c:if>
							</td>
						</tr>
						<tr>
							<th>납품처코드</th>
							<td>
								${salesOrder.SHIPTO_CD}
							</td>
						</tr>
						<tr>
							<th>납품처명</th>
							<td>
								${salesOrder.SHIPTO_NM}
							</td>
						</tr>
						<tr>
							<th>수주번호</th>
							<td>
								${salesOrder.ORDERNO}
							</td>
						</tr>
						<tr>
							<th>SO번호</th>
							<td></td>
						</tr>
						<tr>
							<th>품목명</th>
							<td>
								${salesOrder.ITEM_DESC}
							</td>
						</tr>
						<tr>
							<th>수량</th>
							<td>
								<fmt:formatNumber value="${salesOrder.ORDER_QTY}" type="number" pattern="#,###.##" />
							</td>
						</tr>
						<tr>
							<th>SM</th>
							<td>
								<c:set var="SM_content" value="0" />
								<c:set var="SH_content" value="0" />
								<c:set var="KG_content" value="0" />
								<c:if test="${salesOrder.UNIT1 eq 'SM'}"><c:set var="SM_content" value="${salesOrder.PRIMARY_QTY}" /></c:if>
								<c:if test="${salesOrder.UNIT1 eq 'SH'}"><c:set var="SH_content" value="${salesOrder.SECOND_QTY}" /></c:if>
								<c:if test="${salesOrder.UNIT1 eq 'KG'}"><c:set var="KG_content" value="${salesOrder.PRIMARY_QTY}" /></c:if>
								<c:choose>
									<c:when test="${salesOrder.UNIT1 eq 'SM'}">${SM_content}</c:when>
									<c:otherwise>${SH_content}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th>KG</th>
							<td>
								<c:choose>
									<c:when test="${KG_content eq '0'}"></c:when>
									<c:otherwise>${KG_content}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th>출하지</th>
							<td>
								${salesOrder.PLANT_DESC}
							</td>
						</tr>
						<tr>
							<th>도착지</th>
							<td>
								${salesOrder.ADD1}
							</td>
						</tr>
					</table>
				</c:if>
			</div> <!-- tableView -->
			
		</div> <!-- boardViewArea -->
	</div>
</div> <!-- Wrap -->
</body>
</html>