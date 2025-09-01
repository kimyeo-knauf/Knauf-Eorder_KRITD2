<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
/* .ui-jqgrid-btable .ui-state-highlight { background: gray; } */
</style>

<script type="text/javascript">
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/board/tosConfigList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{ name:"NO", 				label:'NO', 	width:80, 	align:'center', sortable:false ,	formatter:getRownum },
	{ name:"tsc_TITLE",  		label:'제목', 	width:1035, 	align:'left', 	sortable:true 		 },			
	{ name:"user_NM",  			label:'등록자', 	width:140, 	align:'center', 	sortable:true },			
	{ name:"tsc_INDATE", 		label:'등록일',	width:140,	align:'center',	sortable:true,     	formatter:subStirngInDate, index:"tsc_INDATE" },	
	{ name:"viewPopBtn", 		    label:'상세', 	width:140,   align:'center', sortable:false,     formatter:openViewPop },
	{ name:"editAndDelBtn", 		    label:'기능', 	width:140,   align:'center', sortable:false,     formatter:setEditBtn },
	{ name:"tsc_SEQ", hidden:true },
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
// console.log('defaultColModel : ', defaultColModel);
// console.log('updateComModel : ', updateComModel);
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
	
	gridInit();
	
	//등록일 데이트피커
	$('input[name="r_tscsdate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
        var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_tscedate"]').datepicker('setStartDate', minDate);
        dataSearch();
    });
	
	$('input[name="r_tscedate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
        var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_tscsdate"]').datepicker('setEndDate', maxDate);
        dataSearch();
    });
	//	  
	
});

/**
 * gridinit
 */ 
function gridInit(){
	
	$("#gridList").jqGrid({
		url: "./getTosConfigListAjax.lime",
		datatype: "json",
		mtype: 'POST',
		postData: getSearchData(),
		colModel: updateComModel,	//상단에서 선언함
		height: '360px',
		autowidth: false,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		pagination: true,
		pgtext: '{0}/{1}',
		pager: "#pager",
		actions : true,
		pginput : true,
		sortable: true,
		sortorder: 'DESC',
		jsonReader : { 
			root : 'list' ,
		    records : 'listTotalCount'
		},
		loadComplete : function(data){			
			tosConfigTotalCnt = data.listTotalCount;
			$('#listTotal').text('TOTAL '+tosConfigTotalCnt+'EA');
			/*
			if(!isWriteAuth){// 읽기권한 수정/삭제 버튼 숨김 
				$('#gridList').jqGrid('hideCol', ['editAndDelBtn']);
			}
			*/
		},
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
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
	});
}
  
/**
 * row컬럼 format
 */
function getRownum(cellValue,options,rowdata){
		
	var gridParam = $('#gridList').jqGrid('getGridParam');
	var totCnt = gridParam.records; // 게시물 전체 개수.	
	var nowPage = parseInt(gridParam.page);
	var rowLimit = parseInt(gridParam.rowNum, 10);
	var rowIdx = options.rowId-1;
	
	var rn = totCnt - ((nowPage-1) * rowLimit) - rowIdx; 
	return rn.toString();	
}

/**
 * indate 날짜형식 yyyy-mm-dd로 변경
 */
function subStirngInDate(cellValue,options,rowdata){
	var indate = rowdata.tsc_INDATE
	return indate.substring(0,10);	
}

/**
 * 상세버튼 GRID format
 */
function openViewPop(cellval, options, rowObject){
	return '<button class="btn btn-default btn-xs" onclick="tosConfigViewPop(this,\''+rowObject.tsc_SEQ+'\');" type="button" title="상세">상세</button>'
} 

/**
 * 수정버튼 GRID format 
 */
function setEditBtn(cellval, options, rowObject){
	if(isWriteAuth){
		return '<button class="btn btn-default btn-xs" onclick="tosConfigAddEditPop(this,\''+rowObject.tsc_SEQ+'\');" type="button" title="수정">수정</button>'
		+ '<button class="btn btn-default btn-xs" onclick="delTosConfig(this,\''+rowObject.tsc_SEQ+'\');" type="button" title="삭제">삭제</button>';
	}else{
		return '';
	}
}

/**
 * 약관 삭제
 */
 function delTosConfig(obj,tscSeq){	
	var param = { r_tscseq : tscSeq }	
	$(obj).prop('disabled', true);
	
	if(confirm('삭제하시겠습니까?')){
		$.ajax({
			async : false,
			data : param,
			type : 'POST',
			url : '${url}/admin/board/deleteTosConfigAjax.lime',
			success : function( data ){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					dataSearch();
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

/**
 * 팝업사이즈 세팅
 */
function setPopupOption(){
	var widthPx = 1200;
	var heightPx = 800;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	return options;
}

/**
 * 약관관리 등록/수정 폼 팝업
 */
function tosConfigAddEditPop(obj, tscSeq){		
	$('input[name="r_tscseq"]').val(tscSeq); 	
	// POST 팝업 열기.
	window.open('', 'tosConfigAddEditPop', setPopupOption());
	
	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/tosConfig/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'tosConfigAddEditPop');
	$frmPopSubmit.submit(); 
}

/**
 * 약관관리 한 건 뷰 팝업
 */
function tosConfigViewPop(obj, tscSeq){		
	$('input[name="r_tscseq"]').val(tscSeq); 		
	// POST 팝업 열기.
	window.open('', 'tosConfigViewPop', setPopupOption());
	
	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/tosConfig/pop/viewPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'tosConfigViewPop');
	$frmPopSubmit.submit();
}

/**
 * 검색
 */
function dataSearch() {
	var sData = getSearchData();
	
	$("#gridList").setGridParam({
		postData : sData
	}).trigger("reloadGrid", {page:1});
}

function reloadGridForPop(){
	$("#gridList").trigger('reloadGrid');
}

/**
 * 검색조회 데이터
 */
function getSearchData(){
	var sData = {
			//검색조건 
			rl_tsctitle : $('input[name="rl_tsctitle"]').val(),			
			r_tscsdate : $('input[name="r_tscsdate"]').val(),
			r_tscedate : $('input[name="r_tscedate"]').val(),
			rl_usernm : $('input[name="rl_usernm"]').val()
	}
	
	return sData;
}

</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					약관관리
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch()"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			<form name="frmPopSubmit" method="post">
				<input type="hidden" name="pop" value="1" />
				<input type="hidden" name="r_tscseq" value="" />
				<input type="hidden" name="r_bdid_pop" value="tosConfig" />	
			</form>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm" method="post">	
							<input type="hidden" name="wAuth" value="true" />
							
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_tsctitle" value="${param.rl_tsctitle}"  onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="80"/>
												</div>
											</li>
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_usernm" value="${param.rl_usernm}" onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="40"/>
												</div>
											</li>
											<li>
												<label class="search-h">등록일</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_tscsdate" autocomplete="off" value="${param.r_tscsdate}" readonly/>
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_tscedate" autocomplete="off" value="${param.r_tscedate}" readonly/>
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							</form>
							
							<div class="panel-body">
								<h5 class="table-title listT" id="listTotal"></h5>
								<div class="btnList writeObjectClass">
									<button class="btn btn-info" onclick="tosConfigAddEditPop(this, '');" type="button" title="등록">등록</button>
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
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>

</html>