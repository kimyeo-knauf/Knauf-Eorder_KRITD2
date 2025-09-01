<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script src="${url}/include/js/common/jqgrid/js/i18n/grid.locale-kr.js"></script>
<script src="${url}/include/js/common/jqgrid/js/jquery.jqGrid.min.js"></script>
<link href="${url}/include/js/common/jqgrid/css/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="${url}/include/js/common/jquery-ui/jquery-ui.css" rel="stylesheet" type="text/css" media="screen" />

<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'front/order/salesOrderList2/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"ACTUAL_SHIP_DT", label:'출고일자', width:90, align:'center', sortable:false, formatter:setActualShipDt}, // 출하일자.
	{name:"SHIPTO_CD", label:'납품처코드', width:90, align:'center', sortable:false, formatter:setDefault},
	{name:"SHIPTO_NM", label:'납품처명', width:120, align:'left', sortable:false, formatter:setDefault},
	{name:"ORDERNO", label:'수주번호', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"", label:'SO번호', width:100, align:'center', sortable:false, formatter:setDefault}, // AS_IS소스에도 빈값임.
	{name:"ITEM_DESC", label:'품목명', width:210, align:'left', sortable:false, formatter:setDefault},
	{name:"ORDER_QTY", label:'수량', width:60, align:'right', sortable:false, formatter:setOrderQty},
	{name:"UNIT1", label:'SM', width:60, align:'right', sortable:false, formatter:setSm},
	{name:"UNIT2", label:'KG', width:60, align:'right', sortable:false, formatter:setKg},
	{name:"PLANT_DESC", label:'출하지', width:140, align:'left', sortable:false, formatter:setDefault},
	{name:"ADD1", label:'도착지', width:360, align:'left', sortable:false, formatter:setDefault},
];

var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
//console.log('defaultColumnOrder : ', defaultColumnOrder);
var updateComModel = []; // 전역.

if(0 < globalColumnOrder.length){ // 쿠키값이 있을때.
	if(defaultColModel.length == globalColumnOrder.length){
		for(var i=0,j=globalColumnOrder.length; i<j; i++){
			updateComModel.push(defaultColModel[globalColumnOrder[i]]);
		}
		
		setCookie(ckNameJqGrid, globalColumnOrder, 365); // 여기서 계산을 다시 해줘야겠네.
		//delCookie(ckNameJqGrid); // 쿠키삭제
	}else{
		updateComModel = defaultColModel;
		
		setCookie(ckNameJqGrid, defaultColumnOrder, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel = defaultColModel;
	setCookie(ckNameJqGrid, defaultColumnOrder, 365);
}
//console.log('defaultColModel : ', defaultColModel);
//console.log('updateComModel : ', updateComModel);
// End.

// @@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth = ckNameJqGrid+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
// console.log('globalColumnWidthStr : ', globalColumnWidthStr);
// console.log('globalColumnWidth : ', globalColumnWidth);
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;
if('' != globalColumnWidthStr){ // 쿠키값이 있을때.
	if(updateComModel.length == globalColumnWidth.length){
		updateColumnWidth = globalColumnWidth;
	}else{
		for( var j=0; j<updateComModel.length; j++ ) {
			//console.log('currentColModel[j].name : ', currentColModel[j].name);
			if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
				var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
				if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
				else defaultColumnWidthStr += ','+v;
			}
		}
		defaultColumnWidth = defaultColumnWidthStr.split(',');
		updateColumnWidth = defaultColumnWidth;
		setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
	}
}
else{ // 쿠키값이 없을때.
	//console.log('updateComModel : ', updateComModel);
	
	for( var j=0; j<updateComModel.length; j++ ) {
		//console.log('currentColModel[j].name : ', currentColModel[j].name);
		if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
			var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
			if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
			else defaultColumnWidthStr += ','+v;
		}
	}
	defaultColumnWidth = defaultColumnWidthStr.split(',');
	updateColumnWidth = defaultColumnWidth;
	setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
}
//console.log('### defaultColumnWidthStr : ', defaultColumnWidthStr);
//console.log('### updateColumnWidth : ', updateColumnWidth);

if(updateComModel.length == globalColumnWidth.length){
	//console.log('이전 updateComModel : ',updateComModel);
	for( var j=0; j<updateComModel.length; j++ ) {
		updateComModel[j].width = toStr(updateColumnWidth[j]);
	}
	//console.log('이후 updateComModel : ',updateComModel);
}
// End.

//### 2 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid2 = 'front/order/salesOrderList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid2 += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGrid2)));
var globalColumnOrder2 = globalColumnOrderStr2.split(',');
//console.log('globalColumnOrderStr2 : ', globalColumnOrderStr2);

var defaultColModel2 = [ //  ####### 설정 #######
	{name:"ACTUAL_SHIP_DT", label:'출고일자', width:100, align:'center', sortable:false, formatter:setActualShipDt}, // 출하일자.
	{name:"SHIPTO_NM", label:'납품처명', width:200, align:'left', sortable:false, formatter:setDefault},
	{name:"ORDERNO", label:'수주번호', width:130, align:'center', sortable:true, formatter:setPopBtn},
	{name:"ITEM_DESC", label:'품목명', width:305, align:'left', sortable:false, formatter:setDefault},
];
var defaultColumnOrder2 = writeIndexToStr(defaultColModel2.length);
//console.log('defaultColumnOrder2 : ', defaultColumnOrder2);
var updateComModel2 = []; // 전역.

if(0 < globalColumnOrder2.length){ // 쿠키값이 있을때.
	if(defaultColModel2.length == globalColumnOrder2.length){
		for(var i=0,j=globalColumnOrder2.length; i<j; i++){
			updateComModel2.push(defaultColModel2[globalColumnOrder2[i]]);
		}
		
		setCookie(ckNameJqGrid2, globalColumnOrder2, 365); // 여기서 계산을 다시 해줘야겠네.
		//delCookie(ckNameJqGrid2); // 쿠키삭제
	}else{
		updateComModel2 = defaultColModel2;
		
		setCookie(ckNameJqGrid2, defaultColumnOrder2, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel2 = defaultColModel2;
	setCookie(ckNameJqGrid2, defaultColumnOrder2, 365);
}
//console.log('defaultColModel2 : ', defaultColModel2);
//console.log('updateComModel2 : ', updateComModel2);
// End.

var viewDevice = '';
var nowViewDevice = '';
$(window).resize(function(){
	var bodyWidth = $('body').width();
	if (bodyWidth < 767) {
		$('body').removeClass('small-sidebar');
		viewDevice = 'MOBILE'
	}else{
		viewDevice = 'PC'
	}
	
	$('.ui-jqgrid .ui-jqgrid-bdiv').css('width', '100%');
	
	if(nowViewDevice != viewDevice){
		//alert('nowViewDevice : '+nowViewDevice+'\nviewDevice : '+viewDevice);
		//$('#gridList').clearGridData();
		$('#gridList').jqGrid("GridUnload");
		getGridList();
	}
	nowViewDevice = viewDevice;
});

$(function(){
	if(isApp()){
		$('#excelDownBtnId').hide();
	}
	
	viewDevice = ($('body').width() < 767) ? 'MOBILE' : 'PC';
	nowViewDevice = viewDevice;
	
	getGridList();
	
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

function getGridList(){
	//alert(viewDevice);
	var divUpdateComModel = ('PC' == viewDevice) ? updateComModel : updateComModel2; 
	console.log('divUpdateComModel : ', divUpdateComModel);
	
	// grid init
	var searchData = getSearchData();
	$("#gridList").jqGrid({
		url: "${url}/front/order/getSalesOrderListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: divUpdateComModel,
		height: '360px',
		autowidth: false,
		multiselect: false,
		rownumbers: true,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		pagination: true,
		pager: "#pager",
		actions : true,
		pginput : true,
		//sortable: true,
		sortable: { // ####### 설정 #######
			update: function(relativeColumnOrder){
				var grid = $('#gridList');
				var defaultColIndicies = [];
				for( var i=0; i<defaultColModel.length; i++ ) {
					defaultColIndicies.push(defaultColModel[i].name);
				}
	
				globalColumnOrder = []; // 초기화.
				var columnOrder = [];
				var currentColModel = grid.getGridParam('colModel');
				for( var j=0; j<relativeColumnOrder.length; j++ ) {
					//console.log('currentColModel[j].name : ', currentColModel[j].name);
					if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
						columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
					}
				}
				globalColumnOrder = columnOrder;
				
				setCookie(ckNameJqGrid, globalColumnOrder, 365);
				
				// @@@@@@@ For Resize Column @@@@@@@
				//currentColModel = grid.getGridParam('colModel');
				//console.log('이전 updateColumnWidth : ', updateColumnWidth);
				var tempUpdateColumnWidth = [];
				for( var j=0; j<currentColModel.length; j++ ) {
				   if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
				      tempUpdateColumnWidth.push(currentColModel[j].width); 
				   }
				}
				updateColumnWidth = tempUpdateColumnWidth;
				//console.log('이후 updateColumnWidth : ', updateColumnWidth);
				setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
			}
		},
		// @@@@@@@ For Resize Column @@@@@@@
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder : ', globalColumnOrder);
			var minusIdx = 0;
			
			var grid = $('#gridList');
			var currentColModel = grid.getGridParam('colModel');
			//console.log('currentColModel : ', currentColModel);
			if('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
			if('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
			//console.log('minusIdx : ', minusIdx);
			
			var resizeIdx = index + minusIdx;
			//console.log('resizeIdx : ', resizeIdx);
			
			//var realIdx = globalColumnOrder[resizeIdx];
			//console.log('realIdx : ', realIdx);
			
			updateColumnWidth[resizeIdx] = width;
			
			setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
			//alert('Resize Column : '+index+'\nWidth : '+width);
		},
		sortorder: 'desc',
		jsonReader : { 
			root : 'list'
		},
		loadComplete: function(data){
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
		},
		gridComplete: function(){ 
			// 조회된 데이터가 없을때
			var grid = $('#gridList');
		    var emptyText = grid.getGridParam('emptyDataText'); //NO Data Text 가져오기.
		    var container = grid.parents('.ui-jqgrid-view'); //Find the Grid's Container
			if(0 == grid.getGridParam('records')){
				//container.find('.ui-jqgrid-hdiv, .ui-jqgrid-bdiv').hide(); //Hide The Column Headers And The Cells Below
		        //container.find('.ui-jqgrid-titlebar').after(''+emptyText+'');
            }
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

function setDefault(cellValue, options, rowObject) {
	return toStr(cellValue);
}
// 수량.
function setOrderQty(cellValue, options, rowObject) {
	return addComma(toStr(cellValue));
}
// 출하일자.
function setActualShipDt(cellValue, options, rowObject) {
	var actualShipDt = toStr(cellValue);
	if('' != actualShipDt) actualShipDt = actualShipDt.substring(0,4)+'-'+actualShipDt.substring(4,6)+'-'+actualShipDt.substring(6,8);
	return actualShipDt;
}
// SM.
function setSm(cellValue, options, rowObject) {
	var SM_content = 0;
	var SH_content = 0;
	var KG_content = 0;
	
	if('SM' == toStr(cellValue)){
		SM_content = addComma(toStr(rowObject.PRIMARY_QTY));
		SH_content = 0;
		KG_content = 0;
	}
	else if('SH' == toStr(cellValue)){
		SM_content = 0;
		SH_content = addComma(toStr(rowObject.SECOND_QTY));
		KG_content = 0;
	}
	else if('KG' == toStr(cellValue)){
		SM_content = 0;
		SH_content = 0;
		KG_content = addComma(toStr(rowObject.PRIMARY_QTY));
	}
	
	//
	if('SM' == toStr(cellValue)){
		return SM_content;
	}
	
	return SH_content;
}

// KG.
function setKg(cellValue, options, rowObject) {
	var unit1 =  rowObject.UNIT1;
		
	var SM_content = 0;
	var SH_content = 0;
	var KG_content = 0;
	
	if('SM' == toStr(unit1)){
		SM_content = addComma(toStr(rowObject.PRIMARY_QTY));
		SH_content = 0;
		KG_content = 0;
	}
	else if('SH' == toStr(unit1)){
		SM_content = 0;
		SH_content = addComma(toStr(rowObject.SECOND_QTY));
		KG_content = 0;
	}
	else if('KG' == toStr(unit1)){
		SM_content = 0;
		SH_content = 0;
		KG_content = addComma(toStr(rowObject.PRIMARY_QTY));
	}
	
	var KG_String = "";
	
	//
	if(0 == KG_content){
		return '';
	}
	
	return KG_content;
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

//납품처 초기화.
function setDefaultShipTo(){
	$('input[name="r_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
}

function getSearchData(){
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val();
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	var rl_orderno = $('input[name="rl_orderno"]').val();
	var r_shiptocd = $('input[name="r_shiptocd"]').val();
	
	var sData = {
		r_actualshipsdt : r_actualshipsdt
		, r_actualshipedt : r_actualshipedt
		, rl_orderno : rl_orderno
		, r_shiptocd : r_shiptocd
	};
	return sData;
}

// 조회
function dataSearch() {
	var searchData = getSearchData();
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

// 엑셀다운로드
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/front/order/salesOrderMainExcelDown.lime');
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

// 상세조회 펼침
function fn_spread(id){ 
	var getID = document.getElementById(id); 
	getID.style.display=(getID.style.display=='block') ? 'none' : 'block'; 
}

//팝업
function setPopBtn(cellValue, options, rowObject) {
	return '<a href=\'javascript:salesOrderMainViewPop("'+ toStr(cellValue) +'", "'+toStr(rowObject.ORDERTY)+'", "'+ rowObject.LINE_NO +'");\'>'+ toStr(cellValue) +'</a>';
}

//모바일 전체주문현황 상세팝업
function salesOrderMainViewPop(orderno, orderty, lineno){
	if(!isApp()){
		var param = 'salesOrderMainViewPop';
		var widthPx = 615;
		var heightPx = 650;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frm_pop"]').remove();
		
		var htmlText = '';
		htmlText += '<form name="frm_pop" method="post" target="salesOrderMainViewPop">';
		htmlText += '	<input type="hidden" name="pop" value="1" />';
		htmlText += '	<input type="hidden" name="page_type" value="salesOrderMainViewPop" />';
		htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
		htmlText += '	<input type="hidden" name="r_orderno" value="'+ orderno +'" />';
		htmlText += '	<input type="hidden" name="r_orderty" value="'+ orderty +'" />';
		htmlText += '	<input type="hidden" name="r_lineno" value="'+ lineno +'" />';
		htmlText += '</form>';
		$('body').append(htmlText);
		
		var popUrl = '${url}/front/order/salesOrderViewPop.lime';
		window.open('', 'salesOrderMainViewPop', options);
		$('form[name="frm_pop"]').prop('action', popUrl);
		$('form[name="frm_pop"]').submit().remove();
	}
	else{
		// 모달팝업
		//$('#salesOrderMainViewPopMId').modal('show');
		var link = '${url}/front/order/salesOrderViewPop.lime?page_type=salesOrderMainViewPop&r_multiselect=false&r_orderno='+orderno+'&r_orderty='+orderty+'&r_lineno='+lineno+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#salesOrderMainViewPopMId').modal({
			remote: link
		});
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
				<div class="page-breadcrumb"><strong>거래내역(주문)</strong></div>
				
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
	
		<!-- Content -->
		<div class="content">
		
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
				
					<div class="searchArea">
						<div class="col-md-6">
							<em>출고일자</em>
							<input type="text" class="form-control calendar" name="r_actualshipsdt" value="${actualshipsdt}" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_actualshipedt" value="${actualshipsdt}" readonly="readonly" />
						</div>
						
						<div class="col-md-4 right">
							<em>수주번호</em>
							<input type="text" class="form-control" name="rl_orderno" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						</div>
						<div class="col-md-1 empty searchBtn">
							<!-- <button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button> -->
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						
						<c:if test="${'CO' eq sessionScope.loginDto.authority}">
							<div class="col-md-6">
								<em>납품처</em>
								<input type="text" class="form-control search" name="v_shiptonm" placeholder="납품처명" value="" readonly="readonly" onclick="openShiptoPop(this);" />
								<input type="hidden" name="r_shiptocd" value="" />
<%-- 								<button type="button" class="btn-search" onclick="openShiptoPop(this);"><img src="${url}/include/images/front/common/icon_search@2x.png" alt="img" /></button> --%>
								<button type="button" class="btn btn-reset" onclick="setDefaultShipTo();">초기화</button>
							</div>
						</c:if>
						
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
							Total <strong><span id="listTotalCountSpanId"></span></strong>EA
							<div class="title-right little">
								<button type="button" class="btn-excel" id="excelDownBtnId" onclick="excelDown(this);"><img src="${url}/include/images/front/common/icon_excel@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardList">
							<div class="table-responsive in">
								<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
								<div id="pager"></div>
							</div>
						</div> <!-- boardList -->
						
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
	
	<!-- Modal -->
	<div class="modal fade" id="salesOrderMainViewPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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