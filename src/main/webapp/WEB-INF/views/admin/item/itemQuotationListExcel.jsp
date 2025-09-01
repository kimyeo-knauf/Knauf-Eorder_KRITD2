<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />

<script type="text/javascript">
console.log("QuotationList config page");

var ckNameJqGrid = 'admin/quotation/itemQuotationListExcel/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');


var defaultColModel = [ // ## NO 관련 확인 ##
	{name:'QUOTE_QT', label:'Quotation 번호', width:200, align:'center', sortable:true },
	{name:'ITEM_CD', label:'품목코드', width:180, align:'center', sortable:true },
	{name:'ITEM_DESC', label:'품목명', width:800, align:'center', sortable:true},
	{name:'INDATE', label:'등록일', width:500, align:'left', sortable:true},
];
var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
var updateComModel = []; // 전역.

if(0 < globalColumnOrder.length){ // 쿠키값이 있을때.
	if(defaultColModel.length == globalColumnOrder.length){
		for(var i=0,j=globalColumnOrder.length; i<j; i++){
			updateComModel.push(defaultColModel[globalColumnOrder[i]]);
		}
		setCookie(ckNameJqGrid, globalColumnOrder, 365); // 여기서 계산을 다시 해줘야겠네.
		//delCookie(ckNameJqGrid); // 쿠키삭제
	} else{
		updateComModel = defaultColModel;
		setCookie(ckNameJqGrid, defaultColumnOrder, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel = defaultColModel;
	setCookie(ckNameJqGrid, defaultColumnOrder, 365);
}

var ckNameJqGridWidth = ckNameJqGrid+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;
/*if('' != globalColumnWidthStr){ // 쿠키값이 있을때.
	if(updateComModel.length == globalColumnWidth.length){
		updateColumnWidth = globalColumnWidth;
	}else{
		for( var j=0; j<updateComModel.length; j++ ) {
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
	for( var j=0; j<updateComModel.length; j++ ) {
		if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
			var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
			if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
			else defaultColumnWidthStr += ','+v;
		}
	}
	defaultColumnWidth = defaultColumnWidthStr.split(',');
	updateColumnWidth = defaultColumnWidth;
	setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
}*/

for( var j=0; j<updateComModel.length; j++ ) {
	if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
		var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
		if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
		else defaultColumnWidthStr += ','+v;
	}
}
defaultColumnWidth = defaultColumnWidthStr.split(',');
updateColumnWidth = defaultColumnWidth;
setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);

if(updateComModel.length == globalColumnWidth.length){
	for( var j=0; j<updateComModel.length; j++ ) {
		updateComModel[j].width = toStr(updateColumnWidth[j]);
	}
}

$(function(){
	getGridList();
});

$(document).ready(function() {
	// 등록일 데이트피커
	$('input[name="r_indate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	});
});

function getGridList(){
	// grid init
	var searchData = getSearchData();
	$('#gridList').jqGrid({
		url: "${url}/admin/quotation/itemQuotationListExcelAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 10, // 페이징
		rownumbers: true,
		pagination: true, // 페이징
		pager: "#pager",
		actions : true,
		pginput : true,
		pageable: true,
		groupable: true,
		filterable: true,
		columnMenu: true,
		reorderable: true,
		resizable: true,
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
					console.log('currentColModel[j].name : ', currentColModel[j].name);
					if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
						columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
					}
				}
				globalColumnOrder = columnOrder;

				console.log('ckNameJqGrid : ', ckNameJqGrid);
				console.log('globalColumnOrder : ', globalColumnOrder);
				setCookie(ckNameJqGrid, globalColumnOrder, 365);
				
				// @@@@@@@ For Resize Column @@@@@@@
				//currentColModel = grid.getGridParam('colModel');
				var tempUpdateColumnWidth = [];
				for( var j=0; j<currentColModel.length; j++ ) {
				   if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
				      tempUpdateColumnWidth.push(currentColModel[j].width); 
				   }
				}
				updateColumnWidth = tempUpdateColumnWidth;
				setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
			}
		},
		// @@@@@@@ For Resize Column @@@@@@@
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder : ', globalColumnOrder);
			var minusIdx = 0;
			
			var grid = $('#gridList');
			var currentColModel = grid.getGridParam('colModel');
			if('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
			if('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
			
			var resizeIdx = index + minusIdx;
			updateColumnWidth[resizeIdx] = width;
			
			setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
		},
		sortorder: 'desc',
		jsonReader : { 
			root : 'list',
		},
		loadComplete: function(data) {
			//$('#gridList').getGridParam("reccount"); // 현재 페이지에 뿌려지는 row 개수
			//$('#gridList').getGridParam("records"); // 현재 페이지에 limitrow
			console.log('globalColumnOrder : ', globalColumnOrder);
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
		},
		onSelectRow: function(rowId){
			var h_dscode = $('#gridList').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
		
		/*onSelectRow: editRow,
		onSelectAll: function(rowIdArr, status) { //전체 체크박스 선택했을때 onSelectRow가 실행이 안되고 onSelectAll 실행되네...
			if(status){
				$.each(rowIdArr, function(i,e){
					var h_dscode = $('#gridList').find('#'+e).find('input[name="h_dscode"]').val();
					if('' != h_dscode){ //editRow
						editRow(e);
					}
				});
			}
		}*/
	});
}

var lastSelection;


function getSearchData(){
	
	var r_quote_qt = $('input[name="r_quote_qt"]').val();
	var r_item_cd = $('input[name="r_item_cd"]').val();
	var r_item_desc = $('input[name="r_item_desc"]').val();
	var r_indate = $('input[name="r_indate"]').val();
	
	var sData = {
			r_quote_qt : r_quote_qt, 
			r_item_cd : r_item_cd,
			r_item_desc : r_item_desc,
			r_indate : r_indate
	};
	return sData;
}

//조회
function dataSearch() {
	var searchData = getSearchData();
	$('#gridList').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}

function editRow(id){
	//alert('id : '+id+'\nlastSelection : '+lastSelection);
    //if (id && id !== lastSelection) {
        var grid = $('#gridList');
		//grid.jqGrid('restoreRow',lastSelection); //이전에 선택한 행 제어
        grid.jqGrid('editRow',id, {keys: false}); //keys true=enter
        lastSelection = id;
    //}
}

//엑셀다운로드.
//jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/item/quotationExcelDown.lime');
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
		
		<form name="iForm" method="post"></form>
		<form name="frm" method="post">
			<div class="page-inner">
				<div class="page-title">
					<h3>
						Quotation
						<div class="page-right">
							<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
							<!--<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>-->
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
													<label class="search-h">Quotation 번호</label>
													<div class="search-c">
														<input type="text" class="search-input" name="r_quote_qt" value="${param.r_quote_qt}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													</div>
												</li>
												<li>
													<label class="search-h">품목코드</label>
													<div class="search-c">
														<input type="text" class="search-input" name="r_item_cd" value="${param.r_item_cd}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
													</div>
												</li>
												<li>
													<label class="search-h">등록일</label>
													<div class="search-c">
														<input type="text" class="search-input form-sm-d p-r-md" name="r_indate" value="${param.r_indate}" />
														<i class="fa fa-calendar i-calendar"></i>
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
								
							</div>
						</div>
					</div>
					<!-- //Row -->
				</div>
				<!-- //Main Wrapper -->
		
				<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			</div>
		</form>
	</main>

</body>
</html>