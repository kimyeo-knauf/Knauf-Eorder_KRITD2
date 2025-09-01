<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
	.qmsOrderLink{
		color:#1a75ff!important;
	}
	.qmsOrderLink:hover{
		color:#66a3ff!important;
	}
	label.radio > span{
		float: right;
		padding-top: 3px;
	}
	label.radio > span:hover{
		cursor: pointer;
	}
	
</style>
<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/qmsItemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"ORDERNO"  , label:'오더번호', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"QMS_STEP" , label:'입력구분', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"ACTUAL_SHIP_DT", label:'출고일자', width:120, align:'center', sortable:true, formatter:setDefault},
	{name:"ITEM_DESC", label:'품목명', width:220, align:'left', sortable:true, formatter:setDefault},
	{name:"LOTN", label:'Lot No', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"ORDER_QTY", label:'수량', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"QMS_ARR_QTY", label:'QMS 수량', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"QMS_ARR_TXT", label:'QMS오더번호', width:200, align:'left', sortable:true, formatter:setDefault, hidden:true},
	{name:"QMS_ARR", label:'QMS오더번호', width:200, align:'left', sortable:true, formatter:setQmsArrLink},
	{name:"CUST_NM", label:'거래처', width:150, align:'left', sortable:true, formatter:setDefault},
	{name:"SHIPTO_NM", label:'납품처', width:250, align:'left', sortable:true, formatter:setDefault},
	{name:"MAIL_YN" , label:'메일Y/N', width:100, align:'center', sortable:true, formatter:setPrimaryQty}, //
	{name:"FILE_YN" , label:'첨부Y/N', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"ACTIVEYN", label:'마감Y/N', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"PRE1"    , label:'사전입력여부', width:80, align:'center', sortable:true, formatter:setDefault, hidden:true},
	{name:"ADDR", label:'납품주소', width:250, align:'left', sortable:true, formatter:setDefault, hidden:false},
	{name:"QMS_ARR_SHIPTO", label:'현장명', width:200, align:'left', sortable:true, formatter:setQmsArrDefault},
	{name:"ACTUAL_SHIP_QUARTER", label:'분기', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"LINE_NO", label:'라인번호', width:80, align:'center', sortable:true, formatter:setDefault},
	{name:"CUST_PO", label:'확정오더번호', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"CUST_CD", label:'거래처 코드', width:150, align:'left', sortable:true, formatter:setDefault},
	{name:"ORDER_DT", label:'주문일자', width:120, align:'center', sortable:true, formatter:setDefault},//
	{name:"SHIPTO_CD", label:'납품처 코드', width:150, align:'left', sortable:true, formatter:setDefault},
	{name:"SALESREP_NM", label:'영업사원', width:100, align:'center', sortable:true, formatter:setDefault},
	{name:"ITEM_CD", label:'아이템', width:80, align:'center', sortable:true, formatter:setDefault, hidden:true},
	{name:"ORDERTY", label:'오더타입', width:80, align:'center', sortable:true, formatter:setDefault, hidden:true},
	{name:"UNIT", label:'단위', width:80, align:'center', sortable:true, formatter:setDefault, hidden:true},
	{name:"QMS_STATUS" , label:'QMS 회신', width:100, align:'center', sortable:true, formatter:setDefault,hidden:true},
	/* {name:"5", label:'PDF', width:60, align:'center', sortable:true, formatter:setDefault}, */
	{name:"STATUS2", hidden:true},
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

//쿠키값을 이용한 그리드 사이즈 자동조정 주석처리
/* if(updateComModel.length == globalColumnWidth.length){
	for( var j=0; j<updateComModel.length; j++ ) {
		updateComModel[j].width = toStr(updateColumnWidth[j]);
	}
} */
// End.

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
		//$('input[name="r_orderedt"]').datepicker('setStartDate', minDate);
		document.getElementById("r_qmsOrdYear").selectedIndex = 0;
    });

	$('input[name="r_orderedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		//$('input[name="r_ordersdt"]').datepicker('setEndDate', maxDate);
		document.getElementById("r_qmsOrdYear").selectedIndex = 0;
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
		//$('input[name="r_actualshipedt"]').datepicker('setStartDate', minDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });
	
	$('input[name="r_actualshipedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';		
		//$('input[name="r_actualshipsdt"]').datepicker('setEndDate', maxDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });

	getGridList();
});

function getGridList(){ 
	// grid init
	var searchData = null; //getSearchData();

	// 조회조건으로 납품처 조회
	setShipTo();
	
	//console.log(searchData);
	$("#gridList").jqGrid({
		url: "${url}/admin/order/getQmsOrderListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 15,
		rowList : ['15','30','50','100'],
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
			// console.log('globalColumnOrder : ', globalColumnOrder);
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


function setQmsStep(cellValue, options, rowObject) {
	var stepName = '';
	if(cellValue == 'C'){
		stepName = '사전';
	}else if(cellValue == 'Y'){
		stepName = '사전'; /* ERP 수량 대기 */
	}else{
		stepName = '사후';
	}
	return stepName;
}

// QMS 오더번호 배열
function setQmsArrLink(cellValue, options, rowObject) {
	var html = "";
	if(cellValue!=undefined){
		var qmsOrder = cellValue.split(',');
		for(var i = 0 ; i < qmsOrder.length; i++){
			html += "<a class=\"qmsOrderLink\" href=\"#\" onclick=\"javascript:qmsOrderPopOpen('"+qmsOrder[i]+"');\">"+qmsOrder[i]+"</a>";
			if(qmsOrder.length > i+1){
				html +="|";
			}
		}
	}
	
	
	return html;
}



//QMS 오더번호 배열
function setQmsArrDefault(cellValue, options, rowObject) {
	var html = "";
	if(cellValue!=undefined){
		var qmsOrder = cellValue.split(',');
		for(var i = 0 ; i < qmsOrder.length; i++){
			html += "<span>"+qmsOrder[i]+"</span>";
			if(qmsOrder.length > i+1){
				html +="|";
			}
		}
	}
	
	
	return html;
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
	$('select[name="r_shiptocd"] option:eq(0)').prop('selected',true);
	
	setShipTo(toStr(jsonData.CUST_CD));
	
	dataSearch();
}

// 거래처 초기화.
function setDefaultCustomer(){
	$('input[name="v_custnm"]').val('');
	$('input[name="r_custcd"]').val('');
	
	$('select[name="r_shiptocd"]').empty();
	var textHtml = '<option value="">선택하세요</option>';
	$('select[name="r_shiptocd"]').append(textHtml);
	setShipTo();
}

// 납품처 불러오기.
function setShipTo(cust_cd){
	var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();
	
	var searchData = getSearchData();
	$.ajax({
		async : false,
		url : '${url}/admin/order/getShiptoListAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		success : function(data){
			$('select[name="r_shiptocd"]').empty();
			
			var textHtml = '';
			var selected = '';
			textHtml += '<option value="">선택하세요</option>';
			$(data.list).each(function(i,e){

				if(r_shiptocd == e.SHIPTO_CD){
					selected = 'seleted';
				}
				
				textHtml += '<option value="'+e.SHIPTO_CD+'">'+e.SHIPTO_NM+'</option>';
			});
			
			$('select[name="r_shiptocd"]').append(textHtml);

			// 기존 납품처가 있다면 자동선택
			$('select[name="r_shiptocd"]').val(r_shiptocd).attr('selected', 'selected');
			
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
	$('input[name="rl_salesrepnm"]').val(toStr(jsonData.SALES_USER_NM));
	dataSearch();
}

function getSearchData(){
	var r_ordersdt = $('input[name="r_ordersdt"]').val();
	var r_orderedt = $('input[name="r_orderedt"]').val();
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val();
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	var rl_salesrepnm = $('input[name="rl_salesrepnm"]').val();
	var rl_orderno = $('input[name="rl_orderno"]').val();
	var qmsIdToDown = $('input[name="qmsIdToDown"]').val();	
	var r_custcd = $('input[name="r_custcd"]').val();
	var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();	

	var qms_status  = $('input[name="qms_status"]:checked').val();
	var qms_status2 = $('input[name="qms_status2"]:checked').val();
	var qms_status3 = $('input[name="qms_status3"]:checked').val();
	var qms_preyn   = $('input[name="qms_preyn"]:checked').val();

	var sData = {
		r_ordersdt : r_ordersdt
		, r_orderedt : r_orderedt
		, r_actualshipsdt : r_actualshipsdt
		, r_actualshipedt : r_actualshipedt
		, rl_salesrepnm : rl_salesrepnm
		, rl_orderno : rl_orderno
		, qmsIdToDown : qmsIdToDown
		, r_custcd : r_custcd
		, r_shiptocd : r_shiptocd
		, qms_status : qms_status
		, qms_status2: qms_status2
		, qms_status3: qms_status3
		, qms_preyn  : qms_preyn
	};
	return sData;
}

// 조회
function dataSearch() {
	$('#detailListDivId').hide();
	
	var searchData = getSearchData();

	// 조회조건으로 납품처 조회
	setShipTo();
	
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
	
	formPostSubmit('frm', '${url}/admin/order/qmsOrderExcelDown.lime');
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

/**
 * QMS 오더 입력 화면
 */
function qmsOrderPop(obj, orderno, custpo){
	
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	var resultCnt = 0;
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	
	var dupYn = false;
	var dupYn2 = false;
	var qmsCompleteYn = false;
	var qmsPreYn = false;
	
	for(var i = 0; i < selRows.length; i++) {
		var itemRow1 = $("#gridList").jqGrid('getRowData', selRows[i]);
		var rowNum   = $('#gridList').jqGrid('getInd',selRows[i]);
		var currElem = itemRow1['CUST_CD'];
		var currQuarter = itemRow1['ACTUAL_SHIP_QUARTER'];
		
		var qmsStatus = itemRow1['QMS_STATUS']
		if(qmsStatus == '완료'){
			alert(rowNum+'번 행은 이미 QMS 오더 수량이 모두 입력되었습니다.\n새로 생성하실 수 없습니다.');
			qmsCompleteYn = true;
		    break;
		}
		
		var qmsActive = itemRow1['ACTIVEYN']
		if(qmsActive == 'Y'){
			alert(rowNum+'번 행은 QMS 분기 마감이 완료되었습니다.\n새로 생성하실 수 없습니다.');
			qmsCompleteYn = true;
		    break;
		}

		var qmsPreYnCell = itemRow1['PRE1']
		if(qmsPreYnCell == 'Y'){
			alert(rowNum+'번 행은 QMS 사전입력된 행입니다.\n새로 생성하실 수 없습니다.');
			qmsPreYn = true;
		    break;
		}
		
		for(var j = i+1; j < selRows.length; j++) {
			var itemRow2 = $("#gridList").jqGrid('getRowData', selRows[j]);
		  if(currElem != itemRow2['CUST_CD']) {
			// console.log(currElem+' = '+itemRow2['CUST_CD'])
		    dupYn = true;
		    break;
		  }
		  if(currQuarter != itemRow2['ACTUAL_SHIP_QUARTER']){
			  // console.log(currQuarter+' = '+itemRow2['CUST_CD'])
			  dupYn2 = true;
			  break;
		  }
		}
	}

	if(qmsCompleteYn){
		return;
	}else if(dupYn){
		alert('QMS 오더 생성시 서로 다른 거래처는 선택할 수 없습니다.');
		return;
	}else if(dupYn2){
		alert('QMS 오더 생성시 서로 다른 분기는 선택할 수 없습니다.');
		return;
	}else if(qmsPreYn){
		//alert('QMS 오더 생성시 사전입력된 건은 선택할 수 없습니다.');
		return;
	}
	
	//선택한 행이 존재하는 경우
	$.ajax({
		async : false,
		data  : {'currQuarter' : currQuarter},
		type  : 'POST',
		url   : '${url}/admin/order/getQmsOrderId.lime',
		success : function(qmsId){
			$('#qmsId').val(qmsId);
			$('#qmsSeq').val('1');
			var itemFirstRow = $("#gridList").jqGrid('getRowData', selRows[0]);

			// QMS 신규생성
			$.ajax({
				async : false,
				data  : { 'qmsId':$('#qmsId').val(),'qmsSeq':$('#qmsSeq').val() ,'orderNo':itemFirstRow['ORDERNO'] ,'lineNo':itemFirstRow['LINE_NO'] ,'custCd':itemFirstRow['CUST_CD'] ,'shiptoCd':itemFirstRow['SHIPTO_CD'] },
				type  : 'POST',
				url   : '${url}/admin/order/setQmsOrderMast.lime',
				success : function(data){
					if ( data > 0 ){
						// QMS Detail 입력
						for (var index in selRows){
							var itemRow = $("#gridList").jqGrid('getRowData', selRows[index]);
							//console.log(itemRow);
							
							var newOrder = {
								 'qmsId'    :$('#qmsId').val()
								,'qmsSeq'   :$('#qmsSeq').val()
								,'orderNo'  :itemRow['ORDERNO']
								,'custPo'   :itemRow['CUST_PO']
								,'custCd'   :itemRow['CUST_CD']
								,'orderty'  :itemRow['ORDERTY']
								,'lineNo'   :itemRow['LINE_NO']
								,'itemCd'   :itemRow['ITEM_CD']
								,'lotNo'    :itemRow['LOTN'   ]
								,'orderQty' :itemRow['ORDER_QTY']
								,'shiptoCd' :itemRow['SHIPTO_CD']
								,'deleteyn' :'Y'
								,'qmsOrdQty':0
							}
							
							$.ajax({
								async : false,
								data  : newOrder ,
								type  : 'POST',
								url   : '${url}/admin/order/setQmsOrderDetl.lime',
								success : function(result){
									resultCnt++;
								},
								error : function(request,status,error){
									alert('error');
									//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
								}
							});
						}
						
						if(resultCnt > 0 ){
							// POST 팝업 열기.
							var widthPx = 1050;
							var heightPx = 800;
							var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
							var popup = window.open('qmsOrderPop.lime', 'qmsOrderPop', options);
							$frmPopSubmit = $('form[name="frmPopSubmit"]');
							//$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPop.lime');
							$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPop.lime?qmsId='+$('#qmsId').val()+'&qmsSeq='+$('#qmsSeq').val()+'&work=write');
							$frmPopSubmit.attr('method', 'post');
							$frmPopSubmit.attr('target', 'qmsOrderPop');
							$frmPopSubmit.submit();
							//popup.focus();
							if (popup ) { popup .focus(); }
						}
						
					}
				},
				error : function(request,status,error){
					alert('error');
					//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});

		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
	
}


/**
 * QMS 오더 입력 화면
 */
function qmsOrderAllAddPop(obj, orderno, custpo){		
	//조회조건 설정
	var searchData = getSearchData();
	//debugger;
	$(obj).prop('disabled', true);
	//중복여부 체크
	$.ajax({
		async : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		url   : '${url}/admin/order/getQmsOrderDupCheck.lime',
		success : function(dupYn){
			if(dupYn == 'Y'){
				alert('QMS 오더 일괄생성시 서로 다른 거래처 또는 출고일자의 분기가 다르거나 마감된 건이 포함된 경우 생성할 수 없습니다.');
				return;
			}

			//선택한 행이 존재하는 경우
			$.ajax({
				async : false,
				type : 'POST',
				dataType: 'json',
				data : searchData,
				url   : '${url}/admin/order/setQmsOrderAllAdd.lime',
				success : function(qmsId){

					if(qmsId == 'NONE'){
						alert('현재 조회조건으로 입력 가능한 QMS 수량이 없습니다.');
					}else{
						$('#qmsId').val(qmsId);
						$('#qmsSeq').val('1');
						
						// POST 팝업 열기.
						var widthPx = 1050;
						var heightPx = 800;
						var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
						var popup = window.open('qmsOrderPop.lime', 'qmsOrderPop', options);
						$frmPopSubmit = $('form[name="frmPopSubmit"]');
						//$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPop.lime');
						$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPop.lime?qmsId='+$('#qmsId').val()+'&qmsSeq='+$('#qmsSeq').val()+'&work=write');
						$frmPopSubmit.attr('method', 'post');
						$frmPopSubmit.attr('target', 'qmsOrderPop');
						$frmPopSubmit.submit();
						popup.focus();
					}

				},
				error : function(request,status,error){
					alert('error');
					$(obj).prop('disabled', false);
					//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
		},
		error : function(request,status,error){
			alert('error');
			$(obj).prop('disabled', false);
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});

	$(obj).prop('disabled', false);
}


/**
 * QMS 오더 뷰 화면
 */
function qmsOrderPopOpen(qmsId){
	// POST 팝업 열기.
	var widthPx = 1050;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	var popup = window.open('qmsOrderPopView.lime', 'qmsOrderPop', options);
	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	//$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPop.lime');
	$frmPopSubmit.attr('action', '${url}/admin/order/qmsOrderPopView.lime?qmsId='+qmsId+"&work=mod");
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'qmsOrderPop');
	$frmPopSubmit.submit();
	popup.focus();
}


function orderEmailPop(obj){
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var qmsIdTxt = '';
	var qmsNoArr = {};
	
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		if(rowData['QMS_ARR_TXT'] == undefined || rowData['QMS_ARR_TXT'] == '' ){
			alert(''+rowNum+'번째 행은 등록된 QMS 오더번호가 없습니다.');
			return;
		}else{
			qmsNoArr[rowData['QMS_ARR_TXT']] = i;
		}
	}
	
	var qmsIdArrKeys = Object.keys(qmsNoArr);
	for(var i = 0; i < qmsIdArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			qmsIdTxt += ','+qmsIdArrKeys[i]+',';
		}else if(i > 0){
			qmsIdTxt += ','+qmsIdArrKeys[i];
		}else{
			qmsIdTxt += qmsIdArrKeys[i];
		}
	}
	
	console.log(qmsIdTxt);
	
	// POST 팝업 열기.
	var param = 'qmsOrderPopEmail';
	var widthPx  = 755;
	var heightPx = 550;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopEmail">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="qmsOrderPopEmail" />';
	htmlText += '	<input type="hidden" name="qmsIdTxt" value="'+qmsIdTxt+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/order/qmsOrderPopEmail.lime';
	var popup = window.open('', 'qmsOrderPopEmail', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
	
}

function orderFilePop(obj){
	
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var qmsIdTxt = '';
	var qmsNoArr = {};
	 
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		if(rowData['QMS_ARR_TXT'] == undefined || rowData['QMS_ARR_TXT'] == '' ){
			
			alert(''+rowNum+'번째 행은 등록된 QMS 오더번호가 없습니다.');
			return;
		}else{
			qmsNoArr[rowData['QMS_ARR_TXT']] = i;
		}
	}
	
	var qmsIdArrKeys = Object.keys(qmsNoArr);
	for(var i = 0; i < qmsIdArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			qmsIdTxt += ','+qmsIdArrKeys[i]+',';
		}else if(i > 0){
			qmsIdTxt += ','+qmsIdArrKeys[i];
		}else{
			qmsIdTxt += qmsIdArrKeys[i];
		}
	}

	// console.log(qmsIdTxt);
	
	// POST 팝업 열기.
	var param = 'qmsOrderPopFile';
	var widthPx  = 1000;
	var heightPx = 550;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopFile">';
	htmlText += '	<input type="hidden" name="pop"             value="1" />';
	htmlText += '	<input type="hidden" name="page_type"       value="qmsOrderPopFile" />';
	htmlText += '	<input type="hidden" name="qmsIdTxt"        value="'+qmsIdTxt+'" />';

	// 그리드 공통 조회조건 추가
	var searchData = getSearchData();
	htmlText += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	htmlText += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	htmlText += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	htmlText += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	htmlText += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	htmlText += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	htmlText += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	htmlText += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	htmlText += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/order/qmsOrderPopFile.lime';
	var popup = window.open('', 'qmsOrderPopFile', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
	
}



function orderAllEmailPop(obj){
	// POST 팝업 열기.
	var param = 'qmsOrderPopEmail';
	var widthPx  = 755;
	var heightPx = 550;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopEmail">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderAllEmailPop" />';

	//조회조건 설정
	var searchData = getSearchData();
	/*var checkOrderFlag = false;
	//중복여부 체크
	$.ajax({
		async : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		url   : '${url}/admin/order/getOrderCustDupCheck.lime',
		success : function(dupYn){
			if(dupYn == 'Y'){
				checkOrderFlag=true;
			}
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});

	if(checkOrderFlag){
		alert('이메일 일괄발송은 거래처가 모두 동일해야 발송 가능합니다.');
		return;
	}*/
	
	// 그리드 공통 조회조건 추가
	htmlText += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	htmlText += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	htmlText += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	htmlText += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	htmlText += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	htmlText += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	htmlText += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	htmlText += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	htmlText += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/order/qmsOrderPopEmail.lime';
	var popup = window.open('', 'qmsOrderPopEmail', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
}


function orderAllFilePop(obj){
	// POST 팝업 열기.
	var param = 'qmsOrderPopFile';
	var widthPx  = 1000;
	var heightPx = 550;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopFile">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="qmsOrderPopAllFile" />';

	// 그리드 공통 조회조건 추가
	var searchData = getSearchData();
	htmlText += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	htmlText += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	htmlText += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	htmlText += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	htmlText += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	htmlText += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	htmlText += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	htmlText += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	htmlText += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/admin/order/qmsOrderPopFile.lime';
	var popup = window.open('', 'qmsOrderPopFile', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
	
}


function orderAllPrintPop(obj){
	// POST 팝업 열기.
	var param = 'qmsReport';
	var widthPx  = 970;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;

	//조회조건 설정
	var searchData = getSearchData();
	var checkOrderFlag = false;
	//중복여부 체크
	$.ajax({
		async : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		url   : '${url}/admin/order/getQmsOrderCnt.lime',
		success : function(orderCnt){
			if(orderCnt == 0){
				checkOrderFlag=true;
			}
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});

	if(checkOrderFlag){
		alert('일괄 출력 가능한 QMS 데이터가 없습니다.');
		return;
	}
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsReport">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="qmsAllReport" />';

	// 그리드 공통 조회조건 추가
	var searchData = getSearchData();
	htmlText += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	htmlText += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	htmlText += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	htmlText += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	htmlText += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	htmlText += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	htmlText += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	htmlText += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	htmlText += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	htmlText += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/front/report/qmsReport.lime';
	var popup = window.open('', 'qmsReport', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
	
}

function orderPrintPop(obj) {
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var qmsIdTxt = '';
	var qmsNoArr = {};
	 
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		if(rowData['QMS_ARR_TXT'] == undefined || rowData['QMS_ARR_TXT'] == '' ){
			alert(''+rowNum+'번째 행은 등록된 QMS 오더번호가 없습니다.');
			return;
		}else{
			qmsNoArr[rowData['QMS_ARR_TXT']] = i;
		}
	}

	
	var qmsIdArrKeys = Object.keys(qmsNoArr);
	for(var i = 0; i < qmsIdArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			qmsIdTxt += ','+qmsIdArrKeys[i]+',';
		}else if(i > 0){
			qmsIdTxt += ','+qmsIdArrKeys[i];
		}else{
			qmsIdTxt += qmsIdArrKeys[i];
		}
	}

	// console.log(qmsIdTxt);
	
	// POST 팝업 열기.
	var param = 'qmsReport';
	var widthPx  = 970;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsReport">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="qmsReport" />';
	htmlText += '	<input type="hidden" name="qmsId" value="'+qmsIdTxt+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/front/report/qmsReport.lime';
	var popup = window.open('', 'qmsReport', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
}



function qmsOrderRemove(obj){
	
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var qmsIdTxt = '';
	var qmsNoArr = {};
	
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		if(rowData['QMS_ARR_TXT'] == undefined || rowData['QMS_ARR_TXT'] == '' ){
			alert(''+rowNum+'번째 행은 등록된 QMS 오더번호가 없습니다.');
			return;
		}else{
			qmsNoArr[rowData['QMS_ARR_TXT']] = i;
		}
	}
	
	var qmsIdArrKeys = Object.keys(qmsNoArr);
	for(var i = 0; i < qmsIdArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			qmsIdTxt += ','+qmsIdArrKeys[i]+',';
		}else if(i > 0){
			qmsIdTxt += ','+qmsIdArrKeys[i];
		}else{
			qmsIdTxt += qmsIdArrKeys[i];
		}
	}

	// console.log(qmsIdTxt);
	
	var ques = confirm('선택하신 QMS 오더를 모두 삭제하시겠습니까?');
	if(ques){
		//선택한 행이 존재하는 경우
		$.ajax({
			async : false,
			type : 'POST',
			dataType: 'json',
			data : {'qmsIdTxt':qmsIdTxt},
			url   : '${url}/admin/order/setQmsOrderRemove.lime',
			success : function(result){
				alert(result+'건의 QMS 오더가 삭제되었습니다.');
				dataSearch();
			},
			error : function(request,status,error){
				alert('error');
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
}

function qmsOrderTestSync(obj){
	var ques = confirm('QMS 사전입력 자료를 강제로 생성해서 입력하게됩니다.');
	if(ques){
		//선택한 행이 존재하는 경우
		$.ajax({
			async : false,
			type : 'POST',
			dataType: 'json',
			url   : '${url}/admin/order/setQmsPreTestInsert.lime',
			success : function(result){
				alert('사전입력 QMS 오더가 생성되었습니다.');
				dataSearch();
			},
			error : function(request,status,error){
				alert('error');
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
}

function qmsPreOrderRemove(obj){
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var custPoTxt = '';
	var custPoArr = {};
	
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		if(rowData['PRE1'] == undefined || rowData['PRE1'] == 'N' ){
			alert(''+rowNum+'번째 행은 등록된 QMS 사전입력 건이 없습니다.');
			return;
		}else{
			custPoArr[rowData['CUST_PO']] = i;
		}
	}
	
	var custPoArrKeys = Object.keys(custPoArr);
	for(var i = 0; i < custPoArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			custPoTxt += ','+custPoArrKeys[i]+',';
		}else if(i > 0){
			custPoTxt += ','+custPoArrKeys[i];
		}else{
			custPoTxt += custPoArrKeys[i];
		}
	}

	// console.log(custPoTxt);
	
	var ques = confirm('선택하신 사전입력 QMS 오더를 모두 삭제하시겠습니까?');
	if(ques){
		//선택한 행이 존재하는 경우
		$.ajax({
			async : false,
			type : 'POST',
			dataType: 'json',
			data : {'custPoTxt':custPoTxt},
			url   : '${url}/admin/order/setQmsPreOrderRemove.lime',
			success : function(result){
				alert(result+'건의 사전입력 QMS 오더가 삭제되었습니다.');
				dataSearch();
			},
			error : function(request,status,error){
				alert('error');
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
}

function fileDown(obj){
	// 선택행을 조회
	var selRows = $('#gridList').getGridParam('selarrrow');
	//선택한 행이 없는 경우
	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	var qmsIdTxt = '';
	var qmsNoArr = {};
	 
	for(var i = 0; i < selRows.length; i++) {
		var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);		
		var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
		
		if(rowData['QMS_ARR_TXT'] == undefined || rowData['QMS_ARR_TXT'] == '' ){
			
			alert(''+rowNum+'번째 행은 등록된 QMS 오더번호가 없습니다.');
			return;
		}else{
			qmsNoArr[rowData['QMS_ARR_TXT']] = i;
		}
	}
	
	var qmsIdArrKeys = Object.keys(qmsNoArr);
	for(var i = 0; i < qmsIdArrKeys.length; i++) {
		if(i > 0 && (i+1) < selRows.length){
			qmsIdTxt += ','+qmsIdArrKeys[i]+',';
		}else if(i > 0){
			qmsIdTxt += ','+qmsIdArrKeys[i];
		}else{
			qmsIdTxt += qmsIdArrKeys[i];
		}
	}
	
	var fileFormHtml = '';
	var searchData = getSearchData();
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/order/qmsOrderFileAllDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	fileFormHtml += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	fileFormHtml += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	fileFormHtml += '	<input type="hidden" name="qmsIdToDown"        value="'+qmsIdTxt+'" />';
	fileFormHtml += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml);
}

function downloadFile(obj) {
	var fileFormHtml = '';
	var searchData = getSearchData();
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/order/qmsOrderFileAllDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_ordersdt"      value="'+searchData['r_ordersdt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_orderedt"      value="'+searchData['r_orderedt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_actualshipsdt" value="'+searchData['r_actualshipsdt']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_actualshipedt" value="'+searchData['r_actualshipedt']+'" />';
	fileFormHtml += '	<input type="hidden" name="rl_salesrepnm"   value="'+searchData['rl_salesrepnm']+'" />';
	fileFormHtml += '	<input type="hidden" name="rl_orderno"      value="'+searchData['rl_orderno']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_custcd"        value="'+searchData['r_custcd']+'" />';
	fileFormHtml += '	<input type="hidden" name="r_shiptocd"      value="'+searchData['r_shiptocd']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status"      value="'+searchData['qms_status']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status2"     value="'+searchData['qms_status2']+'" />';
	fileFormHtml += '	<input type="hidden" name="qms_status3"     value="'+searchData['qms_status3']+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); 
}

function getFormatDate(date){
  var year = date.getFullYear();
  var month = (1 + date.getMonth());
  month = month >= 10 ? month : '0' + month;
  var day = date.getDate();
  day = day >= 10 ? day : '0' + day;
  return year + '-' + month + '-' + day;
}

function chageQmsOrdYear(obj) {
	var date = obj.value;
	var year, startMonth, endMonth, startDate, endDate;
	if(date.length > 0) {
		year = date.split('-')[0];
		switch(date.split('-')[1]) {
			case "1Q":
				startMonth = 1;
				endMonth = 3;
				break;
			case "2Q":
				startMonth = 4;
				endMonth = 6;
				break;
			case "3Q":
				startMonth = 7;
				endMonth = 9;
				break;
			case "4Q":
				startMonth = 10;
				endMonth = 12;
				break;
		}
		startDate = new Date(year, startMonth - 1, 1);
		lastDate = new Date(year, endMonth, 0);
		$('input[name="r_ordersdt"]').off('changeDate');
		$('input[name="r_orderedt"]').off('changeDate');
		
		$('input[name="r_ordersdt"]').val(getFormatDate(startDate));
		$('input[name="r_ordersdt"]').datepicker('setDate', startDate);

		$('input[name="r_orderedt"]').val(getFormatDate(lastDate));
		$('input[name="r_orderedt"]').datepicker('setDate', lastDate);
		
		$('input[name="r_ordersdt"]').on('changeDate', function(selected) {
			//$('input[name="r_orderedt"]').datepicker('setStartDate', startDate);
			document.getElementById("r_qmsOrdYear").selectedIndex = 0;
	    });
		$('input[name="r_orderedt"]').on('changeDate', function(selected) {
			//$('input[name="r_ordersdt"]').datepicker('setEndDate', lastDate);
			document.getElementById("r_qmsOrdYear").selectedIndex = 0;
	    });
	}
}

function chageQmsOrdQuat(obj) {	
	var date = obj.value;	
	var year, startMonth, endMonth, startDate, endDate;
	if(date.length > 0) {
		year = date.split('-')[0];
		switch(date.split('-')[1]) {
			case "1Q":
				startMonth = 1;
				endMonth = 3;
				break;
			case "2Q":
				startMonth = 4;
				endMonth = 6;
				break;
			case "3Q":
				startMonth = 7;
				endMonth = 9;
				break;
			case "4Q":
				startMonth = 10;
				endMonth = 12;
				break;
		}
		
		startDate = new Date(year, startMonth - 1, 1);
		lastDate = new Date(year, endMonth, 0);

		$('input[name="r_actualshipsdt"]').off('changeDate');
		$('input[name="r_actualshipedt"]').off('changeDate');
		
		$('input[name="r_actualshipsdt"]').val(getFormatDate(startDate));
		$('input[name="r_actualshipsdt"]').datepicker('setDate', startDate);

		$('input[name="r_actualshipedt"]').val(getFormatDate(lastDate));
		$('input[name="r_actualshipedt"]').datepicker('setDate', lastDate);
		
		$('input[name="r_actualshipsdt"]').on('changeDate', function(selected) {
			//$('input[name="r_orderedt"]').datepicker('setStartDate', startDate);
			document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
	    });
		$('input[name="r_actualshipedt"]').on('changeDate', function(selected) {
			//$('input[name="r_ordersdt"]').datepicker('setEndDate', lastDate);
			document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
	    });
	    
	}
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
		<form name="frmPopSubmit" method="post">
			<input type="hidden" id="qmsId" name="qmsId" value=""></input>
			<input type="hidden" id="qmsSeq" name="qmsSeq" value="1"></input>
		</form>
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					QMS 조회 및 등록
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
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">출고일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="${ordersdt}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="${orderedt}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">주문일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_ordersdt" value="" readonly="readonly" />
<%-- 													<input type="text" class="search-input form-sm-d p-r-md" name="r_ordersdt" value="${ordersdt}" readonly="readonly" /> --%>
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_orderedt" value="" readonly="readonly" />
<%-- 													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_orderedt" value="${orderedt}" readonly="readonly" /> --%>
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											
											<li>
												<label class="search-h">영업사원</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_salesrepnm" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													<a href="javascript:;" onclick="openUserListPop('sales');"><i class="fa fa-search i-search"></i></a>
												</div>
											</li>
											
											<li>
												<label class="search-h">출고일자(분기)</label>
												<div class="search-c">
													<select class="form-control" name="r_qmsOrdQuat" id="r_qmsOrdQuat" onchange="chageQmsOrdQuat(this)">
														<option value="">선택안함</option>														
														<c:forEach var="ryl" items="${releaseYearList}" varStatus="status">
															<c:choose>
																<c:when test="${ryl.QMS_YEAR_NM eq preYear && ryl.QMS_DELN_QUAT_NM eq preQuat}">
																	<option value="${ryl.QMS_YEAR}-${ryl.QMS_DELN_QUAT}" selected>${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:when>
																<c:otherwise>
																	<option value="${ryl.QMS_YEAR}-${ryl.QMS_DELN_QUAT}">${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</select>
												</div>
											</li>
											
											<li>
												<label class="search-h">주문일자(분기)</label>
												<div class="search-c">
													<select class="form-control" name="r_qmsOrdYear" id="r_qmsOrdYear" onchange="chageQmsOrdYear(this)" style=>
														<option value="">선택안함</option>
														<c:forEach var="oyl" items="${orderYearList}" varStatus="status">
															<option value="${oyl.QMS_YEAR}-${oyl.QMS_DELN_QUAT}">${oyl.QMS_YEAR_NM} ${oyl.QMS_DELN_QUAT_NM}</option>
														</c:forEach>
													</select>
												</div>
											</li>
											
											<li>
												<label class="search-h">입력구분</label>
												<div class="search-c">
													<label class="radio"><input type="radio" name="qms_preyn" onchange="dataSearch();" value="ALL" checked/><span>전체&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_preyn" onchange="dataSearch();" value="Y" /><span>사전&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_preyn" onchange="dataSearch();" value="N" /><span>사후&nbsp;</span></label>
												</div>
											</li>
											
											<!--  
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
											-->
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
													<input type="text" class="search-input form-md-d" name="v_custnm" value="" onclick="openCustomerPop();" />
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
											<!--
											<li>
												<label class="search-h">납품주소</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_add1" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">영업사원</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_salesrepnm" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													<a href="javascript:;" onclick="openUserListPop('sales');"><i class="fa fa-search i-search"></i></a>
												</div>
											</li>
											<li>
												<label class="search-h">주문번호</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_custpo" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											-->
											<li>
												<%-- <label class="search-h">QMS 상태</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="allCheck" id="allCheck" onclick="checkAll3(this, 'vi_status2'); dataSearch();" />전체</label>
													<c:forEach items="${qmlStatusList}" var="list">
														<label><input type="checkbox" name="vi_status2" value="${list.key}" onclick="dataSearch();" />${list.value}</label>
													</c:forEach>
												</div> --%>
												<label class="search-h">QMS 생성</label>
												<div class="search-c">
												<label class="radio"><input type="radio" name="qms_status" onchange="dataSearch();" value="ALL" checked/><span>전체&nbsp;</span></label>
												<label class="radio"><input type="radio" name="qms_status" onchange="dataSearch();" value="Y" /><span>완료&nbsp;</span></label>
												<label class="radio"><input type="radio" name="qms_status" onchange="dataSearch();" value="N" /><span>미완료&nbsp;</span></label>
												</div>
											</li>
											
											<li>
												<label class="search-h">메일발송</label>
												<div class="search-c">
													<label class="radio"><input type="radio" name="qms_status2" onchange="dataSearch();" value="ALL" checked/><span>전체&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_status2" onchange="dataSearch();" value="Y" /><span>완료&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_status2" onchange="dataSearch();" value="N" /><span>미완료&nbsp;</span></label>
												</div>
											</li>
											
											<li>
												<label class="search-h">QMS 회신(첨부)</label>
												<div class="search-c">
													<label class="radio"><input type="radio" name="qms_status3" onchange="dataSearch();" value="ALL" checked/><span>전체&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_status3" onchange="dataSearch();" value="Y" /><span>완료&nbsp;</span></label>
													<label class="radio"><input type="radio" name="qms_status3" onchange="dataSearch();" value="N" /><span>미완료&nbsp;</span></label>
												</div>
											</li>
										</ul>
									</div>
							</div>
							</form>
							</div>
						</div>
						<div class="col-md-12">
							<div class="panel-body" style="padding-top:0px;padding-bottom:0px;">
									<button style="margin-bottom:3px" class="btn btn-info" onclick="qmsOrderPop(this);" type="button" title="QMS 입력">QMS 입력</button>
									<button style="margin-bottom:3px" class="btn btn-warning" onclick="qmsOrderAllAddPop(this);" type="button" title="QMS 일괄등록">QMS 일괄등록</button>
									<!-- <button class="btn btn-info" onclick="orderPaperPop(this, '', '');" type="button" title="QMS 입력">수정</button> -->
									<button style="margin-bottom:3px" class="btn btn-danger" onclick="qmsOrderRemove(this);" type="button" title="QMS 삭제">QMS 삭제</button>
									<button style="margin-bottom:3px" class="btn btn-info" onclick="orderPrintPop(this, '', '');" type="button" title="QMS 출력">QMS 출력</button>
									<button style="margin-bottom:3px" class="btn btn-warning" onclick="orderAllPrintPop(this, '', '');" type="button" title="QMS 일괄출력">QMS 일괄출력</button>
									<button style="margin-bottom:3px" class="btn btn-info" onclick="orderEmailPop(this);" type="button" title="메일발송">메일 발송</button>
									<button style="margin-bottom:3px" class="btn btn-warning" onclick="orderAllEmailPop(this);" type="button" title="메일일괄발송">메일 일괄발송</button>
									<button style="margin-bottom:3px" class="btn btn-info" onclick="orderFilePop(this, '', '');" type="button" title="파일업로드">파일 업로드</button>
									<button style="margin-bottom:3px" class="btn btn-warning" onclick="orderAllFilePop(this, '', '');" type="button" title="파일 일괄업로드">파일일괄업로드</button>									
									<button style="margin-bottom:3px" class="btn btn-info" onclick="fileDown(this);" type="button" title="파일다운로드">파일다운로드</button>
									<button style="margin-bottom:3px" class="btn btn-warning" onclick="downloadFile(this);" type="button" title="파일일괄다운로드">파일일괄다운로드</button>
									<button style="margin-bottom:3px" class="btn btn-info" onclick="qmsPreOrderRemove(this);" type="button" title="QMS 사전입력 삭제">QMS 사전입력 삭제</button>
									<!-- <button style="margin-bottom:3px" class="btn btn-danger" onclick="qmsOrderTestSync(this);" type="button" title="QMS 사전입력 생성">QMS 사전입력 생성</button> -->
							</div>
						</div>
						<div class="col-md-12">	
							<div class="panel panel-white">
								<div class="panel-body">
									<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
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