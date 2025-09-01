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
var ckNameJqGrid = 'admin/system/fireproofConfig/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"ACTIVE", label:'Active', width:100, align:'center', sortable:true, editable:true, edittype:'select', editoptions:{value:'Y:Y;N:N'} },
	{name:"DISPLAYORDER", label:'Display 순서', width:100, align:'center', sortable:true, editable:true, editoptions:{dataInit:initJqGridAutoNumeric(aNNumberOption, 'left'), dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '5');}}]} },
	{name:"KEYCODE", key:true, label:'코드', width:150, align:'center', sortable:true, formatter:setPtCode },
	{name:"FIREPROOFTYPE", label:'내화구조타입', width:200, align:'center', sortable:true, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '100');}}]} },
	{name:"DESC1", label:'설명1', width:200, align:'left', sortable:false, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '300');}}]} },
	{name:"DESC2", label:'설명2', width:370, align:'left', sortable:false, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '300');}}]} },
	{name:"FIRETIME", label:'시간', width:100, align:'center', sortable:true, formatter : setFiretime},
	{name:"FILENAME", label:'이미지', width:150, align:'center', sortable:false, formatter: setItiImage },
	{name:"CREATETIME", label:'등록일', width:180, align:'center', sortable:true, formatter:setInDateFormat },
	//{name:"PT_INDATE", label:'등록일', width:20, align:'center', sortable:true, formatter:'date', formatoptions:{newformat:'Y-m-d H:i'} }, // 시분 까지 노출해야 한다면 boral은 formatoptions 사용하면 안됨.
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
});

$(document).ready(function() {
	
});

function getGridList(){
	// grid init
	var searchData = getSearchData();
	$('#gridList').jqGrid({
		url: "${url}/admin/system/fireproofListAjax.lime",
		editurl: 'clientArray', //사용x
		//editurl: './deliveryspotUpAjax.lime',
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		multiselect: true,
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
			var h_dscode = $('#gridList').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
		//onSelectRow: editRow,
		onSelectAll: function(rowIdArr, status) { //전체 체크박스 선택했을때 onSelectRow가 실행이 안되고 onSelectAll 실행되네...
			//console.log('status : ', status); //status : true=전체선택했을때, false=전체해제했을때
			//console.log('rowIdArr : ', rowIdArr); //rowid 배열 타입
			//console.log('rowIdArr.length : ', rowIdArr.length);
			if(status){
				$.each(rowIdArr, function(i,e){
					var h_dscode = $('#gridList').find('#'+e).find('input[name="h_dscode"]').val();
					if('' != h_dscode){ //editRow
						editRow(e);
					}
				});
			}
		}
		/* 
		beforeProcessing: function(data, status, xhr){ // 서버로 부터 데이터를 받은 후 화면에 찍기 위한 processing을 진행하기 직전에 호출.
			if('0000' != data.RES_CODE){
				alert(data.RES_MSG);
				return false;
			}
		},
		*/
	});
}

var lastSelection;
// 행 편집.
function editRow(id){
	//alert('id : '+id+'\nlastSelection : '+lastSelection);
    if (id && id !== lastSelection) {
        var grid = $('#gridList');
		//grid.jqGrid('restoreRow',lastSelection); //이전에 선택한 행 제어
        grid.jqGrid('editRow',id, {keys: false}); //keys true=enter
        lastSelection = id;
    }
}

// 행 추가.
function addRow() {
	var rowData = {KEYCODE:'', ACTIVE:''};
	var rowId = $('#gridList').getGridParam("records")+1; //페이징 처리 시 현 페이지의 Max RowId 값+1
	$('#gridList').jqGrid('addRow', {initdata:rowData, position :'first'}); //addRow : onSelectRow 실행하네...
}

//세팅. 방화 코드 인풋.
function setPtCode(cellVal, options, rowObj){
	if('' == toStr(cellVal)){ // 등록 rowObj.PT_CODE 
		return '<input type="text" name="M_KEYCODE" placeholder="자동채번" value="" onkeyup=\'checkByte(this, "10");\' readonly="readonly"/>';
	}
	else{ // 수정
		return '<input type="hidden" name="R_KEYCODE" value="'+cellVal+'" readonly="readonly" />'+cellVal;
	}
}

// 세팅. 방화 등록일자.
function setInDateFormat(cellVal, options, rowObj){
	if('' == toStr(rowObj.CREATETIME )){ // 등록 
		return '자동생성';
	}
	else{ // 수정
		return ('' == toStr(cellVal)) ? '-' : toStr(cellVal).substring(0,10);
	}
}


/*파일 이미지 첨부 
function setDetailBtn(cellval, options, rowObject){
	return '<a href="${url}/admin/system/fireproofStructureFile.lime?file='+ rowObject.FILENAME +'" class="btn btn-default btn-xs">이미지</a>';
}*/

//파일 이미지 가져오기
function setItiImage(cellValue, options, rowdata) {
	return '<img src="${url}/data/fireproof/' + cellValue + '" onerror="this.src=\'${url}/include/images/admin/list_noimg.gif\'" width="30" alt="image" ' 
			+ 'onclick=\'itemDetail(this, "' + rowdata.KEYCODE +'");\' />';
}

function setFiretime(cellValue, options, rowdata) {
	return '<input type="number" name="M_FIRETIME" class="amountClass2 text-right" value="'+toStr(cellValue)+'" />';
}


//수정 페이지 이동 / 상세 팝업 띄우기.
function itemDetail(obj, keyCode){ //process=EDIT/VIEW(=팝업)
	// 파라미터 세팅.
	//var gridRowId = toStr($('#gridList').getGridParam('selrow'));

	// 팝업 세팅.
	var widthPx = 800;
	var heightPx = 450;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frmPop"]').find('input[name="r_itemcd"]').val(keyCode);
	
	window.open('', 'itemViewPop', options);
	$('form[name="frmPop"]').prop('action', '${url}/admin/system/itemViewPop.lime');
	$('form[name="frmPop"]').submit();

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
		 
		var process_type = ('' == toStr(trObj.find('input[name="R_KEYCODE"]').val())) ? 'ADD' : 'EDIT';
		
		//validation
		if(ckflag && '' == trObj.find('select[name="ACTIVE"]').val()){
			alert('상태를 선택해 주세요.');
			trObj.find('select[name="ACTIVE"]').focus();
			ckflag = false;
		}
		//if(ckflag) ckflag = validation(trObj.find('input[name="DISPLAYORDER"]')[0], 'Display 순서', 'value');
		//if(ckflag && 'ADD' == process_type) ckflag = validation(trObj.find('input[name="M_KEYCODE"]')[0], '코드', 'value');
		if(ckflag) ckflag = validation(trObj.find('input[name="FIREPROOFTYPE"]')[0], '내화구조타입', 'value');
		// if(ckflag) ckflag = validation(trObj.find('input[name="DESC1"]')[0], '우편번호', 'value');
		// if(ckflag) ckflag = validation(trObj.find('input[name="DESC1"]')[0], '설명1', 'value');
		// if(ckflag) ckflag = validation(trObj.find('input[name="DESC2"]')[0], '설명2', 'value');
		//if(ckflag) ckflag = validation(trObj.find('input[name="FIRETIME"]')[0], '시간', 'npoint'); 
		
		if(!ckflag){
			$(obj).prop('disabled', false);
			return false;
		}
		
		// aForm append.
		iFormObj.append('<input type="hidden" name="r_processtype" value="' + process_type + '" />');
		if('ADD' == process_type){
			iFormObj.append('<input type="hidden" name="r_keycode" value="' + toStr(trObj.find('input[name="M_KEYCODE"]').val()) + '" />');	
		}else{
			iFormObj.append('<input type="hidden" name="r_keycode" value="' + toStr(trObj.find('input[name="R_KEYCODE"]').val()) + '" />');
		}
		
		iFormObj.append('<input type="hidden" name="m_active" value="' + toStr(trObj.find('select[name="ACTIVE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_displayorder" value="' + toStr(trObj.find('input[name="DISPLAYORDER"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_fireprooftype" value="' + toStr(trObj.find('input[name="FIREPROOFTYPE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_desc1" value="' + toStr(trObj.find('input[name="DESC1"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_desc2" value="' + toStr(trObj.find('input[name="DESC2"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_firetime" value="' + toStr(trObj.find('input[name="M_FIRETIME"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_filename" value="' + toStr(trObj.find('input[name="M_FILENAME"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_createtime" value="' + toStr(trObj.find('input[name="CREATETIME"]').val()) + '" />');
	}
	//console.log($(iFormObj).html());
	
	if(!ckflag){
		$(obj).prop('disabled', false);
		return false;
	}
	
	if (confirm('저장 하시겠습니까?')) {
	var iFormData = iFormObj.serialize();

			var url = '${url}/admin/system/insertUpdateFireproofAjax.lime'; 
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
			
	}
}


//삭제
function dataDel(obj, val) {
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
		 
		var process_type = 'DEL';
		
		// aForm append.
		iFormObj.append('<input type="hidden" name="r_processtype" value="' + process_type + '" />');
		if('ADD' == process_type){
			iFormObj.append('<input type="hidden" name="r_keycode" value="' + toStr(trObj.find('input[name="M_KEYCODE"]').val()) + '" />');	
		}else{
			iFormObj.append('<input type="hidden" name="r_keycode" value="' + toStr(trObj.find('input[name="R_KEYCODE"]').val()) + '" />');
		}
		
		iFormObj.append('<input type="hidden" name="m_active" value="' + toStr(trObj.find('select[name="ACTIVE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_displayorder" value="' + toStr(trObj.find('input[name="DISPLAYORDER"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_fireprooftype" value="' + toStr(trObj.find('input[name="FIREPROOFTYPE"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_desc1" value="' + toStr(trObj.find('input[name="DESC1"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_desc2" value="' + toStr(trObj.find('input[name="DESC2"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_firetime" value="' + toStr(trObj.find('input[name="M_FIRETIME"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_filename" value="' + toStr(trObj.find('input[name="M_FILENAME"]').val()) + '" />');
		iFormObj.append('<input type="hidden" name="m_createtime" value="' + toStr(trObj.find('input[name="CREATETIME"]').val()) + '" />');
	}
	
	if (confirm('삭제 하시겠습니까?')) {
		var iFormData = iFormObj.serialize();
		var url = '${url}/admin/system/insertUpdateFireproofAjax.lime'; 
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
	var rl_fireproof = $('input[name="rl_fireproof"]').val();
	var sData = {
		rl_fireproof : rl_fireproof
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

/*
// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	
	formPostSubmit('frm', '${url}/admin/system/fireproofExcelDown.lime');
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
}*/
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
		
		<%-- 임의 form --%>
		<form name="iForm" method="post"></form>
		<%-- <form name="uForm" method="post" action="${url}/admin/system/deliverySpotEditPop.lime" target="deliverySpotEditPop"></form> --%>
		
		<form name="frm" method="post">
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					내화구조타입 관리
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
												<label class="search-h">내화구조타입</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_fireproof" value="${param.rl_fireproof}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
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
									<button type="button" class="btn btn-danger" onclick="dataDel(this, '');">삭제</button>
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
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>
	
	
</body>

</html>