<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
<style>

</style>

<script type="text/javascript">
/*(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});*/

$(function(){
	$('#sendDiv').hide();
	
	if(isApp()){
		$('#excelDownBtnId').hide();
		$('#excelDownBtnId2').hide();
		$('#excelDownBtnId2').next().addClass('full-width');
	}
	
	$('input[name="insdate"]').datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="inedate"]').datepicker('setStartDate', minDate);
		 $('#sendDiv').hide();
	});

	$('input[name="inedate"]').datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="insdate"]').datepicker('setEndDate', maxDate);
		 $('#sendDiv').hide();
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
		htmlText += '	<input type="hidden" name="page_type" value="factreport" />';
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
		var link = '${url}/front/base/pop/shiptoListPop.lime?page_type=factreport&r_multiselect=false&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) { // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#shiptoListPopMId').modal({
			remote: link
		});
	}
}

//return 납품처 팝업에서 개별 선택.
function setShiptoFromPop(jsonData){
	setShipto(toStr(jsonData.SHIPTO_CD), toStr(jsonData.SHIPTO_NM), toStr(jsonData.ZIP_CD), toStr(jsonData.ADD1), toStr(jsonData.ADD2));
}
function setShipto(shipto_cd, shipto_nm, zip_cd, add1, add2){
	$('input[name="m_shiptocd"]').val(shipto_cd);
	$('input[name="v_shiptonm"]').val(shipto_nm);
	
	$('#sendDiv').hide();
}

//납품처 초기화.
function setDefaultShipTo(){
	$('input[name="r_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
	
	$('#sendDiv').hide();
}

//조회
function dataSearch() {
	var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	
	var insdate = $('input[name="insdate"]').val();
	var inedate = $('input[name="inedate"]').val();
	
	if('' == insdate || '' == inedate){
		alert('출고일자를 선택 후 진행해 주세요.');
		return;
	}
	
	//거래처,납품처명 출력
	var custnm = $('input[name="v_custnm"]').val();
	var shiptonm = $('input[name="v_shiptonm"]').val();
	if(shiptonm != ''){
		$('#titleH2').html('거래처 : ' + custnm + ' / ' + '납품처 : ' + shiptonm);
	}else{
		$('#titleH2').html('거래처 : ' + custnm);
	}
	
	//전송기준 선택
	if(custnm != '' && shiptonm != ''){
		$('input:radio[name="m_papertype"]:input[value="2"]').prop('checked', true);
		$('input:radio[name="m_mpapertype"]:input[value="2"]').prop('checked', true);
	
	}else{
		$('input:radio[name="m_papertype"]:input[value="1"]').prop('checked', true);
		$('input:radio[name="m_mpapertype"]:input[value="1"]').prop('checked', true);
	}
	
	//출고일자 출력
	$('#dateTd').html(insdate+' ~ '+inedate);
	$('#mdateTd').html(insdate+' ~ '+inedate);
	
	//상단에 조회시작일이 월을 넘어가는경우, 마지막월의 시작일과 종료일을 입력하여야함
	var sdateMonth = insdate.substring(0,7);
	var edateMonth = inedate.substring(0,7);
	
	if(sdateMonth != edateMonth){
		var last = new Date(edateMonth.substring(0,4), edateMonth.substring(5,7)); 
	    last = new Date(last-1); 
		var lastDay = last.getDate(); //선택한 달의 마지막 일자
		
		$('input[name="r_insdate"]').val(edateMonth+'-01');
		$('input[name="r_inedate"]').val(edateMonth+'-'+lastDay);
	}else{
		$('input[name="r_insdate"]').val(insdate);
		$('input[name="r_inedate"]').val(inedate);
	}
	
	//하단 폼 show
	$('#sendDiv').show();
}

//이메일전송
function sendEmail(obj){
	$(obj).prop('disabled', true);
	var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	
	var v_email = $('input[name="v_'+ div +'email"]').val();
	if(v_email == ''){
		alert('이메일을 입력해주세요.');
		$('input[name="v_'+ div +'email"]').focus();
		$(obj).prop('disabled', false);
		return false;
	}
	
	v_email = v_email.replace(/(\s*)/g, ""); //모든공백제거
	
	var lastChar = v_email.charAt(v_email.length-1);
	if(lastChar == ','){ v_email = v_email.slice(0,-1); } //마지막콤마제거
	
	var emailArr = v_email.split(',', -1);
	var email_reg = /^[\w]([-_\.]?[\w])*@[\w]([-_\.]?[\w])*\.[\w]{2,3}$/i; //이메일
	for(var i in emailArr) {
		if(!email_reg.test(emailArr[i])){
			alert("이메일 형식이 일치하지 않습니다.");
			$('input[name="v_'+ div +'email"]').focus();
			$(obj).prop('disabled', false);
			return false;
		}
	}
	
	$('input[name="v_email"]').val(v_email);
	
	if(confirm('전송 하시겠습니까?')){
		$('#ajax_indicator').show().fadeIn('fast');
		
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/front/report/factReportSendMailAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
				}
				
				$('#ajax_indicator').fadeOut();
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			},
		});
	}else{
		$(obj).prop('disabled', false);
	}
}

//전송기록 엑셀다운로드
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/front/report/sendMailHistoryExcelDown.lime');
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

<div id="subWrap" class="subWrap">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<!-- Header -->
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<div class="container-fluid">
		<div class="full-content">

			<div class="row no-m">
				<div class="page-breadcrumb"><strong>거래사실확인서</strong></div>
				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="javascript:;">리포트</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/report/factReport.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/report/factReport.lime')}">selected="selected"</c:if> >거래사실확인서</option>
								<option value="${url}/front/report/deliveryReport.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/report/deliveryReport.lime')}">selected="selected"</c:if> >납품확인서</option>
							</select>
						</li>
					</ul>
				</div>
			</div> <!-- Row -->

		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->

	<!-- Container -->
	<main class="container" id="container">

		<!-- Content -->
		<div class="content">
			<form name="frm" method="post" >
				<input type="hidden" name="r_insdate" value="" />
				<input type="hidden" name="r_inedate" value="" />

			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
					<div class="searchArea">
						<div class="col-md-6">
							<em>출고일자</em>
							<input type="text" class="form-control calendar" name="insdate" autocomplete="off" value="${param.insdate}" /> <span>~</span> <input type="text" class="form-control calendar" name="inedate" autocomplete="off" value="${param.inedate}" />
						</div>
						<div class="col-md-3 right">
							<em>영업사원</em>
							<input type="text" class="form-control" name="salesrep_nm" value="${salesrep_nm}" readonly="readonly"/>
						</div>
						<div class="col-md-1 empty searchBtn download">
							<button class="detailBtn btn-down" type="button" id="excelDownBtnId" onclick="excelDown(this);">전송기록다운로드</button>
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						<div class="col-md-6">
							<em>납품처</em>
							<input type="text" class="form-control search" name="v_shiptonm" placeholder="납품처명" value="${shipto_nm}" readonly="readonly" <c:if test="${'CO' eq sessionScope.loginDto.authority}">onclick="openShiptoPop(this);"</c:if> />
							<input type="hidden" name="m_shiptocd" value="${shipto_cd}" />
							
							<c:if test="${'CO' eq sessionScope.loginDto.authority}"><button type="button" class="btn btn-reset" onclick="setDefaultShipTo();">초기화</button></c:if>
						</div>
						<div class="col-md-6 right">
							<em>거래처</em>
							<input type="text" class="form-control" name="v_custnm" value="${cust_nm}" readonly/>
							<input type="hidden" name="m_custcd" value="${cust_cd}" />
						</div>
						
					</div> <!-- searchArea -->

					<div class="searchBtn full-tablet">
						<button class="detailBtn btn-down" type="button" id="excelDownBtnId2" onclick="excelDown(this);">전송기록다운로드</button>
						<button type="button" onclick="dataSearch();">Search</button>
					</div>

					<div class="boardListArea" id="sendDiv">
						<h2 id="titleH2"></h2>

						<div class="tableView">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="60%" />
									<col width="40%" />
								</colgroup>
								<thead>
								<tr>
									<th class="text-center">전송기준</th>
									<th class="text-center">출고일자</th>
								</tr>
								</thead>
								<tbody>
									<tr>
										<td class="table-radio">
											<label class="lol-label-radio"><input type="radio" name="m_papertype" value="1" disabled/><span class="lol-text-radio">거래처 거래사실확인서</span></label>
											<label class="lol-label-radio"><input type="radio" name="m_papertype" value="2" disabled/><span class="lol-text-radio">납품처 거래사실확인서</span></label>
										</td>
										<td class="text-center" id="dateTd"></td>
									</tr>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="35%" />
									<col width="65%" />
								</colgroup>
								<tbody>
									<tr>
										<th>전송기준</th>
										<td class="table-radio">
											<label class="lol-label-radio"><input type="radio" name="m_mpapertype" value="1" disabled/><span class="lol-text-radio">거래처 거래사실확인서</span></label>
											<label class="lol-label-radio"><input type="radio" name="m_mpapertype" value="2" disabled/><span class="lol-text-radio">납품처 거래사실확인서</span></label>
										</td>
									</tr>
									<tr>
										<th>출고일자</th>
										<td id="mdateTd"></td>
									</tr>
								</tbody>
							</table>
							
						</div> <!-- boardList -->
						
						<h2>이메일전송</h2>
						<div class="tableView">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="80%" />
									<col width="20%" />
								</colgroup>
								<thead>
								<tr>
									<th class="text-center">받는사람</th>
									<th class="text-center">전송</th>
								</tr>
								</thead>
								<tbody>
									<tr>
										<td class="text-center">
											<input type="text" class="form-control letter-spacing0" name="v_email" placeholder="email@knauf.com" value="${user_email}" />
										</td>
										<td class="text-center">
											<button type="button" class="btn btn-gray" onclick="sendEmail(this);">전송</button>
										</td>
									</tr>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="80%" />
									<col width="20%" />
								</colgroup>
								<thead>
									<tr>
										<th>받는사람</th>
										<th>전송</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>
											<input type="text" name="v_memail" class="form-control letter-spacing0" placeholder="email@knauf.com" value="${user_email}" />
										</td>
										<td class="text-center">
											<button type="button" class="btn btn-gray" onclick="sendEmail(this);">전송</button>
										</td>
									</tr>
								</tbody>
							</table>
							<p class="summary marL20 pull-left">※ 다중 주소 입력시 <strong>콤마(,)</strong>로 구분해주세요.</p>
							
						</div> <!-- boardList -->
						
						
					</div> <!-- boardListArea -->
					
					<section>
						<c:if test="${!empty main2BannerList}">
							<div class="banArea"><!-- 1300 * 220 -->
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

			</form>
		</div> <!-- Content -->
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