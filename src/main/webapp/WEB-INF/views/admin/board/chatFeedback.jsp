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
var ckNameJqGrid = 'admin/board/sampleList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 ####### 140이 날아감
	{ name:"NO",  			 label:'NO', 	  width:80,  align:'center', sortable:false, formatter:getRownum }, 
	{ name:"bd_TITLE",  	 label:'제목', 	  width:700, align:'left',   sortable:true }, 
    { name:"btn",  			 label:'상세', 	  width:120,  align:'center', sortable:false, formatter:detailView },
	{ name:"user_NM",  		 label:'등록자', 	  width:250,  align:'center', sortable:false }, 
	{ name:"bd_INDATE",	 	 label:'등록일', 	  width:160,  align:'center', sortable:true, formatter:subStirngInDate, index:"bd_INDATE"   }, 
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
	}else{
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

$(function(){
	
	gridInit(); 
	
	//등록일 데이트피커
	$('input[name="r_bdsdate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
        var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_bdedate"]').datepicker('setStartDate', minDate);
        dataSearch();
    });
	
	$('input[name="r_bdedate"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
        var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
        $('input[name="r_bdsdate"]').datepicker('setEndDate', maxDate);
        dataSearch();
    });
});

/**
 * gridinit
 */ 
function gridInit(){
	
	$("#gridList").jqGrid({
		url: "./getchatFeedbackListAjax.lime",
		mtype : "post",
		datatype: "json",
		postData: getSearchData(),
		colModel: updateComModel,		
		height: '360px',
		autowidth: false,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		pagination: true,
		pager: "#pager",
		pgtext: '{0}/{1}',
		actions : true,
		pginput : true,
		sortorder: 'DESC',
		jsonReader : { 
			root : 'list' ,
		    records : 'listTotalCount'
		},
		loadComplete : function(data){			
			boardTotalCnt = data.listTotalCount;
			$('#listTotal').text('TOTAL '+boardTotalCnt+'EA');
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
					if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
						columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
					}
				}
				globalColumnOrder = columnOrder;
				
				setCookie(ckNameJqGrid, globalColumnOrder, 365);
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
		gridComplete: function(){
			var grid = $('#gridList');
		    var emptyText = grid.getGridParam('emptyDataText'); //NO Data Text 가져오기.
		    var container = grid.parents('.ui-jqgrid-view'); //Find the Grid's Container
			if(0 == grid.getGridParam('records')){
				// container.find('.ui-jqgrid-hdiv, .ui-jqgrid-bdiv').hide(); //Hide The Column Headers And The Cells Below
		        // container.find('.ui-jqgrid-titlebar').after(''+emptyText+'');
            }
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
	});
}
  
/**
 * 공지여부 (공지가 아닌 경우 rownum 출력)
 */
function getRownum(cellValue,options,rowdata){
	var notiChk = rowdata.bd_NOTICEYN;
	if('Y' === notiChk) return '공지';

	var gridParam = $('#gridList').jqGrid('getGridParam'),
		totCnt = gridParam.records, // 게시물 전체 개수.nowPage = parseInt(gridParam.page),
		nowPage = parseInt(gridParam.page),
		rowLimit = parseInt(gridParam.rowNum),
		rowIdx = options.rowId-1;

	var rn = totCnt - ((nowPage-1) * rowLimit) - rowIdx;
	return rn.toString();
}


/**
 * indate 날짜형식 yyyy-mm-dd로 변경
 */
function subStirngInDate(cellValue,options,rowdata){
	var indate = rowdata.bd_INDATE
	return indate.substring(0,10);	
}
/**
 * modate 날짜형식 yyyy-mm-dd로 변경
 */
function subStirngMoDate(cellValue,options,rowdata){
	var modate = rowdata.bd_MODATE
	return modate!=null?modate.substring(0,10):'';	
}

/**
 * 검색조회 데이터
 */
function getSearchData(){
	var sData = {
		r_bdid : $('input[name="r_bdid"]').val(),
		rl_bdtitle : $('input[name="rl_bdtitle"]').val(),
		r_bdnoticeyn : $('input:checkbox[name="r_bdnoticeyn"]:checked').val(),		
		r_bdfileyn : $('input[name="r_bdfileyn"]:checked').val(),
		r_bdtype : $('select[name="r_bdtype"]').val(),
		r_bddisplaytype : $('input[name="r_bddisplaytype"]:checked').val(),
		r_bdsdate : $('input[name="r_bdsdate"]').val(),
		r_bdedate : $('input[name="r_bdedate"]').val(),
		rl_usernm : $('input[name="rl_usernm"]').val()
	}
	
	return sData;
}

/**
 * 검색
 */
function dataSearch() {
	var sData = getSearchData();
	
	if($('input[name="r_bdnoticeyn"]').is(':checked') == true ){
		sData.r_bdnoticeyn = 'Y';
	}else{
		sData.r_bdnoticeyn = '';
	}
	
	$("#gridList").setGridParam({
		postData : sData
	}).trigger("reloadGrid", {page:1});
}

/*
function reloadGridForPop(){
	$("#gridList").trigger('reloadGrid');
}*/

function showDetailInfo(seq, idx) {
	//debugger;
	
	var widthPx = 955;
	var heightPx = 720;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	document.frmPop.r_bdnum.value= idx;
	
	$('form[name="frmPop"]').find('input[name="r_bdseq"]').val(seq);
	$('form[name="frmPop"]').attr('bdNum', idx);
	window.open('', 'chatViewPop', options);
	$('form[name="frmPop"]').prop('action', '${url}/admin/board/chatViewPop.lime');
	$('form[name="frmPop"]').submit();
}

function detailView(cellvalue, options, rowObject) {
	//debugger;
	let gridParam = $('#gridList').jqGrid('getGridParam');
	let totCnt = gridParam.records;
	let nowPage = parseInt(gridParam.page);
	let rowLimit = parseInt(gridParam.rowNum);
	let rowIdx = options.rowId-1;

	let rn = totCnt - ((nowPage-1) * rowLimit) - rowIdx;
	console.log(rn.toString());

	return '<input type="button" onclick="showDetailInfo('+ rowObject.bd_SEQ + ', ' + rn.toString() +')" value="상세"/>';
}

</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<form name="frmPop" method="post" target="chatViewPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_bdseq" type="hidden" value="" />
			<input type="hidden" name="r_bdnum" value="" />
		</form>
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					채팅 피드백
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch()"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			<form name="frmPopSubmit" method="post">
				<input type="hidden" name="pop" value="1" />
				<input type="hidden" name="r_bdseq" value="" />			
				<input type="hidden" name="r_bdid_pop" value="sample" />
				<input type="hidden" name="r_bdnum" value="" />
			</form>
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm" method="post">	
							<input type="hidden" name="r_bdid" value="sample" />						
							<input type="hidden" name="wAuth" value="true" />						
							
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_bdtitle" value="${param.rl_bdtitle}" onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="80"/>
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
													<input type="text" class="search-input form-sm-d p-r-md" name="r_bdsdate" autocomplete="off" value="${param.r_bdsdate}" readonly/>
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_bdedate" autocomplete="off" value="${param.r_bdedate}" readonly/>
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