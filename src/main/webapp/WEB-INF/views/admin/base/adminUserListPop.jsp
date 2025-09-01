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

var page_type = toStr('${param.page_type}'); // fixed_sales, orderlist_salesuser=개별선택.

var multi_select = toStr('${r_multiselect}');
multi_select = ('true' == multi_select) ? true : false;


//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/base/adminUserListPop/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList_pop'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"AUTHORITY", label:'권한', width:83, align:'center', sortable:true},
	{name:"USERID", key:true, label:'아이디', width:150, align:'left', sortable:true},
	{name:"USER_NM", label:'임직원명', width:150, align:'left', sortable:true},
	{name:"USER_POSITION", label:'직책', width:110, align:'center', sortable:true},
	{name:"CELL_NO", label:'휴대폰번호', width:120, align:'center', sortable:false, formatter:setCellNoPop},
];
if(!multi_select){
	defaultColModel.push({name:"", label:'선택', width:90, align:'center', sortable:false, formatter:setSelectBtnPop});
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
	var searchData = getSearchDataPop();
	
// 	$('#gridList_pop').jqGrid('GridUnload'); // 있어야 다시 호출하네...
	$("#gridList_pop").jqGrid({
		url: "${url}/admin/base/getAdminUserListAjax.lime",
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
		loadComplete: function(data) {
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
		},
	});
}

function setCellNoPop(cellval, options, rowObject){
	return toTelNumALL(cellval, '-');
}

function setSelectBtnPop(cellval, options, rowObject){
	return '<button type="button" class="btn btn-default btn-xs" onclick=\'dataSelect(this, "'+options.rowId+'")\' >선택</button>';
}

// 선택.
function dataSelect(obj, rowId) { // process_type : 빈값=다중선택, !빈값=개별선택.
	$(obj).prop('disabled', true);
	
	var adminUser;
	var confirmText = '선택한 임직원으로 저장 하시겠습니까?';
	
	if('' == rowId){ // 다중.
		var chk = $('#gridList_pop').jqGrid('getGridParam','selarrrow');
		chk += '';
		var chkArr = chk.split(",");
		if (chk == '') {
			alert('선택 후 진행해 주십시오.');
			$(obj).prop('disabled', false);
			return false;
		}
		
		// 로직 추가.
		
	}
	else{ // 개별
		var rowData = $('#gridList_pop').getRowData(rowId);
		var adminUser = {
			csuserid : rowData.USERID
		};
	
		if (page_type == 'fixed_sales') {
			confirmText = '영업사원의 고정 담당자가 선택한 CS 담당자로 추가 또는 변경 됩니다.\n계속 진행 하시겠습니까?';
			if(confirm(confirmText)){
				adminUser.salesuserids = '${param.ri_salesuserid}'; // Json Data 추가.
				opener.setFixedSales(adminUser);
				window.open('about:blank', '_self').close();
				$(obj).prop('disabled', false);
			}else{
				$(obj).prop('disabled', false);
			}
		}
		if (page_type == 'orderlist_salesuser') {
			confirmText = '해당 영업사원으로 선택 하시겠습니까?';
			if(confirm(confirmText)){
				adminUser.SALES_USERID = rowData.USERID; // Json Data 추가.
				adminUser.SALES_USER_NM = rowData.USER_NM;
				opener.setSalesUser(adminUser);
				window.open('about:blank', '_self').close();
				$(obj).prop('disabled', false);
			}else{
				$(obj).prop('disabled', false);
			}
		}
	}
}

function getSearchDataPop(){
	var rl_usernm = $('input[name="rl_usernm"]').val();
	var rl_cellno = $('input[name="rl_cellno"]').val();
	var sData = {
		ri_authority : '${ri_authority}'
		, r_multiselect : '${r_multiselect}'
		, rl_usernm : rl_usernm
		, rl_cellno : rl_cellno 
		, page_type : page_type
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
	
	<input name="ri_salesuserid" type="hidden" value="${param.ri_salesuserid}" /> <%-- 영업사원 아이디 ,로구분 --%>
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						<c:choose><c:when test="${'orderlist_salesuser' eq page_type}">영업사원 선택</c:when><c:otherwise>임직원 선택</c:otherwise></c:choose>
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
									<label class="search-h">
										<c:choose><c:when test="${'orderlist_salesuser' eq page_type}">영업사원명</c:when><c:otherwise>임직원명</c:otherwise></c:choose>
										
									</label>
									<div class="search-c">
										<input type="text" class="search-input" name="rl_usernm" value="" onkeypress="if(event.keyCode == 13){dataSearchPop();}" />
									</div>
								</li>
								<li>
									<label class="search-h">휴대폰번호</label>
									<div class="search-c">
										<input type="text" class="search-input" name="rl_cellno" value="" onkeypress="if(event.keyCode == 13){dataSearchPop();}" />
									</div>
								</li>
							</ul>
						</div>
					</div>
					
					<h5 class="table-title pull-left no-m-t">Total <span id="listTotalCountSpanId">0</span> EA</h5>
					<div class="btnList">
						<c:if test="${r_multiselect}">
							<button type="button" class="btn btn-primary" onclick="dataSelect(this, '');">선택</button>
							<!-- <a href="javascript:;" class="btn btn-primary" title="선택" onclick="dataSelect(this, '');">선택</a> -->
						</c:if>
					</div>
					<div class="table-responsive">
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