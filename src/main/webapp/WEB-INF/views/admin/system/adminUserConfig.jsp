<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
/* jqgrid without thead : gridList thead만 */
#gbox_gridList .ui-jqgrid-hdiv {display:none !important;}
#gbox_gridList .ui-jqgrid-bdiv tr td:nth-child(6) {padding-right: 25px !important;}
</style>
<script type="text/javascript">

// Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/system/adminUserConfig/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"AUTHORITY", label:'권한', width:73, align:'center', sortable:true},
	{name:"USERID", key:true, label:'아이디', width:150, align:'center', sortable:true},
	{name:"USER_NM", label:'임직원명', width:160, align:'center', sortable:true},
	{name:"USER_POSITION", label:'직책', width:120, align:'center', sortable:true},
	
	{name:"CUSTOMER_CNT", label:'거래처', width:120, align:'center', sortable:true, formatter:setCustomerCnt},
	{name:"CS_SALESUSER", label:'담당', width:160, align:'center', sortable:true, formatter:setCsSalesUser},
	
	{name:"CELL_NO", label:'휴대폰번호', width:130, align:'center', sortable:false, formatter:setCellNo},
	{name:"USER_USE", label:'상태', width:100, align:'center', sortable:true},
	{name:"", label:'기능', width:160, align:'center', sortable:false, formatter:setEditBtn},
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

$(function(){
	getGridList();
	getGridList2('', '', '', '');
});

$(document).ready(function($){ 
	
});

// 내부사용자 권한별 리스트 가져오기.
function getGridList(){
	var searchData = getSearchData();
	//debugger;
	$('#gridList').jqGrid('GridUnload'); // 있어야 다시 호출하네...
	$('#gridList').jqGrid({
		url : "${url}/admin/system/getAdminUserAuthorityListAjax.lime",
		postData : searchData,
		datatype : "json",
		mtype: 'POST',
		autowidth: true,
		//width: '100%',
		height: 'auto',
		hoverrows: false,
		viewrecords: false,
		gridview: true,
		//sortname: 'lft',
		//loadonce: true,
		//scrollrows: true,
		colModel : [
			{name: 'USERID', key:true, hidden:true},
			{name: 'AUTHORITY', hidden:true},
			{name: 'USER_DEPTH', hidden:true},
			{name: 'TOTAL_COUNT', hidden:true},
			{name: 'USER_NM', label: '사용자명', width:80, sortable: false, formatter:setUserNM},
			{name: 'AUTH_COUNT', label: '', align:'right', width:20, sortable: false, formatter:setAuthCount},
		],
		ExpandColumn : 'USER_NM',
		treeGrid : true,
		//treedatatype: 'json',
		treeGridModel : 'adjacency',
		treeReader : {
			level_field : "USER_DEPTH",
			parent_id_field : "USER_PARENT",
			leaf_field : "IS_LEAF",
			expanded_field : "IS_EXPAND",
		},
		treeIcons: {leaf:'ui-icon-document-b'},
		loadComplete: function(data){ //로딩완료후
			var ids = $('#gridList').getDataIDs();
			$.each(ids, function(idx, rowId){
				var rowData = $('#gridList').getRowData(rowId);
				var rowDepth = rowData.USER_DEPTH; //댚스
				var totalCount = rowData.TOTAL_COUNT;

				if(0 == idx) $('#totalCountSpanId').html(addComma(toStr(totalCount)));
				
				if(1 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#FFFFFF"});
				}
				
				else if(2 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#E7E7E7"});
				}
				else if(3 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#DDDDDD"});
				}
				else if(4 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#D1D1D1"});
				}
				
			});
		},
		onCellSelect: function (rowId, col, content, evt) { //셀 선택시
			
		},
		beforeSelectRow : function(rowId, evt){ //로우 선택전
			return true;
	    },
		onSelectRow: function(rowId) { //로우 선택시
			onSelectRowGridList1(rowId, 'Y');
		},
	}); 
}

function onSelectRowGridList1(rowId, callGridListYn){
	var rowData = $('#gridList').jqGrid('getLocalRow', rowId);
	//var rowData = $('#gridList').getRowData(rowId);
	var userid = rowData.USERID;
	var user_nm = rowData.USER_NM;
	var authority = rowData.AUTHORITY;
	var user_depth = rowData.USER_DEPTH;
	
	// 부모 데이터 가져오기.
	var row = $('#gridList').jqGrid('getLocalRow', rowId);
	var parentRowData = $('#gridList').jqGrid('getNodeParent', row);
	//alert('user_depth : '+user_depth+'\nparentRowData : '+parentRowData);
	if('4' == user_depth || ('2' == user_depth && 'SH' != authority && 'SM' != authority && 'SR' != authority)){
		userid = parentRowData.USERID;
		user_nm = parentRowData.USER_NM;
		authority = parentRowData.AUTHORITY;
		user_depth = parentRowData.USER_DEPTH;
	}
	
	if('Y' == callGridListYn){
		getGridList2(userid, user_nm, user_depth, authority);
	}else{
		return userid;
	}
}

function setUserNM(cellval, options, rowObject){
	var authority = rowObject.AUTHORITY;
	var userId = rowObject.USERID;
	var userDepth = rowObject.USER_DEPTH;
	var authCount = rowObject.AUTH_COUNT;
	var retVal = cellval;
	
	// 영업유저명 앞에 SH,SM,SR 붙이기.
	if(('SH' == authority || 'SM' == authority || 'SR' == authority) && '2' != userId){
		retVal = authority+' '+cellval;
	}
	
	return retVal;
}

function setAuthCount(cellval, options, rowObject){
	var authority = rowObject.AUTHORITY;
	//var userId = rowObject.USERID;
	var userDepth = rowObject.USER_DEPTH;
	var authCount = rowObject.AUTH_COUNT;
	var retVal = '';
	
	if('AD' == authority || 'CS' == authority || 'MK' == authority){
		if(Number(userDepth) < 2) retVal += toStr(authCount);
	}
	else if('SH' == authority || 'SM' == authority || 'SR' == authority){
		if(Number(userDepth) < 4) retVal += toStr(authCount);
	}else if('QM' == authority){
		if(Number(userDepth) < 2) retVal += toStr(authCount);
	}else if('CI' == authority) {
		if(Number(userDepth) < 2) retVal += toStr(authCount);
	}
	
	return retVal;
}

function openSalesCategoryEditPop(){
	// 팝업 세팅.
	var widthPx = 800;
	var heightPx = 600;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	var popUrl = '${url}/admin/system/adminUser/pop2/salesUserCategoryEditPop.lime?pop=1';
	window.open(popUrl, 'salesUserCategoryEditPop', options);
	
	/* 
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="salesCategoryEditPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/system/adminUser/pop2/salesUserCategoryEditPop.lime';
	window.open('', 'salesCategoryEditPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();	
	 */
}

// 내부사용자 리스트 가져오기.
function getGridList2(userid, user_nm, user_depth, authority){
	var searchData = getSearchData('1');
	var userListTitle = ''; // gridList2 타이틀.
	console.log('getGridList2');
	
	if('' != toStr(userid)){ // gridList 클릭한 경우.
		// 데이터 재설정.
		$('select[name="r_authority"]').val(''); // 검색조건 중 권한 셀렉트박스 초기화.
		searchData.r_authority = authority;
		
		searchData.r_gridselectyn = 'Y';
		searchData.r_userid = userid;
		searchData.r_userdepth = user_depth;
		
		// gridList2 타이틀 설정.
		if('AD' == authority) userListTitle = '관리'; // 관리 전체.
		if('CS' == authority) userListTitle = 'CS'; // CS 전체.
		if('MK' == authority) userListTitle = '마케팅'; // 마케팅 전체.
		if('QM' == authority) userListTitle = 'QMS'; // QMS 전체.
		if('CI' == authority) userListTitle = 'CI';
		
		if('SH' == authority || 'SM' == authority || 'SR' == authority){ // 영업 전체/SH/SM/SR.
			userListTitle = '영업';
			if('2' != userid){
				userListTitle += ' '+authority+' '+user_nm;
			}
			//debugger;
			$('#salesCateEditBtn').remove();
			$('#userListBtnListDivId').prepend('<button type="button" id="salesCateEditBtn" class="btn btn-line" onclick=\'openSalesCategoryEditPop();\'>영업조직 변경</button>');
		}else{
			$('#salesCateEditBtn').remove();
		}
		
		// Definition for ExcelDown.
		$('form[name="frm"]').find('input[name="excel_gridselectyn"]').val('Y');
		$('form[name="frm"]').find('input[name="excel_authority"]').val(authority);
		$('form[name="frm"]').find('input[name="excel_userid"]').val(userid);
		$('form[name="frm"]').find('input[name="excel_userdepth"]').val(user_depth);
		
	}else{ // 검색한 경우.
		// gridList2 타이틀 설정.
		var select_authority = $('select[name="r_authority"] option:selected').val();
		if('' == select_authority) userListTitle = '전체';
		else userListTitle = $('select[name="r_authority"] option:selected').text(); 
		
		// Initialize for ExcelDown.
		$('form[name="frm"]').find('input[name="excel_gridselectyn"]').val('');
		$('form[name="frm"]').find('input[name="excel_authority"]').val('');
		$('form[name="frm"]').find('input[name="excel_userid"]').val('');
		$('form[name="frm"]').find('input[name="excel_userdepth"]').val('');

	}
	//console.log('searchData : ', searchData);
	
	$('#gridList2').jqGrid('GridUnload'); // 있어야 다시 호출하네...
	$("#gridList2").jqGrid({
		url: "${url}/admin/system/getAdminUserListAjax.lime",
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
				var grid = $('#gridList2');
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
			
			var grid = $('#gridList2');
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
			$('#userListTitleH5Id').html(userListTitle);
		},
		gridComplete: function(){ 
			// 조회된 데이터가 없을때
			var grid = $('#gridList2');
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
	return addComma(cellval);
}

function setCsSalesUser(cellval, options, rowObject){
	if('' == toStr(cellval) || '-' == toStr(cellval)) return '-';
	return 'CS '+cellval;
}

function setCellNo(cellval, options, rowObject){
	return toTelNumALL(cellval, '-');
}

function setEditBtn(cellval, options, rowObject){
	var retStr = '<button type="button" class="btn btn-default btn-xs" onclick=\'adminUserAddEditPop(this, "'+rowObject.USERID+'", "VIEW");\'>상세</button>';
	
	if(isWriteAuth){
		retStr += ' <button type="button" class="btn btn-default btn-xs" onclick=\'adminUserAddEditPop(this, "'+rowObject.USERID+'", "EDIT");\'>수정</button>';
		return retStr;		
	}else{
		return retStr;
	}
}

// 조회 데이터.
function getSearchData(grid_num){ // grid_num : 1=gridList, 2=gridList2.
	var r_authority = $('select[name="r_authority"] option:selected').val();
	var rl_usernm = $('input[name="rl_usernm"]').val();
	var rl_userid = $('input[name="rl_userid"]').val();
	var ri_userusearr = '';
	$('input:checkbox[name="ri_useruse"]:checked').each(function(i,e) {
		if(e==0) ri_userusearr = $(e).val();
		else ri_userusearr += ','+$(e).val();
	});
	
	$('input[name="ri_userusearr"]').val(ri_userusearr); // Use For ExcelDownload.
	
	var sData = {
		r_authority :r_authority
		, rl_usernm :rl_usernm 
		, rl_userid :rl_userid 
		, ri_userusearr :ri_userusearr
		, r_gridselectyn:''
		, r_userid:''
		, r_userdepth:''
	};
	
	return sData;
}

//gridList Reload.
function reloadGridList(){
	$('#gridList').trigger('reloadGrid', [{current:true}]); // 리로드후 현재 유지.
	
	var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	if('' != toStr(gridRowId)){
		$('#gridList').setSelection(gridRowId, true); // 리로드후 선택
	}
}

// gridList2 Reload & Search
function dataSearch(){
	var r_authority = $('select[name="r_authority"] option:selected').val();
	var selRow = toStr($('#gridList').jqGrid('getGridParam', 'selrow')); // gridList 선택된 행의 key값.
	if('' == r_authority && '' != selRow){ // 권한 검색조건을 선택하지 않고, gridList를 선택하지 않은경우
		onSelectRowGridList1(selRow, 'Y');		
	}else{
		$('#gridList').resetSelection(); // gridList 행 선택 취소.
		getGridList2('', '', '', '');
	}
	
	/* 
	var searchData = getSearchData('2');
	//console.log('searchData : ', searchData);
	$('#gridList2').setGridParam({
		postData : searchData
	}).trigger('reloadGrid'); // 리로드후 현재 유지.
	*/
}

// 내부사용자 등록/수정 팝업.
function adminUserAddEditPop(obj, userId, process){ //process=ADD/EDIT/VIEW
	// 팝업 세팅.
	var widthPx = 800;
	var heightPx = 600;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	// 파라미터 세팅.
	var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	var parentUserId = toStr(onSelectRowGridList1(gridRowId, 'N'));
	
	//alert('1.parentUserId : '+parentUserId+'\nuserId : '+userId+'\ngridRowId : '+gridRowId);
	// 등록.
	if('' == userId){ 
		if(!gridRowId || '' == gridRowId){
			alert('내부 사용자를 선택 후 등록 가능합니다.');
			return;
		}
	}
	// 수정/확인.
	else{
		parentUserId = toStr(onSelectRowGridList1(userId, 'N')); // 재정의.
		if('' == parentUserId){
			alert('상위 단계 사용자 아이디를 찾을 수 없습니다.');
			location.reload();
			return;
		}
	}
	//alert('2.parentUserId : '+parentUserId+'\nuserId : '+userId+'\ngridRowId : '+gridRowId);

	$('form[name="frmPop"]').find('input[name="r_userid"]').val(userId);
	$('input[name="r_parentuserid"]').val(parentUserId);
	
	// #POST# 팝업 열기.
	var popUrl = ('VIEW' == process) ? '${url}/admin/system/adminUser/pop/viewPop.lime' : '${url}/admin/system/adminUser/pop/addEditPop.lime';
	window.open('', 'adminUserAddEditViewPop', options);
	$('form[name="frmPop"]').prop('action', popUrl);
	$('form[name="frmPop"]').submit();
}

// 내부 사용자 수정.
function dataUp(obj, use) { // use=사용여부 Y/N/'' > 빈값은 비밀번호 초기화.
	$(obj).prop('disabled', true);
	
	var rowIds = $('#gridList2').jqGrid('getGridParam','selarrrow')+'';
	if (rowIds == ''){
		alert("선택 후 진행해 주세요.");
		$(obj).prop('disabled', false);
		return;
	}
	
	if (confirm('처리 하시겠습니까?')) {
		var uFormObj = $('form[name="uForm"]'); 
		uFormObj.empty();
		
		if('' != use) uFormObj.append('<input type="hidden" name="m_useruse" value="'+use+'" />');
		else uFormObj.append('<input type="hidden" name="r_initpwd" value="Y" />');
			
		uFormObj.append('<input type="hidden" name="ri_userid" value="'+rowIds+'" />');
		var uFormData = uFormObj.serialize();
		
		$.ajax({
			async : false,
			data : uFormData,
			type : 'POST',
			url : '${url}/admin/base/updateUserAjax.lime',
			success : function(data){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					dataSearch();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
			
		});
	} // confirm.
	else{
		$(obj).prop('disabled', false);
	}
}

// 엑셀다운로드.
// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/system/adminUserConfigExcelDown.lime');
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

</script>
</head>

<body class="page-header-fixed compact-menu">
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
		<form name="frmPop" method="post" target="adminUserAddEditViewPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_parentuserid" type="hidden" value="" /> <%-- 등록/수정시 필수 --%>
			<input name="r_userid" type="hidden" value="" /> <%-- 수정시 필수 --%>
		</form>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>
			
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					사용자현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="POST">
				
				<input name="excel_gridselectyn" type="hidden" value="" /> <%-- Definition Parameter for ExcelDown. --%>
				<input name="excel_authority" type="hidden" value="" /> <%-- Definition Parameter for ExcelDown. --%>
				<input name="excel_userid" type="hidden" value="" />  <%-- Definition Parameter for ExcelDown. --%>
				<input name="excel_userdepth" type="hidden" value="" />  <%-- Definition Parameter for ExcelDown. --%>
				
				<input name="ri_userusearr" type="hidden" value="" />
				
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">권한</label>
												<div class="search-c">
													<select class="form-control" name="r_authority" onchange="dataSearch();">
														<option value="">선택하세요</option>
														<!-- <option value="ALL">전체</option> -->
														<option value="AD">관리</option>
														<option value="SH">영업SH</option>
														<option value="SM">영업SM</option>
														<option value="SR">영업SR</option>
														<option value="CS">CS</option>
														<option value="MK">마케팅</option>
														<option value="QM">QMS</option>
														<option value="CI">CI</option>
													</select>
												</div>
											</li>
											<li>
												<label class="search-h">임직원명</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_usernm" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">아이디</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_userid" value="" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">상태</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="ri_useruse" value="Y" onclick="dataSearch();" />Y</label>
													<label><input type="checkbox" name="ri_useruse" value="N" onclick="dataSearch();" />N</label>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="row">
									<div class="col-md-5 col-lg-3">
										<h5 class="table-title">내부사용자 Total <span id="totalCountSpanId">0</span></h5>

										<div class="table-responsive in table-left">
											<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											</table>
										</div>
									</div>
									
									<div class="col-md-7 col-lg-9">
										<h5 class="table-title" id="userListTitleH5Id"></h5>
										<div class="btnList writeObjectClass" id="userListBtnListDivId">
											
											<button type="button" class="btn btn-line" onclick="dataUp(this, '');">비밀번호 초기화</button>
											<button type="button" class="btn btn-info" data-toggle="modal" data-target="#myModal" onclick="adminUserAddEditPop(this, '', 'ADD');">등록</button>
											<button type="button" class="btn btn-gray" onclick="dataUp(this, 'Y');">Y</button>
											<button type="button" class="btn btn-github" onclick="dataUp(this, 'N');">N</button>
										</div>
										<div class="table-responsive in">
											<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											</table>
											<div id="pager"></div>
										</div>
									</div>
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