<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<style>
 .ui-jqgrid .ui-jqgrid-hbox table, 
 .ui-jqgrid .ui-jqgrid-bdiv table {width: 100% !important;}
</style>

<script type="text/javascript">
var page_type = toStr('${param.page_type}'); // orderadd=영업사원 주문등록 개별선택.

var multi_select = toStr('${r_multiselect}');
multi_select = ('true' == multi_select) ? true : false;


//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/base/orderAddressBookmarkPop/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList_pop'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{ name:"OAB_ZIPCD", label:'우편번호', sortable:true, width:70, align:'center'},
	{ name:"OAB_ADD1", label:'주소', key:true, sortable:true, width:200, align:'left', formatter:setOabAddr1},
	{ name:"OAB_ADD2", label:'상세주소', key:true, sortable:true, width:150, align:'left', formatter:setOabAddr2},
	{ name:"OAB_RECEIVER", label:'인수자명', key:true, sortable:true, width:110, align:'left', formatter:setOabReceiver},
	{ name:"OAB_TEL1", label:'연락처', key:true, sortable:true, width:120, align:'center'},
	{ name:"OAB_TEL2", label:'연락처2', key:true, sortable:true, width:120, align:'center'},
	{ name:"OAB_INDATE", label:'등록일자', key:true, sortable:true, width:110, align:'center', formatter:"date", formatoptions:{newformat:"Y-m-d"}}, // 시분 까지 노출해야 한다면 boral은 formatoptions 사용하면 안됨.
	{ name:"OAB_SEQ", label:'고유번호', key:true, hidden:true },
	{ name:"OAB_USERID", label:'아이디', hidden:true },
];
if(!multi_select){
	defaultColModel.push({name:"", label:'선택', width:90, align:'center', sortable:false, formatter:setSelectBtnPop});
	defaultColModel.push({name:"", label:'삭제', width:90, align:'center', sortable:false, formatter:setDeleteBtnPop});
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
		url: "${url}/admin/base/getOrderAddressBookmarkAjax.lime",
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
				$("#gridList_pop").jqGrid("GridUnload");
				$('#gridList_pop').hide();
				$('#noList_pop').show();
            }
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

// 세팅. 주소.
function setOabAddr1(cellval, options, rowObject){
	return escapeXss(cellval);
}

// 세팅. 상세주소.
function setOabAddr2(cellval, options, rowObject){
	return escapeXss(cellval);
}

// 세팅. 인수자명.
function setOabReceiver(cellval, options, rowObject){
	return escapeXss(cellval);
}

// 선택버튼.
function setSelectBtnPop(cellval, options, rowObject){
	return '<button type="button"  class="btn btn-line btn-xs" onclick=\'dataSelect(this, "'+options.rowId+'", "2");\'>선택</button>';
}

// 삭제버튼.
function setDeleteBtnPop(cellval, options, rowObject){
	return '<button type="button"  class="btn btn-line btn-xs" onclick=\'dataDelete(this, "'+options.rowId+'");\'>삭제</button>';
}

// 선택.
function dataSelect(obj, rowId, div) { // rowId : 빈값=다중선택, !빈값=개별선택 / div : 1=선택후계속,2=선택후 닫기.
	$(obj).prop('disabled', true);
	
	var confirmText = '해당 주소를 선택 하시겠습니까?';
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
		
		if('orderadd' == page_type){ // 주문등록.
			if(confirm(confirmText)){
				// 데이터 세팅.
				for(var i=0,j=chkArr.length; i<j; i++){
					var jsonData = new Object();
					var rowObj = $('#gridList_pop').jqGrid('getRowData', chkArr[i]);
					jsonData.OAB_SEQ = chkArr[i];
					jsonData.OAB_USERID = rowObj.OAB_USERID;
					jsonData.OAB_ZIPCD = rowObj.OAB_ZIPCD;
					jsonData.OAB_ADD1 = rowObj.OAB_ADD1;
					jsonData.OAB_ADD2 = rowObj.OAB_ADD2;
					jsonData.OAB_RECEIVER = rowObj.OAB_RECEIVER;
					jsonData.OAB_TEL1 = rowObj.OAB_TEL1;
					jsonData.OAB_TEL2 = rowObj.OAB_TEL2;
					jsonData.OAB_INDATE = rowObj.OAB_INDATE;
					jsonArray.push(jsonData);
				}
				opener.setOrderAddressBookmarkFromPop(jsonArray);
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
		var orderAddress = {
				OAB_SEQ : rowData.OAB_SEQ
				, OAB_USERID : rowData.OAB_USERID
				, OAB_ZIPCD : rowData.OAB_ZIPCD
				, OAB_ADD1 : rowData.OAB_ADD1
				, OAB_ADD2 : rowData.OAB_ADD2
				, OAB_RECEIVER : rowData.OAB_RECEIVER
				, OAB_TEL1 : rowData.OAB_TEL1
				, OAB_TEL2 : rowData.OAB_TEL2
				, OAB_INDATE : rowData.OAB_INDATE
			};
	
		if (page_type == 'orderadd') {
			if(confirm(confirmText)){
				//orderAddress.salesuserids = '${param.ri_salesuserid}'; // Json Data 추가.
				opener.setOrderAddressBookmarkFromPop(orderAddress);
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

// 삭제. 개별만.
function dataDelete(obj, rowId) { 
	$(obj).prop('disabled', true);
	
	var confirmText = '주소록에서 삭제 하시겠습니까?';
	var rowData = $('#gridList_pop').getRowData(rowId);
	var oabSeq = rowData.OAB_SEQ;
	
	// ajax
	if (page_type == 'orderadd') {
		$.ajax({
			async : false,
			url : '${url}/admin/base/pop/deleteOrderAddressBookmarkAjax.lime',
			cache : false,
			type : 'POST',
			dataType: 'json',
			data : {  
				ri_oabseqs : oabSeq
			},
			success : function(data){
				if('0000' == data.RES_CODE){
					alert(data.RES_MSG);
					dataSearchPop();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});	
	}
	
	$(obj).prop('disabled', false);
}

function getSearchDataPop(){
	var sData = {
		page_type : page_type
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
						주소록
						<!-- 
						<div class="btnList">
							<a href="javascript:dataSearchPop();" class="btn btn-github" title="검색">검색</a>
						</div>
						 -->
					</h4>
				</div>
				<div class="modal-body">
					<!-- 
					<div class="tableSearch">
						<div class="topSearch">
							<ul>
							</ul>
						</div>
					</div>
					-->
					 
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
						
						<table id="noList_pop" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none;">
							<tbody>
								<tr>
									<td>등록된 주소가 없습니다.</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
		</div>
	</div>
	
	</form>
</body>
</html>