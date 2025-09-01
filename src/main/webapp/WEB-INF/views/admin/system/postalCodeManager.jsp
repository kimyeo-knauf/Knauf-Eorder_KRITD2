<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />

<script type="text/javascript">
console.log("PostalCode config page");

var ckNameJqGrid = 'admin/system/postalCodeManager/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:'USE_F', label:'사용여부', width:100, align:'center', sortable:true, editable:true, edittype:'select', editoptions:{value:'Y:Y;N:N'} },
	{name:'ZIP_CD', label:'우편번호', width:100, align:'center', sortable:false, editable:true },
	{name:'ADDR', label:'주소', width:500, align:'left', sortable:false, editable:true },
	{name:'REF', label:'참고', width:300, align:'left', sortable:false, editable:true },
	{name:'INSERT_DT', label:'등록일', width:200, align:'center', sortable:true, editible:false, /*formatter:'date', formatoptions:{newformat:'Y-m-d'}*/ },
	{name:'PROC_TYPE', label:'타입', width:100, align:'center', editable:true, hidden:true },
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
	
});

function getGridList(){
	// grid init
	var searchData = getSearchData();
	$('#gridList').jqGrid({
		url: "${url}/admin/system/postalCodeListAjax.lime",
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		multiselect: true,
		rowNum : 10,
		rownumbers: true,
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
		//onSelectRow: editRow,
		onSelectAll: function(rowIdArr, status) { //전체 체크박스 선택했을때 onSelectRow가 실행이 안되고 onSelectAll 실행되네...
			if(status){
				$.each(rowIdArr, function(i,e){
					var h_dscode = $('#gridList').find('#'+e).find('input[name="h_dscode"]').val();
					if('' != h_dscode){ //editRow
						editRow(e);
					}
				});
			}
		}
	});
}

var lastSelection;


/*
//우편번호 Input : editable column > editionoptions > custom_element
function editCellElem1(value, options){
	var rowId = options.id.split('_')[0]; // rowid 가져올 방법이 이것밖에...
	//console.log('custom_element : ', value+'\t options.name : '+options.name+'\t options.id'+options.id+'\t options'+options+'\t rowId'+rowId);
	
	var retTxt = '<input type="text" id="'+options.id+'" name="'+options.name+'" value="'+value+'" onclick=\'openPostPopById("'+rowId+'_PT_ZONECODE", "'+rowId+'_PT_ADDR1", "'+rowId+'_PT_ADDR2", "'+rowId+'_PT_ZIPCODE");\' onkeyup=\'checkByte(this, "7");\' />';
	return retTxt;
}

// 주소 Input : editable column > editionoptions > custom_element
function editCellElem2(value, options){
	var rowId = options.id.split('_')[0]; // rowid 가져올 방법이 이것밖에...
	
	var retTxt = '<input type="text" class="editable" style="width: 98%;" id="'+options.id+'" name="'+options.name+'" value="'+value+'" onkeyup=\'checkByte(this, "100");\' />';
	return retTxt;
}*/

function getSearchData(){
	var r_zipcode = $('input[name="r_zipcode"]').val();
	var r_useflagarr = '';
	$('input:checkbox[name="ri_useruse"]:checked').each(function(i,e) {
		if(e==0) r_useflagarr = $(e).val();
		else r_useflagarr += ','+$(e).val();
	});
	var sData = {
		r_zipcode : r_zipcode, 
		r_useflag : r_useflagarr
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

// 행 추가.
function addRow() {
	var rowData = {ZIP_CD:'', ADDR:'', PROC_TYPE:'ADD', };
	var rowId = $('#gridList').getGridParam("records")+1; //페이징 처리 시 현 페이지의 Max RowId 값+1
	$('#gridList').jqGrid('addRow', {initdata:rowData, position :'first'}); //addRow : onSelectRow 실행하네...
}
//저장/수정.
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
		
		//validation
		if(ckflag) ckflag = validation(trObj.find('input[name="ZIP_CD"]')[0], '우편번호', 'value');
		if(ckflag) ckflag = validation(trObj.find('input[name="PROC_TYPE"]')[0], '타입', 'value');
		
		if(!ckflag){
			$(obj).prop('disabled', false);
			return false;
		}

		var zipcd = toStr(trObj.find('input[name="ZIP_CD"]').val());
		var chkStyle = /[0-9]$/ ;      //체크 방식(숫자)
		if(!chkStyle.test(zipcd)){
			alert('우편번호에 숫자를 입력해 주세요.');
			$(obj).prop('disabled', false);
			return false;
		}

		if(zipcd.length != 5) {
			alert('우편번호는 5자리 이어야합니다.');
			$(obj).prop('disabled', false);
			return false;
		}
		
		iFormObj.append('<input type="hidden" name="r_proctype" value="' + toStr(trObj.find('input[name="PROC_TYPE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="r_zipcd" value="' + toStr(trObj.find('input[name="ZIP_CD"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="r_addr" value="' + toStr(trObj.find('input[name="ADDR"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="r_ref" value="' + toStr(trObj.find('input[name="REF"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="r_usef" value="' + toStr(trObj.find('select[name="USE_F"]').val()) + '" />');
	}
	console.log($(iFormObj).html());
	
	if(!ckflag){
		$(obj).prop('disabled', false);
		return false;
	}

	$(obj).prop('disabled', false);
	if (confirm('저장 하시겠습니까?')) {
		var iFormData = iFormObj.serialize();
		var url = '${url}/admin/system/insertUpdatePostalCodeAjax.lime'; 
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

//엑셀다운로드.
//jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/system/postalCodeConfigExcelDown.lime');
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
						우편번호 관리
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
													<label class="search-h">우편번호</label>
													<div class="search-c">
														<input type="text" class="search-input" name="r_zipcode" value="${param.r_zipcode}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
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
									<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
									<div class="btnList writeObjectClass">
										<button type="button" class="btn btn-warning" onclick="addRow();">추가</button>
										<button type="button" class="btn btn-info" onclick="dataInUp(this, '');">저장</button>
									</div>
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