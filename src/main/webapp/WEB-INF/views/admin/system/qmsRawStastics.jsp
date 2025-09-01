<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />
<style type="text/css">
#gview_gridList > div.ui-state-default.ui-jqgrid-hdiv > div > table > thead > tr.ui-jqgrid-labels.ui-sortable.jqg-second-row-header > th:nth-child(3)
{
	border-right: 1px solid #e1e1e1 !important;
}
#gview_gridList > div.ui-state-default.ui-jqgrid-hdiv > div > table > thead > tr.ui-jqgrid-labels.ui-sortable.jqg-second-row-header > th:nth-child(4) 
{
	border-left: 1px solid #e1e1e1 !important;
	border-right: 1px solid #e1e1e1 !important;
}
#gview_gridList > div.ui-state-default.ui-jqgrid-hdiv > div > table > thead > tr.ui-jqgrid-labels.ui-sortable.jqg-second-row-header > th:nth-child(5)
{
	border-left: 1px solid #e1e1e1 !important;
	border-right: 1px solid #e1e1e1 !important;
}
#gview_gridList > div.ui-state-default.ui-jqgrid-hdiv > div > table > thead > tr.ui-jqgrid-labels.ui-sortable.jqg-second-row-header > th:nth-child(6)
{
	border-left: 1px solid #e1e1e1 !important;
}
</style>
<script type="text/javascript">
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/system/qmsRawStastics/jqGridCookie/gridList'; // 페이지별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	//{name:"USERID", key:true, label:'담당자ID', 		width:10, align:'center', sortable:true, hidden:true },
	//내화구조 정보
	{name:"REFRACT_COMPANY", label:'회사명', 					width:200, align:'center', sortable:true },
	{name:"REFRACT_ITEM", label:'품목', 					width:200, align:'center', sortable:true },
	{name:"REFRACT_AUTH_NUMBER", label:'인정번호', 				width:200, align:'center', sortable:true },
	{name:"REFRACT_TIME", label:'내화성능(시간)', 			width:110, align:'center', sortable:true },
	{name:"REFRACT_NAME", label:'상품명', 					width:200, align:'center', sortable:true },
	{name:"REFRACT_NAME", label:'내화구조명', 				width:200, align:'center', sortable:true },
	{name:"REFRACT_STANDARD", label:'규격', 					width:200, align:'center', sortable:true },
	{name:"REFRACT_CNT", label:'수량', 					width:200, align:'center', sortable:true },
	{name:"REFRACT_REMARK", label:'비고', 					width:200, align:'center', sortable:true },
	//시공현장 정보
	{name:"CONSTRUCTION_SITE", label:'현장명', 				width:200, align:'left', sortable:true },
	{name:"CONSTRUCTION_SIDO", label:'현장주소(광역시, 도)',width:200, align:'center', sortable:true },
	{name:"CONSTRUCTION_ADDR", label:'현장주소(상세)', 		width:200, align:'center', sortable:true },
	{name:"CONSTRUCTION_COMPANY", label:'시공회사', 			width:200, align:'center', sortable:true },
	{name:"SUPERVISION_COMPANY" , label:'감리회사', 			width:200, align:'center', sortable:true },	

	//공급업자 정보
	{name:"SUPPLIER_COMPANY", label:'회사명', 					width:200, align:'center', sortable:true },
	{name:"SUPPLIER_USER", label:'확인자',					width:200, align:'center', sortable:true },
	{name:"SUPPLIER_BS_NUMBER", label:'사업자등록증번호', 		width:200, align:'center', sortable:true },
	{name:"SUPPLIER_ADDR", label:'소재지', 					width:200, align:'center', sortable:true },
	{name:"SUPPLIER_TELL_NUMBER", label:'전화번호', 				width:200, align:'center', sortable:true },	

	//시공업자 정보
	{name:"CNSTR_NM", label:'회사명', 					width:200, align:'center', sortable:true },
	{name:"CNSTR_USER", label:'확인자',					width:200, align:'center', sortable:true },
	{name:"CNSTR_BIZ_NO", label:'사업자등록증번호', 		width:200, align:'center', sortable:true },
	{name:"CNSTR_ADDR", label:'소재지', 					width:200, align:'center', sortable:true },
	{name:"CNSTR_TEL", label:'전화번호', 				width:200, align:'center', sortable:true },	
	
	//제조업자 정보
	{name:"MANUFACTURER_QUAL_NUMBER", label:'품질관리확인서 번호', width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_CDATE", label:'작성일자', 			width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_LOTNUMBER", label:'로트번호', 			width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_USER", label:'확인자', 				width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_COMPANY", label:'회사명', 				width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_BS_NUMBER", label:'사업자등록증번호', 	width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_ADDR", label:'소재지', 				width:200, align:'center', sortable:true },	
	{name:"MANUFACTURER_TELL_NUMBER", label:'전화번호', 			width:200, align:'center', sortable:true },	
];

var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
var updateComModel = []; // 전역.

if(0 < globalColumnOrder.length){ // 쿠키값이 있을때.
	if(defaultColModel.length == globalColumnOrder.length){
		for(var i=0,j=globalColumnOrder.length; i<j; i++){
			updateComModel.push(defaultColModel[globalColumnOrder[i]]);
		}
		
		setCookie(ckNameJqGrid, globalColumnOrder, 365); // 여기서 계산을 다시 해줘야겠네.
	}else{
		updateComModel = defaultColModel;
		
		setCookie(ckNameJqGrid, defaultColumnOrder, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel = defaultColModel;
	setCookie(ckNameJqGrid, defaultColumnOrder, 365);
}

// @@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth = ckNameJqGrid+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;
if('' != globalColumnWidthStr){ // 쿠키값이 있을때.
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
}

if(updateComModel.length == globalColumnWidth.length){
	for( var j=0; j<updateComModel.length; j++ ) {
		updateComModel[j].width = toStr(updateColumnWidth[j]);
	}
}
// End.

$(document).ready(function() {
	// 출고일자 데이트피커.
	$('input[name="r_actualshipsdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		//$('input[name="r_actualshipedt"]').datepicker('setStartDate', minDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });
	
	$('input[name="r_actualshipedt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		//$('input[name="r_actualshipsdt"]').datepicker('setEndDate', maxDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });
	/*
	var sel = document.getElementById("r_qmsOrdQuat");
    for(var i=0; i<sel.length; i++){
        if(i==sel.length-2){
            sel[i].selected = true;
            $(sel[i]).trigger('change');
        }
    }
    */

    getgridList();
});

//중앙값 계산 함수
//크기 순으로 이미 정렬된 배열을 입력해야만 합니다
//범용성을 위해서 이 함수 자체에는 정렬 기능 미포함
function getMedian(array) {
	if (array.length == 0) return NaN; // 빈 배열은 에러 반환(NaN은 숫자가 아니라는 의미임)
		var center = parseInt(array.length / 2); // 요소 개수의 절반값 구하기
	
	if (array.length % 2 == 1) { // 요소 개수가 홀수면
		return array[center]; // 홀수 개수인 배열에서는 중간 요소를 그대로 반환
	} else {
		return (parseInt(array[center - 1]) + parseInt(array[center])) / 2.0; // 짝수 개 요소는, 중간 두 수의 평균 반환
	}
}

function getgridList(){
	// grid init
	var searchData = getSearchData();
	$('#gridList').jqGrid({
		url: "${url}/admin/system/getQmsRawStasticsListAjax.lime",
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 15,
		rowList : ['15','30','50','100'],
		//multiselect: true,
		rownumbers: true,
		pagination: true,
		pager: "#pager",
		actions : true,
		pginput : true,
		sortable: false,
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
					if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
						columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
					}
				}
				globalColumnOrder = columnOrder;
				
				setCookie(ckNameJqGrid, globalColumnOrder, 365);
				
				// @@@@@@@ For Resize Column @@@@@@@
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
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
			$('.ui-pg-input').val(data.page);
		},
		onSelectRow: function(rowId){
			var h_dscode = $('#gridList').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
	});

	$("#gridList").jqGrid('setGroupHeaders', {
		useColSpanStyle: false, 
		groupHeaders:[
			{	startColumnName: 'REFRACT_COMPANY'
				, numberOfColumns: 9
				, titleText: '<table style="width:100%;border-spacing:0px;text-align:left;">' +
	            '<tr><td style="font-size: 15px;padding-top: 10px;padding-left: 45px;background-color: unset !important;">내화구조 정보</td></tr>' +
	            '</table>'},
			{	startColumnName: 'CONSTRUCTION_SITE'
				, numberOfColumns: 5
				, titleText: '<table style="width:100%;border-spacing:0px;text-align:left;">' +
	            '<tr><td style="font-size: 15px;padding-top: 10px;padding-left: 45px;background-color: unset !important;">시공현장 정보</td></tr>' +
	            '</table>'},
            {	startColumnName: 'SUPPLIER_COMPANY'
				, numberOfColumns: 5
				, titleText: '<table style="width:100%;border-spacing:0px;text-align:left;">' +
	            '<tr><td style="font-size: 15px;padding-top: 10px;padding-left: 45px;background-color: unset !important;">공급업자 정보</td></tr>' +
	            '</table>'},
	        {	startColumnName: 'CNSTR_NM'
					, numberOfColumns: 5
					, titleText: '<table style="width:100%;border-spacing:0px;text-align:left;">' +
		            '<tr><td style="font-size: 15px;padding-top: 10px;padding-left: 45px;background-color: unset !important;">시공업자 정보</td></tr>' +
		            '</table>'},
            {	startColumnName: 'MANUFACTURER_QUAL_NUMBER'
				, numberOfColumns: 8
				, titleText: '<table style="width:100%;border-spacing:0px;text-align:left;">' +
	            '<tr><td style="font-size: 15px;padding-top: 10px;padding-left: 30px;background-color: unset !important;">제조업자 정보</td></tr>' +
	            '</table>'},
		]
	});
	
}

function getSearchData(){
	var m_dept = $('input[name="m_dept"]').val();
	var m_quat = $("#r_qmsOrdQuat option:selected").val();
	var sData = {
		m_dept : m_dept,
		m_quat : m_quat
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


// jqgrid 검색 조건 증 체크박스 주의.
function excelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="m_quat" value="'+$("#r_qmsOrdQuat option:selected").val()+'" />');
	
	formPostSubmit('frm', '${url}/admin/system/qmsRawStasticsExcelDown.lime');
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

function getFormatDate(date){
	  var year = date.getFullYear();
	  var month = (1 + date.getMonth());
	  month = month >= 10 ? month : '0' + month;
	  var day = date.getDate();
	  day = day >= 10 ? day : '0' + day;
	  return year + '-' + month + '-' + day;
	}
		
	function chageQmsOrdQuat(obj) {
		/* var date = obj.value;
		var year, startMonth, endMonth, startDate, endDate;
		if(date.length > 0) {
			year = date.split('-')[0];
			switch(date.split('-')[1]) {
				case "1Q":
					startMonth = 1;
					endMonth = 3;
					break;
				case "2Q":
					startMonth = 4;
					endMonth = 6;
					break;
				case "3Q":
					startMonth = 7;
					endMonth = 9;
					break;
				case "4Q":
					startMonth = 10;
					endMonth = 12;
					break;
			}
			startDate = new Date(year, startMonth - 1, 1);
			lastDate = new Date(year, endMonth, 0);

			$('input[name="r_actualshipsdt"]').off('changeDate');
			$('input[name="r_actualshipedt"]').off('changeDate');
			
			$('input[name="r_actualshipsdt"]').val(getFormatDate(startDate));
			$('input[name="r_actualshipsdt"]').datepicker('setDate', startDate);

			$('input[name="r_actualshipedt"]').val(getFormatDate(lastDate));
			$('input[name="r_actualshipedt"]').datepicker('setDate', lastDate);
			
			$('input[name="r_actualshipsdt"]').on('changeDate', function(selected) {
				//$('input[name="r_orderedt"]').datepicker('setStartDate', startDate);
				document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
		    });
			$('input[name="r_actualshipedt"]').on('changeDate', function(selected) {
				//$('input[name="r_ordersdt"]').datepicker('setEndDate', lastDate);
				document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
		    });
		    
		} */
		dataSearch();
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
		
		<%-- 임의 form --%>
		<form name="iForm" method="post"></form>
		<%-- <form name="uForm" method="post" action="${url}/admin/system/deliverySpotEditPop.lime" target="deliverySpotEditPop"></form> --%>
		
		<form name="frm" method="post">
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					QMS 발급대장
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
											<!-- <li>
												<label class="search-h">출고일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li> -->
											<li>
												<label class="search-h">출고일자(분기)</label>
												<div class="search-c">
													<select class="form-control" name="r_qmsOrdQuat" id="r_qmsOrdQuat" onchange="chageQmsOrdQuat(this)">
														<option value="">선택안함</option>
														<c:forEach var="ryl" items="${releaseYearList}" varStatus="status">
															<c:choose>
																<c:when test="${ryl.QMS_YEAR_NM eq preYear && ryl.QMS_DELN_QUAT_NM eq preQuat}">
																	<option value="${ryl.QMS_YEAR}${ryl.QMS_DELN_QUAT}" selected>${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:when>
																<c:otherwise>
																	<option value="${ryl.QMS_YEAR}${ryl.QMS_DELN_QUAT}">${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</select>
												</div>
											</li>
											<!-- <li>
												<label class="search-h">Department</label>
												<div class="search-c">
													<input type="text" class="search-input" name="m_dept" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li> -->
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