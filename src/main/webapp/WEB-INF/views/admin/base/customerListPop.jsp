<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<style>
 .ui-jqgrid .ui-jqgrid-hbox table,
 .ui-jqgrid .ui-jqgrid-bdiv table {/* width: 100% !important; */}
</style>

<script>

var page_type = toStr('${param.page_type}'); // orderadd,orderlist=영업사원 주문등록 개별선택.

var multi_select = toStr('${r_multiselect}');
multi_select = ('true' == multi_select) ? true : false;


//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/base/customerListPop/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList_pop'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"CUST_CD", key:true, label:'코드', width:100, align:'center', sortable:true },
	{name:"CUST_NM", label:'거래처명', width:150, align:'left', sortable:true },
	{name:"CUSTOMER_USER_CNT", label:'거래처계정', width:100, align:'center', sortable:true, formatter:setCustomerCnt },
	{name:"SALESREP_NM2", label:'영업담당', width:120, align:'left', sortable:true, formatter:setSalesNm },
	{name:"SHIPTO_CNT", label:'납품처', width:100, align:'center', sortable:true, formatter:setShipToCnt },
	//{name:"SHIPTO_USER_CNT", label:'납품처계정', width:20, align:'center', sortable:true },
	{name:"ADD1", label:'거래처주소', width:300, align:'left', sortable:true, formatter:setAddr },
	{name:"INSERT_DT", label:'등록일', width:150, align:'center', sortable:false, formatter:setInDate },
	//{name:"", label:'계정관리', width:20, align:'center', formatter:setDetailBtn },
	{name:"PT_ZIPCODE", hidden:true },
	{name:"CUST_MAIN_EMAIL", hidden:true },
];
if(!multi_select){
	defaultColModel.push({name:"", label:'선택', width:100, align:'center', sortable:false, formatter:setSelectBtnPop});
}

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
	getGridListPop();
});

function getGridListPop(){
	// grid init
	var searchData = getSearchDataPop();
	//$('#gridList_pop').jqGrid('GridUnload'); // 있어야 다시 호출하네...
	
	$("#gridList_pop").jqGrid({
		url: "${url}/admin/base/getCustomerListAjax.lime",
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
				var grid = $('#gridList_pop');
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
			
			var grid = $('#gridList_pop');
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
			var grid = $('#gridList_pop');
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

// 거래처계정.
function setCustomerCnt(cellval, options, rowObject){
	if('-1' == cellval) return '-';
	return addComma(cellval);
}

// 영업담당.
function setSalesNm(cellVal, options, rowObj){
	return toStr(rowObj.AUTHORITY) + ' ' + toStr(cellVal);
}

// 납품처 개수.
function setShipToCnt(cellval, options, rowObject){
	if('-1' == cellval) return '-';
	return addComma(cellval);
}

// 거래처주소.
function setAddr(cellVal, options, rowObj){
	var zipCd = toStr(rowObj.ZIP_CD) == '' ? '' : '['+ toStr(rowObj.ZIP_CD)+ ']';
	return zipCd + ' ' + toStr(rowObj.ADD1) + ' ' + toStr(rowObj.ADD2) + ' ' + toStr(rowObj.ADD3) + ' ' + toStr(rowObj.ADD4);
}

// 등록일.
function setInDate(cellval, options, rowObject){
	if(rowObject.USER_EORDER == 'Y'){
		return cellval;
	}else{
		var inDate = toStr(cellval).replaceAll(' ', '');
		if('' == inDate) return '-';
		return inDate.substring(0,4)+'-'+inDate.substring(4,6)+'-'+inDate.substring(6,8)+' '+inDate.substring(8,10)+':'+inDate.substring(10,12);
	}
}

// 선택버튼.
function setSelectBtnPop(cellval, options, rowObject){
	return '<button type="button"  class="btn btn-default btn-xs" onclick=\'dataSelect(this, "'+options.rowId+'", "2");\'>선택</button>';
}

// 선택.
function dataSelect(obj, rowId, div) { // rowId : 빈값=다중선택, !빈값=개별선택 / div : 1=선택후계속,2=선택후 닫기.
	$(obj).prop('disabled', true);
	
	var confirmText = '거래처를 선택 하시겠습니까?';
	
	if('' == rowId){ // 다중.
		var chk = $('#gridList_pop').jqGrid('getGridParam','selarrrow');
		chk += '';
		var chkArr = chk.split(",");
		if (chk == '') {
			alert('선택 후 진행해 주십시오.');
			$(obj).prop('disabled', false);
			return false;
		}

		var jsonArray = new Array();
		
		if('orderadd' == page_type || 'orderlist' == page_type){ // 주문등록.
			confirmText = '해당 거래처를 선택 하시겠습니까?';
			if(confirm(confirmText)){
				// 데이터 세팅.
				for(var i=0,j=chkArr.length; i<j; i++){
					var jsonData = new Object();
					var rowObj = $('#gridList_pop').jqGrid('getRowData', chkArr[i]);
					jsonData.CUST_CD = chkArr[i];
					jsonData.CUST_NM = rowObj.CUST_NM;
					jsonData.CUSTOMER_USER_CNT = rowObj.CUSTOMER_USER_CNT;
					jsonData.SALESREP_NM2 = rowObj.SALESREP_NM2;
					jsonData.SHIPTO_CNT = rowObj.SHIPTO_CNT;
					//jsonData.SHIPTO_USER_CNT = rowObj.SHIPTO_USER_CNT;
					jsonData.ZIP_CD = rowObj.ZIP_CD;
					jsonData.ADD1 = rowObj.ADD1;
					jsonData.ADD2 = rowObj.ADD2;
					jsonData.ADD3 = rowObj.ADD3;
					jsonData.ADD4 = rowObj.ADD4;
					jsonData.INSERT_DT = rowObj.INSERT_DT;
					jsonData.PT_ZIPCODE = rowObj.PT_ZIPCODE;
					jsonArray.push(jsonData);
				}
				opener.setCustomerFromPop(jsonArray);
				$(obj).prop('disabled', false);
			}else{
				$(obj).prop('disabled', false);
				return;
			}
		}
		
		$(obj).prop('disabled', false);
	}
	else{ // 개별
		var rowData = $('#gridList_pop').getRowData(rowId);
		var custMainEmail = toStr(rowData.CUST_MAIN_EMAIL);
		var customer = {
			CUST_CD : rowData.CUST_CD
			, CUST_NM : rowData.CUST_NM
			, SALESREP_NM2 : rowData.SALESREP_NM2
			, CUST_MAIN_EMAIL : custMainEmail
		};
	
		if ('orderadd' == page_type || 'orderlist' == page_type || 'factReport' == page_type) {
			confirmText = '해당 거래처를 선택 하시겠습니까?';
			if(confirm(confirmText)){
				//customer.salesuserids = '${param.ri_salesuserid}'; // Json Data 추가.
				opener.setCustomerFromPop(customer);
				$(obj).prop('disabled', false);
			}else{
				$(obj).prop('disabled', false);
				return;
			}
		}
		
		$(obj).prop('disabled', false);
	}
	
	if('2' == div) window.open('about:blank', '_self').close();
}

function getSearchDataPop(){
	var rl_custcd = $('input[name="rl_custcd"]').val();
	var rl_custnm = $('input[name="rl_custnm"]').val();
	var rl_salesrepnm2 = $('input[name="rl_salesrepnm2"]').val();
	
	var sData = {
		page_type : page_type
		, rl_custcd : rl_custcd
		, rl_custnm : rl_custnm
		, rl_salesrepnm2 : rl_salesrepnm2
	};
	return sData;
}

function dataSearchPop(){
	var searchData = getSearchDataPop();
	//console.log('searchData : ', searchData);
	$('#gridList_pop').setGridParam({
		postData : searchData
	}).trigger('reloadGrid'); // 리로드후 현재 유지.
}

</script>
</head>

<body class="bg-n">
	
	<!-- Modal -->
	<form name="frmPop" method="post">
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						거래처 선택
						<div class="btnList">
							<a href="javascript:dataSearchPop();" class="btn btn-github" title="검색">검색</a>
						</div>
					</h4>
				</div>
				<div class="modal-body">
					<div class="tableSearch">
						<div class="topSearch">
							<ul>
								<li>
									<label class="search-h">거래처코드</label>
									<div class="search-c">
										<input type="text" class="search-input" name="rl_custcd" value="${param.rl_custcd}" onkeypress="if(event.keyCode == 13){dataSearchPop();}" />
									</div>
								</li>
								<li>
									<label class="search-h">거래처명</label>
									<div class="search-c">
										<input type="text" class="search-input" name="rl_custnm" value="${param.rl_custnm}" onkeypress="if(event.keyCode == 13){dataSearchPop();}" />
									</div>
								</li>
								<li>
									<label class="search-h">영업사원</label>
									<div class="search-c">
										<input type="text" class="search-input" name="rl_salesrepnm2" value="${param.rl_salesrepnm2}" onkeypress="if(event.keyCode == 13){dataSearchPop();}" />
									</div>
								</li>
							</ul>
						</div>
					</div>
					
					<h5 class="table-title pull-left no-m-t">Total <span id="listTotalCountSpanId">0</span> EA</h5>
					<div class="btnList">
						<c:if test="${r_multiselect}">
							<button type="button" class="btn btn-primary" onclick="dataSelect(this, '', '1');">선택후 계속</button>
							<button type="button" class="btn btn-github" onclick="dataSelect(this, '', '2');">선택후 닫기</button>
							
						</c:if>
					</div>
					<div class="table-responsive in">
						<table id="gridList_pop" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table> 
						<div id="pager"></div>
					</div>
				</div>
				
			</div>
		</div>
	</div>
	
	</form>
</body>
</html>