<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style type="text/css">
#gridList2_cb {/* width: 35px !important; */}
</style>
<script>
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/customer/customerDetail/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"CUST_CD", label:'거래처코드', width:100, align:'center', sortable:true },
	{name:"CUST_NM", label:'거래처명', width:250, align:'left', sortable:true },
	{name:"USERID", label:'아이디', key:true, width:170, align:'left', sortable:true },
// 	{name:"USER_PWD", label:'패스워드', width:10, align:'center', sortable:true, formatter:setPswd },
	{name:"USER_NM", label:'담당자명', width:170, align:'left', sortable:true },
	{name:"CELL_NO", label:'휴대폰번호', width:200, align:'center', sortable:true, formatter:setCellNo },
	{name:"TEL_NO", label:'전화번호', width:200, align:'center', sortable:true, formatter:setTelNo },
	{name:"USER_EMAIL", label:'이메일', width:300, align:'left', sortable:true },
	{name:"USER_EORDER", label:'관리', width:245, align:'left', formatter:setBtn },
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
var ckNameJqGrid2 = 'admin/customer/customerDetail/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid2 += '/gridList2'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr2 = toStr(decodeURIComponent(getCookie(ckNameJqGrid2)));
var globalColumnOrder2 = globalColumnOrderStr2.split(',');
//console.log('globalColumnOrderStr2 : ', globalColumnOrderStr2);

var defaultColModel2 = [ //  ####### 설정 #######
	{ name:"SHIPTO_CD", label:'납품처코드', sortable:true, width:100, align:'center'},
	{ name:"SHIPTO_NM", label:'납품처명', sortable:true, width:280, align:'left'},
	{ name:"USER_USE", label:'계정사용여부', sortable:false, width:105, align:'center' },
	{ name:"USERID", label:'아이디', key:true, sortable:false, width:150, align:'left' },
// 	{ name:"USER_PWD", label:'패스워드', sortable:false, width:15, align:'center', formatter:setPswd },
	{ name:"USER_NM", label:'담당자명', sortable:false, width:280, align:'left' },
	{ name:"CEL_NO", label:'휴대폰번호', sortable:false, width:110, align:'center', formatter:setCellNo },
	{ name:"TEL_NO", label:'전화번호', sortable:false, width:110, align:'center', formatter:setTelNo },
	{ name:"USER_EMAIL", label:'이메일', sortable:false, width:270, align:'left' },
	{ name:"Comment", label:'주의사항', sortable:false, width:270, align:'center' }, // 2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가. SHIP_TO Table에 Comment(VARCHAR(80)) 추가
	{ name:"USER_EORDER", label:'관리', sortable:false, width:195, align:'left', formatter:setShipToBtn },
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
	insertShiptoUser(); //납품처계정 자동생성
	
	getGridList();
	getGridList2();
});

function getGridList(){
	var searchData = getSearchData();
	
	// grid init
	$('#gridList').jqGrid({
		url: "${url}/admin/customer/getCoUserListAjax.lime",
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_custcd : $('input[name="m_custcd"]').val(),
			r_authority : 'CO'
		},
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : -1,
		rownumbers: true,
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
		onSelectRow: function(rowId){
			var h_dscode = $('#gridList').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
	});
}

var lastSelection;
//행 편집.
function editRow(id){
	//alert('id : '+id+'\nlastSelection : '+lastSelection);
 if (id && id !== lastSelection) {
     var grid = $('#gridList');
		//grid.jqGrid('restoreRow',lastSelection); //이전에 선택한 행 제어
     grid.jqGrid('editRow',id, {keys: false}); //keys true=enter
     lastSelection = id;
 }
}

//거래처계정 리스트
function getGridList2(custCd){
	$("#gridList2").jqGrid({ 
		url: "${url}/admin/customer/getShipToListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_custcd : $('input[name="m_custcd"]').val(),
			r_authority : 'CT'
		},
		colModel: updateComModel2,
		height: '360px',
		autowidth: false,
		multiselect: true,
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

//조회
function dataSearch(num) {
	var searchData = getSearchData();
	$('#gridList'+num).setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

function getSearchData(){
	var r_custcd = $('input[name="m_custcd"]').val();
	var sData = {
		r_custcd : r_custcd
	};
	return sData;
}

//gridList Reload.
function reloadGridList(num){
	$('#gridList'+num).trigger('reloadGrid', [{current:true}]); // 리로드후 현재 유지.
	
	var gridRowId = toStr($('#gridList'+num).getGridParam('selrow'));
	if('' != toStr(gridRowId)){
		$('#gridList'+num).setSelection(gridRowId, true); // 리로드후 선택
	}
}

//관리버튼
function setBtn(cellVal, options, rowObj){
	var resetBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'dataUp(this, "'+ rowObj.USERID +'", "", "")\'>PW초기화</a>';
	var editBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'userAddEditPop(this, "'+ rowObj.USERID +'", "EDIT")\'>수정</a>';
	var useYn = (rowObj.USER_USE == 'Y'? 'N' : 'Y');
	var useBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'dataUp(this, "'+ rowObj.USERID +'", "'+ useYn +'", "")\'>'+ rowObj.USER_USE +'</a>';
	
	if(isWriteAuth){
		if(cellVal == 'Y'){
			return resetBtn + ' ' + editBtn + ' ' + useBtn;	
		}else{
			return resetBtn + ' ' + editBtn;	
		}
	}else{
		return '';
	}
}

//휴대폰번호
function setCellNo(cellVal, options, rowObj){
 	return toStr(rowObj.CELL_NO).replaceAll('-', '');
}

//전화번호
function setTelNo(cellVal, options, rowObj){
 	return toStr(rowObj.TEL_NO).replaceAll('-', '');
}

//패스워드
function setPswd(cellVal, options, rowObj){
	return '';
}

//납품처 관리버튼
function setShipToBtn(cellVal, options, rowObj){
	var resetBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'dataUp(this, "'+ rowObj.USERID +'", "", "2")\'>PW초기화</a>';
	var editBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'userAddEditPop(this, "'+ rowObj.USERID +'", "EDIT")\'>수정</a>';
	var commentBtn = '<a href="javascript:;" class="btn btn-default btn-xs" onclick=\'commentAddEditPop(this, "'+ rowObj.SHIPTO_CD +'")\'>주의사항</a>'; // 2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가. SHIP_TO Table에 Comment(VARCHAR(80)) 추가

	if(cellVal == 'Y' && isWriteAuth){
		return resetBtn + ' ' + editBtn + ' ' + commentBtn;
	}else{
		return commentBtn;
	}
}

//계정생성/수정 팝업.
function userAddEditPop(obj, userId, process){ //process=ADD/EDIT/VIEW
	// 팝업 세팅.
	var widthPx = 800;
	var heightPx = 410;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	// 파라미터 세팅.
	var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	
	//alert('1.parentUserId : '+parentUserId+'\nuserId : '+userId+'\ngridRowId : '+gridRowId);

	var custcd = $('input[name="m_custcd"]').val();
	var custnm = $('input[name="m_custnm"]').val();
	
	$('form[name="frmPop"]').find('input[name="r_userid"]').val(userId);
	$('form[name="frmPop"]').find('input[name="r_custcd"]').val(custcd);
	$('form[name="frmPop"]').find('input[name="r_custnm"]').val(custnm);
	
	// #POST# 팝업 열기.
	var popUrl = ('VIEW' == process) ? '${url}/admin/cutomer/user/pop/viewPop.lime' : '${url}/admin/customer/user/pop/addEditPop.lime';
	window.open('', 'userAddEditViewPop', options);
	$('form[name="frmPop"]').prop('action', popUrl);
	$('form[name="frmPop"]').submit();
}


//2025-02-20 hsg Frog Splash. 주의사항 생성/수정 팝업.
function commentAddEditPop(obj, shiptoCd){
	// 팝업 세팅.
	var widthPx = 600;
	var heightPx = 350;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	// 파라미터 세팅.
	var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	
	//alert('1.parentUserId : '+parentUserId+'\nuserId : '+userId+'\ngridRowId : '+gridRowId);

/* 	var custcd = $('input[name="m_custcd"]').val();
	var custnm = $('input[name="m_custnm"]').val();
	
	$('form[name="frmCommentPop"]').find('input[name="r_userid"]').val(userId);
	$('form[name="frmCommentPop"]').find('input[name="r_custcd"]').val(custcd);
	$('form[name="frmCommentPop"]').find('input[name="r_custnm"]').val(custnm);
	 */	
		$('form[name="frmCommentPop"]').find('input[name="r_shiptocd"]').val(shiptoCd);

	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/customer/shipto/pop/adminCommentAddEditPop.lime';
	window.open('', 'adminCommentAddEditPop', options);
	$('form[name="frmCommentPop"]').prop('action', popUrl);
	$('form[name="frmCommentPop"]').submit();
}


//납품처계정 수정
function dataListUp(obj, use) {
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
		uFormObj.append('<input type="hidden" name="ri_userid" value="'+rowIds+'" />');
		uFormObj.append('<input type="hidden" name="m_useruse" value="'+use+'" />');
		
		var uFormData = uFormObj.serialize();
		$.ajax({
			async : false,
			data : uFormData,
			type : 'POST',
			url : '${url}/admin/customer/updateShiptoUserAjax.lime',
			success : function(data){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					dataSearch('2');
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

// 비밀번호초기화,사용여부 업데이트
function dataUp(obj, userId, use, num) {
	$(obj).prop('disabled', true);
	var initpwd = ( use == '' ? 'Y' : 'N' );
	
	if (confirm('처리 하시겠습니까?')) {
		var param = 'r_initpwd='+initpwd+'&m_useruse='+use+'&ri_userid='+userId;
		$.ajax({
			async : false,
			data : param,
			type : 'POST',
			url : '${url}/admin/customer/updateUserAjax.lime',
			success : function(data){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					dataSearch(num);
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

//납품처계정 자동생성
function insertShiptoUser() {
	var r_custcd = $('input[name="m_custcd"]').val();
	
	var param = 'r_custcd='+r_custcd;
	$.ajax({
		async : false,
		data : param,
		type : 'POST',
		url : '${url}/common/insertShiptoUserAjax.lime',
		success : function(data){
			if (data.RES_CODE == '0000') {
				//dataSearch('2');
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
		<form name="frmPop" method="post" target="userAddEditViewPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_userid" type="hidden" value="" /> <%-- 수정시 필수 --%>
			<input name="r_custcd" type="hidden" value="" /> <%-- 등록/수정시 필수 --%>
			<input name="r_custnm" type="hidden" value="" /> <%-- 등록시 필수 --%>
		</form>
		
		<%-- 2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가. 팝업 전송 form --%>
		<form name="frmCommentPop" method="post" target="adminCommentAddEditPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_shiptocd" type="hidden" value="" /> <%-- 등록시 필수 --%>
		</form>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>

		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					계정관리
					<div class="page-right">
						<button type="button" class="btn btn-line" title="목록" onclick="location.href ='${url}/admin/customer/customerList.lime'"><i class="fa fa-list-ul"></i><em>목록</em></button>
						<%-- 
						<button type="button" class="btn btn-line text-default" title="검색"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line text-default" title="엑셀다운로드"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
						 --%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm"  method="post" enctype="multipart/form-data">
				<input name="m_custcd" type="hidden" value="${customer.CUST_CD}" />
				<input name="m_custnm" type="hidden" value="${customer.CUST_NM}" />
				
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
					
						<div class="panel panel-white">
 							<div class="panel-body">
								<h5 class="table-title listT">${customer.CUST_NM}</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" onclick="userAddEditPop(this, '','ADD');">계정생성</button>
								</div>
								<div class="table-responsive in">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
								</div>
							</div>
						</div>
						
						<div class="panel panel-white">
 							<div class="panel-body">
								<h5 class="table-title listT">납품처</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-gray" onclick="dataListUp(this, 'Y');">Y</button>
									<button type="button" class="btn btn-github" onclick="dataListUp(this, 'N');">N</button>
								</div>
								<div class="table-responsive in">
									<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
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