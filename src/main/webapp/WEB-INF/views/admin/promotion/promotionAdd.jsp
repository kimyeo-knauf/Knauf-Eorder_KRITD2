<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

</head>
<script type="text/javascript">
var pageType = '${pageType}'; <%-- ADD/EDIT --%>

//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/orderAdd/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"ITI_FILE1", label:'이미지', width:135, align:'center', sortable:false, formatter:setItiImage1},
	{ name:"ITEM_CD", label:'품목코드', key:true, sortable:false, width:200, align:'center', formatter:setItemCd },
	// { name:"DESC1", label:'품목명', width:100, sortable:false, align:'left' },
	{name:"DESC1", label:'품목명1', width:500, align:'left', sortable:false},
	{name:"DESC2", label:'품목명2', width:500, align:'left', sortable:false},
	{name:"UNIT", label:'구매단위', width:150, align:'center', sortable:false},
	{ name:"", label:'기능', sortable:false, width:150, align:'center', formatter:setButton },
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

$(document).ready(function(){

	if('EDIT' == pageType){

		var prm_type = '${promotionOne.PRM_TYPE}';
		var prm_seq =  '${promotionOne.PRM_SEQ}';
		if('2' == prm_type){
			$('#noList').hide();
			getItemListAjax(prm_seq,pageType);
		}

	}

	// dropify 파일 확장자,크기 체크
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileExtension', function(evt, el){
		alert('gif,png,jpg,jpeg 파일만 업로드 할 수 있습니다.');
		evt.stopImmediatePropagation();
	});

	drEvent.on('dropify.error.fileSize', function(evt, el){
		alert('이미지는 10MB 이하로 등록해 주세요.');
		evt.stopImmediatePropagation();
	});

	//파일다운로드 세팅
	$('.dropify-filename-inner').each(function(i,e){
		var fileInputName = $(e).closest('td').find('input').attr('name');
		var isImage1 = 'm_prmimage1' == fileInputName;	// false = m_prmimage2

		var fileName = (isImage1) ? '${promotionOne.PRM_IMAGE1}' : '${promotionOne.PRM_IMAGE2}';
		var fileType = (isImage1) ? '${promotionOne.PRM_IMAGE1TYPE}' : '${promotionOne.PRM_IMAGE2TYPE}';

		var textHtml = '<a href="javascript:;" onclick=\'fileDown("'+fileName+'","'+fileType+'");\'>'+fileName+'</a>';

		$(e).html(textHtml);
	});

	initDatepicker();
});


/**
데이트피커 설정
 */
function initDatepicker(){
	var $m_prmsdate = $('input[name="m_prmsdate"]'),
		$m_prmedate = $('input[name="m_prmedate"]');

	//시작일 데이트피커
	$m_prmsdate.datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$m_prmedate.datepicker('setStartDate', minDate);
	});

	//마감일 데이트피커
	$m_prmedate.datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$m_prmsdate.datepicker('setEndDate', maxDate);
	});

	//수정 시 이전날짜 이후날짜 제한 설정
	var prm_sdate = '${promotionOne.PRM_SDATE}',
		prm_edate = '${promotionOne.PRM_EDATE}';

	if(prm_sdate){
		$m_prmsdate.datepicker('setDate', prm_sdate.substring(0,10));
		$m_prmedate.datepicker('option','minDate',prm_sdate.substring(0,10));
	}

	if(prm_edate){
		$m_prmedate.datepicker('setDate', prm_edate.substring(0,10));
		$m_prmsdate.datepicker('option','maxDate',prm_edate.substring(0,10));
	}
}

// 품목 리스트 grid 가져오기.
function getItemListAjax(prm_seq,page_type){
	$("#gridList").jqGrid({
		url: "${url}/admin/promotion/getPromotionItemListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_prmiprmseq : prm_seq
			, r_pagetype : page_type
		},
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		multiselect:false,
		rownumbers: true,
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
		jsonReader : {
			root : 'list'
		},
		loadComplete: function(data){
			//console.log($('#gridList').getGridParam('records'));
			initAutoNumeric();
		},
		gridComplete: function(){
			//alert($('#gridList').getGridParam('records'));
			// 조회된 데이터가 없을때
			var grid = $('#gridList');
			var emptyText = grid.getGridParam('emptyDataText'); //NO Data Text 가져오기.
			var container = grid.parents('.ui-jqgrid-view'); //Find the Grid's Container
			if(0 == grid.getGridParam('records')){
				//container.find('.ui-jqgrid-hdiv, .ui-jqgrid-bdiv').hide(); //Hide The Column Headers And The Cells Below
				//container.find('.ui-jqgrid-titlebar').after(''+emptyText+'');
			}
		},
		//emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

function setItiImage1(cellValue, options, rowdata) {
	if(cellValue == null){
		return '<img src="${url}/data/item/' + cellValue + '" onerror="this.src=\'${url}/include/images/admin/list_noimg.gif\'" width="30" alt="image" />';
	}else{
		return cellValue;
	}
}


function setItemCd(cellValue, options, rowdata) {
	return cellValue+'<input type="hidden" name="m_itemcd" value="'+cellValue+'" />';
}

function setButton(cellValue, options, rowdata) {
	return '<button type="button"  class="btn btn-default btn-xs" onclick=\'delItem(this, "'+options.rowId+'");\'>삭제</button>';
}

// 품목 선택 팝업 띄우기.
function openItemPop(obj){
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;

	$('form[name="frm_pop"]').remove();

	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="itemListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="promotionadd" />'; //orderadd
	htmlText += '	<input type="hidden" name="r_multiselect" value="true" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '</form>';
	$('body').append(htmlText);

	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/itemListPop.lime';
	window.open('', 'itemListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

/**
 * 현재 출력 되고 있는 레코드 개수 반환
 */
function getGridReccount() {
	var gridReccount = $('#gridList').getGridParam('reccount');

	return gridReccount;
}

//return 품목 팝업에서 다중 선택.
function setItemFromPop(jsonArray){
	if($('#noList').is(':visible')){
		$('#noList').hide();
		getItemListAjax('','ADD');
	}

	// 행 추가.
	var jsonNewArray = new Array();

	var nowViewItemCd = '';
	$('input[name="m_itemcd"]').each(function(i,e) {
		nowViewItemCd += $(e).val()+',';
	});

	for(var x=0,y=jsonArray.length; x<y; x++){
		//console.log('jsonArray[] : ', jsonArray[x]);
		var selectedItemCd = jsonArray[x]['ITEM_CD'];
		if(0 > nowViewItemCd.indexOf(selectedItemCd+',')){
			jsonNewArray.push(jsonArray[x]);
		}
	}

	var newRow = {position:"last", initdata:jsonNewArray};
	$("#gridList").jqGrid('addRow', newRow);
	initAutoNumeric();
}

// 품목 삭제.
function delItem(obj, rowId){
	$("#gridList").jqGrid("delRowData", rowId); // 행 삭제

	// 행이 모두 삭제된 경우 초기화.
	var rowCnt = $("#gridList").getGridParam("reccount");
	if(0 == rowCnt){
		$('#noList').show();
		$("#gridList").jqGrid("GridUnload");
	}
}

// 유효성 체크.
function dataValidation(){
	var ckflag = true;
	var m_prmtype = $('input[name="m_prmtype"]:checked').val();

	if(ckflag) ckflag = validation($('input[name="m_prmtitle"]')[0], '이벤트명', 'value');
	if(ckflag) ckflag = validation($('input[name="m_prmsdate"]')[0], '시작일', 'value');
	if(ckflag) ckflag = validation($('input[name="m_prmedate"]')[0], '종료일', 'value');

	if('ADD' == pageType){
		if (ckflag && !$('input[name="m_prmimage2"]').val()) {
			alert('리스트이미지를 등록해주세요.');
			ckflag = false;
		}

		if (ckflag && !$('input[name="m_prmimage1"]').val()) {
			alert('메인이미지를 등록해주세요.');
			ckflag = false;
		}
	}


	//이벤트 구분이 품목일 때
	if('2' == m_prmtype){
		// 품목선택 및 품목관련 입력 여부.
		if(ckflag){
			if($('#noList').is(':visible')){
				alert('품목을 선택해 주세요.');
				ckflag = false;
			}

			if(ckflag &&  getGridReccount() > 10){
				alert('이벤트 품목은 최대 10개까지만 등록할 수 있습니다.');
				ckflag = false;
			}
		}
	}

	return ckflag;
}

//이벤트등록
function dataIn(obj){
	$(obj).prop('disabled', true);

	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}

	if(confirm('저장하시겠습니까?')){

		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'POST',
			url : '${url}/admin/promotion/insertUpdatePromotionAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					formGetSubmit('${url}/admin/promotion/promotionList.lime', '');
				}
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});

		$(obj).prop('disabled', false);
	}
	else{
		$(obj).prop('disabled', false);
	}
}

/**
 * 파일다운로드
 */
function fileDown(file_name,file_type){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');

	// 파일 다운로드.
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/promotion/promotionFileDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
	fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
	fileFormHtml += '	<input type="hidden" name="filetoken" value="'+token+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); // common.js 위치.

	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
		//console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
	}, 1000 );
}

/**
 * 링크여부에 따라 URL 필드 숨김
 */
function toggledByPrmtype(val) {
	if('1' === val){
		$('#itemGridDiv').css('display', 'none');
	}else{
		$('#itemGridDiv').css('display', 'block');
	}
}

</script>

<body class="page-header-fixed pace-done compact-menu searchHidden">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>

		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					<c:choose>
						<c:when test="${'ADD' eq pageType}">이벤트등록</c:when>
						<c:when test="${'EDIT' eq pageType}">이벤트수정</c:when>
						<c:otherwise></c:otherwise>
					</c:choose>
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="목록" onclick="document.location.href='${url}/admin/promotion/promotionList.lime'"><i class="fa fa-list-ul"></i><em>목록</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form method="post" name="frm" enctype="multipart/form-data">
							<input type="hidden" name="r_prmseq" value="${promotionOne.PRM_SEQ}" /> <%-- 주문번호 --%>
							<input type="hidden" name="r_processtype" value="${pageType}" /> <%-- 주문번호 --%>

							<%-- Create an empty container for the picker popup. --%>
							<div id="dateTimePickerDivId"></div> 
							
							<div class="panel-body">
								<h5 class="table-title">이벤트 등록</h5>
								<div class="btnList">
<%--									<button type="button" class="btn btn-info writeObjectClass" onclick="dataIn(this, '00');">저장</button>--%>
									<button type="button" class="btn btn-info writeObjectClass" onclick="dataIn(this);">저장</button>
								</div>
								
								<div class="table-responsive">
									<table id="" class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="12%" />
											<col width="38%" />
											<col width="12%" />
											<col width="38%" />
										</colgroup>
										<tbody>
											<tr>
												<th>이벤트명 * </th>
												<td colspan="3">
													<input type="text" class="w-40" name="m_prmtitle" value="${promotionOne.PRM_TITLE}" onkeyup="checkByte(this, '160')"; />
												</td>
											</tr>
											<tr>
												<th>시작일 * </th>
												<td>
													<input type="text" class="w-40 p-r-md" name="m_prmsdate" value="${fn:substring(promotionOne.PRM_SDATE,0,10)}" onkeyup="checkByte(this, '40')"  autocomplete="off" readonly/>
													<i class="fa fa-calendar i-calendar"></i>
												</td>

												<th>종료일 * </th>
												<td>
													<input type="text" class="w-40 p-r-md" name="m_prmedate" value="${fn:substring(promotionOne.PRM_EDATE,0,10)}" onkeyup="checkByte(this, '40')" utocomplete="off" readonly/>
													<i class="fa fa-calendar i-calendar"></i>
												</td>
											</tr>
											<tr>
												<th>리스트이미지 * <i class="f-s-11">(720*485)px</i></th>
												<td>
													<input type="file" class="dropify" name="m_prmimage2" value="${promotionOne.PRM_IMAGE2}" <c:if test="${!empty promotionOne.PRM_IMAGE2}">data-default-file="${url}/data/promotion/${promotionOne.PRM_IMAGE2}"</c:if>
														   data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false"/>
												</td>

												<th>메인이미지 * <i class="f-s-11">(1350*500)px</i></th>
												<td>
													<input type="file" class="dropify" name="m_prmimage1" value="${promotionOne.PRM_IMAGE1}" <c:if test="${!empty promotionOne.PRM_IMAGE1}">data-default-file="${url}/data/promotion/${promotionOne.PRM_IMAGE1}"</c:if>
														   data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false"/>
												</td>
											</tr>
											<tr>
												<th>이벤트구분 * </th>
												<td colspan="3" class="radio">
													<label><input type="radio" name="m_prmtype" onclick="toggledByPrmtype(this.value);" value="1" <c:if test="${empty promotionOne.PRM_TYPE or '1' eq promotionOne.PRM_TYPE}">checked="checked"</c:if> />공지</label>
													<label><input type="radio" name="m_prmtype" onclick="toggledByPrmtype(this.value);" value="2" <c:if test="${'2' eq promotionOne.PRM_TYPE}">checked="checked"</c:if> />품목</label>
												</td>
											</tr>
										</tbody>
									</table>
									<div class="m-t-md f-s-16 f-red">* 이미지 등록은 GIF, PNG, JPG, JPEG 파일만 가능합니다.</div>
								</div>
							</div>
								
							<div class="panel-body" id="itemGridDiv" <c:if test="${empty promotionOne.PRM_TYPE or '1' eq promotionOne.PRM_TYPE}">style="display: none;"</c:if>>
								<h5 class="table-title">품목</h5>
								<div class="btnList writeObjectClass">
									<a href="javascript:;" onclick="openItemPop(this);" class="btn btn-default">품목선택</a>
									<!-- <a href="javascript:;" onclick="delItem(this);" class="btn btn-danger">삭제</a> -->
								</div>
								<div class="table-responsive in min">
									<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
									</table>
									
									<table id="noList" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td>품목을 선택해 주세요.</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							</form>
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>
</html>