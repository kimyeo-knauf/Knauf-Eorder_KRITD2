<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var page_type = toStr('${param.page_type}'); //recommend=추천상품 다중선택 / orderadd=영업사원 주문등록 다중선택 / orderedit=CS주문처리 개별선택.
var multi_select = toStr('${r_multiselect}');
multi_select = ('true' == multi_select) ? true : false;
var ckNameJqGrid = 'admin/order/salesOrderList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

/* var defaultColModel = [ //  ####### 설정 #######
	{name:"ORDERNO", label:'오더번호', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"CUST_PO", label:'고객PO', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"PLANT_DESC", label:'출하지', width:100, align:'left', sortable:false, formatter:setDefault},
	{name:"STATUS_DESC", label:'오더상태', width:100, align:'left', sortable:false, formatter:setStatus2}, //
	{name:"ORDER_QTY", label:'수량', width:50, align:'right', sortable:false, formatter:setOrderQty},
	{name:"UNIT", label:'단위', width:50, align:'center', sortable:false, formatter:setDefault},
	{name:"ACTUAL_SHIP_DT", label:'출하일자', width:80, align:'left', sortable:false, formatter:setActualShipDt}, // 출하일자.
	{name:"REQUEST_DT", label:'납품요청일', width:115, align:'left', sortable:false, formatter:setRequestDt}, //
	{name:"CUST_NM", label:'거래처명', width:120, align:'left', sortable:true, formatter:setDefault},
	{name:"ADD1", label:'납품주소', width:150, align:'left', sortable:false, formatter:setAdd1},
	//{name:"ORDERTY", label:'오더코드', width:20, align:'left', sortable:false, formatter:setDefault},
	{name:"ITEM_CD", label:'폼목코드', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"ITEM_DESC", label:'품목명', width:200, align:'left', sortable:true, formatter:setDefault},
	{name:"ITEM_DESC2", label:'품목명2', width:190, align:'left', sortable:true},	
	{name:"SHIPTO_NM", label:'납품처명', width:120, align:'left', sortable:false, formatter:setDefault},
	{name:"ADD4", label:'특기사항', width:95, align:'left', sortable:false, formatter:setDefault},
	{name:"PRIMARY_QTY", label:'헤베수량', width:80, align:'right', sortable:false, formatter:setPrimaryQty},  
	{name:"DRIVER_PHONE", label:'기사TEL', width:100, align:'left', sortable:false, formatter:setDefault},
	{name:"UNIT1", label:'주단위', width:60, align:'center', sortable:false, formatter:setDefault},
	{name:"ADD3", label:'전화번호', width:100, align:'center', sortable:false, formatter:setDefault}, //
	{name:"HOLD_CODE", label:'보류코드', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"SALESREP_NM", label:'영업사원', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"", label:'기능', width:180, align:'left', sortable:false, formatter:setButton}, //
// 	{name:"STATUS1", hidden:true},
	{name:"STATUS2", hidden:true},
	{name:"ADD2", hidden:true},
// 	{name:"SHIPTO_CD", hidden:true}, // 납품처코드.
// 	{name:"REQUEST_TIME", hidden:true},
// 	{name:"TRUCK_NO", hidden:true}, // 차량번호.
// 	{name:"DUMMY", hidden:true}, // H=한진,D=동원
]; */

var defaultColModel = [ //  ####### 설정 #######
	{name:"ORDERNO", label:'오더번호', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"ORDERTY", label:'오더유형', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"HOLD_CODE", label:'보류코드', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"CUST_NM", label:'거래처명', width:120, align:'left', sortable:true, formatter:setDefault},
	{name:"ADD1", label:'납품주소', width:150, align:'left', sortable:false, formatter:setAdd1},
	{name:"ACTUAL_SHIP_DT", label:'출하일자', width:80, align:'left', sortable:false, formatter:setActualShipDt}, // 출하일자.
	{name:"REQUEST_DT", label:'납품요청일', width:115, align:'left', sortable:false, formatter:setRequestDt}, //
	{name:"ITEM_DESC", label:'품목명', width:200, align:'left', sortable:true, formatter:setDefault},
	{name:"ORDER_QTY", label:'수량', width:50, align:'right', sortable:false, formatter:setOrderQty},
	{name:"UNIT", label:'단위', width:50, align:'center', sortable:false, formatter:setDefault},
	{name:"SHIPTO_NM", label:'납품처명', width:120, align:'left', sortable:false, formatter:setDefault},
	{name:"PLANT_DESC", label:'출하지', width:100, align:'left', sortable:false, formatter:setDefault},
	//{name:"PRIMARY_QTY", label:'헤베수량', width:80, align:'right', sortable:false, formatter:setPrimaryQty}, //
	{name:"PRIMARY_QTY", label:'헤베수량', width:80, align:'right', sortable:false, formatter:'number', formatoptions:{decimalSeperator:',', thousandsSeperator:',', decimalPlaces:3} }, 
	{name:"UNIT1", label:'주단위', width:60, align:'center', sortable:false, formatter:setDefault},
	{name:"ITEM_CD", label:'폼목코드', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"STATUS_DESC", label:'오더상태', width:100, align:'left', sortable:false, formatter:setStatus2}, //
	{name:"DRIVER_PHONE", label:'기사TEL', width:100, align:'left', sortable:false, formatter:setDefault},
	{name:"ORDER_DT", label:'오더일자', width:100, align:'left', sortable:false, formatter:setActualShipDt},
	//오더일자 추가 필요
	{name:"CUST_PO", label:'고객PO', width:80, align:'center', sortable:true, formatter:setDefault},
	//{name:"ORDERTY", label:'오더코드', width:20, align:'left', sortable:false, formatter:setDefault},
	{name:"ADD4", label:'특기사항', width:95, align:'left', sortable:false, formatter:setDefault},
	{name:"ADD3", label:'전화번호', width:100, align:'center', sortable:false, formatter:setDefault}, //
	{name:"SALESREP_NM", label:'영업사원', width:80, align:'center', sortable:false, formatter:setDefault},
	{name:"LOTN", label:'LOTN', width:80, align:'center', sortable:false, formatter:setDefault},// 2025-03-24 hsg Super KIck : 조회목폭에 LOTN 항목 추가 요청
	{name:"", label:'기능', width:180, align:'left', sortable:false, formatter:setButton}, //
// 	{name:"STATUS1", hidden:true},
	{name:"STATUS2", hidden:true},
	{name:"ADD2", hidden:true},
// 	{name:"SHIPTO_CD", hidden:true}, // 납품처코드.
// 	{name:"REQUEST_TIME", hidden:true},
// 	{name:"TRUCK_NO", hidden:true}, // 차량번호.
// 	{name:"DUMMY", hidden:true}, // H=한진,D=동원
];

var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
// console.log('defaultColumnOrder : ', defaultColumnOrder);
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
// console.log('defaultColModel : ', defaultColModel);
// console.log('updateComModel : ', updateComModel);
// console.log('defaultColumnOrder : ', defaultColumnOrder);
// console.log('globalColumnOrderStr : ', globalColumnOrderStr);
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

$(function(){
	getGridList();
});

$(document).ready(function() {
	// 주문일자 데이트피커.
	$('input[name="r_ordersdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_orderedt"]').datepicker('setStartDate', minDate);
    });

	$('input[name="r_orderedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_ordersdt"]').datepicker('setEndDate', maxDate);
    });
	
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
	
	// 납품요청일자 데이트피커.
	$('input[name="r_requestsdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_requestedt"]').datepicker('setStartDate', minDate);
    });
	$('input[name="r_requestedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_requestsdt"]').datepicker('setEndDate', maxDate);
    });
	
	// 주문상태값 전체 체크.
	$('input:checkbox[name="allCheck"]').trigger('click');
	$('input:checkbox[name="allCheck"]').uniform();
	$('input:checkbox[name="vi_status2"]').uniform();
});

function getGridList(){ 
	// grid init
	var searchData = getSearchData();
	$("#gridList").jqGrid({
		url: "${url}/admin/order/getSalesOrderListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		multiselect: true,
		rownumbers: true,
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
			$('.ui-pg-input').val(data.page);
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
// 헤베수량.
function setPrimaryQty(cellValue, options, rowObject) {
	return addComma(toStr(cellValue));
}
// 주문상태명.
function setStatus2(cellValue, options, rowObject) {
	return toStr(cellValue);
}
// 납품요청일시.
function setRequestDt(cellValue, options, rowObject) {
	var requestDt = toStr(cellValue);
	if('' != requestDt) requestDt = requestDt.substring(0,4)+'-'+requestDt.substring(4,6)+'-'+requestDt.substring(6,8);
	
	var requestTime = toStr(rowObject.REQUEST_TIME);
	if('' != requestTime) requestDt += ' '+requestTime.substring(0,2)+':'+requestTime.substring(2,4);
	
	return requestDt;
}
//납품주소.
function setAdd1(cellValue, options, rowObject) {
	var retStr = toStr(cellValue).replace(/(^\s*)|(\s*$)/g, '');
	var add2 = toStr(rowObject.ADD2).replace(/(^\s*)|(\s*$)/g, '');
	if('' != add2) retStr += ' '+add2;
	return retStr;
}
// 출하일자.
function setActualShipDt(cellValue, options, rowObject) {
	var actualShipDt = toStr(cellValue);
	if('' != actualShipDt) actualShipDt = actualShipDt.substring(0,4)+'-'+actualShipDt.substring(4,6)+'-'+actualShipDt.substring(6,8);
	return actualShipDt;
}
// 기능버튼.
function setButton(cellValue, options, rowObject) {
	var retStr = '';
	
	var status2 = rowObject.STATUS2;
	var status_desc = rowObject.STATUS_DESC;
	var orderno = rowObject.ORDERNO;
	var cust_po = rowObject.CUST_PO;
	
	var orderty = rowObject.ORDERTY;
	var line_no = rowObject.LINE_NO;
	
	var deliType = rowObject.DUMMY; // H=한진,D=동원
	var truckNo = toStr(rowObject.TRUCK_NO); // 챠량번호. ex.서울90바5516박충렬
	var driverName = '';
	if('' != truckNo){
		driverName = truckNo.substring(9, truckNo.length); // ex.정우성
		truckNo = truckNo.substring(0, 9); // ex.서울90바5516
	}
	var plantDesc = rowObject.PLANT_DESC; // 출하지.
	var actualShipDt = rowObject.ACTUAL_SHIP_DT; // 출하일.
	var driverPhone = rowObject.DRIVER_PHONE; // 기사TEL.
	var add1 = rowObject.ADD1; // 주소.
	
	// 거래명세표 버튼 > 배차완료(530) 이후에만 노출.
	if(530 <= status2){
		retStr += '<button type="button" class="btn btn-default btn-xs" onclick=\'orderPaperPop(this, "'+orderno+'", "'+cust_po+'");\'>거래명세표</button>';
	}
	// 배송추적 버튼
	if('' != truckNo && ('H' == deliType || 'D' == deliType) && '출하완료' == status_desc){
		if('' != retStr) retStr += ' ';
		retStr += '<button type="button" class="btn btn-gray btn-xs w-xxs" onclick=\'openTruckMapPop(this, "'+truckNo+'", "'+deliType+'", "'+plantDesc+'", "'+actualShipDt+'", "'+driverPhone+'", "'+driverName+'", "'+add1+'", "'+orderno+'", "'+orderty+'", "'+line_no+'");\'>배송추적</button>';
	}
	return retStr;
}

// 거래명세표 팝업 띄우기.
function orderPaperPop(obj, orderno, custpo){
	if(orderno == ''){
		var rowIds = $('#gridList').jqGrid('getGridParam','selarrrow');
		var orderNo = '';
		for(var i=0; i<rowIds.length; i++){
			var status2 = $("#gridList").getRowData(rowIds[i]).STATUS2;
			if(530 <= status2){
				orderNo += $("#gridList").getRowData(rowIds[i]).ORDERNO + ',';
			}
		}
		
		if (rowIds == ''){
			alert("선택 후 진행해 주세요.\n거래명세표는 배차완료 이후에만 출력 가능합니다.");
			return;
		}
		if (orderNo == ''){
			alert("거래명세표는 배차완료 이후 건만 출력 가능합니다.");
			return;
		}
	
	}else{
		orderNo = orderno;
	}
	
	var param = 'salesOrderPaper';
	var widthPx = 800;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="salesOrderPaper">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="salesOrderPaper" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '	<input type="hidden" name="ri_orderno" value="'+ orderNo +'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/base/salesOrderPaper.lime';
	window.open('', 'salesOrderPaper', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// 차량위치 팝업 띄우기.
function openTruckMapPop(obj, truck_no, deli_type, plantDesc, actualShipDt, driverPhone, driverName, add1, orderno, orderty, line_no){ // deli_type : H=한진,D=동원
	//alert('truck_no : '+truck_no+'\ndeli_type : '+deli_type);
	//alert('orderno : '+orderno+'\norderty : '+orderty+'\nline_no : '+line_no);
	
	var widthPx = 770;
	var heightPx = 810;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="deliveryTrackingPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="r_delitype" value="'+deli_type+'" />';
	
	htmlText += '	<input type="hidden" name="r_orderno" value="'+orderno+'" />';
	htmlText += '	<input type="hidden" name="r_orderty" value="'+orderty+'" />';
	htmlText += '	<input type="hidden" name="r_lineno" value="'+line_no+'" />';
	
// 	htmlText += '	<input type="hidden" name="r_truckno" value="'+truck_no+'" />';
// 	htmlText += '	<input type="hidden" name="r_plantdesc" value="'+plantDesc+'" />';
// 	htmlText += '	<input type="hidden" name="r_actualshipdt" value="'+actualShipDt+'" />';
// 	htmlText += '	<input type="hidden" name="r_driverphone" value="'+driverPhone+'" />';
// 	htmlText += '	<input type="hidden" name="r_drivername" value="'+driverName+'" />';
// 	htmlText += '	<input type="hidden" name="r_add1" value="'+add1+'" />';
	
	//htmlText += '	<input type="hidden" name="r_lat" value="37.536256" />';  //위도(y)
	//htmlText += '	<input type="hidden" name="r_lag" value="126.895436" />'; //경도(x)
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/common/pop/deliveryTrackingPop.lime';
	window.open('', 'deliveryTrackingPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

//거래처 선택 팝업 띄우기.
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
	dataSearch();
	
	setShipTo(toStr(jsonData.CUST_CD));
}

// 거래처 초기화.
function setDefaultCustomer(){
	$('input[name="v_custnm"]').val('');
	$('input[name="r_custcd"]').val('');
	
	$('select[name="r_shiptocd"]').empty();
	var textHtml = '<option value="">선택하세요</option>';
	$('select[name="r_shiptocd"]').append(textHtml);
}

// 납품처 불러오기.
function setShipTo(cust_cd){
	$.ajax({
		async : false,
		//url : '${url}/admin/base/getShiptoListAjax.lime'
		url : '${url}/admin/base/getShiptoListBySalesOrderAjax.lime',  
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { 
			r_custcd : cust_cd
			, r_ordersdt : $('input[name="r_ordersdt"]').val().replaceAll('-', '')
			, r_orderedt : $('input[name="r_orderedt"]').val().replaceAll('-', '')
			, r_requestsdt : $('input[name="r_requestsdt"]').val().replaceAll('-', '')
			, r_requestedt : $('input[name="r_requestedt"]').val().replaceAll('-', '')
			, r_actualshipsdt : $('input[name="r_actualshipsdt"]').val().replaceAll('-', '')
			, r_actualshipedt : $('input[name="r_actualshipedt"]').val().replaceAll('-', '')
			, where : 'all'
		},
		success : function(data){
			$('select[name="r_shiptocd"]').empty();
			
			var textHtml = '';
			textHtml += '<option value="">선택하세요</option>';
			$(data.list).each(function(i,e){
				//textHtml += '<option value="'+e.SHIPTO_CD+'">'+e.SHIPTO_NM+'</option>';
				textHtml += '<option value="'+e.SHIPTO_NM+'">'+e.SHIPTO_NM+'</option>';
			});
			
			$('select[name="r_shiptocd"]').append(textHtml);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});	
}

// 영업사원 팝업 띄우기.
function openUserListPop(user_type){ // user_type : sales,cs
	var pageType = '';
	var authority = '';
	if('sales' == user_type){
		pageType = 'orderlist_salesuser';
		authority = 'SH,SM,SR';
	}
	
	// 팝업 세팅.
	var widthPx = 800;
	var heightPx = 600;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="adminUserListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="'+pageType+'" />';
	htmlText += '	<input type="hidden" name="ri_authority" value="'+authority+'" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/adminUserListPop.lime';
	window.open('', 'adminUserListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// 고정 저장 > 고정등록 팝업에서 호출.
function setSalesUser(jsonData){
	$('input[name="rl_salesrepid"]').val(toStr(jsonData.SALES_USERID));
	$('input[name="rl_salesrepnm"]').val(toStr(jsonData.SALES_USER_NM));
	dataSearch();
}

function getSearchData(){
	if($('input[name="rl_salesrepnm"]').val() === '') {
		$('input[name="rl_salesrepid"]').val('');
	}
	
	var r_ordersdt = $('input[name="r_ordersdt"]').val();
	var r_orderedt = $('input[name="r_orderedt"]').val();
	var rl_orderno = $('input[name="rl_orderno"]').val();
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val();
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	var r_requestsdt = $('input[name="r_requestsdt"]').val();
	var r_requestedt = $('input[name="r_requestedt"]').val();
	var rl_custpo = $('input[name="rl_custpo"]').val();
	var rl_add1 = $('input[name="rl_add1"]').val();
	var rl_itemdesc = $('input[name="rl_itemdesc"]').val();
	//var rl_receiver = $('input[name="rl_receiver"]').val();
	var r_custcd = $('input[name="r_custcd"]').val();
	//var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();
	var rl_shiptonm = $('select[name="r_shiptocd"] option:selected').val();
	var rl_salesrepnm = $('input[name="rl_salesrepnm"]').val();
	var rl_salesrepid = $('input[name="rl_salesrepid"]').val();
	var rl_ordertp = $('input[name="rl_ordertp"]').val();
	
	var ri_status2 = '';
	//if($('input:checkbox[name="vi_status2"]').length != $('input:checkbox[name="vi_status2"]:checked').length){ // 상태값을 전체 개수와 선택된 개수가 동일하면 빈값으로 세팅.
		$('input:checkbox[name="vi_status2"]:checked').each(function(i,e) {
			if($(e).val() !== '') {
				if(i === 0) ri_status2 = $(e).val();
				else ri_status2 += ','+$(e).val();
			}
		});
	//}
	
	$('input[name="ri_status2"]').val(ri_status2); // Use For ExcelDownload.
	
	var sData = {
		r_ordersdt : r_ordersdt
		, r_orderedt : r_orderedt
		, rl_orderno : rl_orderno
		, r_actualshipsdt : r_actualshipsdt
		, r_actualshipedt : r_actualshipedt
		, r_requestsdt : r_requestsdt
		, r_requestedt : r_requestedt
		, rl_custpo : rl_custpo
		, rl_add1 : rl_add1
		, rl_itemdesc : rl_itemdesc
		//, rl_receiver : rl_receiver
		, r_custcd : r_custcd
		//, r_shiptocd : r_shiptocd
		, rl_shiptonm : rl_shiptonm
		, rl_salesrepnm : rl_salesrepnm
		, rl_salesrepid : rl_salesrepid
		, ri_status2 : ri_status2
		, rl_ordertp : rl_ordertp
	};
	//debugger;
	return sData;
}

// 조회
function dataSearch() {
	//$('#detailListDivId').hide();
	
	var searchData = getSearchData();
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

// 엑셀다운로드.
// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var colSortStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
	if('' == colSortStr) colSortStr = defaultColumnOrder;
	
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="r_colsortstr" value="'+colSortStr+'" />');
	
	formPostSubmit('frm', '${url}/admin/order/salesOrderExcelDown.lime');
	$('form[name="frm"]').attr('action', '');

	$('input[name="filetoken"]').remove();
	$('input[name="r_colsortstr"]').remove();
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
$(function(){
	getGridListPop();
	categorySelect('1');
});

function getGridListPop(){
	// grid init
	var searchData = getSearchDataPop();
	//$('#gridList_pop').jqGrid('GridUnload'); // 있어야 다시 호출하네...

	$("#gridList").jqGrid({
		url: "${url}/admin/base/getItemListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		multiselect: multi_select,
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
//품목분류
function getSearchDataPop(){
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	var rl_desc1 = $('input[name="rl_desc1"]').val();
	var rl_desc2 = $('input[name="rl_desc2"]').val();
	var rl_searchtext = $('input[name="rl_searchtext"]').val();
	var rl_itemcd = $('input[name="rl_itemcd"]').val();
	var rl_thicknm = $('input[name="rl_thicknm"]').val();
	var rl_widthnm = $('input[name="rl_widthnm"]').val();
	var rl_lengthnm = $('input[name="rl_lengthnm"]').val();
	// var r_checkitembookmark = $('input[name="r_checkitembookmark"]:checked').val(); //즐겨찾기
	var r_checkitembookmark = $('input[name="r_checkitembookmark"]').is(':checked') == true ? 'Y' : 'N' ; //즐겨찾기
	/*
	var ri_existimageynarr = '';
	$('input:checkbox[name="ri_existimageyn"]:checked').each(function(i,e) {
		if(i==0) ri_existimageynarr = $(e).val();
		else ri_existimageynarr += ','+$(e).val();
	});
	
	var ri_existrecommendarr = '';
	$('input:checkbox[name="ri_existrecommend"]:checked').each(function(i,e) {
		if(i==0) ri_existrecommendarr = $(e).val();
		else ri_existrecommendarr += ','+$(e).val();
	});
	*/

	var sData = {
		r_itemdeliverytype : toStr('${param.r_itemdeliverytype}') // Y=배송비 아이템만 출력, 빈값=배송비 아이템 제외하고 출력, ALL=모두출력.
		, r_salescd1nm : r_salescd1nm
		, r_salescd2nm : r_salescd2nm
		, r_salescd3nm : r_salescd3nm
		, r_salescd4nm : r_salescd4nm
		, rl_desc1 : rl_desc1
		, rl_desc2 : rl_desc2
		, rl_searchtext : rl_searchtext
		, rl_itemcd : rl_itemcd
		, rl_thicknm : rl_thicknm
		, rl_widthnm : rl_widthnm
		, rl_lengthnm : rl_lengthnm
		, r_checkitembookmark : r_checkitembookmark
		//, ri_existimageynarr : ri_existimageynarr
		//, ri_existrecommendarr : ri_existrecommendarr
	};
	return sData;
}
function getSearchDataPop(){
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	var rl_desc1 = $('input[name="rl_desc1"]').val();
	var rl_desc2 = $('input[name="rl_desc2"]').val();
	var rl_searchtext = $('input[name="rl_searchtext"]').val();
	var rl_itemcd = $('input[name="rl_itemcd"]').val();
	var rl_thicknm = $('input[name="rl_thicknm"]').val();
	var rl_widthnm = $('input[name="rl_widthnm"]').val();
	var rl_lengthnm = $('input[name="rl_lengthnm"]').val();
	// var r_checkitembookmark = $('input[name="r_checkitembookmark"]:checked').val(); //즐겨찾기
	var r_checkitembookmark = $('input[name="r_checkitembookmark"]').is(':checked') == true ? 'Y' : 'N' ; //즐겨찾기
	/*
	var ri_existimageynarr = '';
	$('input:checkbox[name="ri_existimageyn"]:checked').each(function(i,e) {
		if(i==0) ri_existimageynarr = $(e).val();
		else ri_existimageynarr += ','+$(e).val();
	});
	
	var ri_existrecommendarr = '';
	$('input:checkbox[name="ri_existrecommend"]:checked').each(function(i,e) {
		if(i==0) ri_existrecommendarr = $(e).val();
		else ri_existrecommendarr += ','+$(e).val();
	});
	*/

	var sData = {
		r_itemdeliverytype : toStr('${param.r_itemdeliverytype}') // Y=배송비 아이템만 출력, 빈값=배송비 아이템 제외하고 출력, ALL=모두출력.
		, r_salescd1nm : r_salescd1nm
		, r_salescd2nm : r_salescd2nm
		, r_salescd3nm : r_salescd3nm
		, r_salescd4nm : r_salescd4nm
		, rl_desc1 : rl_desc1
		, rl_desc2 : rl_desc2
		, rl_searchtext : rl_searchtext
		, rl_itemcd : rl_itemcd
		, rl_thicknm : rl_thicknm
		, rl_widthnm : rl_widthnm
		, rl_lengthnm : rl_lengthnm
		, r_checkitembookmark : r_checkitembookmark
		//, ri_existimageynarr : ri_existimageynarr
		//, ri_existrecommendarr : ri_existrecommendarr
	};
	return sData;
}
function dataSearchPop(){
	var searchData = getSearchDataPop();
	//console.log('searchData : ', searchData);
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger('reloadGrid',{page:1}); // 리로드후 현재 유지.
}

function categorySelect(ct_level) {
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	//var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	
	var params = 'r_ctlevel='+ct_level+'&';
	if('2' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&';
	if('3' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&';
	if('4' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&r_salescd3nm='+r_salescd3nm+'&';
	
	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : '${url}/admin/base/getCategoryListAjax.lime',
		success : function(data) {
			var htmlText = '<option value="">선택하세요.</option>';
			if('1' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				$('select[name="r_salescd2nm"]').empty();
				$('select[name="r_salescd2nm"]').append(htmlText);
				
				$('select[name="r_salescd1nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd1nm"]').append(htmlText);
			}
			if('2' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				
				$('select[name="r_salescd2nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd2nm"]').append(htmlText);
			}
			if('3' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				
				$('select[name="r_salescd3nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd3nm"]').append(htmlText);
			}
			if('4' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				
				$('select[name="r_salescd4nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd4nm"]').append(htmlText);
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
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
					전체주문현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="document.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
			<form name="frm" method="post">
			<input type="hidden" name="ri_status2" value="" />
			
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm">
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">주문일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_ordersdt" value="${ordersdt}" readonly="readonly" />
<%-- 													<input type="text" class="search-input form-sm-d p-r-md" name="r_ordersdt" value="${ordersdt}" readonly="readonly" /> --%>
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_orderedt" value="${orderedt}" readonly="readonly" />
<%-- 													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_orderedt" value="${orderedt}" readonly="readonly" /> --%>
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">출고일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">납품요청일</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_requestsdt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_requestedt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">오더번호</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_orderno" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">거래처</label>
												<div class="search-c">
													<%-- 거래처 input의 readonly를 풀고 like 검색을 할경우 납품처 선택이 문제생김. --%>
													<input type="text" class="search-input form-md-d" name="v_custnm" value="" readonly="readonly" onclick="openCustomerPop();" />
													<input type="hidden" class="" name="r_custcd" value="" />
													<a href="javascript:;" onclick="openCustomerPop();"><i class="fa fa-search i-search"></i></a>
													<button type="button" class="btn btn-line btn-xs pull-left" onclick="setDefaultCustomer();">초기화</button>
												</div>
											</li>
											<li>
												<label class="search-h">납품처</label>
												<div class="search-c">
													<select class="form-control" name="r_shiptocd" onchange="dataSearch();">
														<option value="">선택하세요</option>
													</select>
												</div>
											</li>
											<li>
												<label class="search-h">납품주소</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_add1" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">영업사원</label>
												<div class="search-c">
													<input type="text" hidden="true" name="rl_salesrepid">
													<input type="text" class="search-input" name="rl_salesrepnm" readonly="readonly" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													<a href="javascript:;" onclick="openUserListPop('sales');"><i class="fa fa-search i-search"></i></a>
												</div>
											</li>
											<li>
												<label class="search-h">주문번호</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_custpo" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li class="col1">
												<label class="search-h">품목명</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_itemdesc" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li class="col1">
												<!-- <label class="search-h">품목분류</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_itemdesc" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div> -->
												<label class="search-h">품목분류</label>												
												<select style="width: 20%;" class="form-control form-sm" name="r_salescd1nm" id="r_salescd1nm" onchange="categorySelect(2); dataSearchPop();">
													<option value="">선택하세요</option>
												</select>
												<select style="width: 19%;" class="form-control form-sm" name="r_salescd2nm" id="r_salescd2nm" onchange="categorySelect(3); dataSearchPop();">
													<option value="">선택하세요</option>
												</select>																							
												<select style="width: 19%;" class="form-control form-sm" name="r_salescd3nm" id="r_salescd3nm" onchange="dataSearchPop();">
													<option value="">선택하세요</option>
												</select>
											</li>
		<!-- 										<select class="form-control form-sm" name="r_salescd4nm" id="r_salescd4nm" onchange="dataSearchPop();"> 
													<option value="">선택하세요</option>
												</select> -->
											<li class='col1'>
												<label class="search-h">오더유형</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_ordertp" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>											
											<li class="col2">
												<label class="search-h">주문상태</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="allCheck" id="allCheck" onclick="checkAll3(this, 'vi_status2'); dataSearch();" />전체</label>
													<c:forEach items="${salesOrderStatusList}" var="list">
														<label><input type="checkbox" name="vi_status2" value="${list.key}" onclick="dataSearch();" />${list.value}</label>
													</c:forEach>
												</div>
											</li>
											
										</ul>
									</div>
								</div>
							</div>
							</form>
							
							<div class="panel-body">
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="btnList writeObjectClass">
									<button class="btn btn-info" onclick="orderPaperPop(this, '', '');" type="button" title="거래명세표">거래명세표</button>
								</div>
								<div class="table-responsive in">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
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