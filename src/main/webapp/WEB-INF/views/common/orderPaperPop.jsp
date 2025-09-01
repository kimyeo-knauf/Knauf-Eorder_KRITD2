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

<c:if test="${!isLayerPop}">
<link rel="shortcut icon" href="${url}/data/config/favicon.ico" type="image/x-icon" /><!-- 파비콘 -->
<script src="${url}/include/js/common/jquery/jquery-2.1.4.min.js"></script>
<script src="${url}/include/js/lime.js"></script>
<%-- <link rel="stylesheet" href="${url}/include/css/modern.css" /> --%>
</c:if>

<script src="${url}/include/js/common/jquery-print/printThis.js"></script>

<!-- css -->
<link rel="stylesheet" href="${url}/include/css/front/screen.css" media="screen" />
<link rel="stylesheet" href="${url}/include/css/front/print.css" media="print" />

<style type="text/css" media="print">
	@page {size: A4 portrait; margin : 5mm 4.7mm 5mm 4.7mm;}
	
	div.orderPop {
		page-break-after: always;
		page-break-inside: avoid;
	}

</style>

<script type="text/javascript">
$(function(){
	var osSize = $('#cust_header > div').size();
	var j = 1;
	for (var i=0; i<osSize; i++) {
		var page = 1;
		$('div.containerPop').append('<div id="pageDivId_' + j + '" class="orderPop" style="page-break-before:always;"></div>');
		
		// header
		var headerDiv = $('#cust_header > div').eq(i);
		$('#pageDivId_' + j).append(headerDiv.html());
		
		// sub
		$('#pageDivId_' + j).append(getProductHtml(j));
		
		// 주문품목
		$('#cust_sub > div').eq(i).find('tr').each(function(k) {
			if (k > 0) {
				var trHtml = $(this).clone().wrapAll('<table/>').parent().html();
				$('#productListTableId_' + j + ' tbody').append(trHtml);
				
				if ($('#productListTableId_' + j).height() > getProductListHeight(page)) {		// 지정된 높이보다 크다면
					console.log('k='+k+', page='+page+', j='+j);
					$('#productListTableId_' + j + ' tr').eq(k+1).remove();		// 일단 그놈을 삭제하고
					$('#pageDivId_' + j).append('<div>&nbsp;</div>');	// 여백을 만들고
					$('div.containerPop').append('<p id="pagePId_' + j + '" style="page-break-before:always;"></p>');	// 페이지를 다음으로 넘긴다음
					page++;
					j++;
					$('div.containerPop').append('<div id="pageDivId_' + j + '" class="orderPop"></div>');		// div를 다시 만들고
					$('#pageDivId_' + j).append(getProductHtml(j));		// table을 만들고
					$('#productListTableId_' + j + ' tbody').append(trHtml);	// 그안에 다시 넣는다.
				}
			}
		});
		
		// confirm Product
		$('#pageDivId_' + j).append(getConfirmProductHtml(j));
		
		// 주문확정품목
		if($('#confirm_sub > div').eq(i).find('tr').length == 1){
			$('#confirmProductListTableId_' + j).remove();
		}
		
		$('#confirm_sub > div').eq(i).find('tr').each(function(k) {
			if (k > 0) {
				var trHtml = $(this).clone().wrapAll('<table/>').parent().html();
				$('#confirmProductListTableId_' + j + ' tbody').append(trHtml);
				
				var height = $('#productListTableId_' + j).height() + $('#confirmProductListTableId_' + j).height();
				
				//alert('productListTableId_ : '+$('#productListTableId_' + j).height()+'\nconfirmProductListTableId_ : '+$('#confirmProductListTableId_' + j).height());
				//alert('height : '+height+'\ngetProductListHeight(page) : '+getProductListHeight(page));
				
				if (height > getProductListHeight(page)) {		// 지정된 높이보다 크다면
					console.log('k='+k+', page='+page+', j='+j);
					$('#confirmProductListTableId_' + j + ' tr').eq(k+1).remove();		// 일단 그놈을 삭제하고
					$('#pageDivId_' + j).append('<div>&nbsp;</div>');	// 여백을 만들고
					$('div.containerPop').append('<p id="pagePId_' + j + '" style="page-break-before:always;"></p>');	// 페이지를 다음으로 넘긴다음
					page++;
					j++;
					$('div.containerPop').append('<div id="pageDivId_' + j + '" class="orderPop"></div>');		// div를 다시 만들고
					$('#pageDivId_' + j).append(getConfirmProductHtml(j));		// table을 만들고
					$('#confirmProductListTableId_' + j + ' tbody').append(trHtml);	// 그안에 다시 넣는다.
				}
			}
		});

		// 다음페이지
		if (i < osSize-1) {
			$('div.containerPop').append('<p id="pagePId_' + j + '" style="page-break-before:always;"></p>');
			j++;
		}
	}

	/* page-break-before: always; 미지원 브라우저 
	$('div.orderPop').each(function() {
		if ($(this).height() < getOnePageHeight()) {
			var blankHeight = getOnePageHeight() - $(this).height();
			$(this).append('<div style="height:' + blankHeight + 'px;"></div>');
		}
	});
	*/
	
	/*if(isApp()){
		$('.printAreaDivClass').printThis();
	}
	else{
		if(window.print){
			$('.printAreaDivClass').printThis();
			//window.print();
		}
		else {
			alert('지원되지 않습니다.');
		}
	}*/

	window.print();
	
});

function getProductHtml(i) {
	var pHtml = '<div class="line2px proList proList2">';
	pHtml += '<table id="productListTableId_' + i + '" width="100%" border="0" cellpadding="0" cellspacing="0">';
	pHtml += '<colgroup><col width="10%" /><col width="65%" /><col width="10%" /><col width="15%" /></colgroup>';
	pHtml += '<tbody><tr><th colspan="4">주문품목</th></tr><tr><th>NO</th><th>제품명</th><th>단위</th><th>주문수량</th></tr>';	//NO, 제품명, 단위, 주문수량
	pHtml += '</tbody></table></div>';
	return pHtml;
}

function getConfirmProductHtml(i) {
	// 20240-10-28 HSG 요청에 따라 출고지 폭을 15%에서 12%로 바꾸고 품목코드 폭을 8%에서 11%로 수정 
	var pHtml = '<div class="line2px proList proList2">';
	pHtml += '<table id="confirmProductListTableId_' + i + '" width="100%" border="0" cellpadding="0" cellspacing="0">';
	pHtml += '<colgroup><col width="4%" /><col width="8%" /><col width="12%" /><col width="11%" /><col width="35%" /><col width="5%" /><col width="9%" /><col width="16%" /></colgroup>';
	pHtml += '<tbody><tr><th colspan="8">주문확정품목</th></tr><tr><th>NO</th><th>주문번호</th><th>출고지</th><th>품목코드</th><th>품목명</th><th>단위</th><th>출고수량</th><th>납품요청일시</th></tr>';	//NO,주문번호,라인,출고지,품목코드,품목명,단위
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
	
// 	alert(userAgent);
	
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
		return 1100;
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
		
	</div><!-- END body -->

</div><!-- END wrapper -->

<div class="orderPop" style="display:none;">
	<div id="cust_header">
		<c:forEach var="list" items="${list}">
			<div>
				<h1>자재주문서</h1>
				
				<div class="wd_48 left">
					<img src="${url}/include/images/front/common/usg_boral_logo.png" class="logo" style="width:auto; height:50px;" alt="logo" />
				</div>
			
				<div class="line2px info wd_49 right">
					<table class="fl_lft" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="36%" />
							<col width="64%" />
						</colgroup>
						<tbody>
							<tr>
								<th>주문번호</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td class="fontWeightB fontSize15"  style="font-size: 15px; letter-spacing: 1px">${list.REQ_NO}</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="line2px info right">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="18%" />
							<col width="32%" />
							<col width="18%" />
							<col width="32%" />
						</colgroup>
						<tbody>
							<tr>
								<th>거래처명</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">${list.CUST_NM}(${list.CUST_CD})</td>
								<th class="bordeL01d">납품처</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.SHIPTO_CD or '0' eq list.SHIPTO_CD}"> </c:when>
										<c:otherwise>${list.SHIPTO_NM}(${list.SHIPTO_CD})</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>주문일시</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.INDATE}">-</c:when>
										<c:otherwise>${fn:substring(list.INDATE, 0, 16)}</c:otherwise>
									</c:choose>
								</td>
								<th class="bordeL01d">영업/CS 담당자</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.SALESUSERID}">-</c:when>
										<c:otherwise>${list.SALESUSER_NM}(${list.SALESUSERID})</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>납품요청일</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.REQUEST_DT}">-</c:when>
										<c:otherwise>
											${fn:substring(list.REQUEST_DT, 0, 4)}-${fn:substring(list.REQUEST_DT, 4, 6)}-${fn:substring(list.REQUEST_DT, 6, 8)} 
										</c:otherwise>
									</c:choose>
								</td>
								<th class="bordeL01d">요청시간</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.REQUEST_TIME}">-</c:when>
										<c:otherwise>
											${fn:substring(list.REQUEST_TIME, 0, 2)}:${fn:substring(list.REQUEST_TIME, 2, 4)}
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>현장명</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td colspan="3" style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${empty list.SHIPTO_CD or '0' eq list.SHIPTO_CD}"> </c:when>
										<c:otherwise>${list.SHIPTO_NM}(${list.SHIPTO_CD})</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>남품주소</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td colspan="3" style="font-size: 15px; letter-spacing: 1px">
									<c:choose>
										<c:when test="${'AA' eq list.TRANS_TY}">
											[${list.ZIP_CD}] ${list.ADD1}${list.ADD2}
										</c:when>
										<c:otherwise>
											<!-- 자차운송(주문처운송) -->
											<%-- [${list.ZIP_CD}] ${list.ADD1} ${list.ADD2} --%>
											${list.ADD1}${list.ADD2} <%-- 우편번호는 90000이 되어서 출력 필요 없을듯. --%>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>연락처</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td colspan="3" style="font-size: 15px; letter-spacing: 1px">
									${list.TEL1} / 
									<c:choose>
										<c:when test="${empty list.TEL2}">-</c:when>
										<c:otherwise>${list.TEL2}</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>고객요청사항</th>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td colspan="3" style="font-size: 15px; letter-spacing: 1px">${list.REMARK}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</c:forEach>
	</div>
	
	<div id="cust_sub">
		<c:forEach var="list" items="${list}">
		<div>
			<div class="line2px proList">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="10%" />
						<col width="65%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<tbody>
						<tr>
							<th>NO</th>
							<th>제품명</th>
							<th>단위</th>
							<th>주문수량</th>
						</tr>
						<c:forEach var="product" items="${list.subList}" varStatus="st">
							<tr>
								<td><fmt:formatNumber value="${st.count}" pattern="#,###" /></td>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td class="ta_lft" style="font-size: 15px; letter-spacing: 1px">${product.DESC1}</td>
								<td>${product.UNIT}</td>
								<!-- 2024-10-23 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
								<td class="ta_rgt" style="font-size: 15px; letter-spacing: 1px"><fmt:formatNumber value="${product.QUANTITY}" pattern="#,###" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		</c:forEach>
	</div>
	
	<div id="confirm_sub">
		<c:forEach var="list" items="${list}">
			<div>
				<div class="line2px proList">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="4%" />
							<col width="8%" />
<!-- 							<col width="6%" /> -->
							<col width="15%" />
							<col width="8%" />
							<col width="35%" />
							<col width="5%" />
							<col width="9%" />
							<col width="16%" />
<!-- 							<col width="12%" /> -->
						</colgroup>
						<tbody>
							<tr>
								<th>NO</th>
								<th>주문번호</th>
<!-- 								<th>라인</th> -->
								<th>출고지</th>
								<th>품목코드</th>
								<th>품목명</th>
								<th>단위</th>
								<th>출고수량</th>
								<th>납품요청일시</th>
<!-- 								<th>피킹일자</th> -->
							</tr>
							<c:forEach var="confirm" items="${list.confirmList}" varStatus="cf">
								<c:set var="now_custpo" value="${confirm.CUST_PO}" />
								<c:set var="pre_custpo" value="" />
								<c:if test="${0 eq status.index}"><c:set var="pre_custpo" value="" /></c:if>
								<c:if test="${0 ne status.index}"><c:set var="pre_custpo" value="${confirm[status.index-1].CUST_PO}" /></c:if>
							
								<tr>
									<td><fmt:formatNumber value="${cf.count}" pattern="#,###" /></td>
									<td><c:if test="${pre_custpo ne now_custpo}">${confirm.CUST_PO}</c:if></td>
<%-- 									<td>${confirm.LINE_NO}</td> --%>
									<!-- 2024-10-24 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
									<td style="font-size: 15px; letter-spacing: 1px">
										<c:set value="${confirm.PT_NAME}" var="ptName" />
										<c:set value="${fn:substring(ptName,0,fn:indexOf(ptName, ' (')) }" var="ptName2" />
										${ptName2}
									</td>
									<!-- 2024-10-24 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
									<td style="font-size: 15px; letter-spacing: 1px">${confirm.ITEM_CD}</td>
									<!-- 2024-10-24 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
									<td class="ta_lft" style="font-size: 15px; letter-spacing: 1px">${confirm.ITEM_NAME}</td>
									<td>${confirm.UNIT}</td>
									<!-- 2024-10-24 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
									<td class="ta_rgt" style="font-size: 15px; letter-spacing: 1px"><fmt:formatNumber value="${confirm.QUANTITY}" pattern="#,###" /></td>
									<!-- 2024-10-24 hsg 이오더 자재주문서 폰트 크기 확대 요청 관련 (td 태그에 스타일 추가 적용 : style="font-size: 15px; letter-spacing: 1px" -->
									<td style="font-size: 15px; letter-spacing: 1px">
										<c:set value="${confirm.REQUEST_DT}" var="requestDt" />
										<c:if test="${!empty requestDt}">
											<c:set value="${confirm.REQUEST_TIME}" var="requestTime" />
											
											${fn:substring(requestDt, 0, 4)}-${fn:substring(requestDt, 4, 6)}-${fn:substring(requestDt, 6, 8)}
											<c:if test="${!empty requestTime}"> ${fn:substring(requestTime, 0, 2)}:${fn:substring(requestTime, 2, 4)}</c:if>
										</c:if>
									</td>
									<%-- 
									<td>
										<c:set value="${confirm.PICKING_DT}" var="pickingDt" />
										<c:if test="${!empty pickingDt}">
											${fn:substring(pickingDt, 0, 4)}-${fn:substring(pickingDt, 4, 6)}-${fn:substring(pickingDt, 6, 8)}
										</c:if>
									</td>
									--%>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</c:forEach>
	</div>
	
	<!-- <p class="option_apply"><a href="javascript:printWin();">인쇄하기</a></p> -->
</div>

</body>

</html>