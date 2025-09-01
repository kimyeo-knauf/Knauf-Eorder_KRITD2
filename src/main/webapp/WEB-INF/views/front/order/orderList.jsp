<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});

$(function(){
	if(!isApp()){
		$('#excelDownBtnId').hide();
	}
	
	if('Y' == toStr('${param.r_detailsearch}')){
		fn_spread('hiddenContent02');
	}
});

$(document).ready(function() {
	//시작일 데이트피커
	$('input[name="r_insdate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
        var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_inedate"]').datepicker('setStartDate', minDate);
    });
	
	//마감일 데이트피커
	$('input[name="r_inedate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
        var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_insdate"]').datepicker('setEndDate', maxDate);
    });
	
	// 1분마다 dataSearch 실행하기.
	/*if(!isApp()){
		setInterval(function(){
			dataSearch();
		}, 60000);	
	}*/
});

// 주문처리. 임시저장 삭제 및 고객취소.
function dataUp(obj, req_no, status){ 
	// status : 90=임시저장 삭제, 00=수정, 01=고객취소(전체),02=보류수정 99=임시저장 수정 또는 주문접수 상태변경 폼으로 이동/주문접수 수정 폼. 
	// status는 StatusUtil 과 다름에 유의
	$(obj).prop('disabled', true);
	
	if('99' == status || '00' == status){
		formGetSubmit('${url}/front/order/orderAdd.lime', 'r_reqno='+req_no+'&m_statuscd='+status);
		return;
	}
	
	if ('01' == status){
		var confirmText = '선택하신 주문건을 취소 하시겠습니까?';
	}
	
	if ('90' == status){
		var confirmText = '임시저장건을 삭제 하시겠습니까';
	}

	if ('02' == status){
		//var confirmText = '주문접수 상태로 변경하시겠습니까?';
		//if(confirm(confirmText)){
			$.ajax({
				async : false,
				url : '${url}/front/order/updateStatusAjax.lime',
				cache : false,
				type : 'POST',
				data : { 
					r_reqno : req_no
					, m_statuscd : status
				},
				success : function(data){
					if('0000' == data.RES_CODE){
						alert(data.RES_MSG);
					}
					dataSearch();
					
					$(obj).prop('disabled', false);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
		//}
		//else{
		//	$(obj).prop('disabled', false);
		//}
		formGetSubmit('${url}/front/order/orderAdd.lime', 'r_reqno='+req_no+'&m_statuscd='+status);
		return;
	}
	
	if(confirm(confirmText)){
		$.ajax({
			async : false,
			url : '${url}/front/order/updateStatusAjax.lime',
			cache : false,
			type : 'POST',
			data : { 
				r_reqno : req_no
				, m_statuscd : status
			},
			success : function(data){
				if('0000' == data.RES_CODE){
					alert(data.RES_MSG);
				}
				dataSearch();
				
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}
	else{
		$(obj).prop('disabled', false);
	}
}

// 주문건 복사.
function dataCopy(obj){
	$(obj).prop('disabled', true);
	
	var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	var reqNoObj = $('input:checkbox[name="r_'+div+'reqno"]:checked');
	
	if(0 >= $(reqNoObj).length){
		alert('선택 후 진행해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	if(1 < $(reqNoObj).length){
		alert('한 건만 선택해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('선택하신 주문건을 복사 하시겠습니까?')){
		formGetSubmit('${url}/front/order/orderAdd.lime', 'copy_reqno='+$(reqNoObj).val());
	}
	else{
		$(obj).prop('disabled', false);
	}
}

// 품목 리스트 보여주기.
function viewItemList(obj, req_no){
	$.ajax({
		async : false,
		url : '${url}/front/order/getOrderDetailListAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : {r_reqno : req_no},
		success : function(data){
			var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
			
			$('#totalStringId').empty();
			$('#itemListTbodyId').empty();
			$('#mitemListTbodyId').empty();
			
			var htmlText = '';
			var mhtmlText = '';
			
			$(data.list).each(function(i,e){
				// PC.
				htmlText += '<tr>';
				htmlText += '	<td>'+addComma(i+1)+'</td>';
				htmlText += '	<td class="text-left">'+e.ITEM_CD+'</td>';
				htmlText += '	<td class="text-left"><p class="nowrap">'+e.DESC1+'</p></td>';
				htmlText += '	<td class="text-left">'+e.UNIT+'</td>';
				htmlText += '	<td class="text-right">'+addComma(e.QUANTITY)+'</td>';
				htmlText += '</tr>';
				
				// 모바일.
				mhtmlText += '<tr>';
				mhtmlText += '	<td>'+addComma(i+1)+'</td>';
				mhtmlText += '	<td class="text-left">'+e.ITEM_CD+'</td>';
				mhtmlText += '	<td class="text-left"><p class="nowrap2">'+e.DESC1+'</p></td>';
				mhtmlText += '	<td class="text-right">'+addComma(e.QUANTITY)+'</td>';
				mhtmlText += '</tr>';
			});
			
			$('#totalStringId').append(addComma(data.listTotalCount));
			$('#itemListTbodyId').append(htmlText);
			$('#mitemListTbodyId').append(mhtmlText);
			
			$('#detailData').show();
			
		},
		error : function(request,status,error){
			alert('Error');
			return;
		}
	});
}

// 납품처 선택 팝업 띄우기.
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

// 납품처 초기화.
function setDefaultShipTo(){
	$('input[name="r_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
}

// 자재주문서 출력 팝업.
function openOrderPaperPop(obj){
	//$(obj).prop('disabled', true);
	
	var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	var reqNoObj = $('input:checkbox[name="r_'+div+'reqno"]:checked');
	
	if(0 >= $(reqNoObj).length){
		alert('선택 후 진행해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	
	var ri_reqno = '';
	var checkStatus = true;
	$(reqNoObj).each(function(i,e){
		if('99' == $(e).closest('tr').attr('statusCdAttr')){
			checkStatus = false;
			return false;
		}
		
		if(0==i) ri_reqno = $(e).val();
		else ri_reqno += ','+$(e).val();
	});
	if(!checkStatus){
		alert('임시저장 상태건이 포함 되어 있습니다.\n임시저장 상태건을 제외한 후에 다시 선택해 주세요.');
		return;
	}
	
	// 팝업 세팅.
	if(!isApp()){
		var widthPx = 900;
		var heightPx = 750;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frm_pop2"]').remove();
		
		var htmlText = '';
		htmlText += '<form name="frm_pop2" method="post" target="orderPaperPop">';
		htmlText += '	<input type="hidden" name="pop" value="1" />';
		htmlText += '	<input type="hidden" name="ri_reqno" value="'+ri_reqno+'" />';
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
		var link = '${url}/front/base/orderPaperPop.lime?ri_reqno='+ri_reqno+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) { // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#orderPaperPopMId').modal({
			remote: link
		});
	}
}

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/order/orderList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/order/orderList.lime');
}

// 엑셀다운로드.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/front/order/orderExcelDown.lime');
	$('form[name="frm"]').attr('action', '');
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
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
</script>
</head>

<body>
<div id="subWrap" class="subWrap">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>
	
	<div class="container-fluid">
		<div class="full-content">
		
			<div class="row no-m">
				<div class="page-breadcrumb"><strong>웹주문현황</strong></div>
				
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
							<em>주문일자</em>
							<input type="text" class="form-control calendar" name="r_insdate" value="${insdate}" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_inedate" value="${inedate}" readonly="readonly" />
						</div>
						<div class="col-md-3 right">
							<em>인수자명</em>
							<input type="text" class="form-control" name="rl_receiver" value="${param.rl_receiver}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						</div>
						<div class="col-md-1 empty searchBtn">
							<button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button>
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						
						<div id="hiddenContent02" style="display: none; height:auto; margin-bottom:0;"> <!-- 상세조회 더보기  -->
							<c:if test="${'CO' eq sessionScope.loginDto.authority}">
							<div class="col-md-6 right">
								<em>납품처</em>
								<input type="text" class="form-control search" name="v_shiptonm" placeholder="납품처명" value="${param.v_shiptonm}" readonly="readonly" onclick="openShiptoPop(this);" />
								<input type="hidden" name="r_shiptocd" value="${param.r_shiptocd}" />
								<button type="button" class="btn btn-reset" onclick="setDefaultShipTo();">초기화</button>
							</div>
							</c:if>
							<div class="col-md-6">
								<em>주문번호</em>
								<input type="text" class="form-control" name="rl_reqno" value="${param.rl_reqno}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							
							<%-- 
							<div class="col-md-6 right">
								<em>오더번호</em>
								<input type="text" class="form-control" name="" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							--%>
							
							<%-- 
							<div class="col-md-6 right">
								<em>주소</em>
								<input type="text" class="form-control" name="" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							--%>
							
							<div class="col-md-12 line">
								<em>주문상태</em>
								<div class="table-checkbox">
									<label class="lol-label-checkbox" for="checkbox">
										<input type="checkbox" name="allCheck" id="checkbox" onclick="checkAll2(this, 'ri_statuscd');" <c:if test="${'on' eq param.allCheck}">checked="checked"</c:if> />
										<span class="lol-text-checkbox">전체</span>
									</label>
									<label class="lol-label-checkbox" for="checkbox99">
										<input type="checkbox" id="checkbox99" name="ri_statuscd" value="99" <c:if test="${'99' eq paramValues.ri_statuscd[0]}">checked="checked"</c:if> />
										<span class="lol-text-checkbox">${orderStatus['99']}</span>
									</label>
									<!-- ★★ 2025-07-21 hsg 주문상태 보류 추가 ★★ Front에선 주문상태가 보류일 경우 확인 중으로 변경 -->
									<c:forEach items="${orderStatusList}" var="list">
									  <label class="lol-label-checkbox" for="checkbox${list.key}">
									    <input type="checkbox" id="checkbox${list.key}" name="ri_statuscd" value="${list.key}" 
									      <c:if test="${not empty paramValues.ri_statuscd && fn:contains(param.ri_statuscd, list.key)}">checked="checked"</c:if>
									    />
									    <span class="lol-text-checkbox"><c:choose><c:when test="${'08' eq list.key}">확인중</c:when><c:otherwise><c:out value="${list.value}" /></c:otherwise></c:choose></span>
									  </label>
									</c:forEach>
								</div>
							</div>
						</div>
					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button>
						<button type="button" onclick="dataSearch();">Search</button>
					</div>
					
					<div class="boardListArea">
						<h2>
							Total <strong><fmt:formatNumber value="${cvt:toInt(listTotalCount)}" pattern="#,###" /></strong>EA
							<div class="title-right">
								<button class="btn btn-green" type="button" onclick="location.href='${url}/front/order/orderAdd.lime'">주문등록</button>
								<button class="btn btn-gray" type="button" onclick="dataCopy(this);">복사</button>
								<button class="btn btn-yellow" type="button" onclick="openOrderPaperPop(this);">자재주문서</button>
								<button class="btn-excel" type="button" id="excelDownBtnId" onclick="excelDown(this);"><img src="${url}/include/images/front/common/icon_excel@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardList orderList">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="5%" />
									<col width="9%" />
									<col width="12%" />
									<col width="20%" />
									<col width="23%" />
									<col width="10%" />
									<col width="7%" />
									<col width="14%" />
								</colgroup>
								<thead>
									<tr>
										<th>선택</th>
										<th>주문상태</th>
										<th>주문번호</th>
										<th>납품처명</th>
										<th>납품주소</th>
										<th>주문품목수</th>
										<th>주문자</th>
										<th>처리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="list" varStatus="status">
										<tr statusCdAttr="${list.STATUS_CD}">
											<td>
												<div class="basic-checkbox">
													<input type="checkbox" class="lol-checkbox" name="r_reqno" id="checkbox_${status.index}" value="${list.REQ_NO}" />
													<label class="lol-label-checkbox" for="checkbox_${status.index}"></label>
												</div>
											</td>
											<!-- ★★ 2025-07-21 hsg 주문상태 보류 추가 ★★ Front에선 주문상태가 보류일 경우 확인 중으로 변경 -->
											<td><c:choose><c:when test="${'08' eq list.STATUS_CD}">확인중</c:when><c:otherwise><c:out value="${orderStatus[list.STATUS_CD]}" /></c:otherwise></c:choose></td>
											<td><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&qmsTempId=${list.QMS_TEMP_ID}">${list.REQ_NO}</a></td>
											<td class="text-left">${list.SHIPTO_NM}</td>
											<td class="text-left"><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&qmsTempId=${list.QMS_TEMP_ID}" class="nowrap">${list.ADD1} ${list.ADD2}</a></td>
											<td class="text-right"><a class="dataBtn" href="javascript:;" onclick="viewItemList(this, '${list.REQ_NO}');"><fmt:formatNumber value="${list.ITEM_CNT}" pattern="#,###" /></a></td>
											<td>${list.USER_NM}</td>
											<td>
												<c:if test="${'99' eq list.STATUS_CD}">
													<button type="button" class="btn btn-md btn-default" onclick="dataUp(this, '${list.REQ_NO}', '99');">수정</button>
													<button type="button" class="btn btn-md btn-gray" onclick="dataUp(this, '${list.REQ_NO}', '90');">삭제</button>
												</c:if>
												<c:if test="${'00' eq list.STATUS_CD}">
													<button type="button" class="btn btn-md btn-default" onclick="dataUp(this, '${list.REQ_NO}', '00');">수정</button>
													<button type="button" class="btn btn-md btn-light-gray" onclick="dataUp(this, '${list.REQ_NO}', '01');">전체취소</button>
												</c:if>
												<c:if test="${'08' eq list.STATUS_CD}">
													<button type="button" class="btn btn-md btn-default" onclick="dataUp(this, '${list.REQ_NO}', '02');">수정</button>
													<button type="button" class="btn btn-md btn-light-gray" onclick="dataUp(this, '${list.REQ_NO}', '01');">전체취소</button>
												</c:if>
											</td>
										</tr>
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="8" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												웹주문현황 내역이 없습니다.
											</td>
										</tr>
									</c:if>
								
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="13%" />
									<col width="20%" />
									<col width="20%" />
<!-- 									<col width="47%" /> -->
									<col width="20%" />
								</colgroup>
								<thead>
									<tr>
										<th>선택</th>
										<th>주문번호</th>
										<th>주문상태</th>
<!-- 										<th>납품처명</th> -->
										<th>처리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="list" varStatus="status">
										<tr>
											<td>
												<div class="basic-checkbox">
													<input type="checkbox" class="lol-checkbox" name="r_mreqno" id="mcheckbox_${status.index}" value="${list.REQ_NO}" />
													<label class="lol-label-checkbox" for="mcheckbox_${status.index}"></label>
												</div>
											</td>

											<td><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&qmsTempId=${list.QMS_TEMP_ID}">${list.REQ_NO}</a></td>
											<!-- ★★ 2025-07-21 hsg 주문상태 보류 추가 ★★ Front에선 주문상태가 보류일 경우 확인 중으로 변경 -->
											<td><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&qmsTempId=${list.QMS_TEMP_ID}"><c:choose><c:when test="${'08' eq list.STATUS_CD}">확인중</c:when><c:otherwise><c:out value="${orderStatus[list.STATUS_CD]}" /></c:otherwise></c:choose></a></td>
<%-- 											<td class="text-left"><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&" class="nowrap">${list.SHIPTO_NM}</a></td> --%>
											<td>
												<c:if test="${'99' eq list.STATUS_CD}">
													<button type="button" class="btn btn-xs btn-default" onclick="dataUp(this, '${list.REQ_NO}', '99');">수정</button>
													<button type="button" class="btn btn-xs btn-light-gray" onclick="dataUp(this, '${list.REQ_NO}', '90');">삭제</button>
												</c:if>
												<c:if test="${'00' eq list.STATUS_CD}">
													<button type="button" class="btn btn-xs btn-default" onclick="dataUp(this, '${list.REQ_NO}', '00');">수정</button>
													<button type="button" class="btn btn-lg btn-light-gray" onclick="dataUp(this, '${list.REQ_NO}', '01');">전체취소</button>
												</c:if>
											</td>
										</tr>
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="4" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												웹주문현황 내역이 없습니다.
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
						
						<div id="detailData" style="display:none;">
							<h2>
								Total <strong id="totalStringId"></strong>EA
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="8%" />
										<col width="20%" />
										<col width="40%" />
										<col width="12%" />
										<col width="20%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>단위</th>
											<th>주문수량</th>
										</tr>
									</thead>
									<tbody id="itemListTbodyId">
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="8%" />
										<col width="20%" />
										<col width="40%" />
										<col width="12%" />
										<col width="20%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>단위</th>
											<th>주문수량</th>
										</tr>
									</thead>
									<tbody id="mitemListTbodyId">
									</tbody>
								</table>
							</div> <!-- boardList -->
						</div>
						
					</div> <!-- boardListArea -->
					
					<section>
						<c:if test="${!empty main2BannerList}">
							<div class="banArea" ><!-- 1300 * 220 -->
								<ul id="content-slider" class="content-slider">
									<c:forEach items="${main2BannerList}" var="bn2List" varStatus="stat">
										<li>
											<c:if test="${bn2List.BN_LINKUSE eq 'Y'}">
												<a <c:if test="${!empty bn2List.BN_LINK}">href="${bn2List.BN_LINK}" target="_blank"</c:if> <c:if test="${empty bn2List.BN_LINK}">href="javascript:;"</c:if> >
													<img class="hide-xxs" src="${url}/data/banner/${bn2List.BN_IMAGE}"  width="1300" height="220" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
													<img class="hide500" src="${url}/data/banner/${bn2List.BN_MOBILEIMAGE}"  width="500" height="150" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
												</a>
											</c:if>
											<c:if test="${bn2List.BN_LINKUSE eq 'N'}">
												<img class="hide-xxs" src="${url}/data/banner/${bn2List.BN_IMAGE}"  width="1300" height="220" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
												<img class="hide500" src="${url}/data/banner/${bn2List.BN_MOBILEIMAGE}"  width="500" height="150" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
											</c:if>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
					</section>
					
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