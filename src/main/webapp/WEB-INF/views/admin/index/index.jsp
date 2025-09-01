<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<link href='${url}/include/js/common/fullcalendar-3.9.0/fullcalendar.css' rel='stylesheet' />
<script src='${url}/include/js/common/fullcalendar-3.9.0/fullcalendar.js'></script>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy.MM.dd" var="nowDate" />
<script>
var calendar;
$(document).ready(function() {
	setIndexSchdule();
});

/*
메인화면 월간일정
 */
function setIndexSchdule() {

	$('#calendar').fullCalendar({
		navLinks: false, // can click day/week names to navigate views
		eventLimit: false, // allow "more" link when too many events
		locale:'ko',
		height: 406,
		displayEventTime : false,
		selectable: true,
		events: {
			url: '${url}/admin/board/getScheduleListAjax.lime',
			failure: function () {
				console.log('error');
			}
		},
		select: function(selectedDayObj) {
			viewDetail(selectedDayObj.format('YYYY-MM-DD'));
		},
		eventClick: function(eventDateObj) {
			var sdate = eventDateObj.start.format('YYYY-MM-DD');
			viewDetail(sdate);
		}

	});

	$(".fc-today-button").click(function() {
		viewDetail('${nowDate}');
	});

	viewDetail(getDateStr(new Date()));
}

/*
달력 오른쪽 특정날짜 일정목록
 */
function viewDetail(sdate) {
	$.ajax({
		async : false,
		url : '${url}/admin/board/getScheduleListByDateAjax.lime',
		cache : false,
		data : {r_scddate: sdate},
		type : 'POST',
		success : function(data) {
			$('#scheduleDivId').empty();
			$('#scheduleDivId').prev('h5').empty();
			$('#scheduleDivId').prev('h5').append( sdate );

			if (data.length == 0) {
				$('#scheduleDivId').append('<span>등록된 일정이 없습니다.</span>');
			} else {
				$.each(data, function(key, val) {
					$('#scheduleDivId').append('<span>' + val.SCD_TITLE.replaceAll('\\n', '<br/>') + '</span>');
				});
			}
		}
	});
}

//배송조회 팝업 띄우기.(1:한진,2:동원)
function deliveryTrackingPop(obj){
	
	var truckNo = '경기80바9311';
// 	var delType = '2';
	var delType = '1';
	
// 	alert(truckNo);
	
	$.ajax({
		async : false,
		url : '${url}/admin/base/delTrackingAjax.lime',
		cache : false,
		data : {r_truckNo:truckNo,type:delType},
		type : 'POST',
		success : function(data) {
			console.log(data);
			
			var obj = JSON.parse(data);
			console.log(obj.result.lat); //위도
			console.log(obj.result.lon); //경도
		}
	});
	
	/*
	// 팝업 세팅.770 * 920
	var widthPx = 770;
	var heightPx = 920;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="deliveryTrackingPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="r_lat" value="37.536256" />';  //위도(y)
	htmlText += '	<input type="hidden" name="r_lag" value="126.895436" />'; //경도(x)
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/common/pop/deliveryTrackingPop.lime';
	window.open('', 'deliveryTrackingPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	*/
}

function deliveryTrackingPop2(obj){
	var truckNo = '경기80바9311';
// 	var delType = '2';
	var delType = '1';
	
// 	alert(truckNo);
	
	var jsonData = new Object();
	jsonData.service = 'getTruckLocation';
	jsonData.truckNo = truckNo;
	
	$.ajax({
		//async : false,
		contentType: "application/json; charset=UTF-8",
		dataType : 'json',
		crossOrigin : true,
		cache : false,
		url : 'http://tms.tjlogis.co.kr/GtmsRequest',
		header:{
			"key":"BCC002CDDB13C2052C99FFDB2B580ED2",
			"Content-Type":"application/json",
			"X-HTTP-Method-Override":"POST"
		},
		data : JSON.stringify(jsonData),
		type : 'POST',
		success : function(data) {
			console.log(data);
			
			var obj = JSON.parse(data);
			console.log(obj.result.lat); //위도
			console.log(obj.result.lon); //경도
		}
	});
}

</script>

<style type="text/css">
.table-responsive {overflow-x: auto;}
@media (max-width: 499px) {
	.table-responsive.narrow .panel-body > .table {width: 650px;}
}
</style>
</head>

<body class="page-header-fixed compact-menu index">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>

		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>메인화면</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper" class="m-b-xl">
				<!-- Row -->
				<div class="row">
					<!-- Col-md-12 -->
					<div class="col-md-12">
						
						<div class="col-md-8">
							<div class="panel no-m">
								<div class="box01">
									<div class="panel-heading">주문현황[TODAY]</div>
									<div class="panel-body no-p-l no-p-r">
										<ul>
											<li>
												<a href="#">
													<i>${orderStatus['00']}</i> <!-- 주문접수 -->
													<strong><fmt:formatNumber value="${cntFor00}" pattern="#,###" /></strong>
												</a>
											</li>
											<li>
												<a href="#">
													<i>${salesOrderStatus['522']}</i> <!-- 주문확정 -->
													<strong><fmt:formatNumber value="${cntFor522}" pattern="#,###" /></strong>
												</a>
											</li>
											<li>
												<a href="#">
													<i>${salesOrderStatus['530']}</i> <!-- 배차완료-->
													<strong><fmt:formatNumber value="${cntFor530}" pattern="#,###" /></strong>
												</a>
											</li>
											<li>
												<a href="#">
													<i>${salesOrderStatus['560']}</i> <!-- 출하완료 -->
													<strong><fmt:formatNumber value="${cntFor560}" pattern="#,###" /></strong>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<!-- //panel -->
						</div>
						<!-- //col-md-8 -->
						
						<div class="col-md-4">
							<div class="panel no-m">
								<div class="box-color">
									<div class="panel-heading">
										사용자
 										<!-- <button type="button" onclick="deliveryTrackingPop(this);">MAP</button> -->
 										<!-- <button type="button" onclick="deliveryTrackingPop2(this);">MAP 한진</button> -->
									</div>
									<div class="panel-body no-p">
										<ul>
											<li>
												<a href="${url}/admin/customer/customerList.lime">거래처 <strong><fmt:formatNumber value="${cvt:toInt(userMap.CUSTOMER_CNT)}" pattern="#,###" /></strong></a>
											</li>
											<li>
												<!-- AD,MK -->
												<c:if test="${ -1 < userMap.ITEM_CNT }"> 
													<a href="${url}/admin/item/itemList.lime">품목 수 <span style="float: right;"><fmt:formatNumber value="${cvt:toInt(userMap.ITEM_CNT)}" pattern="#,###" /></span></a>
												</c:if>
												
												<!-- 영업 -->
 												<c:if test="${ !empty userMap.CS_SALESUSER }"> 
													<a href="${url}/admin/mypage/csSalesUserList.lime">CS 담당자 - ${userMap.CS_SALESUSER}</a>
												</c:if>
												
												<!-- CS -->
												<c:if test="${ -1 < userMap.SALES_CNT }"> 
													<a href="${url}/admin/mypage/csSalesUserList.lime">영업 담당자 <span style="float: right;"><fmt:formatNumber value="${cvt:toInt(userMap.SALES_CNT)}" pattern="#,###" /></span></a>
												</c:if>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<!-- //panel -->
						</div>
						<!-- //col-md-4 -->
						
						<div class="col-md-8">
							<div class="panel no-m">
								<div class="panel-heading">
									주문접수
									<%-- <button type="button" onclick="location.href='${url}/admin/order/orderList.lime'"><img src="${url}/include/images/common/btn_more.png" alt="more" /></button> --%>
								</div>
								<div class="table-responsive narrow">
									<div class="panel-body no-p">
										<table class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											<colgroup>
												<col width="10%" />
												<col width="20%" />
												<col width="40%" />
												<col width="15%" />
												<col width="15%" />
											</colgroup>
											<thead class="index">
												<tr>
													<th>NO</th>
													<th>주문번호</th>
													<th>거래처</th>
													<th>품목수</th>
													<th>주문일시</th>
												</tr>
											</thead>
											<tbody class="index">
												<c:forEach items="${listFor00}" var="list" varStatus="stat">
													<tr>
														<td>${stat.index+1}</td> 
														<td class="text-left">${list.REQ_NO}</td>
														<td class="text-left">${list.CUST_NM}</td>
														<td class="text-right"><fmt:formatNumber value="${cvt:toInt(list.ITEM_CNT)}" pattern="#,###" /></td>
														<td>${fn:substring(list.INDATE, 0, 16)}</td>
													</tr>
												</c:forEach>
											</tbody> 
										</table>
									</div>
								</div>
							</div>
							<!-- //panel -->
	
							<div class="panel panel-white no-m">
								<div class="panel-heading">
									월간일정
									<button type="button" onclick="location.href='${url}/admin/board/scheduleList.lime'"><img src="${url}/include/images/common/btn_more.png" alt="more" /></button>
								</div>
								<div class="table-responsive">
									<div class="panel-body no-p">
										<div class="col-md-12 schedule">
											<div class="col-md-7 col-lg-5">
												<div id='calendar'></div>
											</div>
											<div class="col-md-5 col-lg-7">
												<h5></h5>
												<div class="scheduleTxt" id="scheduleDivId">
													<%--<h5>2019. 07. 10</h5>
													<span>오전 10시 현장설명회</span>
													<span>입찰마감</span>--%>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- //panel -->
						</div>
						<!-- //col-md-8 -->
						
						<div class="col-md-4">
						
						
							<div class="panel panel-white no-m">
								<div class="panel-heading">
									알림
								</div>
								<div class="bannerIndex m-b-xxs">
									<a href="${url}/data/user/pmanual.pdf" download><img src="${url}/include/images/admin/banner01.jpg" alt="사용자 매뉴얼" /></a>
								</div>
								<div class="bannerIndex bgP">
									<a href="${url}/data/user/bmanual.pdf" download><img src="${url}/include/images/admin/banner02.jpg" alt="내부사용자사매뉴얼" /></a>
								</div>
							</div>
						
							
							<div class="panel panel-white no-m">
								<div class="panel-heading">
									공지사항
									<button type="button" onclick="location.href='${url}/admin/board/noticeList.lime'"><img src="${url}/include/images/common/btn_more.png" alt="more" /></button>
								</div>
								<div class="table-responsive narrow">
									<div class="panel-body no-p">
										<table class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											<colgroup>
												<col width="8%" />
												<col width="50%" />
												<col width="19%" />
												<col width="23%" />
											</colgroup>
											<thead class="index">
											<tr>
												<th>NO</th>
												<th>제목</th>
												<th>등록자</th>
												<th>등록일</th>
											</tr>
											</thead>
											<tbody class="index"> <!-- 노출10개  -->
											<c:forEach items="${noticeList}" var="list" varStatus="stat">
												<tr>
													<td>${stat.count}</td>
													<td class="text-left">
														<span>
															<c:choose>
																<c:when test="${fn:length(list.BD_TITLE) > 20}">${fn:substring(list.BD_TITLE, 0, 20)}...</c:when>
																<c:otherwise>${list.BD_TITLE}</c:otherwise>
															</c:choose>
														</span>
													</td>
													<td>${list.USER_NM}</td>
													<%-- <td><fmt:formatDate value="${list.BD_INDATE}" pattern="yyyy-MM-dd"/></td> --%>
													<td>${fn:substring(list.BD_INDATE,0,10)}</td>
												</tr>
											</c:forEach>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- //panel -->
						</div>
						<!-- //col-md-4 -->
						
						<%--
						<div class="col-md-4">
							<div class="col-md-12 no-p">
								<div class="panel-heading">
									FAQ
									<button type="button" onclick="location.href='${url}/admin/board/faqList.lime'"><img src="${url}/include/images/common/btn_more.png" alt="more" /></button>
								</div>
								<div class="table-responsive narrow">
									<div class="panel-body no-p">
										<table class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											<colgroup>
												<col width="15%" />
												<col width="55%" />
												<col width="30%" />
											</colgroup>
											<thead class="index">
												<tr>
													<th>NO</th>
													<th>협력엄체명</th>
													<th>요청일</th>
												</tr>
											</thead>
											<tbody class="index">
												<c:forEach items="${newSupplyList}" var="list" varStatus="stat">
													<tr>
													<td>${stat.count}</td>
													<td class="text-left">${list.SCP_NAME}</td>
													<td><fmt:formatDate value="${list.SCP_INDATE}" pattern="yyyy-MM-dd"/></td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<!-- //col-md-4 -->
						--%>
						
					</div>
					<!-- //col-md-12 -->
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>
</html>