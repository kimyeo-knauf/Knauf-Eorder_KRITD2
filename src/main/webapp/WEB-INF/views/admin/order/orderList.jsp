<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/orderList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));

var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"STATUS_CD", label:'주문상태', width:90, align:'center', sortable:true, formatter:setStatusCd},
	{name:"REQ_NO", key:true, label:'주문번호', width:90, align:'center', sortable:true, formatter:setReqNo},
	{name:"INDATE", label:'주문일시', width:115, align:'center', sortable:true, formatter:'date', formatter:setInDate}, // 시분 까지.
	//{name:"INDATE", label:'주문일시', width:20, align:'left', sortable:true, formatter:'date', formatoptions:{newformat:'Y-m-d H:i'}}, // 시분 까지 노출해야 한다면 boral은 formatoptions 사용하면 안됨.
	{name:"CONFIRM_DT2", label:'확정일시', width:115, align:'center', sortable:false, formatter:setConfirmDt}, // CONFIRM_DT
	{name:"REQUEST_DT", label:'납품요청일시', width:115, align:'center', sortable:true, formatter:setRequestDt}, // REQUEST_DT + REQUEST_TIME

	{name:"CUST_CD", label:'거래처', width:155, align:'left', sortable:true, formatter:setCustCd}, // CUST_CD + CUST_NM
	{name:"SHIPTO_CD", label:'납품처', width:155, align:'left', sortable:true, formatter:setShipttoCd}, // SHIPTO_CD + SHIPTO_NM
	{name:"ZIP_CD", label:'납품주소', width:270, align:'left', sortable:false, formatter:setZipCd}, // ZIP_CD + ADD1 + ADD2
	{name:"USERID", label:'주문자', width:130, align:'center', sortable:true, formatter:setUserId}, // USERID + USER_NM
	{name:"SALESUSERID", label:'영업담당', width:130, align:'center', sortable:false, formatter:setSalesUserId}, // SALESUSERID + SALESUSER_NM // sortable:true로 변경시 작업필요.
	{name:"CSUSERID", label:'CS(고정)', width:130, align:'center', sortable:false, formatter:setCsUserId}, // CSUSERID + CSUSER_NM // sortable:true로 변경시 작업필요.
	{name:"ITEM_CNT", label:'품목', width:55, align:'right', sortable:false, formatter:setItemCnt},
	{name:"ACCESS_DEVICE", label:'접속유형', width:80, align:'center', sortable:false, formatter:setAccessDevice},
	//{name:"", label:'오더장', width:20, align:'center', sortable:false, formatter:setBtn},
	{name:"", label:'기능', width:150, align:'center', sortable:false, formatter:setBtn2},
	{name:"QMS_TEMP_ID", label:'사전입력 QMS ID', width:150, align:'center', sortable:false},
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

//### 2 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid2 = 'admin/order/itemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid2 += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGrid2)));
var globalColumnOrder2 = globalColumnOrderStr2.split(',');
//console.log('globalColumnOrderStr2 : ', globalColumnOrderStr2);

var defaultColModel2 = [ //  ####### 설정 #######
	{ name:"ITEM_CD", label:'품목코드', sortable:false, width:200, align:'left'},
	{ name:"DESC1", label:'품목명', sortable:false, width:1140, align:'left', formatter:setDesc1},
	{ name:"UNIT", label:'단위', sortable:false, width:150, align:'center'},
	{ name:"QUANTITY", label:'수량', sortable:false, width:150, align:'right', formatter:setQuantity},
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

//### 1 WIDTH ###################################################################################################
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
//### 2 WIDTH ###################################################################################################
// @@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth2 = ckNameJqGrid2+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth2)));
var globalColumnWidth2 = globalColumnWidthStr2.split(',');
// console.log('globalColumnWidthStr2 : ', globalColumnWidthStr2);
// console.log('globalColumnWidth2 : ', globalColumnWidth2);
var defaultColumnWidthStr2 = '';
var defaultColumnWidth2;
var updateColumnWidth2;
if('' != globalColumnWidthStr2){ // 쿠키값이 있을때.
	if(updateComModel2.length == globalColumnWidth2.length){
		updateColumnWidth2 = globalColumnWidth2;
	}else{
		for( var j=0; j<updateComModel2.length; j++ ) {
			//console.log('currentColModel2[j].name : ', currentColModel2[j].name);
			if('rn' != updateComModel2[j].name && 'cb' != updateComModel2[j].name){
				var v = ('' != toStr(updateComModel2[j].width)) ? toStr(updateComModel2[j].width) : '0';
				if('' == defaultColumnWidthStr2) defaultColumnWidthStr2 = v;
				else defaultColumnWidthStr2 += ','+v;
			}
		}
		defaultColumnWidth2 = defaultColumnWidthStr2.split(',');
		updateColumnWidth2 = defaultColumnWidth2;
		setCookie(ckNameJqGridWidth2, defaultColumnWidth2, 365);
	}
}
else{ // 쿠키값이 없을때.
	//console.log('updateComModel2 : ', updateComModel2);
	
	for( var j=0; j<updateComModel2.length; j++ ) {
		//console.log('currentColModel2[j].name : ', currentColModel2[j].name);
		if('rn' != updateComModel2[j].name && 'cb' != updateComModel2[j].name){
			var v = ('' != toStr(updateComModel2[j].width)) ? toStr(updateComModel2[j].width) : '0';
			if('' == defaultColumnWidthStr2) defaultColumnWidthStr2 = v;
			else defaultColumnWidthStr2 += ','+v;
		}
	}
	defaultColumnWidth2 = defaultColumnWidthStr2.split(',');
	updateColumnWidth2 = defaultColumnWidth2;
	setCookie(ckNameJqGridWidth2, defaultColumnWidth2, 365);
}
//console.log('### defaultColumnWidthStr2 : ', defaultColumnWidthStr2);
//console.log('### updateColumnWidth2 : ', updateColumnWidth2);

if(updateComModel2.length == globalColumnWidth2.length){
	//console.log('이전 updateComModel2 : ',updateComModel2);
	for( var j=0; j<updateComModel2.length; j++ ) {
		updateComModel2[j].width = toStr(updateColumnWidth2[j]);
	}
	//console.log('이후 updateComModel2 : ',updateComModel2);
}
// End.

$(function(){
	if('' == toStr('${param.fromOrderView}')){
		//주문접수 체크
		$('input:checkbox[name="ri_statuscd"][value="00"]').prop("checked", true);
		//보류 체크
		$('input:checkbox[name="ri_statuscd"][value="08"]').prop("checked", true);
	}
	setSearchValue();

	getGridList();
	
	// 1분마다 dataSearch 실행하기.
	setInterval(function(){
		dataSearch();
	}, 60000);
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
	
	// 주문상태값 전체 체크.
	// $('input:checkbox[name="allCheck"]').trigger('click');


	$('input:checkbox[name="allCheck"]').uniform();
	$('input:checkbox[name="ri_statuscd"]').uniform();
});

/**
 * 검색조건 값 set
 */
function setSearchValue() {
	/*var searchCookieValues = toStr(decodeURIComponent(getCookie("search_orderList")));
	console.log('searchCookieValues 1 ', searchCookieValues);

	if(searchCookieValues != ''){*/
		
	//var searchCookieValues = toStr(decodeURIComponent(getCookie("search_orderList")));	
	var jsonObj = JSON.parse(localStorage.getItem("search_orderList"));
	console.log('jsonObj 1 ', jsonObj);

	if(jsonObj != null){
		//console.log('searchCookieValues 2 ', searchCookieValues);
		//var jsonObj = JSON.parse(decodeURIComponent(getCookie("search_orderList")));
		//console.log('searchCookieValues 2  jsonObj', jsonObj);

		if('Y' == toStr('${param.fromOrderView}')){
			$('input[name="r_insdate"]').val(jsonObj.r_insdate);
			$('input[name="r_inedate"]').val(jsonObj.r_inedate);
			$('input[name="rl_reqno"]').val(jsonObj.rl_reqno);
			$('select[name="r_csuserid"]').val(jsonObj.r_csuserid);
			$('input[name="r_custnm"]').val(jsonObj.r_custnm);

			if('' != jsonObj.r_custnm){
				$('input[name="r_custcdFromPop"]').val(jsonObj.r_custcd);
				setShipTo(toStr(jsonObj.r_custcd)); //납품처 select list 불러옴
			}

			$('select[name="r_shiptocd"]').val(jsonObj.r_shiptocd);
			$('input[name="rl_salesusernm"]').val(jsonObj.rl_salesusernm);

			var ri_statuscds = jsonObj.ri_statuscds.split(','),
				ri_statuscdsLen = ri_statuscds.length;
			$('input:checkbox[name="ri_statuscd"]').each(function(i,e) {
				for(var j=0; j<ri_statuscdsLen; j++){
					if($(e).val() == ri_statuscds[j]){
						$(e).prop('checked', true);
						continue;
					}
				}
			});

			if(ri_statuscdsLen == 6){
				$('#allCheck').prop('checked', true);
			}

		}else{
			//주문접수 체크
			$('input:checkbox[name="ri_statuscd"][value="00"]').prop("checked", true);
			//보류 체크
			$('input:checkbox[name="ri_statuscd"][value="08"]').prop("checked", true);
			//delCookie('search_orderList');
			localStorage.removeItem('search_orderList');
		}

	}
	else{
		//주문접수 체크
		$('input:checkbox[name="ri_statuscd"][value="00"]').prop("checked", true);
		//보류 체크
		$('input:checkbox[name="ri_statuscd"][value="08"]').prop("checked", true);
	}
	// JSON.parse(decodeURIComponent(getCookie("search_orderList")));

}

// 주문 헤더 리스트 가져오기(H).
function getGridList(){
	// grid init
	var searchData = getSearchData();
	$("#gridList").jqGrid({
		url: "${url}/admin/order/getOrderHeaderListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
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

// 주문상태.
function setStatusCd(cellValue, options, rowObject) {
	var orderStatusJson = $.parseJSON('${orderStatusToJson}');
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+orderStatusJson[cellValue]+'</a>';
	//return orderStatusJson[cellValue];
}
// 웹주문상세.
function setReqNo(cellValue, options, rowObject) {
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+cellValue+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+cellValue+'</a>';
}
// 주문일자. YYYY-MM-DD HH:MI
function setInDate(cellValue, options, rowObject) {
	var retStr = ('' == toStr(cellValue)) ? '-' : toStr(cellValue).substring(0,16);
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+retStr+'</a>';
	//return retStr;
}
// 확정일시. CONFIRM_DT.
function setConfirmDt(cellValue, options, rowObject) {
	return toStr(cellValue);
}
// 납품요청일시. REQUEST_DT + REQUEST_TIME.
function setRequestDt(cellValue, options, rowObject) {
	var dt = toStr(cellValue);
	var time = toStr(rowObject.REQUEST_TIME);
	if('' == dt) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+dt.substring(0,4)+'-'+dt.substring(4,6)+'-'+dt.substring(6,8)+' '+time.substring(0,2)+':'+time.substring(2,4)+'</a>';
	//return dt.substring(0,4)+'-'+dt.substring(4,6)+'-'+dt.substring(6,8)+' '+time.substring(0,2)+':'+time.substring(2,4);
}
// 거래처. CUST_CD + CUST_NM.
function setCustCd(cellValue, options, rowObject) {
	var cd = toStr(cellValue) ;
	var nm = toStr(rowObject.CUST_NM);
	if('' == cd || '' == nm) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+nm+'('+cd+')'+'</a>';;
	//return nm+'('+cd+')';
}
// 납품처. SHIPTO_CD + SHIPTO_NM
function setShipttoCd(cellValue, options, rowObject) {
	var cd = toStr(cellValue) ;
	var nm = toStr(rowObject.SHIPTO_NM);
	if('' == cd || '' == nm) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+nm+'('+cd+')'+'</a>';;
	//return nm+'('+cd+')';
}
// 납품주소. ZIP_CD + ADD1 + ADD2
function setZipCd(cellValue, options, rowObject) {
	var zipCd = toStr(cellValue);
	var add1 = toStr(rowObject.ADD1);
	var add2 = toStr(rowObject.ADD2);
	
	var retStr = '';
	if('' != zipCd) retStr += '['+zipCd+'] ';
	retStr += add1+' '+add2;
	
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+retStr+'</a>';
	//return retStr;
}
// 주문자. USERID + USER_NM
function setUserId(cellValue, options, rowObject) {
	var cd = toStr(cellValue).replaceAll(' ', '');
	var nm = toStr(rowObject.USER_NM);
	if('' == cd || '' == nm) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+nm+'('+cd+')'+'</a>';
	//return nm+'('+cd+')';
}
// 영업담당. SALESUSER_NM + SALESUSERID
function setSalesUserId(cellValue, options, rowObject) {
	var cd = toStr(cellValue) ;
	var nm = toStr(rowObject.SALESUSER_NM);
	if('' == cd || '' == nm) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+nm+'('+cd+')'+'</a>';
	//return nm+'('+cd+')';
}
// CS담당자. 영업담당자의 고정 CS담당자. CSUSERID + CSUSER_NM 
function setCsUserId(cellValue, options, rowObject) {
	var cd = toStr(cellValue) ;
	var nm = toStr(rowObject.CSUSER_NM);
	if('' == cd || '' == nm) return '';
	return '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'">'+nm+'('+cd+')'+'</a>';
	//return nm+'('+cd+')';
}
// 품목수. 품목리스트 보여주기.
function setItemCnt(cellValue, options, rowObject) {
	if(0 == toStr(cellValue) || '' == toStr(cellValue)) return '-';
	return '<a href=\'javascript:getGridList2("'+ rowObject.REQ_NO +'")\'>' + addComma(toStr(cellValue)) + '</a>';
}
// 접속유형. 1=웹,2=앱
function setAccessDevice(cellValue, options, rowObject) {
	if('2' == toStr(cellValue)) return 'APP';
	return 'WEB';
}
// 오더장(자재주문서) 팝업 띄우기.
function setBtn(cellValue, options, rowObject) {
	return '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'openOrderPaper(this, "'+rowObject.REQ_NO+'");\'>자재주문서</a>';
}
// 오더처리.
function setBtn2(cellValue, options, rowObject) {

	var retStr = '<a href="${url}/admin/order/orderView.lime?r_reqno='+rowObject.REQ_NO+'&qmsTempId='+rowObject.QMS_TEMP_ID+'" class="btn btn-default btn-xs">상세</a>';
	if(isWriteAuth){
		var statusCd = rowObject.STATUS_CD;
		if('00' == statusCd){
			// ★★ 2025-07-21 hsg 주문상태 보류 추가 ★★ 주문접수 일 때 류 버튼 추가
			retStr += ' <button type="button" class="btn btn-default btn-xs" onclick="editOrderStatus(this, '+rowObject.REQ_NO+',\'08\');">보류</button>';
			retStr += ' <button type="button" class="btn btn-default btn-xs" onclick="checkOrderEditStatus(this, '+rowObject.REQ_NO+');">처리</button>';
		}
		if('08' == statusCd){
			retStr += ' <button type="button" class="btn btn-default btn-xs" onclick="checkOrderEditStatus(this, '+rowObject.REQ_NO+');">처리</button>';
		}
	}
	
	return retStr;
}

// 주문 상세 리스트 가져오기(D).
function getGridList2(req_no){
	$('#gridList2').jqGrid('GridUnload');
	$('#detailListDivId').show();
	
	$("#gridList2").jqGrid({ 
		url: "${url}/admin/order/getOrderDetailListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_reqno : req_no
		},
		colModel: updateComModel2,
		height: '360px',
		autowidth: false,
		rownumbers: true,
		rowNum : -1,
		//sortable: true,
		sortable: { // ####### 설정 #######
			update: function(relativeColumnOrder){
				var grid = $('#gridList2');
				var defaultColIndicies2 = [];
				for( var i=0; i<defaultColModel2.length; i++ ) {
					defaultColIndicies2.push(defaultColModel2[i].name);
				}
	
				globalColumnOrder2 = []; // 초기화.
				var columnOrder2 = [];
				var currentColModel2 = grid.getGridParam('colModel');
				for( var j=0; j<relativeColumnOrder.length; j++ ) {
					//console.log('currentColModel2[j].name : ', currentColModel2[j].name);
					if('rn' != currentColModel2[j].name && 'cb' != currentColModel2[j].name){
						columnOrder2.push(defaultColIndicies2.indexOf(currentColModel2[j].name));
					}
				}
				globalColumnOrder2 = columnOrder2;
				
				setCookie(ckNameJqGrid2, globalColumnOrder2, 365);
				//console.log('globalColumnOrder2 : ', globalColumnOrder2);
				
				// @@@@@@@ For Resize Column @@@@@@@
				//currentColModel2 = grid.getGridParam('colModel');
				//console.log('이전 updateColumnWidth2 : ', updateColumnWidth2);
				var tempUpdateColumnWidth2 = [];
				for( var j=0; j<currentColModel2.length; j++ ) {
				   if('rn' != currentColModel2[j].name && 'cb' != currentColModel2[j].name){
				      tempUpdateColumnWidth2.push(currentColModel2[j].width); 
				   }
				}
				updateColumnWidth2 = tempUpdateColumnWidth2;
				//console.log('이후 updateColumnWidth2 : ', updateColumnWidth2);
				setCookie(ckNameJqGridWidth2, updateColumnWidth2, 365);
			}
		},
		// @@@@@@@ For Resize Column @@@@@@@
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder2 : ', globalColumnOrder2);
			var minusIdx2 = 0;
			
			var grid = $('#gridList2');
			var currentColModel2 = grid.getGridParam('colModel');
			//console.log('currentColModel2 : ', currentColModel2);
			if('rn' == currentColModel2[0].name || 'cb' == currentColModel2[0].name) minusIdx2--;
			if('rn' == currentColModel2[1].name || 'cb' == currentColModel2[1].name) minusIdx2--;
			//console.log('minusIdx2 : ', minusIdx2);
			
			var resizeIdx2 = index + minusIdx2;
			//console.log('resizeIdx2 : ', resizeIdx2);
			
			//var realIdx = globalColumnOrder2[resizeIdx2];
			//console.log('realIdx : ', realIdx);
			
			updateColumnWidth2[resizeIdx2] = width;
			
			setCookie(ckNameJqGridWidth2, updateColumnWidth2, 365);
			//alert('Resize Column : '+index+'\nWidth : '+width);
		},
		sortorder: 'desc',
		jsonReader : {
			root : 'data'
		},
		loadComplete: function(data){
			$('#listTotalCountSpanId2').html(addComma(data.listTotalCount));
		},
	});
}

// gridlist2 > 품목명. DESC1 + DESC2
function setDesc1(cellValue, options, rowObject) {
	return toStr(cellValue)+' '+toStr(rowObject.DESC2);
}
// gridlist2 > 수량. QUANTITY.
function setQuantity(cellValue, options, rowObject) {
	return addComma(cellValue);
}

// 상태값 체크후 처리 폼으로 이동.
function checkOrderEditStatus(obj, req_no){
	$(obj).prop('disabled', true);
	$.ajax({
		async : false,
		url : '${url}/admin/order/checkOrderEditStatusAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { r_reqno : req_no },
		success : function(data){
			if('0000' == data.RES_CODE){
				formGetSubmit('${url}/admin/order/orderEdit.lime', 'r_reqno='+req_no);
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});	
}

// 수정 페이지 이동 / 상세 팝업 띄우기.
// function itemDetail(obj, itemCd, process){ //process=EDIT/VIEW(=팝업)
// 	// 파라미터 세팅.
// 	//var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	
// 	if('VIEW' == process){
// 		// 팝업 세팅.
// 		var widthPx = 800;
// 		var heightPx = 700;
// 		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
// 		$('form[name="frmPop"]').find('input[name="r_itemcd"]').val(itemCd);
		
// 		window.open('', 'itemViewPop', options);
// 		$('form[name="frmPop"]').prop('action', '${url}/admin/item/itemViewPop.lime');
// 		$('form[name="frmPop"]').submit();
// 	}
// 	else{ // EDIT
// 		formGetSubmit('${url}/admin/item/itemEdit.lime', 'r_itemcd='+itemCd+'&');
// 	}
// }

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
	$('input[name="r_custnm"]').val(toStr(jsonData.CUST_NM));
	$('input[name="r_custcdFromPop"]').val(toStr(jsonData.CUST_CD));

	setShipTo(toStr(jsonData.CUST_CD));
}

// 거래처 초기화.
function setDefaultCustomer(){
	$('input[name="r_custnm"]').val('');
	
	$('select[name="r_shiptocd"]').empty();
	var textHtml = '<option value="">선택하세요</option>';
	$('select[name="r_shiptocd"]').append(textHtml);
}

// 납품처 불러오기.
function setShipTo(cust_cd){
	$.ajax({
		async : false,
		url : '${url}/admin/base/getShiptoListAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { 
			r_custcd : cust_cd
			, where : 'all'
		},
		success : function(data){
			$('select[name="r_shiptocd"]').empty();
			
			var textHtml = '';
			textHtml += '<option value="">선택하세요</option>';
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
	$('input[name="rl_salesusernm"]').val(toStr(jsonData.SALES_USER_NM));
	dataSearch();
}

function getSearchData(){
	var r_insdate = $('input[name="r_insdate"]').val();
	var r_inedate = $('input[name="r_inedate"]').val();
	var rl_reqno = $('input[name="rl_reqno"]').val();
	var r_csuserid = $('select[name="r_csuserid"] option:selected').val();
	var r_custnm = $('input[name="r_custnm"]').val(); // 일부로 rl 안함.
	var r_shiptocd = $('select[name="r_shiptocd"] option:selected').val();
	var rl_salesusernm = $('input[name="rl_salesusernm"]').val();
	
	var ri_statuscds = '';
	$('input:checkbox[name="ri_statuscd"]:checked').each(function(i,e) {
		if(i==0) ri_statuscds = $(e).val();
		else ri_statuscds += ','+$(e).val();
	});

	$('input[name="ri_statuscds"]').val(ri_statuscds); // Use For ExcelDownload.
	
	var sData = {
		r_insdate : r_insdate
		, r_inedate : r_inedate
		, rl_reqno : rl_reqno
		, r_csuserid : r_csuserid
		, r_custnm : r_custnm
		, r_shiptocd : r_shiptocd
		, rl_salesusernm : rl_salesusernm
		, ri_statuscds : ri_statuscds
	};

	return sData;
}

// 조회
function dataSearch() {
	$('#detailListDivId').hide();
	
	var searchData = getSearchData();
	searchData.r_custcd = $('input[name="r_custcdFromPop"]').val();
	//setCookie("search_orderList", JSON.stringify(searchData), 365);
	localStorage.setItem("search_orderList", JSON.stringify(searchData));
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

// 엑셀다운로드.
// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/order/orderExcelDown.lime');
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

// 자재주문서 출력 팝업.
function openOrderPaperPop(obj){
	//$(obj).prop('disabled', true);
	
	var chk = $('#gridList').jqGrid('getGridParam','selarrrow');
	chk += '';
	var chkArr = chk.split(",");
	if (chk == '') {
		alert("선택 후 진행해 주십시오.");
		$(obj).prop('disabled', false);
		return false;
	}
	
	// 팝업 세팅.
	var widthPx = 900;
	var heightPx = 750;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop2"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop2" method="post" target="orderPaperPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="ri_reqno" value="'+chk+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/orderPaperPop.lime';
	window.open('', 'orderPaperPop', options);
	$('form[name="frm_pop2"]').prop('action', popUrl);
	$('form[name="frm_pop2"]').submit().remove();
}


/*
 * ★★ 2025-07-21 hsg 주문상태 보류 추가 ★★ 보류 버튼 클릭 시 호출
 */
function editOrderStatus(obj, req_no, statuscd){
	$(obj).prop('disabled', true);
	$.ajax({
		async : false,
		url : '${url}/admin/order/chageOrderStatusAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : { r_reqno : req_no, r_statuscd : statuscd },
		success : function(data){
			/* if('0000' == data.RES_CODE){
				formGetSubmit('${url}/admin/order/orderEdit.lime', 'r_reqno='+req_no);
			} */
			dataSearch();
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
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


		<%-- 팝업 전송 form --%>
		<form name="frm_pop" method="post" target="orderPaperPop" width="800" height="600">
			<input name="ri_reqno" type="hidden" value="" /> <%--  --%>
		</form>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					웹주문현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="location.href='${url}/admin/order/orderList.lime';"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
			<form name="frm" method="post">
			<input type="hidden" name="ri_statuscds" value="" />
			
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
<%--							<form name="frm">--%>
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">주문일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_insdate" value="${insdate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_inedate" value="${inedate}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
											<li>
												<label class="search-h">주문번호</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_reqno" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_reqno}"/>
												</div>
											</li>
											<%-- 거래처 담당 영업사원의 고정/임시 CS담당자 검색조건. --%>
											<c:if test="${'AD' eq admin_authority}">
												<li>
													<label class="search-h">CS</label> 
													<div class="search-c">
														<select class="form-control" name="r_csuserid" onchange="dataSearch();">
															<option value="">선택하세요</option>
															<c:forEach items="${csUserList}" var="list">
																<option value="${list.USERID}">${list.USER_NM}</option>	
															</c:forEach>
														</select>
													</div>
												</li>
											</c:if>
											<li>
												<label class="search-h">거래처</label>
												<div class="search-c">
													<%--거래처 팝업에서 선택한 거래처 코드(검색조건 값 유지 할 때 사용)--%>
													<input type="hidden" class="search-input form-md-d" name="r_custcdFromPop" value="" />
													<%-- 거래처 input의 readonly를 풀고 like 검색을 할경우 납품처 선택이 문제생김. --%>
													<input type="text" class="search-input form-md-d" name="r_custnm" value="" readonly="readonly" onclick="openCustomerPop();"/>
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
												<label class="search-h">영업사원</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_salesusernm" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													<a href="javascript:;" onclick="openUserListPop('sales');"><i class="fa fa-search i-search"></i></a>
												</div>
											</li>
											
											<li class="wide">
												<label class="search-h">주문상태</label>
												<div class="search-c checkbox">
<%--													<label><input type="checkbox" name="allCheck" id="allCheck" onclick="checkAll3(this, 'ri_statuscd'); dataSearch();" />전체</label>--%>
													<label><input type="checkbox" name="allCheck" id="allCheck" onclick="checkAll3(this, 'ri_statuscd'); dataSearch();" />전체</label>
													<c:forEach items="${orderStatusList}" var="list">
														<label><input type="checkbox" name="ri_statuscd" value="${list.key}" onclick="dataSearch();" />${list.value}</label>
													</c:forEach>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
<%--							</form>--%>
							
							<div class="panel-body">
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" data-toggle="modal" data-target="#myModal" onclick="openOrderPaperPop(this);">자재주문서</button>
								</div>
								<div class="table-responsive in">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
								</div>
							</div>
							
						</div>
					</div>
					
					<div class="col-md-12" style="display:none;" id="detailListDivId">
						<div class="panel panel-white">
							<div class="panel-body">
								<h5 class="table-title listT">주문품목 <span id="listTotalCountSpanId2">0</span>EA</h5>
								<div class="table-responsive in min">
									<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
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