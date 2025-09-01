<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />

<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/mypage/csSalesUserList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"AUTHORITY", label:'권한', width:145, align:'center', sortable:true},
	{name:"USERID", key:true, label:'아이디', width:200, align:'center', sortable:true},
	{name:"USER_NM", label:'임직원명', width:250, align:'center', sortable:true},
	{name:"USER_POSITION", label:'직책', width:200, align:'center', sortable:true},
	
	{name:"CUSTOMER_CNT", label:'거래처', width:200, align:'center', sortable:true, formatter:setCustomerCnt},
	{name:"CS_SALESUSER", label:'담당', width:200, align:'center', sortable:true, formatter:setCsSalesUser},
	
	{name:"CELL_NO", label:'휴대폰번호', width:255, align:'center', sortable:false, formatter:setCellNo},
	{name:"SALES_FIXEDYN", label:'임시여부', width:150, align:'center', sortable:true, formatter:setFixedYn},
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

//### 2 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid2 = 'admin/mypage/csSalesUserList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid2 += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGrid2)));
var globalColumnOrder2 = globalColumnOrderStr2.split(',');
//console.log('globalColumnOrderStr2 : ', globalColumnOrderStr2);

var defaultColModel2 = [ //  ####### 설정 #######
	{ name:"CUST_CD", label:'코드', key:true, sortable:true, width:100, align:'center'},
	{ name:"CUST_NM", label:'거래처명', sortable:true, width:250, align:'left'},
	{ name:"CUSTOMER_USER_CNT", label:'거래처계정', sortable:false, width:150, align:'center', formatter:setCustomerUserCnt },
	{ name:"SALESREP_NM2", label:'영업담당', sortable:false, width:150, align:'center'},
	{ name:"SHIPTO_CNT", label:'납품처', sortable:false, width:150, align:'center', formatter:setShiptoCnt },
	{ name:"SHIPTO_USER_CNT", label:'납품처계정', sortable:false, width:150, align:'center', formatter:setShiptoUserCnt },
	{ name:"ADD1", label:'거래처주소', sortable:false, width:535, align:'left', formatter:setAddress },
	{ name:"INSERT_DT", label:'등록일', sortable:false, width:150, align:'center', formatter:setInDate },
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
	getGridList();
	//getGridList2('1');
	//$('#customerDivId').hide();
});

$(document).ready(function() {
	
});

function getGridList(){
	// grid init
	var searchData = getSearchData();
	$("#gridList").jqGrid({
		url: "${url}/admin/mypage/getCsSalesUserListAjax.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		multiselect: true,
		rownumbers: true,
		rowNum : -1,
		//rowList : ['10','30','50','100'],
		//pagination: true,
		//pager: "#pager",
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

function setCustomerCnt(cellval, options, rowObject){
	if('-1' == cellval) return '-';
	return '<a href=\'javascript:getGridList2("'+ rowObject.USERID +'")\'>' + addComma(cellval) + '</a>';
}

function setCsSalesUser(cellval, options, rowObject){
	if('' == toStr(cellval) || '-' == toStr(cellval)) return '-';
	return 'CS '+cellval;
}

function setCellNo(cellval, options, rowObject){
	return toTelNumALL(cellval, '-');
}

function setFixedYn(cellval, options, rowObject){
	if('N' == cellval) return 'Y';
	//if('Y' == cellval) return '';
	return '';
}

function getGridList2(salesUserId){
	$('#gridList2').jqGrid('GridUnload');
	$('#customerDivId').show();
	
	$("#gridList2").jqGrid({ 
		url: "${url}/admin/customer/getCustomerListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_salesrepcd : salesUserId
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

function setCustomerUserCnt(cellval, options, rowObject){
	return addComma(cellval);
}

function setShiptoCnt(cellval, options, rowObject){
	return addComma(cellval);
}

function setShiptoUserCnt(cellval, options, rowObject){
	return addComma(cellval);
}

function setAddress(cellval, options, rowObject){
	var retStr = '';
	var zipCd = toStr(rowObject.ZIP_CD).replaceAll(' ', ''); // 우편번호
	if('' != zipCd) retStr += '우)'+zipCd+' ';
	retStr += toStr(cellval)+' ';
	retStr += toStr(rowObject.ADD2);
	return retStr;
}

function setInDate(cellval, options, rowObject){
	var inDate = toStr(cellval).replaceAll(' ', '');
	if('' == inDate) return '-';
	return inDate.substring(0,4)+'-'+inDate.substring(4,6)+'-'+inDate.substring(6,8)+' '+inDate.substring(8,10)+':'+inDate.substring(10,12);
}

// 임시저장.
function dataIn(obj) {
	$(obj).prop('disabled', true);
	
	var chk = $('#gridList').jqGrid('getGridParam','selarrrow');
	chk += '';
	var chkArr = chk.split(",");
	if (chk == '') {
		alert("선택 후 진행해 주십시오.");
		$(obj).prop('disabled', false);
		return false;
	}

	var uFormObj = $('form[name="uForm"]'); 
	uFormObj.empty();
	
	uFormObj.append('<input type="hidden" name="m_fixedyn" value="N" />');
	for(var i=0,j=chkArr.length; i<j; i++){
		uFormObj.append('<input type="hidden" name="mi_salesuserid" value="'+chkArr[i]+'" />');	
	}
	var uFormData = uFormObj.serialize();
	
	if (confirm('임시저장 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : uFormData,
			type : 'POST',
			url : '${url}/admin/mypage/insertCsSalesMapAjax.lime',
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
	var rl_usernm = $('input[name="rl_usernm"]').val();
	var sData = {
		rl_usernm : rl_usernm
	};
	return sData;
}

// 조회
function dataSearch() {
	$('#customerDivId').hide();
	
	var searchData = getSearchData();
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

// 고정등록 팝업 띄우기.
function openPop(obj){
	var chk = $('#gridList').jqGrid('getGridParam','selarrrow');
	chk += '';
	var chkArr = chk.split(",");
	if (chk == '') {
		alert("영업사원을 선택해 주세요.");
		return false;
	}
	
	// 팝업 세팅.
	var widthPx = 900;
	var heightPx = 750;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').find('input[name="page_type"]').val('fixed_sales');
	$('form[name="frm_pop"]').find('input[name="ri_authority"]').val('CS');
	$('form[name="frm_pop"]').find('input[name="r_multiselect"]').val('false');
	$('form[name="frm_pop"]').find('input[name="ri_salesuserid"]').val(chk);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/adminUserListPop.lime';
	window.open('', 'adminUserListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit();
}

// 고정 저장 > 고정등록 팝업에서 호출.
function setFixedSales(jsonData){
	//console.log('jsonData userid : '+jsonData.userid);
	//console.log('jsonData salesuserids : '+jsonData.salesuserids);
	
	$.ajax({
		async : false,
		data : {
			//m_fixedyn : 'Y'
			m_csuserid : jsonData.csuserid
			, mi_salesuserid : jsonData.salesuserids
		},
		type : 'POST',
		url : '${url}/admin/mypage/updateFixedCsSalesMapAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				alert(data.RES_MSG);
				dataSearch();
			}else{
				
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

</script>
</head>

<body class="page-header-fixed compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<%-- 팝업 전송 form --%>
		<form name="frm_pop" method="post" target="adminUserListPop" width="800" height="600">
			<input name="pop" type="hidden" value="1" />
			<input name="page_type" type="hidden" value="" />
			<input name="ri_authority" type="hidden" value="" /> <%-- 권한 ,로구분 --%>
			<input name="r_multiselect" type="hidden" value="true" /> <%-- 행 단위 선택 가능여부 T/F --%>
			
			<input name="ri_salesuserid" type="hidden" value="" /> <%-- 영업사원 아이디 ,로구분 --%>
		</form>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>
		
		<form name="frm" method="post" onsubmit="return false;">
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					조직설정
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<!-- <button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button> -->
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
												<label class="search-h">영업담당자명</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_usernm" value="${param.rl_usernm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" data-toggle="modal" data-target="#myModal" onclick="openPop(this);">고정등록</button>
									<button type="button" class="btn btn-github" onclick="dataIn(this);">임시저장</button>
								</div>
								<div class="table-responsive in">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
								</div>
							</div>
							
						</div>
					</div>
					
					<div class="col-md-12" style="display:none;" id="customerDivId">
						<div class="panel panel-white">
							<div class="panel-body">
								<h5 class="table-title">거래처</h5>
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