<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
<meta name="title" content="e-Ordering System">
<meta name="keywords" content="e-Ordering System">
<meta name="description" content="e-Ordering System">
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<%-- <c:if test="${!isLayerPop}"> --%>
<link rel="shortcut icon" href="${url}/data/config/favicon.ico" type="image/x-icon" /><!-- 파비콘 -->
<script src="${url}/include/js/common/jquery/jquery-2.1.4.min.js"></script>
<script src="${url}/include/js/lime.js"></script>
<%-- <link rel="stylesheet" href="${url}/include/css/modern.css" /> --%>
<%-- </c:if> --%>

<script src="${url}/include/js/common/jquery-print/printThis.js"></script>

<!-- css -->
<link rel="stylesheet" href="${url}/include/css/front/screen.css?202009101" media="screen" />
<link rel="stylesheet" href="${url}/include/css/front/print.css?202009101" media="print" />

<%-- 2025-04-07 hsg Jackknife Hold : @page에 size를 'auto'를 'A4 portrait'로 변경 --%>
<style type="text/css" media="print">
	@page {size: A4 portrait; margin : 5mm 4.7mm 5mm 4.7mm;}
	div.orderPop {
		page-break-after: always;
		page-break-inside: avoid;
	}
	
	.nextPage {page-break-before:always}
	
	#wrapper .close {
		display: none !important;
	}
</style>
<style type="text/css" media="screen">
	#wrapper .close {
		display: none;
	}
	#wrapper.app .close {
		display: block;
		position: fixed;
		top: 20px;
		left: 15px;
		z-index: 1;
		background-color: transparent;
		border: none;
		outline: none;
	}
	#wrapper.app #body {
		width: 800px;
	}
	#wrapper.app .deliveryPop {
		margin-right: 0;
		margin-left: 0;
		padding: 0 15px;
	}
	#wrapper.app .deliveryPop div.bottomArea {
		right: 0;
		left: 0;
		padding: 0 15px;
	}
	
	
</style>
<script type="text/javascript">
$(function(){
	if(isApp()){
		$('#wrapper').addClass('app');
	}
});

$(document).ready(function(){
	console.log('Delivery Paper Pop');
	
	if('11' == '${param.paper_type}' || '21' == '${param.paper_type}'){
		//console.log('rowSpanListToJson : ', $.parseJSON('${rowSpanListToJson}'));
		var rowSpanListToJson = $.parseJSON('${rowSpanListToJson}');
		$(rowSpanListToJson).each(function(i,e){
			var idx = 0;
			for(var key in e) {
				var firstTf = true;
				$('.pageDivClass_'+i).find('.itemDescTrClass > .itemDescTdClass').each(function(i2,e2){
					if(key == $(e2).attr('itemDescAttr')){
						if(firstTf){
							$(e2).prop('rowspan', e[key]);
							firstTf = false;
						}else{
							$(e2).remove();
						}
					}
				});
			}
			
		});
	}
	
	if(isApp()){
		$('.printAreaDivClass').printThis();
	}
	else{
		if(window.print){
			//$('.printAreaDivClass').printThis();
			window.print();
		}
		else {
			alert("지원되지 않습니다.");
		}
	}
});

</script>

<body class="he100 printAreaDivClass">

<c:forEach items="${deliveryPaperList}" var="pageList" varStatus="status">

<!-- BEGIN wrapper -->
<div id="wrapper" class="pageDivClass_${status.index}" <c:if test="${0 < status.index}">class="nextPage"</c:if>>

	<button type="button" class="close" onclick="history.back();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>

	<!-- BEGIN body -->
	<div id="body">
	
		<!-- BEGIN container -->
		<div class="containerPop">
		
			<div class="deliveryPop">

				<div class="wd_48 right ta_rgt">
					<img src="${url}/include/images/front/common/usg_boral_logo.png" class="logo" style="width:auto; height:50px;" alt="logo" />
				</div>

				<h1>자재납품 확인서</h1>
				
				
				<div class="wd_50 left txtArea">
					<table class="fl_lft" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<c:if test="${'10' eq param.paper_type or '11' eq param.paper_type or '12' eq param.paper_type}">
								<tr>
									<td>거래처명 :</td>
									<td>${fn:trim(custInfo.CUST_NM)}</td>
								</tr>
								<tr>
									<td>현&nbsp; 장&nbsp; 명 :</td>
									<td>${fn:trim(custInfo.SHIPTO_NM)}</td>
								</tr>
								<tr>
									<td>출고일시 :</td>
									<td>
										<fmt:parseDate var="startDateStr" value="${startDate}" pattern="yyyyMMdd" />
										<fmt:parseDate var="endDateStr" value="${endDate}" pattern="yyyyMMdd" />
										<fmt:formatDate value="${startDateStr}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${endDateStr}" pattern="yyyy-MM-dd"/>
									</td>
								</tr>
							</c:if>
							<c:if test="${'20' eq param.paper_type or '21' eq param.paper_type or '22' eq param.paper_type}">
								<tr>&nbsp;</tr>
								<tr>
									<td>거래처명 :</td>
									<td>${fn:trim(custInfo.CUST_NM)}</td>
								</tr>
								<!--<c:if test="${'22' eq param.paper_type}">
								<tr>
									<td>배송지명 :</td>
									<td>${fn:trim(custInfo.SHIPTO_NM)}</td>
								</tr>
								</c:if>-->
								<tr>
									<td>출고일시 :</td>
									<td>
										<fmt:parseDate var="startDateStr" value="${startDate}" pattern="yyyyMMdd" />
										<fmt:parseDate var="endDateStr" value="${endDate}" pattern="yyyyMMdd" />
										<fmt:formatDate value="${startDateStr}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${endDateStr}" pattern="yyyy-MM-dd"/>
									</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<div class="line2px proList">
					<table id="tbl_list_${status.index}" width="100%" border="0" cellpadding="0" cellspacing="0">
					
						<%-- ####### 개별  ####### --%>
						<c:if test="${'10' eq param.paper_type or '20' eq param.paper_type}">
							<colgroup>
								<col width="12%" />
								<col width="26%" />
								<col width="8%" />
								<col width="6%" />
								<col width="15%" />
								<col width="33%" />
							</colgroup>
							<tbody>
								<tr>
									<th>출하일자</th>
									<th>품목</th>
									<th>수량</th>
									<th>단위</th>
									<th>제조사</th>
									<th>배송지</th>
								</tr>
								<c:forEach items="${pageList}" var="itemList" varStatus="status2">
									<c:if test="${itemList.ORDER_QTY != 0}">
										<tr>
											<td>
												<fmt:parseDate var="actualShipDt" value="${itemList.ACTUAL_SHIP_DT}" pattern="yyyyMMdd" />
												<fmt:formatDate value="${actualShipDt}" pattern="yyyy-MM-dd"/>
											</td>
											<td class="ta_lft" id='td_item'>${fn:trim(itemList.ITEM_DESC)}</td>
											<!-- 납품확인서 출력 시 개수가 0인 경우 출력되지 않도록 예외 처리 psy -->
											<td class="ta_rgt" id='td_qty'>
												<fmt:formatNumber value="${fn:trim(itemList.ORDER_QTY)}" type="number" pattern="#,###" />
											</td>
											<td>${fn:trim(itemList.UNIT)}</td>
											<td>${fn:trim(itemList.MANUFACT)}</td>
											<!-- <td>
												<c:choose>
													<c:when test="${'255' eq itemList.ITEM_CD_3}">세경산업㈜</c:when>
													<c:when test="${'254' eq itemList.ITEM_CD_3}">생고뱅이소바코리아</c:when>
													<c:when test="${'21M' eq itemList.ITEM_CD_3}">유창㈜</c:when>
													<c:otherwise>크나우프 석고보드㈜</c:otherwise>
												</c:choose>
											</td>-->
											<td class="ta_lft" id="td_addr">
												<c:set value="${fn:trim(itemList.ADD1)}" var="add1" />
												<c:set value="${fn:trim(itemList.ADD2)}" var="add2" />
												${add1}<c:if test="${'' ne add2 and !empty add2}"> ${add2}</c:if>
											</td>
										</tr>
									</c:if>
								</c:forEach>
							</tbody>
						</c:if>
						
						<%-- ####### 아이템별 ####### --%>
						<c:if test="${'11' eq param.paper_type or '21' eq param.paper_type}">
							<colgroup>
								<col width="26%" />
								<col width="12%" />
								<col width="8%" />
								<col width="6%" />
								<col width="15%" />
								<col width="33%" />
							</colgroup>
							<tbody>
								<tr>
									<th>품목</th>
									<th>출하일자</th>
									<th>수량</th>
									<th>단위</th>
									<th>제조사</th>
									<th>배송지</th>
								</tr>
								<c:forEach items="${pageList}" var="itemList" varStatus="status2">
									<c:set value="${itemList.ACTUAL_SHIP_DT}" var="actualShipDt" />
									
									<tr class="itemDescTrClass" <c:if test="${'소계' eq actualShipDt}">style="background-color:#f5f5f5; font-weight:700;"</c:if>>
										<td class="ta_lft itemDescTdClass"  id='td_item' itemDescAttr="${fn:trim(itemList.ITEM_DESC)}">${fn:trim(itemList.ITEM_DESC)}</td>
										<td>
											
											<c:choose>
												<c:when test="${'소계' eq actualShipDt}">소계</c:when>
												<c:otherwise>
													<fmt:parseDate var="actualShipDt" value="${actualShipDt}" pattern="yyyyMMdd" />
													<fmt:formatDate value="${actualShipDt}" pattern="yyyy-MM-dd"/>
												</c:otherwise>
											</c:choose>
										</td>
										<td class="ta_rgt" id='td_qty'><fmt:formatNumber value="${fn:trim(itemList.SUM_ORDER_QTY)}" type="number" pattern="#,###" /></td>
										<td>
											<c:choose>
												<c:when test="${!empty fn:trim(itemList.UNIT)}">${fn:trim(itemList.UNIT)}</c:when>
												<c:otherwise>
													${fn:trim(pageList[status2.index-1].UNIT)}
												</c:otherwise>
											</c:choose>
										</td>
										<td>${fn:trim(itemList.MANUFACT)}</td>
										<!--<td>
											<c:choose>
												<c:when test="${'255' eq itemList.ITEM_CD_3}">세경산업㈜</c:when>
												<c:when test="${'254' eq itemList.ITEM_CD_3}">생고뱅이소바코리아</c:when>
												<c:when test="${'21M' eq itemList.ITEM_CD_3}">유창㈜</c:when>
												<c:when test="${empty itemList.ITEM_CD_3}"></c:when>
												<c:otherwise>크나우프 석고보드㈜</c:otherwise>
											</c:choose>
										</td>-->
										<td class="ta_lft" id="td_addr">
											<c:set value="${fn:trim(itemList.ADD1)}" var="add1" />
											<c:set value="${fn:trim(itemList.ADD2)}" var="add2" />
											${add1}<c:if test="${'' ne add2 and !empty add2}"> ${add2}</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</c:if>
						
						<%-- ####### 아이템별-총합 ####### --%>
						<c:if test="${'12' eq param.paper_type or '22' eq param.paper_type}">
							<colgroup>
								<col width="38%" />
								<col width="12%" />
								<col width="10%" />
								<col width="12%" />
								<col width="10%" />
								<col width="18%" />
							</colgroup>
							<tbody>
								<tr>
									<th>품목</th>
									<th>수량</th>
									<th>단위</th>
									<th>헤베수량</th>
									<th>헤베단위</th>
									<th>제조사</th>
								</tr>
								<c:forEach items="${pageList}" var="itemList" varStatus="status2">
									<tr>
										<td class="ta_lft" id='td_item'>${fn:trim(itemList.ITEM_DESC)}</td>
										<td class="ta_rgt" id='td_qty'><fmt:formatNumber value="${fn:trim(itemList.ORDER_QTY)}" type="number" pattern="#,###" /></td>
										<td>${fn:trim(itemList.UNIT)}</td>
										<td class="ta_rgt" id='td_qty'><fmt:formatNumber value="${fn:trim(itemList.PRIMARY_QTY)}" type="number" pattern="#,###" /></td>
										<td>${fn:trim(itemList.UNIT1)}</td>
										<td>${fn:trim(itemList.MANUFACT)}</td>
										<!-- <td>
											<c:choose>
												<c:when test="${'255' eq itemList.ITEM_CD_3}">세경산업㈜</c:when>
												<c:when test="${'254' eq itemList.ITEM_CD_3}">생고뱅이소바코리아</c:when>
												<c:when test="${'21M' eq itemList.ITEM_CD_3}">유창㈜</c:when>
												<c:otherwise>크나우프 석고보드㈜</c:otherwise>
											</c:choose>
										</td>-->
									</tr>
								</c:forEach>
							</tbody>
						</c:if>
						
					</table>
				</div>


				<div class="bottomArea" style="bottom:45px;">
					<!--<c:if test="${'10' eq param.paper_type or '11' eq param.paper_type}">
						<em><div style='float:left;'>상기 품목을 ${fn:trim(custInfo.SHIPTO_NM)}에 납품함을 확인합니다.</div><div style='float:right;'>${todayDate}</div></em>
					</c:if>
					<c:if test="${'20' eq param.paper_type or '21' eq param.paper_type}">
						<em><div style='float:left;'>상기 품목을 ${fn:trim(custInfo.CUST_NM)}에 납품함을 확인합니다.</div><div style='float:right;'>${todayDate}</div></em>
					</c:if>-->
					<em><div style='float:right;'>${todayDate}</div></em>
					<em><div style='float:right;'>영업 담당: ${fn:trim(custInfo.SALESREP_NM)}</div></em>
					<strong>
						크나우프 석고보드 주식회사<br />
						전라남도 여수시 낙포단지길 45(낙포동)<br /><br />
						대표이사: 송광섭
						<img src="${url}/data/config/${ceosealImg}" class="stamp" style='top:70px; width:70px; height:70px; right:30%;' />
					</strong>
					
					<em><div style='float:right;'>Page ${status.count} of ${totPageCnt}</div></em>
					<em style='margin-top:5px; margin-bottom:5px; width:100%; height:2px; background-color:black;'></em>
					<em><div style='float:left;'>크나우프 석고보드㈜</div><div style='float:right;'>Tel : 02-6902-3100</div></em>
					<em style='postion:absolut; top:150px;'><div style='float:left;'>서울특별시 강남구 테헤란로87길 38(삼성동) 도심공항 타워 7층</div><div style='float:right;'>Fax : 02-6902-3190</div></em>

					<!-- <table class="fl_lft" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="80%" />
							<col width="20%" />
						</colgroup>
						<tbody>
							<tr>
								<td colspan="2" class="ta_rgt bordeB013">Page ${status.count} of ${totPageCnt}</td>
							</tr>
							<tr>
								<td>
									크나우프 석고보드㈜<br />서울특별시 강남구 테헤란로87길 38(삼성동) 도심공항 타워 7층 (06164)
								</td>
								<td class="ta_rgt">Tel : 02-6902-3100<br />Fax : 02-6902-3190</td>
							</tr>
						</tbody>
					</table> -->

				</div>
				
			</div>
			
		</div><!-- END container -->
		
	</div><!-- END body -->

</div><!-- END wrapper -->

</c:forEach>







</body>
</html>