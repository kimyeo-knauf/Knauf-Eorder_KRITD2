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

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}&libraries=services"></script>

<script type="text/javascript">

(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});

//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'front/order/salesOrderList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');
 
var defaultColModel = [ //  ####### 설정 #######
	{name:"ORDERNO", label:'오더번호', width:90, align:'center', sortable:true, formatter:setDefault},
	{name:"CUST_PO", label:'주문번호', width:90, align:'center', sortable:true, formatter:setDefault},
	{name:"ORDERTY", label:'오더코드', width:90, align:'center', sortable:false, formatter:setDefault},
	{name:"ITEM_CD", label:'폼목코드', width:90, align:'center', sortable:false, formatter:setDefault},
	{name:"ITEM_DESC", label:'품목명', width:195, align:'left', sortable:true, formatter:setDefault},
	{name:"ORDER_QTY", label:'수량', width:50, align:'right', sortable:false, formatter:setOrderQty},
	{name:"UNIT", label:'단위', width:50, align:'center', sortable:false, formatter:setDefault},
	{name:"STATUS_DESC", label:'오더상태', width:100, align:'center', sortable:false, formatter:setStatus2}, //
	{name:"SHIPTO_NM", label:'납품처명', width:200, align:'left', sortable:false, formatter:setDefault},
	{name:"ADD1", label:'납품주소', width:100, align:'left', sortable:false, formatter:setAdd1},
	{name:"PLANT_DESC", label:'출하지', width:100, align:'left', sortable:false, formatter:setDefault},
	{name:"PRIMARY_QTY", label:'헤베수량', width:80, align:'right', sortable:false, formatter:setPrimaryQty}, //
	{name:"DRIVER_PHONE", label:'기사TEL', width:100, align:'center', sortable:false, formatter:setDefault},
	{name:"REQUEST_DT", label:'납품요청일', width:100, align:'center', sortable:false, formatter:setRequestDt}, //
	{name:"ACTUAL_SHIP_DT", label:'출하일자', width:90, align:'center', sortable:false, formatter:setActualShipDt}, // 출하일자.
	{name:"ADD3", label:'전화번호', width:100, align:'center', sortable:false, formatter:setDefault}, //
	{name:"HOLD_CODE", label:'보류코드', width:100, align:'center', sortable:false, formatter:setDefault},
	{name:"SALESREP_NM", label:'접수자', width:100, align:'center', sortable:false, formatter:setDefault},
	{name:"", label:'기능', width:160, align:'center', sortable:false, formatter:setButton}, //
// 	{name:"STATUS1", hidden:true},
	{name:"STATUS2", hidden:true},
	{name:"ADD2", hidden:true},
	{name:"LINE_NO", hidden:true},
	{name:"GET_ORDERNO", hidden:true, formatter:getOrderNo},
// 	{name:"SHIPTO_CD", hidden:true}, // 납품처코드.
// 	{name:"REQUEST_TIME", hidden:true},
// 	{name:"TRUCK_NO", hidden:true}, // 차량번호.
// 	{name:"DUMMY", hidden:true}, // H=한진,D=동원
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
		multiselect: true,
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
// 주문상태명.
function setStatus2(cellValue, options, rowObject) {
	return toStr(cellValue);
}
// 납품주소.
function setAdd1(cellValue, options, rowObject) {
	var retStr = toStr(cellValue).replace(/(^\s*)|(\s*$)/g, '');
	var add2 = toStr(rowObject.ADD2).replace(/(^\s*)|(\s*$)/g, '');
	if('' != add2) retStr += ' '+add2;
	return retStr;
}
//헤베수량.
function setPrimaryQty(cellValue, options, rowObject) {
	return addComma(toStr(cellValue));
}
// 납품요청일시.
function setRequestDt(cellValue, options, rowObject) {
	var requestDt = toStr(cellValue);
	if('' != requestDt) requestDt = requestDt.substring(0,4)+'-'+requestDt.substring(4,6)+'-'+requestDt.substring(6,8);
	
	var requestTime = toStr(rowObject.REQUEST_TIME);
	if('' != requestTime) requestDt += ' '+requestTime.substring(0,2)+':'+requestTime.substring(2,4);
	
	return requestDt;
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
	var rl_receiver = $('input[name="rl_receiver"]').val();
	var r_shiptocd = $('input[name="r_shiptocd"]').val();
	
	var ri_status2 = '';
	if($('input:checkbox[name="vi_status2"]').length != $('input:checkbox[name="vi_status2"]:checked').length){ // 상태값을 전체 개수와 선택된 개수가 동일하면 빈값으로 세팅.
		$('input:checkbox[name="vi_status2"]:checked').each(function(i,e) {
			if(i==0) ri_status2 = $(e).val();
			else ri_status2 += ','+$(e).val();
		});
	}
	
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
		, rl_receiver : rl_receiver
		, r_shiptocd : r_shiptocd
		, ri_status2 : ri_status2
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
	
	var colSortStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
	if('' == colSortStr) colSortStr = defaultColumnOrder;
	
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="r_colsortstr" value="'+colSortStr+'" />');
	
	formPostSubmit('frm', '${url}/front/order/salesOrderExcelDown.lime');
	$('form[name="frm"]').attr('action', '');

	// jsh 2021.08.02 기존폼에 append 하는 방식이라 input을 날려야함.
	// 다른화면처럼 폼을 날리고 싶지만 시간상 동일하게 반영
	$('input[name="filetoken"]').remove();
	$('input[name="r_colsortstr"]').remove();
	
	var fileTimer = setInterval(function() {
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

//모바일 전체주문현황 상세팝업
function salesOrderViewPop(orderno, orderty, lineno){
	if(!isApp()){
		var param = 'salesOrderViewPop';
		var widthPx = 615;
		var heightPx = 650;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frm_pop"]').remove();
		
		var htmlText = '';
		htmlText += '<form name="frm_pop" method="post" target="salesOrderViewPop">';
		htmlText += '	<input type="hidden" name="pop" value="1" />';
		htmlText += '	<input type="hidden" name="page_type" value="salesOrderViewPop" />';
		htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
		htmlText += '	<input type="hidden" name="r_orderno" value="'+ orderno +'" />';
		htmlText += '	<input type="hidden" name="r_orderty" value="'+ orderty +'" />';
		htmlText += '	<input type="hidden" name="r_lineno" value="'+ lineno +'" />';
		htmlText += '</form>';
		$('body').append(htmlText);
		
		var popUrl = '${url}/front/order/salesOrderViewPop.lime';
		window.open('', 'salesOrderViewPop', options);
		$('form[name="frm_pop"]').prop('action', popUrl);
		$('form[name="frm_pop"]').submit().remove();
	}
	else{
		// 모달팝업
		//$('#salesOrderViewPopMId').modal('show');
		var link = '${url}/front/order/salesOrderViewPop.lime?page_type=salesOrderViewPop&r_multiselect=false&r_orderno='+orderno+'&r_orderty='+orderty+'&r_lineno='+lineno+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#salesOrderViewPopMId').modal({
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
				<div class="page-breadcrumb"><strong>전체주문현황</strong></div>
				
				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/order/salesOrderList.lime">전체주문현황</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/order/salesOrderList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/salesOrderList.lime')}">selected="selected"</c:if> >전체주문현황</option>
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
							<em>주문일자</em>
							<input type="text" class="form-control calendar" name="r_ordersdt" value="${ordersdt}" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_orderedt" value="${orderedt}" readonly="readonly" />
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
								<em>출고일자</em>
								<input type="text" class="form-control calendar" name="r_actualshipsdt" value="" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_actualshipedt" value="" readonly="readonly" />
							</div>
							<div class="col-md-6 right">
								<em>납품요청일</em>
								<input type="text" class="form-control calendar" name="r_requestsdt" value="" readonly="readonly" /> <span>~</span> <input type="text" class="form-control calendar" name="r_requestedt" value="" readonly="readonly" />
							</div>
							<div class="col-md-6">
								<em>품목명</em>
								<input type="text" class="form-control" name="rl_itemdesc" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
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
							 
							<div class="col-md-12 line">
								<em>출고상태</em>
								<div class="table-checkbox">
									<label class="lol-label-checkbox" for="checkbox">
										<input type="checkbox" name="allCheck" id="checkbox" onclick="checkAll2(this, 'vi_status2');" />
										<span class="lol-text-checkbox">전체</span>
									</label>
									<c:forEach items="${salesOrderStatusList}" var="list" varStatus="status">
										<label class="lol-label-checkbox" for="checkbox${status.count}">
											<input type="checkbox" id="checkbox${status.count}" name="vi_status2" value="${list.key}" />
											<span class="lol-text-checkbox">${list.value}</span>
										</label>
									</c:forEach>
								</div>
							</div>
						</div>
						
					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<button type="button" class="detailBtn" onclick="fn_spread('hiddenContent02');">상세조회</button>
						<button type="button" onclick="dataSearch();">Search</button>
					</div>
					
					<div class="boardListArea">
						<h2>
							Total <strong><span id="listTotalCountSpanId"></span></strong>EA
							<div class="title-right little">
								<button class="btn btn-green" type="button" onclick="orderPaperPop(this, '', '');">거래명세표</button>
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