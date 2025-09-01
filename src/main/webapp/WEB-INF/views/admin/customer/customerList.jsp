<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />

<script type="text/javascript">
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/customer/customerList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"CUST_CD", key:true, label:'코드', width:120, align:'center', sortable:true },
	{name:"CUST_NM", label:'거래처명', width:170, align:'left', sortable:true },
	{name:"CUSTOMER_USER_CNT", label:'거래처계정', width:140, align:'center', sortable:true, formatter:setCustomerCnt },
	{name:"SALESREP_NM2", label:'영업담당', width:170, align:'left', sortable:true, formatter:setSalesNm },
	{name:"SHIPTO_CNT", label:'납품처', width:100, align:'center', sortable:true, formatter:setShipToCnt },
	{name:"SHIPTO_USER_CNT", label:'납품처계정', width:135, align:'center', sortable:true },
	{name:"ADD1", label:'거래처주소', width:530, align:'left', sortable:true, formatter:setAddr },
	{name:"INSERT_DT", label:'등록일', width:120, align:'center', sortable:true, formatter:setInDate },
	{name:"", label:'계정관리', width:150, align:'center', sortable:false, formatter:setDetailBtn },
	{name:"PT_ZIPCODE", hidden:true },
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
var ckNameJqGrid2 = 'admin/customer/customerList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid2 += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGrid2)));
var globalColumnOrder2 = globalColumnOrderStr2.split(',');
//console.log('globalColumnOrderStr2 : ', globalColumnOrderStr2);

var defaultColModel2 = [ //  ####### 설정 #######
	{ name:"USER_USE", label:'사용여부', sortable:true, width:145, align:'center'},
	{ name:"USERID", label:'ID', key:true, sortable:true, width:250, align:'center'},
	{ name:"USER_NM", label:'담당자', sortable:false, width:250, align:'left'},
	{ name:"TEL_NO", label:'전화번호', sortable:false, width:250, align:'center', formatter:setCellNo },
	{ name:"CELL_NO", label:'휴대폰번호', sortable:false, width:250, align:'center', formatter:setTelNo },
	{ name:"USER_EMAIL", label:'이메일', sortable:false, width:300, align:'left' },
	{ name:"INSERT_DT", label:'등록일', sortable:false, width:190, align:'center', formatter:setInDate },
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


//### 3 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid3 = 'admin/customer/customerList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid3 += '/gridList3'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr3 = toStr(decodeURIComponent(getCookie(ckNameJqGrid3)));
var globalColumnOrder3 = globalColumnOrderStr3.split(',');
//console.log('globalColumnOrderStr3 : ', globalColumnOrderStr3);

var defaultColModel3 = [ //  ####### 설정 #######
	{ name:"SHIPTO_CD", label:'납품처코드', sortable:true, width:240, align:'center'},
	{ name:"SHIPTO_NM", label:'납품처명', key:true, sortable:true, width:590, align:'left'},
	{ name:"ADDR1", label:'주소', sortable:false, width:805, align:'left', formatter:setAddr },
];
var defaultColumnOrder3 = writeIndexToStr(defaultColModel3.length);
//console.log('defaultColumnOrder3 : ', defaultColumnOrder3);
var updateComModel3 = []; // 전역.

if(0 < globalColumnOrder3.length){ // 쿠키값이 있을때.
	if(defaultColModel3.length == globalColumnOrder3.length){
		for(var i=0,j=globalColumnOrder3.length; i<j; i++){
			updateComModel3.push(defaultColModel3[globalColumnOrder3[i]]);
		}
		
		setCookie(ckNameJqGrid3, globalColumnOrder3, 365); // 여기서 계산을 다시 해줘야겠네.
		//delCookie(ckNameJqGrid3); // 쿠키삭제
	}else{
		updateComModel3 = defaultColModel3;
		
		setCookie(ckNameJqGrid3, defaultColumnOrder3, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel3 = defaultColModel3;
	setCookie(ckNameJqGrid3, defaultColumnOrder3, 365);
}
//console.log('defaultColModel3 : ', defaultColModel3);
//console.log('updateComModel3 : ', updateComModel3);
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
//### 3 WIDTH ###################################################################################################
// @@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth3 = ckNameJqGrid3+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr3 = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth3)));
var globalColumnWidth3 = globalColumnWidthStr3.split(',');
// console.log('globalColumnWidthStr3 : ', globalColumnWidthStr3);
// console.log('globalColumnWidth3 : ', globalColumnWidth3);
var defaultColumnWidthStr3 = '';
var defaultColumnWidth3;
var updateColumnWidth3;
if('' != globalColumnWidthStr3){ // 쿠키값이 있을때.
	if(updateComModel3.length == globalColumnWidth3.length){
		updateColumnWidth3 = globalColumnWidth3;
	}else{
		for( var j=0; j<updateComModel3.length; j++ ) {
			//console.log('currentColModel3[j].name : ', currentColModel3[j].name);
			if('rn' != updateComModel3[j].name && 'cb' != updateComModel3[j].name){
				var v = ('' != toStr(updateComModel3[j].width)) ? toStr(updateComModel3[j].width) : '0';
				if('' == defaultColumnWidthStr3) defaultColumnWidthStr3 = v;
				else defaultColumnWidthStr3 += ','+v;
			}
		}
		defaultColumnWidth3 = defaultColumnWidthStr3.split(',');
		updateColumnWidth3 = defaultColumnWidth3;
		setCookie(ckNameJqGridWidth3, defaultColumnWidth3, 365);
	}
}
else{ // 쿠키값이 없을때.
	//console.log('updateComModel3 : ', updateComModel3);
	
	for( var j=0; j<updateComModel3.length; j++ ) {
		//console.log('currentColModel3[j].name : ', currentColModel3[j].name);
		if('rn' != updateComModel3[j].name && 'cb' != updateComModel3[j].name){
			var v = ('' != toStr(updateComModel3[j].width)) ? toStr(updateComModel3[j].width) : '0';
			if('' == defaultColumnWidthStr3) defaultColumnWidthStr3 = v;
			else defaultColumnWidthStr3 += ','+v;
		}
	}
	defaultColumnWidth3 = defaultColumnWidthStr3.split(',');
	updateColumnWidth3 = defaultColumnWidth3;
	setCookie(ckNameJqGridWidth3, defaultColumnWidth3, 365);
}
//console.log('### defaultColumnWidthStr3 : ', defaultColumnWidthStr3);
//console.log('### updateColumnWidth3 : ', updateColumnWidth3);

if(updateComModel3.length == globalColumnWidth3.length){
	//console.log('이전 updateComModel3 : ',updateComModel3);
	for( var j=0; j<updateComModel3.length; j++ ) {
		updateComModel3[j].width = toStr(updateColumnWidth3[j]);
	}
	//console.log('이후 updateComModel3 : ',updateComModel3);
}
// End.

$(function(){
	getGridList();
});


function getGridList(){
	// grid init
	var searchData = getSearchData();
	$('#gridList').jqGrid({
		url: "${url}/admin/customer/getCustomerListPagerAjax.lime",
		editurl: 'clientArray', //사용x
		//editurl: './deliveryspotUpAjax.lime',
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		rownumbers: true,
		pagination: true,
		pager: "#pager",
		actions : true,
		pginput : true,
		pageable: true,
		groupable: true,
		filterable: true,
		columnMenu: true,
		reorderable: true,
		resizable: true,
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
			root : 'list',
		},
		loadComplete: function(data) {
			//$('#gridList').getGridParam("reccount"); // 현재 페이지에 뿌려지는 row 개수
			//$('#gridList').getGridParam("records"); // 현재 페이지에 limitrow
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
			$('.ui-pg-input').val(data.page);
		},
		onSelectRow: function(rowId){
		},
		//onSelectRow: editRow,
		onSelectAll: function(rowIdArr, status) { //전체 체크박스 선택했을때 onSelectRow가 실행이 안되고 onSelectAll 실행되네...
			//console.log('status : ', status); //status : true=전체선택했을때, false=전체해제했을때
			//console.log('rowIdArr : ', rowIdArr); //rowid 배열 타입
			//console.log('rowIdArr.length : ', rowIdArr.length);
		}
		/* 
		beforeProcessing: functi0on(data, status, xhr){ // 서버로 부터 데이터를 받은 후 화면에 찍기 위한 processing을 진행하기 직전에 호출.
			if('0000' != data.RES_CODE){
				alert(data.RES_MSG);
				return false;
			}
		},
		*/
	});
}


//거래처계정
function setCustomerCnt(cellval, options, rowObject){
	if('-1' == cellval) return '-';
	return '<a href=\'javascript:getGridList2("'+ rowObject.CUST_CD +'")\'>' + addComma(cellval) + '</a>';
}

//영업담당
function setSalesNm(cellVal, options, rowObj){
	return toStr(rowObj.AUTHORITY) + ' ' + toStr(cellVal);
}

//납품처
function setShipToCnt(cellval, options, rowObject){
	if('-1' == cellval) return '-';
	return '<a href=\'javascript:getGridList3("'+ rowObject.CUST_CD +'")\'>' + addComma(cellval) + '</a>';
}

//거래처주소
function setAddr(cellVal, options, rowObj){
	var zipCd = toStr(rowObj.ZIP_CD) == '' ? '' : '['+ toStr(rowObj.ZIP_CD)+ ']';
	return zipCd + ' ' + toStr(rowObj.ADD1) + ' ' + toStr(rowObj.ADD2);
}

//등록일
function setInDate(cellval, options, rowObject){
	if(rowObject.USER_EORDER == 'Y'){
		return cellval;
	}else{
		var inDate = toStr(cellval).replaceAll(' ', '');
		if('' == inDate) return '-';
		return inDate.substring(0,4)+'-'+inDate.substring(4,6)+'-'+inDate.substring(6,8)+' '+inDate.substring(8,10)+':'+inDate.substring(10,12);
	}
}

//거래처 상세로 이동
function setDetailBtn(cellval, options, rowObject){
	return '<a href="${url}/admin/customer/customerDetail.lime?r_custcd='+ rowObject.CUST_CD +'" class="btn btn-default btn-xs">계정관리</a>';
}

//거래처계정 리스트
function getGridList2(custCd){
	$('#gridList2').jqGrid('GridUnload');
	$('#customerDivId').show();
	$('#shipToDivId').hide();
	
	$("#gridList2").jqGrid({ 
		url: "${url}/admin/customer/getCoUserListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_custcd : custCd,
			r_authority : 'CO'
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
	});
}


//휴대폰번호
function setCellNo(cellVal, options, rowObj){
 	return toStr(rowObj.CELL_NO).replaceAll('-', '');
}

//전화번호
function setTelNo(cellVal, options, rowObj){
 	return toStr(rowObj.TEL_NO).replaceAll('-', '');
}

//납품처현황 리스트
function getGridList3(custCd){
	$('#gridList3').jqGrid('GridUnload');
	$('#shipToDivId').show();
	$('#customerDivId').hide();
	
	$("#gridList3").jqGrid({ 
		url: "${url}/admin/customer/getShipToListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_custcd : custCd
		},
		colModel: updateComModel3,
		height: '360px',
		autowidth: false,
		rownumbers: true,
		rowNum : -1,
		//sortable: true,
		sortable: { // ####### 설정 #######
			update: function(relativeColumnOrder){
				var grid = $('#gridList3');
				var defaultColIndicies3 = [];
				for( var i=0; i<defaultColModel3.length; i++ ) {
					defaultColIndicies3.push(defaultColModel3[i].name);
				}
	
				globalColumnOrder3 = []; // 초기화.
				var columnOrder3 = [];
				var currentColModel3 = grid.getGridParam('colModel');
				for( var j=0; j<relativeColumnOrder.length; j++ ) {
					//console.log('currentColModel3[j].name : ', currentColModel3[j].name);
					if('rn' != currentColModel3[j].name && 'cb' != currentColModel3[j].name){
						columnOrder3.push(defaultColIndicies3.indexOf(currentColModel3[j].name));
					}
				}
				globalColumnOrder3 = columnOrder3;
				
				setCookie(ckNameJqGrid3, globalColumnOrder3, 365);
				//console.log('globalColumnOrder3 : ', globalColumnOrder3);
				
				// @@@@@@@ For Resize Column @@@@@@@
				//currentColModel3 = grid.getGridParam('colModel');
				//console.log('이전 updateColumnWidth3 : ', updateColumnWidth3);
				var tempUpdateColumnWidth3 = [];
				for( var j=0; j<currentColModel3.length; j++ ) {
				   if('rn' != currentColModel3[j].name && 'cb' != currentColModel3[j].name){
				      tempUpdateColumnWidth3.push(currentColModel3[j].width); 
				   }
				}
				updateColumnWidth3 = tempUpdateColumnWidth3;
				//console.log('이후 updateColumnWidth3 : ', updateColumnWidth3);
				setCookie(ckNameJqGridWidth3, updateColumnWidth3, 365);
			}
		},
		// @@@@@@@ For Resize Column @@@@@@@
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder3 : ', globalColumnOrder3);
			var minusIdx3 = 0;
			
			var grid = $('#gridList3');
			var currentColModel3 = grid.getGridParam('colModel');
			//console.log('currentColModel3 : ', currentColModel3);
			if('rn' == currentColModel3[0].name || 'cb' == currentColModel3[0].name) minusIdx3--;
			if('rn' == currentColModel3[1].name || 'cb' == currentColModel3[1].name) minusIdx3--;
			//console.log('minusIdx3 : ', minusIdx3);
			
			var resizeIdx3 = index + minusIdx3;
			//console.log('resizeIdx3 : ', resizeIdx3);
			
			//var realIdx = globalColumnOrder3[resizeIdx3];
			//console.log('realIdx : ', realIdx);
			
			updateColumnWidth3[resizeIdx3] = width;
			
			setCookie(ckNameJqGridWidth3, updateColumnWidth3, 365);
	        //alert('Resize Column : '+index+'\nWidth : '+width);
	    },
		sortorder: 'desc',
		jsonReader : {
			root : 'data'
		},
	});
}


// 저장/수정.
function dataInUp(obj, val) {
	$(obj).prop('disabled', true);
	
	var chk = $('#gridList').jqGrid('getGridParam','selarrrow');
	chk += '';
	var chkArr = chk.split(",");
	if (chk == '') {
		alert("선택 후 진행해 주십시오.");
		$(obj).prop('disabled', false);
		return false;
	}
	
	var iFormObj = $('form[name="iForm"]');
	iFormObj.empty();
	
	var ckflag = true;
	for (var i=0; i<chkArr.length; i++){
		var trObj = $('#jqg_gridList_' + chkArr[i]).closest('tr');
		
		var process_type = ('' == toStr(trObj.find('input[name="R_PT_CODE"]').val())) ? 'ADD' : 'EDIT';
		
		//validation
		if(ckflag && '' == trObj.find('select[name="PT_USE"]').val()){
			alert('상태를 선택해 주세요.');
			trObj.find('select[name="PT_USE"]').focus();
			ckflag = false;
		}
		if(ckflag) ckflag = validation(trObj.find('input[name="PT_SORT"]')[0], '출력순서', 'value');
		if(ckflag && 'ADD' == process_type) ckflag = validation(trObj.find('input[name="M_PT_CODE"]')[0], '출고지 코드', 'value');
		if(ckflag) ckflag = validation(trObj.find('input[name="PT_NAME"]')[0], '출고지명', 'value');
		//if(ckflag) ckflag = validation(trObj.find('input[name="PT_ZONECODE"]')[0], '우편번호', 'value');
		//if(ckflag) ckflag = validation(trObj.find('input[name="PT_ADDR2"]')[0], '상세주소', 'value');
		if(ckflag) ckflag = validation(trObj.find('input[name="PT_TEL"]')[0], '연락처', 'alltlp'); //alltlp=휴대폰+일반전화번호+050+070 체크, '-' 제외
		
		if(!ckflag){
			$(obj).prop('disabled', false);
			return false;
		}
		
		// aForm append.
		iFormObj.append('<input type="hidden" name="r_processtype" value="' + process_type + '" />');
		if('ADD' == process_type){
			iFormObj.append('<input type="hidden" name="r_ptcode" value="' + toStr(trObj.find('input[name="M_PT_CODE"]').val()) + '" />');	
		}else{
			iFormObj.append('<input type="hidden" name="r_ptcode" value="' + toStr(trObj.find('input[name="R_PT_CODE"]').val()) + '" />');
		}
		
		iFormObj.append('<input type="hidden" name="m_ptuse" value="' + toStr(trObj.find('select[name="PT_USE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptsort" value="' + toStr(trObj.find('input[name="PT_SORT"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptname" value="' + toStr(trObj.find('input[name="PT_NAME"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptzonecode" value="' + toStr(trObj.find('input[name="PT_ZONECODE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptzipcode" value="' + toStr(trObj.find('input[name="PT_ZIPCODE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptaddr1" value="' + toStr(trObj.find('input[name="PT_ADDR1"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_ptaddr2" value="' + toStr(trObj.find('input[name="PT_ADDR2"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_pttel" value="' + toStr(trObj.find('input[name="PT_TEL"]').val()) + '" />');
	}
	console.log($(iFormObj).html());
	
	if(!ckflag){
		$(obj).prop('disabled', false);
		return false;
	}
	
	if (confirm('저장 하시겠습니까?')) {
		var iFormData = iFormObj.serialize();
		var url = '${url}/admin/system/insertUpdatePlantAjax.lime'; 
		$.ajax({
			async : false,
			data : iFormData,
			type : 'POST',
			url : url,
			success : function(data) {
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					dataSearch();
				}else{
					
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}else{
		$(obj).prop('disabled', false);
	}
}

function getSearchData(){
	var rl_custcd = $('input[name="rl_custcd"]').val();
	var rl_custnm = $('input[name="rl_custnm"]').val();
	var rl_salesrepnm = $('input[name="rl_salesrepnm"]').val();
	
	var r_salesepcY = '', r_salesepcN = ''; //영업담당자 YN
	if($('input[name="r_salesrepcdyn"]:checked').length == 1){
		if($('input[name="r_salesrepcdyn"]:checked').val() == 'Y') r_salesepcN = '0';
		else r_salesepcY = '0';
	}
	
	var sData = {
		rl_custcd : rl_custcd
		, rl_custnm : rl_custnm
		, rl_salesrepnm : rl_salesrepnm
		, r_salesrepcdyn : r_salesepcY
		, rn_salesrepcdyn : r_salesepcN
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
function excelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/customer/customerExcelDown.lime');
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


//gridList Reload.
function reloadGridList(){
	$('#gridList').trigger('reloadGrid', [{current:true}]); // 리로드후 현재 유지.
	
	var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	if('' != toStr(gridRowId)){
		$('#gridList').setSelection(gridRowId, true); // 리로드후 선택
	}
}

</script>
</head>

<body class="page-header-fixed compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<%-- 임의 form --%>
		<form name="iForm" method="post"></form>
		<%-- <form name="uForm" method="post" action="${url}/admin/system/deliverySpotEditPop.lime" target="deliverySpotEditPop"></form> --%>
		
		<form name="frm" method="post">
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					거래처현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">거래처코드</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_custcd" value="${param.rl_custcd}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">거래처명</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_custnm" value="${param.rl_custnm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">영업담당</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_salesrepnm" value="${param.rl_salesrepnm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">영업담당자</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="r_salesrepcdyn" value="Y" onclick="dataSearch();" />Y</label>
													<label><input type="checkbox" name="r_salesrepcdyn" value="N" onclick="dataSearch();" />N</label>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="table-responsive in">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
								</div>
							</div>
							
							<div class="panel-body" style="display:none;" id="shipToDivId">
								<h5 class="table-title">납품처현황</h5>
								<div class="table-responsive in min">
									<table id="gridList3" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
								</div>
							</div>
							
							<div class="panel-body" style="display:none;" id="customerDivId">
								<h5 class="table-title">거래처계정</h5>
								<div class="table-responsive in min">
									<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
								</div>
							</div>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		
		</form>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>

</html>