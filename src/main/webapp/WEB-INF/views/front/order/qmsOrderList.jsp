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

<%-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}&libraries=services"></script> --%>

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
var ckNameJqGrid = 'front/order/salesOrderList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');
 
var defaultColModel = [ //  ####### 설정 #######
	{name:"ORDERNO", label:'오더번호', width:80, align:'center', sortable:true, formatter:setDefault},
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
	{name:"ORDERNO", label:'오더번호', width:180, align:'center', sortable:true, formatter:setPopBtn},
	{name:"CUST_PO", label:'주문번호', width:180, align:'center', sortable:true, formatter:setDefault},
	{name:"STATUS_DESC", label:'오더상태', width:100, align:'center', sortable:false, formatter:setStatus2}, //
	//{name:"ITEM_CD", label:'폼목코드', width:180, align:'center', sortable:false, formatter:setDefault},
	{name:"", label:'기능', width:160, align:'center', sortable:false, formatter:setButton}, //
	{name:"STATUS2", hidden:true},
	{name:"GET_ORDERNO", hidden:true, formatter:getOrderNo},
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
	
	// 모달팝업 내용삭제
	$(document).on('hide.bs.modal', function (e) {   // bootstrap modal refresh
       $(e.target).find('.modal-content').empty();
    });
});

function getGridList(){ 
	// grid init
	var searchData = getSearchData();

	// 조회조건으로 납품처 조회
	setShipTo();
	
	console.log(searchData);
	$("#gridList").jqGrid({
		url: "${url}/front/order/getQmsOrderListAjax.lime",
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

//QMS 오더번호 배열
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
//헤베수량.
function setPrimaryQty(cellValue, options, rowObject) {
	return addComma(toStr(cellValue));
}
// 주문상태명.
function setStatus2(cellValue, options, rowObject) {
	return toStr(cellValue);
}
//납품요청일시.
function setRequestDt(cellValue, options, rowObject) {
	var requestDt = toStr(cellValue);
	if('' != requestDt) requestDt = requestDt.substring(0,4)+'-'+requestDt.substring(4,6)+'-'+requestDt.substring(6,8);
	
	var requestTime = toStr(rowObject.REQUEST_TIME);
	if('' != requestTime) requestDt += ' '+requestTime.substring(0,2)+':'+requestTime.substring(2,4);
	
	return requestDt;
}
// 납품주소.
function setAdd1(cellValue, options, rowObject) {
	var retStr = toStr(cellValue).replace(/(^\s*)|(\s*$)/g, '');
	var add2 = toStr(rowObject.ADD2).replace(/(^\s*)|(\s*$)/g, '');
	if('' != add2) retStr += ' '+add2;
	return retStr;
}
//출하일자.
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
		retStr += '<button type="button" class="btn btn-line" onclick=\'orderPaperPop(this, "'+orderno+'", "'+cust_po+'");\'>거래명세표</button>';
	}
	// 배송추적 버튼
	if('' != truckNo && ('H' == deliType || 'D' == deliType) && '출하완료' == status_desc){
		if('' != retStr) retStr += ' ';
		retStr += '<button type="button" class="btn btn-gray no-m" onclick=\'openTruckMapPop(this, "'+truckNo+'", "'+deliType+'", "'+plantDesc+'", "'+actualShipDt+'", "'+driverPhone+'", "'+driverName+'", "'+add1+'", "'+orderno+'", "'+orderty+'", "'+line_no+'");\'>배송추적</button>';
	}
	return retStr;
}

//팝업
function setPopBtn(cellValue, options, rowObject) {
	return '<a href=\'javascript:salesOrderViewPop("'+ toStr(cellValue) +'", "'+toStr(rowObject.ORDERTY)+'", "'+ rowObject.LINE_NO +'");\'>'+ toStr(cellValue) +'</a>';
}
function getOrderNo(cellValue, options, rowObject) {
	return toStr(rowObject.ORDERNO);
}

//거래명세표 팝업 띄우기.
function orderPaperPop(obj, orderno, custpo){
	if(orderno == ''){
		var rowIds = $('#gridList').jqGrid('getGridParam','selarrrow');
		var orderNo = '';
		for(var i=0; i<rowIds.length; i++){
			var status2 = $("#gridList").getRowData(rowIds[i]).STATUS2;
			if(530 <= status2){
				orderNo += $("#gridList").getRowData(rowIds[i]).GET_ORDERNO + ',';
			}
		}
		
		if (rowIds == ''){
			alert("선택 후 진행해 주세요.");
			return;
		}
		if (orderNo == ''){
			alert("거래명세표는 배차완료 이후 건만 출력 가능합니다.");
			return;
		}
	
	}else{
		orderNo = orderno;
	}

	if(!isApp()){
		var param = 'salesOrderPaper';
		var widthPx = 900;
		var heightPx = 750;
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
		
		var popUrl = '${url}/front/base/salesOrderPaper.lime';
		window.open('', 'salesOrderPaper', options);
		$('form[name="frm_pop"]').prop('action', popUrl);
		$('form[name="frm_pop"]').submit().remove();
	}
	else{
		// 모달팝업
		//$('#salesOrderPaperMId').modal('show');
		var link = '${url}/front/base/salesOrderPaper.lime?page_type=salesOrderPaper&r_multiselect=false&ri_orderno='+orderNo+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#salesOrderPaperMId').modal({
			remote: link
		});
	}
}

// 차량위치 팝업 띄우기.
function openTruckMapPop(obj, truck_no, deli_type, plantDesc, actualShipDt, driverPhone, driverName, add1, orderno, orderty, line_no){ // deli_type : H=한진,D=동원
	//alert('truck_no : '+truck_no+'\ndeli_type : '+deli_type);
	
	if(!isApp()){
		var widthPx = 770;
		var heightPx = 920;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frm_pop"]').remove();
		
		var htmlText = '';
		htmlText += '<form name="frm_pop" method="post" target="deliveryTrackingPop">';
		htmlText += '	<input type="hidden" name="pop" value="1" />';
		htmlText += '	<input type="hidden" name="r_delitype" value="'+deli_type+'" />';
		
		htmlText += '	<input type="hidden" name="r_orderno" value="'+orderno+'" />';
		htmlText += '	<input type="hidden" name="r_orderty" value="'+orderty+'" />';
		htmlText += '	<input type="hidden" name="r_lineno" value="'+line_no+'" />';
		
// 		htmlText += '	<input type="hidden" name="r_truckno" value="'+truck_no+'" />';
// 		htmlText += '	<input type="hidden" name="r_plantdesc" value="'+plantDesc+'" />';
// 		htmlText += '	<input type="hidden" name="r_actualshipdt" value="'+actualShipDt+'" />';
// 		htmlText += '	<input type="hidden" name="r_driverphone" value="'+driverPhone+'" />';
// 		htmlText += '	<input type="hidden" name="r_drivername" value="'+driverName+'" />';
// 		htmlText += '	<input type="hidden" name="r_add1" value="'+add1+'" />';
		
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
	else{
		// 모달팝업
		//$('#deliveryTrackingPopMId').modal('show');
		var link = '${url}/common/pop/deliveryTrackingPop.lime?'; //layer_pop=Y&
		link += 'r_delitype='+deli_type;
		
		link += '&r_orderno='+orderno;
		link += '&r_orderty='+orderty;
		link += '&r_lineno='+line_no;
		
// 		link += '&r_truckno='+truck_no;
// 		link += '&r_plantdesc='+plantDesc;
// 		link += '&r_actualshipdt='+actualShipDt;
// 		link += '&r_driverphone='+driverPhone;
// 		link += '&r_drivername='+driverName;
// 		link += '&r_add1='+add1;
		
		link += '&layer_pop=Y';
		
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#deliveryTrackingPopMId').modal({
			remote: link
		});
	 }
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
	var popUrl = '${url}/front/base/pop/customerListPop.lime';
	window.open('', 'customerListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// return 거래처 팝업에서 개별 선택.
function setCustomerFromPop(jsonData){
	$('input[name="r_custcd"]').val(toStr(jsonData.CUST_CD));
	$('input[name="v_custnm"]').val(toStr(jsonData.CUST_NM));
	$('select[name="r_shiptocd"] option:eq(0)').prop('selected',true);
	
	dataSearch();
	
	setShipTo(toStr(jsonData.CUST_CD));
}

//거래처 초기화.
function setDefaultCustomer(){
	$('input[name="v_custnm"]').val('');
	$('input[name="r_custcd"]').val('');
	
	$('select[name="r_shiptocd"]').empty();
	var textHtml = '<option value="">선택하세요</option>';
	$('select[name="r_shiptocd"]').append(textHtml);
	setShipTo();
}

//납품처 불러오기.
function setShipTo(cust_cd){
	var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();
	
	var searchData = getSearchData();
	$.ajax({
		async : false,
		url : '${url}/front/order/getShiptoListAjax.lime',
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
	//debugger;
	var r_ordersdt = $('input[name="r_ordersdt"]').val();
	var r_orderedt = $('input[name="r_orderedt"]').val();
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val();
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	var rl_salesrepnm = $('input[name="rl_salesrepnm"]').val()!=undefined?$('input[name="rl_salesrepnm"]').val():"";
	var rl_orderno = $('input[name="rl_orderno"]').val();
	var r_custcd = $('input[name="r_custcd"]').val()!=undefined?$('input[name="r_custcd"]').val():"";
	var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val()!=undefined?$('select[name="r_shiptocd"] option:selected').val():"";

	var qms_status  = $('input[name="qms_status"]:checked').val();
	var qms_status2 = $('input[name="qms_status2"]:checked').val();
	var qms_status3 = $('input[name="qms_status3"]:checked').val();
	var qms_preyn = $('input[name="qms_preyn"]:checked').val();

	var sData = {
		r_ordersdt : r_ordersdt
		, r_orderedt : r_orderedt
		, r_actualshipsdt : r_actualshipsdt
		, r_actualshipedt : r_actualshipedt
		, rl_salesrepnm : rl_salesrepnm
		, rl_orderno : rl_orderno
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
	var searchData = getSearchData();

	// 조회조건으로 납품처 조회
	setShipTo();
	
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

//엑셀다운로드.
//jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	
	var colSortStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
	if('' == colSortStr) colSortStr = defaultColumnOrder;
	
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="r_colsortstr" value="'+colSortStr+'" />');
	
	formPostSubmit('frm', '${url}/front/order/salesOrderExcelDown.lime');
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

// 상세조회 펼침
function fn_spread(id){ 
	var getID = document.getElementById(id); 
	getID.style.display=(getID.style.display=='block') ? 'none' : 'block'; 
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
		
		for(var j = i+1; j < selRows.length; j++) {
			var itemRow2 = $("#gridList").jqGrid('getRowData', selRows[j]);
		  if(currElem != itemRow2['CUST_CD']) {
			console.log(currElem+' = '+itemRow2['CUST_CD'])
		    dupYn = true;
		    break;
		  }
		  if(currQuarter != itemRow2['ACTUAL_SHIP_QUARTER']){
			  console.log(currQuarter+' = '+itemRow2['CUST_CD'])
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
	}
	//선택한 행이 존재하는 경우
	$.ajax({
		async : false,
		data  : {'currQuarter' : currQuarter},
		type  : 'POST',
		url   : '${url}/front/order/getQmsOrderId.lime',
		success : function(qmsId){
			$('#qmsId').val(qmsId);
			$('#qmsSeq').val('1');
			var itemFirstRow = $("#gridList").jqGrid('getRowData', selRows[0]);
			//debugger;
			// QMS 신규생성
			$.ajax({
				async : false,
				data  : { 'qmsId':$('#qmsId').val(),'qmsSeq':$('#qmsSeq').val() ,'orderNo':itemFirstRow['ORDERNO'] ,'lineNo':itemFirstRow['LINE_NO'] ,'custCd':itemFirstRow['CUST_CD'] ,'shiptoCd':itemFirstRow['SHIPTO_CD'] },
				type  : 'POST',
				url   : '${url}/front/order/setQmsOrderMast.lime',
				success : function(data){
					if ( data > 0 ){
						// QMS Detail 입력
						for (var index in selRows){
							var itemRow = $("#gridList").jqGrid('getRowData', selRows[index]);
							console.log(itemRow);
							
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
								url   : '${url}/front/order/setQmsOrderDetl.lime',
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
							var widthPx = 1000;
							var heightPx = 800;
							var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
							var popup = window.open('qmsOrderPop.lime', 'qmsOrderPop', options);
							$frmPopSubmit = $('form[name="frmPopSubmit"]');
							//$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPop.lime');
							$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPop.lime?qmsId='+$('#qmsId').val()+'&qmsSeq='+$('#qmsSeq').val()+'&work=write');
							$frmPopSubmit.attr('method', 'post');
							$frmPopSubmit.attr('target', 'qmsOrderPop');
							$frmPopSubmit.submit();
							popup.focus();
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
	//중복여부 체크
	$.ajax({
		async : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		url   : '${url}/front/order/getQmsOrderDupCheck.lime',
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
				url   : '${url}/front/order/setQmsOrderAllAdd.lime',
				success : function(qmsId){

					if(qmsId == 'NONE'){
						alert('현재 조회조건으로 입력 가능한 QMS 수량이 없습니다.');
					}else{
						$('#qmsId').val(qmsId);
						$('#qmsSeq').val('1');
						
						// POST 팝업 열기.
						var widthPx = 1000;
						var heightPx = 800;
						var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
						var popup = window.open('qmsOrderPop.lime', 'qmsOrderPop', options);
						$frmPopSubmit = $('form[name="frmPopSubmit"]');
						//$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPop.lime');
						$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPop.lime?qmsId='+$('#qmsId').val()+'&qmsSeq='+$('#qmsSeq').val()+'&work=write');
						$frmPopSubmit.attr('method', 'post');
						$frmPopSubmit.attr('target', 'qmsOrderPop');
						$frmPopSubmit.submit();
						popup.focus();
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
 * QMS 오더 뷰 화면
 */
function qmsOrderPopOpen(qmsId){
	// POST 팝업 열기.
	var widthPx = 1000;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	var popup = window.open('qmsOrderPopView.lime', 'qmsOrderPop', options);
	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	//$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPop.lime');
	$frmPopSubmit.attr('action', '${url}/front/order/qmsOrderPopView.lime?qmsId='+qmsId+"&work=mod");
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
	var heightPx = 500;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopEmail">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="qmsOrderPopEmail" />';
	htmlText += '	<input type="hidden" name="qmsIdTxt" value="'+qmsIdTxt+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	var popUrl = '${url}/front/order/qmsOrderPopEmail.lime';
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

	console.log(qmsIdTxt);
	
	// POST 팝업 열기.
	var param = 'qmsOrderPopFile';
	var widthPx  = 900;
	var heightPx = 500;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopFile">';
	htmlText += '	<input type="hidden" name="pop"             value="1" />';
	htmlText += '	<input type="hidden" name="page_type"       value="qmsOrderPopFile" />';
	htmlText += '	<input type="hidden" name="qmsIdTxt"        value="'+qmsIdTxt+'" />';
	//debugger;
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
	
	var popUrl = '${url}/front/order/qmsOrderPopFile.lime';
	var popup = window.open('', 'qmsOrderPopFile', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
	
}



function orderAllEmailPop(obj){
	// POST 팝업 열기.
	var param = 'qmsOrderPopEmail';
	var widthPx  = 755;
	var heightPx = 500;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="qmsOrderPopEmail">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderAllEmailPop" />';

	//조회조건 설정
	var searchData = getSearchData();
	var checkOrderFlag = false;
	//중복여부 체크
	$.ajax({
		async : false,
		type : 'POST',
		dataType: 'json',
		data : searchData,
		url   : '${url}/front/order/getOrderCustDupCheck.lime',
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
		alert('이메일 일괄발송은 거래처를 선택해야 발송 가능합니다.');
		return;
	}
	
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
	
	var popUrl = '${url}/front/order/qmsOrderPopEmail.lime';
	var popup = window.open('', 'qmsOrderPopEmail', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
	popup.focus();
}


function orderAllFilePop(obj){
	// POST 팝업 열기.
	var param = 'qmsOrderPopFile';
	var widthPx  = 900;
	var heightPx = 500;
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
	
	var popUrl = '${url}/front/order/qmsOrderPopFile.lime';
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
		url   : '${url}/front/order/getQmsOrderCnt.lime',
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

	console.log(qmsIdTxt);
	
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

	console.log(qmsIdTxt);
	
	var ques = confirm('선택하신 QMS 오더를 모두 삭제하시겠습니까?');
	if(ques){
		//선택한 행이 존재하는 경우
		$.ajax({
			async : false,
			type : 'POST',
			dataType: 'json',
			data : {'qmsIdTxt':qmsIdTxt},
			url   : '${url}/front/order/setQmsOrderRemove.lime',
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

	console.log(custPoTxt);
	
	var ques = confirm('선택하신 사전입력 QMS 오더를 모두 삭제하시겠습니까?');
	if(ques){
		//선택한 행이 존재하는 경우
		$.ajax({
			async : false,
			type : 'POST',
			dataType: 'json',
			data : {'custPoTxt':custPoTxt},
			url   : '${url}/front/order/setQmsPreOrderRemove.lime',
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

function downloadFile(obj) {
	var fileFormHtml = '';
	var searchData = getSearchData();
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/front/order/qmsOrderFileAllDown.lime">';
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

<body>
<div id="subWrap" class="subWrap">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<%-- 임의 form --%>
	<form name="uForm" method="post"></form>
	<form name="frmPopSubmit" method="post">
		<input type="hidden" id="qmsId" name="qmsId" value=""></input>
		<input type="hidden" id="qmsSeq" name="qmsSeq" value="1"></input>
	</form>
	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>
	
	<div class="container-fluid">
		<div class="full-content">
		
			<div class="row no-m">
				<div class="page-breadcrumb"><strong>QMS 조회 및 등록</strong></div>
				
				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/order/salesOrderList.lime">전체주문현황</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/order/salesOrderList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/salesOrderList.lime')}">selected="selected"</c:if> >QMS 조회 및 등록</option>
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
		<input type="hidden" name="ri_status2" value="" />
	
		<!-- Content -->
		<div class="content">
		
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
				
					<div class="searchArea">
						<div class="col-md-6">
							<em>출고일자</em>
							<input type="text" class="form-control calendar" name="r_actualshipsdt" value="${ordersdt}" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_actualshipedt" value="${orderedt}" readonly="readonly" />
						</div>
						<div class="col-md-4 right">
							<em>납품주소</em>
							<input type="text" class="form-control" name="rl_add1" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						</div>
						<div class="col-md-1 empty searchBtn">
							<button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button>
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						
						<div id="hiddenContent02" style="display: none; height:auto; margin-bottom:0;"> <!-- 상세조회 더보기  -->
							<div class="col-md-6">
								<em>출고일자(분기)</em>
								<select class="form-control" name="r_qmsOrdQuat" id="r_qmsOrdQuat" onchange="chageQmsOrdQuat(this)">
									<option value="">선택안함</option>
									<c:forEach var="ryl" items="${releaseYearList}" varStatus="status">
										<option value="${ryl.QMS_YEAR}-${ryl.QMS_DELN_QUAT}">${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
									</c:forEach>
								</select>
							</div>
							<div class="col-md-6 right">
								<em>납품요청일</em>
								<input type="text" class="form-control calendar" name="r_requestsdt" value="" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_requestedt" value="" readonly="readonly" />
							</div>
							<div class="col-md-6">
								<em>주문일자</em>
								<input type="text" class="form-control calendar" name="r_ordersdt" value="" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_orderedt" value="" readonly="readonly" />
							</div>
							<div class="col-md-6">
								<em>품목명</em>
								<input type="text" class="form-control" name="rl_itemdesc" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							<div class="col-md-6 right">
								<em>주문일자(분기)</em>
								<select class="form-control" name="r_qmsOrdYear" id="r_qmsOrdYear" onchange="chageQmsOrdYear(this)" style=>
									<option value="">선택안함</option>
									<c:forEach var="oyl" items="${orderYearList}" varStatus="status">
										<option value="${oyl.QMS_YEAR}-${oyl.QMS_DELN_QUAT}">${oyl.QMS_YEAR_NM} ${oyl.QMS_DELN_QUAT_NM}</option>
									</c:forEach>
								</select>
							</div>
							<div class="col-md-6 right">
								<em>오더번호</em>
							<input type="text" class="form-control" name="rl_orderno" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							
							<c:if test="${'CO' eq sessionScope.loginDto.authority}">
								<div class="col-md-6">
									<em>납품처</em>
									<input type="text" class="form-control search" name="v_shiptonm" placeholder="납품처명" value="" readonly="readonly" onclick="openShiptoPop(this);" />
									<input type="hidden" name="r_shiptocd" value="" />
									<%-- <button type="button" class="btn-search" onclick="openShiptoPop(this);"><img src="${url}/include/images/front/common/icon_search@2x.png" alt="img" /></button> --%>
									<button type="button" class="btn btn-reset" onclick="setDefaultShipTo();">초기화</button>
								</div>
								<div class="col-md-6 right">
									<em>주문번호</em>
									<input type="text" class="form-control" name="rl_custpo" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
								</div>
							</c:if>
							<c:if test="${'CO' ne sessionScope.loginDto.authority}">
								<div class="col-md-6">
									<em>주문번호</em>
									<input type="text" class="form-control" name="rl_custpo" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
								</div>
							</c:if>
							
							<div class="col-md-6">
								<em>QMS 생성</em>
								<div class="table-radio" style="float:left;">
									<label class="lol-label-radio" for="qms_status_1">
										<input type="radio" id="qms_status_1" name="qms_status" value="ALL" checked="checked" onchange="dataSearch();" autocomplete="off">
										<span class="lol-text-radio">전체 </span>
									</label>
									<label class="lol-label-radio" for="qms_status_2">
										<input type="radio" id="qms_status_2" name="qms_status" value="Y" onchange="dataSearch();" />
										<span class="lol-text-radio">완료 </span>
									</label>
									<label class="lol-label-radio" for="qms_status_3">
										<input type="radio" id="qms_status_3" name="qms_status" value="N" onchange="dataSearch();" />
										<span class="lol-text-radio">미완료 </span>
									</label>
								</div>
							</div>
							
							<div class="col-md-6">
								<em>메일발송</em>
								<div class="table-radio" style="float:left;">
									<label class="lol-label-radio" for="qms_status2_1">
										<input type="radio" id="qms_status2_1" name="qms_status2" value="ALL" checked="checked" onchange="dataSearch();" autocomplete="off">
										<span class="lol-text-radio">전체 </span>
									</label>
									<label class="lol-label-radio" for="qms_status2_2">
										<input type="radio" id="qms_status2_2" name="qms_status2" value="Y" onchange="dataSearch();" />
										<span class="lol-text-radio">완료 </span>
									</label>
									<label class="lol-label-radio" for="qms_status2_3">
										<input type="radio" id="qms_status2_3" name="qms_status2" value="N" onchange="dataSearch();" />
										<span class="lol-text-radio">미완료 </span>
									</label>
								</div>
							</div>
							
							<div class="col-md-6">
								<em>QMS 회신(첨부)</em>
								<div class="table-radio" style="float:left;">
									<label class="lol-label-radio" for="qms_status3_1">
										<input type="radio" id="qms_status3_1" name="qms_status3" value="ALL" checked="checked" onchange="dataSearch();" autocomplete="off">
										<span class="lol-text-radio">전체 </span>
									</label>
									<label class="lol-label-radio" for="qms_status3_2">
										<input type="radio" id="qms_status3_2" name="qms_status3" value="Y" onchange="dataSearch();" />
										<span class="lol-text-radio">완료 </span>
									</label>
									<label class="lol-label-radio" for="qms_status3_3">
										<input type="radio" id="qms_status3_3" name="qms_status3" value="N" onchange="dataSearch();" />
										<span class="lol-text-radio">미완료 </span>
									</label>
								</div>
							</div>
							
							<div class="col-md-6">
								<em>입력구분</em>
								<div class="table-radio" style="float:left;">
									<label class="lol-label-radio" for="qms_preyn_1">
										<input type="radio" id="qms_preyn_1" name="qms_preyn" value="ALL" checked="checked" onchange="dataSearch();" autocomplete="off">
										<span class="lol-text-radio">전체 </span>
									</label>
									<label class="lol-label-radio" for="qms_preyn_2">
										<input type="radio" id="qms_preyn_2" name="qms_preyn" value="Y" onchange="dataSearch();" />
										<span class="lol-text-radio">사전 </span>
									</label>
									<label class="lol-label-radio" for="qms_preyn_3">
										<input type="radio" id="qms_preyn_3" name="qms_preyn" value="N" onchange="dataSearch();" />
										<span class="lol-text-radio">사후 </span>
									</label>
								</div>
							</div>
						</div>
						
					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button>
						<button type="button" onclick="dataSearch();">Search</button>
					</div>
					<div class="boardListArea" style="padding-top:0px!important;">
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
						<button style="margin-bottom:3px" class="btn btn-info" onclick="qmsPreOrderRemove(this, '', '');" type="button" title="QMS 사전입력 삭제">QMS 사전입력 삭제</button>						
					</div>
					<div class="boardListArea" style="margin-top:0px!important;">
						<h2>
							Total <strong><span id="listTotalCountSpanId"></span></strong>EA
							<div class="title-right little">
								<button type="button" class="btn-excel" id="excelDownBtnId" onclick="excelDown(this);"><img src="${url}/include/images/front/common/icon_excel@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardList salesList">
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
	<div class="modal fade" id="salesOrderPaperMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content paper">
				
			</div>
		</div>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="deliveryTrackingPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content">
				
			</div>
		</div>
	</div>
	
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
	<div class="modal fade" id="salesOrderViewPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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