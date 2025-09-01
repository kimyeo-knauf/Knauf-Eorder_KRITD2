<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<!-- ### Bootstrap Multiselect ### -->
<!-- https://github.com/davidstutz/bootstrap-multiselect -->
<!-- http://davidstutz.de/bootstrap-multiselect/ -->
<script src="${url}/include/js/common/bootstrap-mutiselect-master/js/bootstrap-multiselect.js"></script>
<link href="${url}/include/js/common/bootstrap-mutiselect-master/css/bootstrap-multiselect.css" rel="stylesheet" />

<script type="text/javascript">
var selectedPaperType = '10'; // 선택된 납품확인서 유형별 paper_type 값.

console.log('Delivery Report');

$(function(){
	setMuliSelectAdd1();
	setMuliSelectItemDesc();
	
	//$('#paperType10').trigger('click');
	viewReportType('10');
});

$(document).ready(function() {
	// 출고일자 데이트피커.
	$('input[name="r_actualshipsdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		//clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_actualshipedt"]').datepicker('setStartDate', minDate);
		
		setData('1');
    });
	$('input[name="r_actualshipedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		//clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_actualshipsdt"]').datepicker('setEndDate', maxDate);
		
		setData('2');
    });
});

// set 착지주소 멀티 셀렉트.
function setMuliSelectAdd1(){
	$('#v_add1').multiselect({
		disableIfEmpty: true,
		disabledText: '선택해 주세요.',
		nonSelectedText: '선택해 주세요.',
		checkboxName: function(option){ // 체크박스명 정의.
			return 'ri_add1';	
		},
		onChange: function(option, checked, select) {
			//alert('Changed option ' + $(option).val() + '.');
        },
        onDropdownHide: function(event) { // 체크박스 선택후 포커스 아웃했을때 이벤트 발생.
			//alert('Dropdown closed.');
        	setData('6');
        },
        buttonText: function(options, select) {
            if (options.length > 0) {
                return '착지주소 '+options.length+'개 선택';
            }
            else{
            	return '선택해 주세요.';
            }
        },
     	enableFiltering: true, // 검색창.
     	enableCaseInsensitiveFiltering: true, // 검색창.
        enableFullValueFiltering: false, // 검색창.
        includeSelectAllOption: true,
        selectAllJustVisible: false,
        selectAllText: '전체선택'        
	});	 
}

// set 품목명 멀티 셀렉트.
function setMuliSelectItemDesc(){
	$('#v_itemdesc').multiselect({
		disableIfEmpty: true,
		disabledText: '선택해 주세요.',
		nonSelectedText: '선택해 주세요.',
		checkboxName: function(option){ // 체크박스명 정의.
			return 'ri_itemdesc';	
		},
		onChange: function(option, checked, select) {
			//alert('Changed option ' + $(option).val() + '.');
        },
        onDropdownHide: function(event) { // 체크박스 선택후 포커스 아웃했을때 이벤트 발생.
			//alert('Dropdown closed.');
        	setData('7');
        },
        buttonText: function(options, select) {
            if (options.length > 0) {
                return '품목 '+options.length+'개 선택';
            }
            else{
            	return '선택해 주세요.';
            }
        },
        enableFiltering: true, // 검색창.
        enableCaseInsensitiveFiltering: true, // 검색창.
        enableFullValueFiltering: false, // 검색창.
        includeSelectAllOption: true,
        selectAllJustVisible: false,
        selectAllText: '전체선택'
	});	 
}

// 거래처 선택 팝업 띄우기.
function openCustomerPop(){
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 805;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="customerListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderlist" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/customerListPop.lime';
	window.open('', 'customerListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// return 거래처 팝업에서 개별 선택.
function setCustomerFromPop(jsonData){
	$('input[name="r_custcd"]').val(toStr(jsonData.CUST_CD));
	$('input[name="v_custnm"]').val(toStr(jsonData.CUST_NM));

	setData('3');
}

// 거래처 초기화.
function setDefaultCustomer(){
	$('input[name="v_custnm"]').val('');
	$('input[name="r_custcd"]').val('');
	
	$('select[name="r_shiptocd"]').empty();
	var textHtml = '<option value="">선택해 주세요.</option>';
	$('select[name="r_shiptocd"]').append(textHtml);
	
	setData('4');
}

// 기간+거래처의 납품처 불러오기.
function setShipTo(cust_cd){
	var r_actualshipsdt = toStr($('input[name="r_actualshipsdt"]').val());	
	var r_actualshipedt = toStr($('input[name="r_actualshipedt"]').val());
	
	$.ajax({
		async : false,
		url : '${url}/admin/base/getShiptoListBySalesOrderAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { 
			r_custcd : cust_cd
			, r_actualshipsdt : r_actualshipsdt.replaceAll('-', '')
			, r_actualshipedt : r_actualshipedt.replaceAll('-', '')
			//, where : 'all'
		},
		success : function(data){
			$('select[name="r_shiptocd"]').empty();
			
			var textHtml = '';
			textHtml += '<option value="">선택해 주세요.</option>';
			$(data.list).each(function(i,e){
				textHtml += '<option value="'+e.SHIPTO_CD+'">'+e.SHIPTO_NM+'</option>';
			});
			
			$('select[name="r_shiptocd"]').append(textHtml);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});	
}

// 기간+거래처 > 착지주소 불러오기.
function setAdd1(cust_cd){
	var r_actualshipsdt = toStr($('input[name="r_actualshipsdt"]').val());	
	var r_actualshipedt = toStr($('input[name="r_actualshipedt"]').val());
	
	$.ajax({
		async : false,
		url : '${url}/admin/base/getAdd1ListBySalesOrderAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { 
			r_custcd : cust_cd
			, r_actualshipsdt : r_actualshipsdt.replaceAll('-', '')
			, r_actualshipedt : r_actualshipedt.replaceAll('-', '')
		},
		success : function(data){
			//$('#v_add1').multiselect('destroy');
			$('select[name="v_add1"]').empty();
			
			var textHtml = '';
			//textHtml += '<option value="">선택해 주세요.</option>';
			$(data.list).each(function(i,e){
				if('' != toStr(e.ADD1)){
					textHtml += '<option value="'+e.ADD1+'">'+e.ADD1+'</option>';
				}
			});
			
			$('select[name="v_add1"]').append(textHtml);
			
			$('#v_add1').multiselect('rebuild');
		},
		error : function(request,status,error){
			alert('Error');
		}
	});	
}

// 기간+거래처+(현장(납품처) or 착지주소) > 품목명 불러오기.
function setItemDesc(){
	if('10' == selectedPaperType || '11' == selectedPaperType || '12' == selectedPaperType){ // 현장(납품처).
		//var r_shiptocd = toStr($('select[name="r_shiptocd"] option:selected').val());
		//if('' == r_shiptocd){
		var r_shiptonm = toStr($('select[name="r_shiptocd"] option:selected').text());
		if('' == r_shiptonm){
			// 품목명 disabled.
			$('select[name="v_itemdesc"]').empty();
			$('#v_itemdesc').multiselect('rebuild');
			return;
		}
		$('input[name="r_shiptonm"]').val(r_shiptonm);
	}else if('20' == selectedPaperType || '21' == selectedPaperType || '22' == selectedPaperType){ // 착지주소.
		var chkAdd1Cnt = $('input:checkbox[name="ri_add1"]:checked').length;
		if(0 >= chkAdd1Cnt){
			// 품목명 disabled.
			$('select[name="v_itemdesc"]').empty();
			$('#v_itemdesc').multiselect('rebuild');
			return; 
		}
	}
	
	var params = $('form[name="frm"]').serialize();
	$.ajax({
		async : false,
		url : '${url}/admin/base/getItemDescListBySalesOrderAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : params,
		success : function(data){
			//$('#v_itemdesc').multiselect('destroy');
			$('select[name="v_itemdesc"]').empty();
			
			var textHtml = '';
			//textHtml += '<option value="">선택해 주세요.</option>';
			$(data.list).each(function(i,e){
				if('' != toStr(e.ITEM_DESC)){
					textHtml += '<option value="'+e.ITEM_DESC+'">'+e.ITEM_DESC+'</option>';
				}
			});
			
			$('select[name="v_itemdesc"]').append(textHtml);
			
			$('#v_itemdesc').multiselect('rebuild');
		},
		error : function(request,status,error){
			alert('Error');
		}
	});	
}

// 출고일자 && 거래처 && (현장(납품처) or 착지주소) && 품목명 > onchange event.
// search_type : 1=출고일자 시작일, 2=출고일자 종료일, 3=거래처 선택, 4=거래처 초기화, 5=납품처 선택, 6=착지주소 선택, 7=품목명 선택 / B=4개의 납품확언서 버튼 클릭
function setData(search_type){ 
	//alert('setData Start.');
	
	var r_actualshipsdt = toStr($('input[name="r_actualshipsdt"]').val());	
	var r_actualshipedt = toStr($('input[name="r_actualshipedt"]').val());
	var r_custcd = toStr($('input[name="r_custcd"]').val());
	
	// Default.
	if('1' == search_type || '2' == search_type || '3' == search_type || '4' == search_type || 'B' == search_type){
		// 납품처 및 착지주소 disabled. 
		if('' == r_actualshipsdt || '' == r_actualshipedt || '' == r_custcd){
			$('select[name="r_shiptocd"]:not(:eq(0))').empty();
			$('select[name="r_shiptocd"]').prop('disabled', true);
			
			$('select[name="v_add1"]').empty();
			$('#v_add1').multiselect('rebuild');
		}
		// 납품처 및 착지주소 다시 불러오기.
		else{
			if('10' == selectedPaperType || '11' == selectedPaperType || '12' == selectedPaperType){
				setShipTo(r_custcd);
				$('select[name="r_shiptocd"]').prop('disabled', false);
			}
			else if('20' == selectedPaperType || '21' == selectedPaperType || '22' == selectedPaperType){
				setAdd1(r_custcd);
			}
		}
		
		// 품목명 disabled.
		$('select[name="v_itemdesc"]').empty();
		$('#v_itemdesc').multiselect('rebuild');
	}
	// 납품처 및 착지주소 변경시.
	else if('5' == search_type || '6' == search_type){
		// 이 경우는 없겠네?
		if('' == r_actualshipsdt || '' == r_actualshipedt || '' == r_custcd){
			
		}
		// 품목명 다시 불러오기.
		else{
			setItemDesc();
		}
	}
	// 품목명 변경시.
	else if('7' == search_type){
		
	}
}

// 납품확인서 유형별 검색조건 활성화.			
function viewReportType(paper_type){ // paper_type : 10=개별아이템-현장, 20=개별아이템-착지, 11=아이템별-현장, 21=아이템별-착지, 12=아이템총계-현장, 22=아이템총계-착지
	if('12' == paper_type || '22' == paper_type) {
		document.getElementById('hebeCheck').style.display = 'none';
	} else {
		document.getElementById('hebeCheck').style.display = '';
	}

	if('10' == paper_type || '11' == paper_type || '12' == paper_type){
		$('#searchAreaLiShipTo').show(); // 납품처
		$('#searchAreaLiAdd').hide(); // 착지
	}
	else if('20' == paper_type || '21' == paper_type || '22' == paper_type){
		$('#searchAreaLiShipTo').hide(); // 납품처
		$('#searchAreaLiAdd').show(); // 착지
	}
	
	selectedPaperType = paper_type; // selectedPaperType은 전역변수로, 선택된 납품확인서 유형별 paper_type 값.
	$('#selectedPaperTypeH5Id').html($('#paperType'+paper_type).text());
	
	$('#noList').show();
	$('#printArea').hide();
	
	$('input[name="paper_type"]').val(paper_type);
	
	setData('B');
}

// 조회
function dataSearch() {
	//alert(selectedPaperType);
	
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val(); 
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	if('' == r_actualshipsdt){
		alert('출고일자 검색 시작일을 입력해 주세요.');
		return;
	}
	if('' == r_actualshipedt){
		alert('출고일자 검색 종료일을 입력해 주세요.');
		return;
	}
	
	var r_custcd = $('input[name="r_custcd"]').val();
	if('' == r_custcd){
		alert('거래처를 선택해 주세요.');
		return;
	}
	
	// selectedPaperType : 10=개별아이템-현장, 20=개별아이템-착지, 11=아이템별-현장, 21=아이템별-현장, 12=아이템총계-현장, 22=아이템총계-착지
	if('10' == selectedPaperType || '11' == selectedPaperType || '12' == selectedPaperType){
		//var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();
		//if('' == r_shiptocd){
		var r_shiptonm = toStr($('select[name="r_shiptocd"] option:selected').text());
		if('' == r_shiptonm){
			// 품목명 disabled.
			$('select[name="v_itemdesc"]').empty();
			$('#v_itemdesc').multiselect('rebuild');
			
			alert('납품처를 선택해 주세요.');
			return;
		}
		$('input[name="r_shiptonm"]').val(r_shiptonm);
	}
	else if('20' == selectedPaperType || '21' == selectedPaperType || '22' == selectedPaperType){
		// 착지 멀티 셀렉트 유효성 체크.
		var chkAdd1Cnt = $('input:checkbox[name="ri_add1"]:checked').length;
		if(0 >= chkAdd1Cnt){
			// 품목명 disabled.
			$('select[name="v_itemdesc"]').empty();
			$('#v_itemdesc').multiselect('rebuild');
			
			alert('착지주소를 선택해 주세요.');
			return; 
		}
	}
	
	// 춤목명 멀티 셀력트 유효성 체크.
	var chkItemCnt = $('input:checkbox[name="ri_itemdesc"]:checked').length;
	if(0 >= chkItemCnt){
		alert('품목명을 선택해 주세요.');
		return; 
	}
	
	// 데이터 검색.
	
	// iframe > 브라우져 미리보기 문제 있음.
	/* 
	$('input[name="paper_type"]').val(selectedPaperType);
	
	var iframUrl = '${url}/admin/report/deliveryPaperPop.lime';
	$('form[name="frm"]').prop('action', iframUrl);
	$('form[name="frm"]').prop('target', 'reportIframe');
	$('form[name="frm"]').submit();
	
	$('form[name="frm"]').prop('action', '');
	$('form[name="frm"]').prop('target', '');
	
	// 아래는 검색된 결과에 따른 처리.
	//$('#noList').hide();
	//$('#printArea').show();
	*/
	
	deliveryPaperPop();
	return;
}

// 납품확인서 팝업 띄우기.
function deliveryPaperPop(){
	var param = 'deliveryPaperPop';
	var widthPx = 840;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
// 	$('form[name="frm_pop"]').remove();
	
// 	var htmlText = '';
// 	htmlText += '<form name="frm_pop" method="post" target="deliveryPaperPop">';
// 	htmlText += '	<input type="hidden" name="pop" value="1" />';
// 	htmlText += '	<input type="hidden" name="paper_type" value="'+selectedPaperType+'" />';
// 	htmlText += '</form>';
// 	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/report/deliveryPaperPop.lime';
	window.open('', 'deliveryPaperPop', options);
	$('form[name="frm"]').append('<input type="hidden" name="pop" value="1" />');
	$('form[name="frm"]').prop('target', 'deliveryPaperPop');
	$('form[name="frm"]').prop('action', popUrl);
	$('form[name="frm"]').submit();
	
	$('form[name="frm"]').find('input[name="pop"]').remove();
	$('form[name="frm"]').prop('target', '');
	$('form[name="frm"]').prop('action', '');
}

</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<!-- Page Content -->
	<main class="page-content content-wrap">
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					납품확인서
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="출력" onclick="dataSearch();"><i class="fa fa-print"></i><em>출력</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="document.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<!-- <button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button> -->
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
			<form name="frm" method="post">
			<input type="hidden" name="paper_type" value="10" />
			<input type="hidden" name="r_shiptonm" value="" />

				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body no-p" id="searchAreaDivId">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">출고일자 *</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="${insdate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="${inedate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">거래처 *</label>
												<div class="search-c">
													<%-- 거래처 input의 readonly를 풀고 like 검색을 할경우 납품처 선택이 문제생김. --%>
													<input type="text" class="search-input form-md-d" name="v_custnm" value="" readonly="readonly" onclick="openCustomerPop();" />
													<input type="hidden" class="" name="r_custcd" value="" />
													<a href="javascript:;" onclick="openCustomerPop();"><i class="fa fa-search i-search"></i></a>
													<button type="button" class="btn btn-line btn-xs pull-left" onclick="setDefaultCustomer();">초기화</button>
												</div>
											</li>
											<li id="searchAreaLiShipTo" style="display:none;">
												<label class="search-h">납품처 *</label>
												<div class="search-c">
													<select class="form-control" name="r_shiptocd" onchange="setData('5');" disabled="disabled">
														<option value="">선택해 주세요.</option>
													</select>
												</div>
											</li>
											<li id="searchAreaLiAdd" style="display:none;">
												<label class="search-h">착지주소 *</label>
												<div class="search-c">
													<%-- option name : ri_add1 --%>
													<select name="v_add1" id="v_add1" multiple="multiple">
													</select>
												</div>
											</li>
											<li>
												<label class="search-h">품목명 *</label>
												<div class="search-c">
													<%-- option name : ri_itemdesc --%>
													<select name="v_itemdesc" id="v_itemdesc" multiple="multiple">
													</select>
												</div>
											</li>
											<li>
												<div class="search-c" id='hebeCheck'>
													<label class="lol-label-checkbox" for="r_hebechk">
														<input type="checkbox" id="r_hebechk" name="r_hebechk" value="Y"/>
														<span class="lol-text-checkbox">헤베표시</span>
													</label>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title listT" id="selectedPaperTypeH5Id"></h5>
								<div class="btnList more">
									<button class="btn btn-sm btn-warning deliPaperBtnClass" onclick="viewReportType('10');" type="button" title="개별아이템-현장" id="paperType10">개별아이템-현장</button>
									<button class="btn btn-sm btn-warning deliPaperBtnClass" onclick="viewReportType('20');" type="button" title="개별아이템-착지" id="paperType20">개별아이템-착지</button>
									<button class="btn btn-sm btn-info deliPaperBtnClass" onclick="viewReportType('11');" type="button" title="아이템별소계-현장" id="paperType11">아이템별소계-현장</button>
									<button class="btn btn-sm btn-info deliPaperBtnClass" onclick="viewReportType('21');" type="button" title="아이템별소계-착지" id="paperType21">아이템별소계-착지</button>
									<button class="btn btn-sm btn-info deliPaperBtnClass" onclick="viewReportType('12');" type="button" title="아이템별총합-현장" id="paperType12">아이템별총합-현장</button>
									<button class="btn btn-sm btn-info deliPaperBtnClass" onclick="viewReportType('22');" type="button" title="아이템별총합-착지" id="paperType22">아이템별총합-착지</button>
								</div>
								<div class="table-responsive in">
									<table id="printArea" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td>
													<iframe name="reportIframe" id="reportIframe" width="100%" height="600" frameborder="1" scrolling="yes"></iframe>
												</td>
											</tr>
										</tbody>
									</table>
									<table id="noList" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td>출력할 납품확인서를 선택해 주세요.</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
			</form>
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>
</html>