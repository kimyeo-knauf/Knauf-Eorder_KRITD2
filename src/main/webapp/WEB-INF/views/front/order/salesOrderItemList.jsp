<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
$(window).resize(function(){
	var bodyWidth = $('body').width();
	if (bodyWidth < 767) {
		$('body').removeClass('small-sidebar');
	}
	$('.ui-jqgrid .ui-jqgrid-bdiv').css('width', '100%');
});

$(document).ready(function() {
	if(isApp()){
		$('#excelDownBtnId').hide();
	}
	
	// 출고일자 데이트피커.
	$('input[name="r_actualshipsdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
        var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_actualshipedt"]').datepicker('setStartDate', minDate);
    });
	$('input[name="r_actualshipedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
        var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_actualshipsdt"]').datepicker('setEndDate', maxDate);
    });
});

//납품처 선택 팝업 띄우기.
function openShiptoPop(obj){
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 795;
		var heightPx = 652;
		
		var sw=screen.width;
		var sh=screen.height;
		var px=(sw-widthPx)/2;
		var py=(sh-heightPx)/2;
		
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx+', top='+py+', left='+px;
		
		$('form[name="frm_pop"]').remove();
		
		var htmlText = '';
		htmlText += '<form name="frm_pop" method="post" target="shiptoListPop">';
		htmlText += '	<input type="hidden" name="pop" value="1" />';
		htmlText += '	<input type="hidden" name="page_type" value="orderadd" />';
		htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
		htmlText += '</form>';
		$('body').append(htmlText);
		
		// #POST# 팝업 열기.
		var popUrl = '${url}/front/base/pop/shiptoListPop.lime';
		window.open('', 'shiptoListPop', options);
		$('form[name="frm_pop"]').prop('action', popUrl);
		$('form[name="frm_pop"]').submit().remove();
	}
	else{
		// 모달팝업 >> 새롭게 페이지 추가.
		//$('#shiptoListPopMId').modal('show');
		var link = '${url}/front/base/pop/shiptoListPop.lime?page_type=orderadd&r_multiselect=false&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) { // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#shiptoListPopMId').modal({
			remote: link
		});
	}
}

// return 납품처 팝업에서 개별 선택.
function setShiptoFromPop(jsonData){
	setShipto(toStr(jsonData.SHIPTO_CD), toStr(jsonData.SHIPTO_NM), toStr(jsonData.ZIP_CD), toStr(jsonData.ADD1), toStr(jsonData.ADD2));
}
function setShipto(shipto_cd, shipto_nm, zip_cd, add1, add2){
	$('input[name="r_shiptocd"]').val(shipto_cd);
	$('input[name="v_shiptonm"]').val(shipto_nm);
}

//납품처 초기화.
function setDefaultShipTo(){
	$('input[name="r_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
}

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/order/salesOrderItemList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/order/salesOrderItemList.lime');
}

//상세조회 펼침,닫힘.
function fn_spread(id){
	if($('#'+id).css('display') == 'none'){
		$('#'+id).show();
		$('input[name="r_detailsearch"]').val('Y');
	}
	else{
		$('#'+id).hide();
		$('input[name="r_detailsearch"]').val('N');
	}
}

//엑셀다운로드
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/front/order/salesOrderItemExcelDown.lime');
	$('form[name="frm"]').attr('action', '');
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        //console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}

</script>

</head>

<body>
<!-- Wrap -->
<div id="subWrap" class="subWrap">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<div class="container-fluid">
		<div class="full-content">
		
			<div class="row no-m">
				<div class="page-breadcrumb"><strong>거래내역(품목)</strong></div>
				
				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/order/orderList.lime">웹주문현황</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/order/orderAdd.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/orderAdd.lime')}">selected="selected"</c:if> >주문등록</option>
								<option value="${url}/front/order/orderList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/orderList.lime')}">selected="selected"</c:if> >웹주문현황</option>
								<option value="${url}/front/order/salesOrderMainList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/salesOrderMainList.lime')}">selected="selected"</c:if> >거래내역(주문)</option>
								<option value="${url}/front/order/salesOrderItemList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/salesOrderItemList.lime')}">selected="selected"</c:if> >거래내역(품목)</option>
							</select>
						</li>
					</ul>
				</div>
			</div> <!-- Row -->
			
		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->
	
	<!-- Container -->
	<main class="container" id="container">
		<form name="frm" method="post" >
		
		<%-- Start. Use For Paging --%>
		<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
		<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitrow --%>
		<%-- End. --%>
		
		<input name="r_detailsearch" type="hidden" value="${param.r_detailsearch}" />
		
		
		<!-- Content -->
		<div class="content">
		
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
				
					<div class="searchArea">
						<div class="col-md-6">
							<em>출고일자</em>
							<input type="text" class="form-control calendar" name="r_actualshipsdt" value="${actualshipsdt}" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_actualshipedt" value="${actualshipedt}" readonly="readonly" />
						</div>
						
						<div class="col-md-1 empty searchBtn">
							<!-- <button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button> -->
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						
						<c:if test="${'CO' eq sessionScope.loginDto.authority}">
							<div class="col-md-6">
								<em>납품처</em>
								<input type="text" class="form-control search" name="v_shiptonm" placeholder="납품처명" value="${param.v_shiptonm}" readonly="readonly" onclick="openShiptoPop(this);" />
								<input type="hidden" name="r_shiptocd" value="${param.r_shiptocd}" />
<%-- 								<button type="button" class="btn-search" onclick="openShiptoPop(this);"><img src="${url}/include/images/front/common/icon_search@2x.png" alt="img" /></button> --%>
								<button type="button" class="btn btn-reset" onclick="setDefaultShipTo();">초기화</button>
							</div>
						</c:if>
						
						<div class="col-md-6 right">
							<em>품목명</em>
							<input type="text" class="form-control" name="rl_itemdesc" value="${param.rl_itemdesc}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						</div>
						
						<!-- 상세조회 더보기  -->
						<%-- 
						<div id="hiddenContent02" style="display: none; height:auto; margin-bottom:0;"> 
							<c:if test="${'CO' eq sessionScope.loginDto.authority}">
							<div class="col-md-6">
								<em>납품처</em>
								<input type="text" class="form-control" name="v_shiptonm" value="" readonly="readonly" onclick="openShiptoPop(this);" />
								<input type="hidden" name="r_shiptocd" value="" />
								<button type="button" class="btn-search" onclick="openShiptoPop(this);"><img src="${url}/include/images/front/common/icon_search@2x.png" alt="img" /></button>
								<button type="button" class="detailBtn" onclick="setDefaultShipTo();">초기화</button>
							</div>
							</c:if>
						</div>
						 --%>
					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<!-- <button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button> -->
						<button type="button" class="full-width" onclick="dataSearch();">Search</button>
					</div>
					
					<div class="boardListArea">
						<h2>
							Total <strong><fmt:formatNumber value="${cvt:toInt(listTotalCount)}" pattern="#,###" /></strong>EA
							<div class="title-right">
								<button type="button" class="btn-excel" id="excelDownBtnId" onclick="excelDown(this);"><img src="${url}/include/images/front/common/icon_excel@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardList itemList">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="10%" />
									<col width="60%" />
									<col width="15%" />
									<col width="15%" />
								</colgroup>
								<thead>
									<tr>
										<th>NO</th>
										<th>품목명</th>
										<th>단위</th>
										<th>수량</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="v_startnumber" value="${startnumber}" />
									<c:forEach items="${list}" var="list" varStatus="status">
										<tr>
											<td><fmt:formatNumber value="${cvt:toInt(v_startnumber)}" pattern="#,###" /></td>
											<td class="text-left">${list.ITEM_DESC}</td>
											<td class="text-left">${list.UNIT}</td>
											<td class="text-right"><fmt:formatNumber value="${list.ORDER_QTY}" type="number" pattern="#,###.##" /></td>
										</tr>
										<c:set var="v_startnumber" value="${v_startnumber-1}" />
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="4" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												거래내역(품목)이 없습니다.
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="10%" />
									<col width="60%" />
									<col width="15%" />
									<col width="15%" />
								</colgroup>
								<thead>
									<tr>
										<th>NO</th>
										<th>품목명</th>
										<th>단위</th>
										<th>수량</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="v_startnumber2" value="${startnumber}" />
									<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td><fmt:formatNumber value="${cvt:toInt(v_startnumber2)}" pattern="#,###" /></td>
										<td class="text-left">${list.ITEM_DESC}</td>
										<td class="text-left">${list.UNIT}</td>
										<td class="text-right"><fmt:formatNumber value="${list.ORDER_QTY}" type="number" pattern="#,###.##" /></td>
									</tr>
									<c:set var="v_startnumber2" value="${v_startnumber2-1}" />
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="4" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												거래내역(품목)이 없습니다.
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>
							
						</div> <!-- boardList -->
						
						<!-- BEGIN paginate -->
						<c:if test="${!empty list}">
							<%@ include file="/WEB-INF/views/include/front/pager.jsp" %>
						</c:if>
						<!-- END paginate -->
						
					</div> <!-- boardListArea -->
					
				</div> <!-- Col-md-12 -->
			</div> <!-- Row -->
			
		</div> <!-- Content -->
		
		</form>
	</main> <!-- Container -->
	
	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>
	
	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
	
	<!-- Modal -->
	<div class="modal fade" id="shiptoListPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content">
				
			</div>
		</div>
	</div>
</div> <!-- Wrap -->

</body>
</html>