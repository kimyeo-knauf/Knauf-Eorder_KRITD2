<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
</c:if>

<script src="${url}/include/js/common/jquery-print/printThis.js"></script>

<title>거래명세표</title>

<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<!-- css -->
<link rel="stylesheet" href="${url}/include/css/front/screen.css" media="screen" />
<link rel="stylesheet" href="${url}/include/css/front/print.css" media="print" />

<%-- 2025-04-07 hsg Jackknife Hold : @page에 size를 'auto'를 'A4 portrait'로 변경 --%>
<style type="text/css" media="print">
	@page {size: A4 portrait; margin : 5mm 4.7mm 5mm 4.7mm;}
	
	div.estimatePop {
		page-break-after: always;
		page-break-inside: avoid;
	}
</style>

<script type="text/javascript">

$(function(){
	
	var osSize = $('#header1 > div').size();
	var j = 1;
	for (var i=0; i<osSize; i++) {
		var page = 1;
		$('div.containerPop').append('<div id="pageDivId_' + j + '" class="estimatePop"></div>');
		
		// 상단
		var header1Div = $('#header1 > div').eq(i);
		$('#pageDivId_' + j).append(header1Div.html());
		
		var header2Div = $('#header2 > div').eq(i);
		$('#pageDivId_' + j).append(header2Div.html());
		
		// 회사정보
		var customerDiv = $('#customerInfo > div').eq(i);
		$('#pageDivId_' + j).append(customerDiv.html());
		
		// 상품리스트
		$('#pageDivId_' + j).append(getProductHtml(j));
		
		var p = 0;
		$('#productListDivId > div').eq(i).find('tr').each(function(k) {
			if (k > 0) {
				var trHtml = $(this).clone().wrapAll('<table/>').parent().html();
				$('#productListTableId_' + j + ' tbody').append(trHtml);
				p++;
				
				if ($('#productListTableId_' + j).height() > getProductListHeight(page)) {		// 지정된 높이보다 크다면
					console.log('k='+k+', page='+page+', j='+j+', p='+p);
					$('#productListTableId_' + j + ' tr').eq(p).remove();		// 일단 그놈을 삭제하고
					$('#pageDivId_' + j).append('<div>&nbsp;</div>');	// 여백을 만들고
					$('div.containerPop').append('<p id="pagePId_' + j + '" style="page-break-before:always;"></p>');	// 페이지를 다음으로 넘긴다음
					page++;
					j++;
					p = 1;
					$('div.containerPop').append('<div id="pageDivId_' + j + '" class="estimatePop"></div>');		// div를 다시 만들고
					$('#pageDivId_' + j).append(getProductHtml(j));		// table을 만들고
					$('#productListTableId_' + j + ' tbody').append(trHtml);	// 그안에 다시 넣는다.
				}
			}
		});

		// 특이사항
		var etcDiv = $('#bottom > div').eq(i);
		$('#pageDivId_' + j).append(etcDiv.html());
		
		// 다음페이지
		if (i < osSize-1) {
			$('div.containerPop').append('<p id="pagePId_' + j + '" style="page-break-before:always;"></p>');
			j++;
		}
	}
	
	// page-break-before: always; 미지원 브라우저 
	$('div.estimatePop').each(function() {
		if ($(this).height() < getOnePageHeight()) {
			var blankHeight = getOnePageHeight() - $(this).height();
			$(this).append('<div style="height:' + blankHeight + 'px;"></div>');
		}
	});
	
	if(isApp()){
		$('.printAreaDivClass').printThis();
	}
	else{
		if(window.print){
			$('.printAreaDivClass').printThis();
			//window.print();
		}
		else {
			alert("지원되지 않습니다.");
		}
	}
});

function getProductHtml(i) {
	var pHtml = '<div class="line2px proList">';
	pHtml += '<table id="productListTableId_' + i + '" width="100%" border="0" cellpadding="0" cellspacing="0">';
	pHtml += '<colgroup><col width="8%" /><col width="*" /><col width="9%" /><col width="14%" /><col width="35%" /></colgroup>';
	pHtml += '<tbody><tr><th>DO NO</th><th>품명및규격</th><th>단위</th><th>수량</th><th>비고</th></tr>';
	pHtml += '</tbody></table></div>';
	return pHtml;
}

function getProductListHeight(page) {
	var userAgent = navigator.userAgent.toLowerCase();
	var browser = {
	    msie    : (/msie/.test( userAgent ) || /trident/.test(userAgent)) && !/opera/.test( userAgent ),
	    safari  : /webkit/.test( userAgent ),
	    firefox : /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ),
	    opera   : /opera/.test( userAgent )
	};
	
	if (page == 1) {
		/*
		if (browser.msie) return 1065;						// IE
		else if ( browser.safari ) return 952;	// Chrome || Safari
		else if ( browser.firefox ) return 985;	// Firefox || NS
		else if ( browser.opera ) return 952;		// Opera
		else return 952;
		*/
		return 600;
	}
	else {
		return 990;
	}
}

function getOnePageHeight() {
	var userAgent = navigator.userAgent.toLowerCase();
	var browser = {
	    msie    : (/msie/.test( userAgent ) || /trident/.test(userAgent)) && !/opera/.test( userAgent ),
	    safari  : /webkit/.test( userAgent ),
	    firefox : /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ),
	    opera   : /opera/.test( userAgent )
	};
	
	if (browser.msie) return 1065;						// IE
	else if ( browser.safari ) return 952;	// Chrome || Safari
	else if ( browser.firefox ) return 985;	// Firefox || NS
	else if ( browser.opera ) return 952;		// Opera
	else return 952;
}


</script>

</head>

<body>

<!-- BEGIN wrapper -->
<div id="wrapper" class="printAreaDivClass">

	<!-- BEGIN body -->
	<div id="body">
	
	<!-- BEGIN container -->
		<div class="containerPop">
		</div><!-- END container -->
	
			<div class="estimatePop" style="display:none">
				
				<div id="header1">
					<c:forEach items="${list}" var="list" varStatus="status">
					<div>
						<div class="wd_25 left topLeft">
							<table class="fl_lft" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="30%" />
									<col width="70%" />
								</colgroup>
								<tbody>
									<tr>
										<th>출고시간</th>
										<td>${fn:substring(list.osList[0].ACTUAL_SHIP_DT,0,4)}-${fn:substring(list.osList[0].ACTUAL_SHIP_DT,4,6)}-${fn:substring(list.osList[0].ACTUAL_SHIP_DT,6,8)}</td>
									</tr>
									<tr>
										<th>운전기사</th>
										<td>${list.osList[0].RECEIVER}</td>
									</tr>
									<tr>
										<th>차량번호</th>
										<td>${list.osList[0].TRUCK_NO}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>	
					</c:forEach>	
				</div>
						
				<div id="header2">
					<c:forEach items="${list}" var="list" varStatus="status">
						<div>
						<h1 class="wd_40 left">거래명세표</h1>
						<div class="line2px wd_35 topRight">
							<table class="fl_lft" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="10%" />
									<col width="22.5%" />
									<col width="22.5%" />
									<col width="22.5%" />
									<col width="22.5%" />
								</colgroup>
								<tbody>
									<tr class="borderNoneB">
										<th rowspan="2">결재</th>
										<th>담당</th>
										<th>대리</th>
										<th>과장</th>
										<th>부장</th>
									</tr>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
						</div>
					</c:forEach>
				</div>
					
					<div id="customerInfo">
						<c:forEach items="${list}" var="list" varStatus="status">
						<div>
							<div class="line2px right">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<colgroup>
										<col width="3%" />
										<col width="12%" />
										<col width="16%" />
										<col width="9%" />
										<col width="10%" />
										<col width="3%" />
										<col width="12%" />
										<col width="16%" />
										<col width="9%" />
										<col width="10%" />
									</colgroup>
									<tbody>
										<tr>
											<th colspan="2">출고번호</th>
											<td colspan="3" class="letterSNo">${list.osList[0].ORDERNO}</td>
											<th colspan="2" class="bordeL01d">거래일자</th>
											<td colspan="3" class="letterSNo">
												<c:if test="${!empty list.osList[0].ACTUAL_SHIP_DT}">
													${fn:substring(list.osList[0].ACTUAL_SHIP_DT,0,4)}-${fn:substring(list.osList[0].ACTUAL_SHIP_DT,4,6)}-${fn:substring(list.osList[0].ACTUAL_SHIP_DT,6,8)}
												</c:if>
												<%-- ${fn:substring(list.osList[0].ORDER_DT,0,4)}-${fn:substring(list.osList[0].ORDER_DT,4,6)}-${fn:substring(list.osList[0].ORDER_DT,6,8)} --%>
											</td>
										</tr>
										<tr>
											<th rowspan="3">공급자</th>
											<th class="bordeL01d">등록번호</th>
											<td colspan="3" class="fontWeightB fontSize15 letterS3">417-81-17256</td>
											<th class="bordeL01d" rowspan="3">공급받는자</th>
											<th class="bordeL01d">등록번호</th>
											<td colspan="3" class="fontWeightB fontSize15 letterS3">
												<c:if test="${!empty list.customer2}">
													${fn:substring(list.customer2.CUST_REG,0,3)}-${fn:substring(list.customer2.CUST_REG,3,5)}-${fn:substring(list.customer2.CUST_REG,5,10)}
												</c:if>
											</td>
										</tr>
										<tr>
											<th class="bordeL01d">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 호</th>
											<td>크나우프 석고보드(주)</td>
											<th class="bordeL01d">대표자</th>
											<!-- <td><em class="ceo" style='text-align:left;'>송광섭</em><img src="${url}/data/config/${ceosealImg}" class="stamp" style="width:50px; height:50px; right:10%;"/></td> -->
											<td style="text-align:left">송광섭<img src="${url}/data/config/${ceosealImg}" class="stamp" style="width:70px; height:70px; right:-40px; top:10%;"/></td>
											<th class="bordeL01d">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 호</th>
											<td>${list.customer2.CUST_NM}</td>
											<th class="bordeL01d">대표자</th>
											<td>
												<c:if test="${'admin' eq where}">${list.customer2.CUST_CEO}</c:if>
												<c:if test="${'front' eq where}">${list[0].customer2.CUST_CEO}</c:if>
											</td>
										</tr>
										<tr>
											<th class="bordeL01d">사업장소</th>
											<td colspan="3">전남 여수시 낙포단지길 45 (낙포동)</td>
											<th class="bordeL01d">사업장주소</th>
											<td colspan="3">
												<c:if test="${'admin' eq where}">${list.customer2.CUST_ADDR}</c:if>
												<c:if test="${'front' eq where}">${list[0].customer2.CUST_ADDR}</c:if>
											</td>
										</tr>
									</tbody>
								</table>
								</div>
								</div>
							</c:forEach>
						</div>
					
						<div id="productListDivId">
							<c:forEach items="${list}" var="list" varStatus="status">
								<div>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodyList bordeTT017b90a1">
									<colgroup>
										<col width="16%" />
										<col width="39%" />
										<col width="9%" />
										<col width="14%" />
										<col width="32%" />
									</colgroup>
									<tbody>
										<tr>
											<th>DO NO</th>
											<th>품명및규격</th>
											<th>단위</th>
											<th>수량</th>
											<th>비고</th>
										</tr>
										<c:forEach items="${list.osList}" var="osList" varStatus="stat">
											<tr>
												<td>${stat.index+1}</td>
												<td class="ta_lft">${osList.ITEM_DESC}</td>
												<td>${osList.UNIT}</td>
												<td class="ta_rgt">${osList.ORDER_QTY}</td>
												<td class="ta_lft">${osList.ADD4}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								</div>
							</c:forEach>
						</div>
				
				<div id="bottom">
					<c:forEach items="${list}" var="list" varStatus="status">
						<div>
						<div class="line2px proList">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>
									<tr>
										<th>납품회사</th>
										<td>${list.osList[0].SHIPTO_NM}</td>
										<th>납품일시</th>
										<td>${fn:substring(list.osList[0].REQUEST_DT,0,4)}-${fn:substring(list.osList[0].REQUEST_DT,4,6)}-${fn:substring(list.osList[0].REQUEST_DT,6,8)}</td>
									</tr>
									<tr>
										<th>납품장소</th>
										<td>
											<c:set var="add1" value="${fn:replace(list.osList[0].ADD1, ' ', '')}" />
											<c:set var="add2" value="${fn:replace(list.osList[0].ADD2, ' ', '')}" />
											${add1}<c:if test="${!empty add2 and '' ne add2}"> ${add2}</c:if>
										</td>
										<th>전화번호</th>
										<td>${list.osList[0].ADD3}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="line2px proList wd_75 left">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="15%" />
									<col width="10%" />
									<col width="25%" />
									<col width="15%" />
									<col width="10%" />
									<col width="25%" />
								</colgroup>
								<tbody>
									<tr>
										<th rowspan="2">정시도착</th>
										<th class="bordeL01d">예</th>
										<td></td>
										<th rowspan="2">제품파손</th>
										<th class="bordeL01d">유</th>
										<td></td>
									</tr>
									<tr>
										<th class="bordeL01d">아니오</th>
										<td></td>
										<th class="bordeL01d">무</th>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="wd_24 right">
							<img src="${url}/include/images/front/common/usg_boral_logo.png" class="logo" alt="logo" />
						</div>
						</div>
					</c:forEach>
				</div>

			</div>
		
		
	</div><!-- END body -->

</div><!-- END wrapper -->

</body>
</html>
