<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
<%--  NUMBER 타입 INPUT 박스에 화살표 제거   --%>
/* Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

/* Firefox */
input[type=number] {
    -moz-appearance: textfield;
}
</style>
<script type="text/javascript">

//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/item/itemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"ITI_FILE1", label:'이미지', width:90, align:'center', sortable:true, formatter:setItiImage1},
	{name:"ITEM_CD", key:true, label:'품목코드', width:150, align:'center', sortable:true},
	{name:"DESC1", label:'품목명1', width:300, align:'left', sortable:true},
	{name:"DESC2", label:'품목명2', width:300, align:'left', sortable:true},
	{name:"THICK_NM", label:'두께', width:100, align:'right', sortable:true},
	{name:"WIDTH_NM", label:'폭', width:100, align:'right', sortable:true},
	{name:"LENGTH_NM", label:'길이', width:100, align:'right', sortable:true},
	{name:"UNIT4", label:'구매단위', width:100, align:'center', sortable:true},
	{name:"ITI_SORT", label:'노출순서', width:100, align:'center', sortable:false, formatter : setSortInput},
// 	{name:"SEARCH_TEXT", label:'SEARCH_TEXT', width:20, align:'left', sortable:false},
	{name:"ITI_PALLET", label:'파레트적재단위', width:140, align:'right', sortable:true, formatter:setPallet},
	{name:"", label:'기능', width:120, align:'center', sortable:false, formatter:setEditBtn},
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
	categorySelect('1');
});

$(document).ready(function() {
	
});

function getGridList(){
	console.log('getGridList');
	// grid init
	var searchData = getSearchData();
	$("#gridList").jqGrid({
		url: "${url}/admin/item/getItemListAjax.lime",
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
		onSelectRow: function(rowId) {

		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

function setItiImage1(cellValue, options, rowdata) {
	return '<img src="${url}/data/item/' + cellValue + '" onerror="this.src=\'${url}/include/images/admin/list_noimg.gif\'" width="30" alt="image" />';
}

function setSortInput(cellval, options, rowObject) {
	    var iti_sort = (rowObject.ITI_SORT) ? rowObject.ITI_SORT : '';
		var retStr = '<input type="number" name="m_itisort" id="m_itisort_'+rowObject.ITEM_CD+'" maxlength="4"  oninput="maxLengthCheck(this);" style="text-align: right;" value="'+iti_sort+'"/>';
		return retStr;
}

function setPallet(cellval, options, rowObject){
	return addComma(cellval);
}

function setEditBtn(cellval, options, rowObject){
	var retStr = '<a href="javascript:;"  class="btn btn-default btn-xs" onclick=\'itemDetail(this, "'+rowObject.ITEM_CD+'", "VIEW");\'>상세</a>';
	
	if(isWriteAuth){
		retStr += ' <a href="javascript:;"  class="btn btn-default btn-xs" onclick=\'itemDetail(this, "'+rowObject.ITEM_CD+'", "EDIT");\'>수정</a>';
		return retStr;		
	}else{
		return retStr;
	}
}

/*
   NUMBER타입 INPUT 자리수 제한(태그 속성 maxlength값만큼 제한)
 */
function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}


// 수정 페이지 이동 / 상세 팝업 띄우기.
function itemDetail(obj, itemCd, process){ //process=EDIT/VIEW(=팝업)
	// 파라미터 세팅.
	//var gridRowId = toStr($('#gridList').getGridParam('selrow'));
	
	if('VIEW' == process){
		// 팝업 세팅.
		var widthPx = 800;
		var heightPx = 750;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frmPop"]').find('input[name="r_itemcd"]').val(itemCd);
		
		window.open('', 'itemViewPop', options);
		$('form[name="frmPop"]').prop('action', '${url}/admin/item/itemViewPop.lime');
		$('form[name="frmPop"]').submit();
	}
	else{ // EDIT
		formGetSubmit('${url}/admin/item/itemEdit.lime', 'r_itemcd='+itemCd+'&');
	}
}

function getSearchData(){
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	var rl_desc1 = $('input[name="rl_desc1"]').val();
	var rl_desc2 = $('input[name="rl_desc2"]').val();
	//var rl_searchtext = $('input[name="rl_searchtext"]').val();
	var rl_itemcd = $('input[name="rl_itemcd"]').val();
	var rl_thicknm = $('input[name="rl_thicknm"]').val();
	var rl_widthnm = $('input[name="rl_widthnm"]').val();
	var rl_lengthnm = $('input[name="rl_lengthnm"]').val();
	
	var ri_existimageynarr = '';
	$('input:checkbox[name="ri_existimageyn"]:checked').each(function(i,e) {
		if(i==0) ri_existimageynarr = $(e).val();
		else ri_existimageynarr += ','+$(e).val();
	});
	$('input[name="ri_existimageynarr"]').val(ri_existimageynarr); // Use For ExcelDownload.
	
	var ri_existrecommendarr = '';
	$('input:checkbox[name="ri_existrecommend"]:checked').each(function(i,e) {
		if(i==0) ri_existrecommendarr = $(e).val();
		else ri_existrecommendarr += ','+$(e).val();
	});
	$('input[name="ri_existrecommendarr"]').val(ri_existrecommendarr); // Use For ExcelDownload.
	
	var sData = {
		r_salescd1nm : r_salescd1nm
		, r_salescd2nm : r_salescd2nm
		, r_salescd3nm : r_salescd3nm
		, r_salescd4nm : r_salescd4nm
		, rl_desc1 : rl_desc1
		, rl_desc2 : rl_desc2
		//, rl_searchtext : rl_searchtext
		, rl_itemcd : rl_itemcd
		, rl_thicknm : rl_thicknm
		, rl_widthnm : rl_widthnm
		, rl_lengthnm : rl_lengthnm
		, ri_existimageynarr : ri_existimageynarr
		, ri_existrecommendarr : ri_existrecommendarr
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

function categorySelect(ct_level) {
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	//var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	
	var params = 'r_ctlevel='+ct_level+'&';
	if('2' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&';
	if('3' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&';
	if('4' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&r_salescd3nm='+r_salescd3nm+'&';
	
	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : '${url}/admin/base/getCategoryListAjax.lime',
		success : function(data) {
			var htmlText = '<option value="">선택하세요.</option>';
			if('1' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				$('select[name="r_salescd2nm"]').empty();
				$('select[name="r_salescd2nm"]').append(htmlText);
				
				$('select[name="r_salescd1nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd1nm"]').append(htmlText);
			}
			if('2' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				
				$('select[name="r_salescd2nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd2nm"]').append(htmlText);
			}
			if('3' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				
				$('select[name="r_salescd3nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd3nm"]').append(htmlText);
			}
			if('4' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				
				$('select[name="r_salescd4nm"]').empty();
				$(data).each(function(i,e){
					htmlText += '<option value="'+e.CATEGORY_NAME+'">'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd4nm"]').append(htmlText);
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

// 엑셀다운로드.
// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/item/itemExcelDown.lime');
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


/*
    ITEMINFO SORT 숨김
 */
function updateItemInfoSortAjax(obj) {
	$(obj).prop('disabled', true);

    var r_itemcdArr = $("#gridList").getGridParam('selarrrow'),
        r_itemcdArrLen = r_itemcdArr.length,
		m_itisortArr = [];

    if(!r_itemcdArrLen){
		alert("품목을 선택해주세요.");
		$(obj).prop('disabled', false);
		return;
	}
	var m_itisort = '';
    for(var i = 0; i < r_itemcdArrLen; i++){
		m_itisort = $('#m_itisort_' + r_itemcdArr[i]).val()
    	if('' == m_itisort || Number(m_itisort) < 1){
    		alert('노출순서는 0이상의 숫자만 입력해주세요. ');
    		// alert('노출순서를 입력하지 않은 품목이 포함되어 있습니다. ');
			$(obj).prop('disabled', false);
    		return false;
		}
        m_itisortArr.push(m_itisort);
    }

    if (confirm('저장 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : {r_itemcdArr : r_itemcdArr , m_itisortArr : m_itisortArr},
			type : 'POST',
            traditional : true,
			url : '${url}/admin/item/updateItemInfoSortAjax.lime',
			success : function(data) {
				alert(data.RES_MSG);
				if (data.RES_CODE == '0000') {
					document.location.reload();
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
		<form name="frmPop" method="post" target="itemViewPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_itemcd" type="hidden" value="" />
		</form>
		
		<%-- 임의 form --%>
		<form name="uForm" method="post"></form>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					품목현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="document.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
			<form name="frm" method="post">
				<input type="hidden" name="ri_existrecommendarr" value="" />
				<input type="hidden" name="ri_existimageynarr" value="" />
			
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm">
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">품목분류</label>
												<div class="search-c">
													<select class="form-control form-sm" name="r_salescd1nm" id="r_salescd1nm" onchange="categorySelect(2); dataSearch();">
														<option value="">선택하세요</option>
													</select>
													<select class="form-control form-sm" name="r_salescd2nm" id="r_salescd2nm" onchange="categorySelect(3); dataSearch();">
														<option value="">선택하세요</option>
													</select>
													<select class="form-control form-sm" name="r_salescd3nm" id="r_salescd3nm" onchange="dataSearch();">
														<option value="">선택하세요</option>
													</select>
 													<!-- <select class="form-control form-sm" name="r_salescd4nm" id="r_salescd4nm" onchange="dataSearch();"> 
														<option value="">선택하세요</option>
													</select> -->
												</div>
											</li>
											<li>
												<label class="search-h">품목명검색1</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_desc1" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">품목명검색2</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_desc2" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
 											<!-- <li>
												<label class="search-h">SEARCH-TEXT</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_searchtext" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>  -->
											<li>
												<label class="search-h">품목코드</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_itemcd" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">두께</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_thicknm" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">폭</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_widthnm" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">길이</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_lengthnm" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li>
											<li>
												<label class="search-h">이미지</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="ri_existimageyn" value="N" onclick="dataSearch();" />N</label>
												</div>
											</li>
											<li>
												<label class="search-h">관련품목</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="ri_existrecommend" value="N" onclick="dataSearch();" />N</label>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							</form>
							
							<div class="panel-body">
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="btnList writeObjectClass">
                                    <button type="button" onclick="updateItemInfoSortAjax(this)"  class="btn btn-info">노출순서저장</button>
									<button type="button" onclick="location.href='${url}/admin/item/itemEditExcel.lime'" class="btn btn-gray-d">일괄관리</button>
								</div>
								<div class="table-responsive in">
                                    <form name=""></form>
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
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