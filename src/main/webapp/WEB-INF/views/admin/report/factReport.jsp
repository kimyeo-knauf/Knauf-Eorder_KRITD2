<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript">
$(function(){
	$('#sendDiv').hide();
	
	//시작일 데이트피커
	$('input[name="insdate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="inedate"]').datepicker('setStartDate', minDate);

        $('#sendDiv').hide();
    });
	
	//마감일 데이트피커
	$('input[name="inedate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="insdate"]').datepicker('setEndDate', maxDate);

        $('#sendDiv').hide();
    });
});

// 거래처 선택 팝업 띄우기.
function openCustomerPop(obj){
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 805;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="customerListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="factReport" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/customerListPop.lime';
	window.open('', 'customerListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

//return 거래처 팝업에서 개별 선택.
function setCustomerFromPop(jsonData){
	$('input[name="m_custcd"]').val(toStr(jsonData.CUST_CD));
	$('input[name="v_custnm"]').val(toStr(jsonData.CUST_NM));
	$('input[name="m_salesnm"]').val(toStr(jsonData.SALESREP_NM2));
	$('input[name="v_email"]').val(toStr(jsonData.CUST_MAIN_EMAIL));
	
	setDefaultShipTo();
}

// 납품처 초기화.
function setDefaultShipTo(){
	$('input[name="m_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
	
	$('#sendDiv').hide();
}

// 납품처 선택 팝업 띄우기.
function openShiptoPop(obj){
	var selectedCustCd = toStr($('input[name="m_custcd"]').val());
	if('' == selectedCustCd){
		alert('거래처를 선택 후 진행해 주세요.');
		return;
	}
	
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 805;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="shiptoListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="factReport" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '	<input type="hidden" name="r_custcd" value="'+selectedCustCd+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/shiptoListPop.lime';
	window.open('', 'shiptoListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

//return 납품처 팝업에서 개별 선택.
function setShiptoFromPop(jsonData){
	$('input[name="m_shiptocd"]').val(toStr(jsonData.SHIPTO_CD));
	$('input[name="v_shiptonm"]').val(toStr(jsonData.SHIPTO_NM));
	$('input[name="m_zipcd"]').val(toStr(jsonData.ZIP_CD));
	$('input[name="m_add1"]').val(toStr(jsonData.ADD1));
	$('input[name="m_add2"]').val('');
	//$('input[name="m_add2"]').val(toStr(jsonData.ADD2));
	
	$('#sendDiv').hide();
}

/*
//엑셀다운로드.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/report/factReportExcelDown.lime');
	$('form[name="frm"]').attr('action', '');
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
 }, 1000 );
}
*/

//조회
function dataSearch() {
	var insdate = $('input[name="insdate"]').val();
	var inedate = $('input[name="inedate"]').val();
	
	if('' == insdate || '' == inedate){
		alert('출고일자를 선택 후 진행해 주세요.');
		return;
	}
	if('' == $('input[name="m_custcd"]').val()){
		alert('거래처를 선택 후 진행해 주세요.');
		return;
	}
	
	//거래처,납품처명 출력
	var custnm = $('input[name="v_custnm"]').val();
	var shiptonm = $('input[name="v_shiptonm"]').val();
	if(shiptonm != ''){
		$('#titleTd').html('거래처 : ' + custnm + ' / ' + '납품처 : ' + shiptonm);
	}else{
		$('#titleTd').html('거래처 : ' + custnm);
	}
	
	//전송기준 선택
	$('input:radio[name="m_papertype"]').parent().removeClass('checked');
	if($('input[name="m_custcd"]').val() != '' && $('input[name="m_shiptocd"]').val() != ''){
		$('input:radio[name="m_papertype"]:input[value="2"]').attr('checked', true);
		$('input:radio[name="m_papertype"]:input[value="2"]').parent().addClass('checked');
		
	}else{
		$('input:radio[name="m_papertype"]:input[value="1"]').attr('checked', true);
		$('input:radio[name="m_papertype"]:input[value="1"]').parent().addClass('checked');
	}
	
	//출고일자 출력
	$('#dateTd').html(insdate+' ~ '+inedate);
	
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
	
	var v_email = $('input[name="v_email"]').val();
	if(v_email == ''){
		alert('이메일을 입력해주세요.');
		$('input[name="v_email"]').focus();
		$(obj).prop('disabled', false);
		return false;
	}
	
	v_email = v_email.replace(/(\s*)/g, ""); //모든공백제거
	
	var lastChar = v_email.charAt(v_email.length-1);
	if(lastChar == ','){ v_email = v_email.slice(0,-1); } //마지막콤마제거
	
	var emailArr = v_email.split(',', -1);
	var email_reg = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/; //이메일
	//var email_reg = /^[\w]([-_\.]?[\w])*@[\w]([-_\.]?[\w])*\.[\w]{2,3}$/i; //이메일
	
	for(var i in emailArr) {
		if(!email_reg.test(emailArr[i])){
			alert("이메일 형식이 일치하지 않습니다.");
			$('input[name="v_email"]').focus();
			$(obj).prop('disabled', false);
			return false;
		}
	}
	
	if(confirm('전송 하시겠습니까?')){
		$('#ajax_indicator').show().fadeIn('fast');
		
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/report/factReportSendMailAjax.lime',
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
				$('#ajax_indicator').fadeOut();
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
	
	formPostSubmit('frm', '${url}/admin/report/sendMailHistoryExcelDown.lime');
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

<body class="page-header-fixed pace-done compact-menu searchHidden">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					거래사실확인서
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							
							<form method="post" name="frm">
							<div class="panel-body">
								<h5 class="table-title">거래사실 확인서</h5>
								<div class="btnList">
									<button type="button" class="btn btn-warning" onclick="excelDown(this);">전송기록 엑셀다운로드</button>
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
												<th>출고일자</th>
												<td>
													<input type="text" class="w-40" name="insdate" value="${insdate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="w-40" name="inedate" value="${inedate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													
													<input type="hidden" class="w-40" name="r_insdate" value="" readonly="readonly" />
													<input type="hidden" class="w-40" name="r_inedate" value="" readonly="readonly" />
												</td>
												<th>거래처 *</th>
												<td>
													<input type="text" class="w-40" name="v_custnm" value="" readonly="readonly" onclick="openCustomerPop(this);" />
													<input type="hidden" name="m_custcd" value="" />
													<a href="javascript:;" onclick="openCustomerPop(this);"><i class="fa fa-search i-search f-s-15"></i></a>
												</td>
											</tr>
											<tr>
												<th>납품처</th>
												<td>
													<input type="text" class="w-16" name="m_shiptocd" placeholder="납품처코드" value="" readonly="readonly" onclick="openShiptoPop(this);" />
													<input type="text" class="w-41" name="v_shiptonm" placeholder="납품처명" value="" readonly="readonly" onclick="openShiptoPop(this);" />
													<a href="javascript:;" onclick="openShiptoPop(this);"><i class="fa fa-search i-search f-s-15"></i></a>
													<button type="button" class="btn btn-xs btn-line writeObjectClass" onclick="setDefaultShipTo();">초기화</button>
												</td>
												<th>영업사원</th>
												<td>
													<input type="text" class="w-40" name="m_salesnm" value="" readonly="readonly" />
												</td>
											</tr>
										</tbody>
									</table>
									
									<div id="sendDiv">
										<h5 class="table-title" id="titleTd"></h5>
										<div class="table-responsive">
											<table id="" class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
												<colgroup>
													<col width="50%" />
													<col width="50%" />
												</colgroup>
												<tbody>
													<tr>
														<th class="text-center">전송기준</th>
														<th class="text-center">출고일자</th>
													</tr>
													<tr>
														<td class="radio text-center">
															<label><input type="radio" name="m_papertype" value="1" disabled/>거래처 거래사실확인서</label>
															<label><input type="radio" name="m_papertype" value="2" disabled/>납품처 거래사실확인서</label>
														</td>
														<td class="text-center" id="dateTd"></td>
													</tr>
												</tbody>
											</table>
										</div>
										
										<h5 class="table-title">이메일 전송</h5>
										<div class="table-responsive">
											<table id="" class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
												<colgroup>
													<col width="80%" />
													<col width="20%" />
												</colgroup>
												<tbody>
													<tr>
														<th class="text-center">받는사람</th>
														<th class="text-center">전송</th>
													</tr>
													<tr>
														<td class="text-center">
															<input type="text" name="v_email" value="" placeholder="email@knauf.com" />
														</td>
														<td class="text-center">
															<button type="button" class="btn btn-xs btn-gray w-20 writeObjectClass" onclick="sendEmail(this);">전송</button>
														</td>
													</tr>
												</tbody>
											</table>
											
											<div class="m-t-md f-s-14 f-red">※ 다중 주소 입력시 <strong>콤마(,)</strong>로 구분해주세요.</div>
										</div>
									</div>
									
								</div>
							</div>
							
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
	
</body>
</html>