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
// Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/promotion/promotionList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');
                                                                                                                                                                                         
var defaultColModel = [ //  ####### 설정 #######
	{ name:"NO",  			 label:'NO', 	  width:80,  align:'center', sortable:false, formatter:getRownum },
	{ name:"PRMONGOINGYN",label:'진행여부',	  width:150,  align:'center', sortable:false, },
	{ name:"PRM_CODE", 		 label:'이벤트코드',	  width:150, align:'center',   sortable:true, formatter:openViewPop },
	{ name:"PRM_TITLE",  	 label:'이벤트명', 	  width:445, align:'left',   sortable:true, formatter:openViewPop },
	{ name:"PRM_TYPE",  		 label:'이벤트구분', 	  width:150,  align:'center',   sortable:true, formatter:setTypeName ,  index:"PRM_TYPE" },
	{ name:"PRM_SDATE",	 label:'시작/종료일자', 	  width:250,  align:'center', sortable:false ,  formatter:setTerm   },
	{ name:"PRM_INDATE",	 label:'등록일', 	  width:150,  align:'center', sortable:true,  formatter:subStirngInDate, index:"PRM_INDATE"   },
	{ name:"USER_NM",	 label:'등록자', 	  width:150,  align:'center', sortable:false  },
	{ name:"editBtn", 		    label:'수정', 	width:150,   align:'center', sortable:false, formatter : setEditBtn },
	{ name:"PRM_SEQ", hidden:true },
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
});

/**
 * gridinit
 */ 
function gridInit(){
	
	$("#gridList").jqGrid({
		url: "./getPromotionListAjax.lime",
		mtype : "post",
		datatype: "json",
		postData: getSearchData(),
		colModel: updateComModel,	//상단에서 선언함		
		height: '360px',
		autowidth: false,
		rowNum : 10,
		rowList : ['10','30','50','100'],
		pagination: true,
		pager: "#pager",
		pgtext: '{0}/{1}',
		actions : true,
		pginput : true,
// 		sortable: true,
		sortorder: 'DESC',
		jsonReader : { 
			root : 'list' ,
		    records : 'listTotalCount'
		},
		loadComplete : function(data){			
			promotionTotalCnt = data.listTotalCount;
			$('#listTotal').text('TOTAL '+promotionTotalCnt+'EA');
			
			if(!isWriteAuth){// 읽기 권한 수정/삭제 버튼 숨김
				$('#gridList').jqGrid('hideCol', ['setEditBtn']);
			} 
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
 * NO컬럼 format
 */
function getRownum(cellValue,options,rowdata){
	
	var gridParam = $('#gridList').jqGrid('getGridParam'),
		totCnt = gridParam.records, // 게시물 전체 개수
		nowPage = parseInt(gridParam.page),
		rowLimit = parseInt(gridParam.rowNum, 10),
		rowIdx = options.rowId-1;
	
	var rn = totCnt - ((nowPage-1) * rowLimit) - rowIdx; 
	return rn.toString();	
}

/**
 * 구분 이름 한글로 변경
 * RPM_TYPE = 1:공지 , 2:품목
 */
function setTypeName(cellValue,options,rowdata){
	var typeVal = rowdata.PRM_TYPE;
	var typeName = '';
	
	if('1' === typeVal){
		typeName = '공지';
	}else if('2' === typeVal){
		typeName = '품목';
	}
	return typeName;
}

/**
 * 시작일자 종료일자 한 컬럼에 출력
 */
function setTerm(cellValue,options,rowdata){
	var sDate = rowdata.PRM_SDATE.substr(0,10),
		eDate = rowdata.PRM_EDATE.substr(0,10),
	    retTerm = sDate+' ~ '+ eDate;

	return retTerm;
}

/**
 * indate 날짜형식 yyyy-mm-dd로 변경
 */
function subStirngInDate(cellValue,options,rowdata){
	return rowdata.PRM_INDATE.substr(0,10);
}

function setEditBtn(cellval, options, rowObject){
	var retStr = '';
	if(isWriteAuth){
		retStr = ' <a href="javascript:;"  class="btn btn-default btn-xs" onclick=\'promotionDetail(this, "'+rowObject.PRM_SEQ+'", "EDIT");\'>수정</a>';
	}

	return retStr;
}

function promotionDetail(obj,prmSeq) {
	formGetSubmit('${url}/admin/promotion/promotionAdd.lime', 'r_prmseq='+prmSeq);
}

/**
 * 팝업 옵션값 초기화
 */
function setPopupOption(){
	var widthPx = 1000;
	var heightPx = 700;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	return options;
}

//선택 시 팝업 출력
function openViewPop(cellValue, options, rowObject) {
	return '<a href="javascript:;" onclick="promotionViewPop(this,\''+rowObject.PRM_SEQ+'\')">'+cellValue+'</a>';
}

/**
 * 프로모션 미리보기 팝업
 */
function promotionViewPop(obj, prmSeq){
	$('input[name="r_prmseq"]').val(prmSeq);
	// POST 팝업 열기.
	window.open('', 'promotionViewPop', setPopupOption());

	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/promotion/promotionViewPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'promotionViewPop');
	$frmPopSubmit.submit();
}

/**
 * 검색조회 데이터
 */
function getSearchData(){
	var r_prmongoingArr = '';
	$('input[name="r_prmongoingArr"]').each(function() {
		if (this.checked) {
			if (r_prmongoingArr == '') {
				r_prmongoingArr = $(this).val();
			} else {
				r_prmongoingArr += ',' + $(this).val();
			}
		}
	});

	var sData = {
		r_prmtype : $('input[name="r_prmtype"]:checked').val(),
		r_prmongoingArr : r_prmongoingArr,
        rl_prmtitle : $('input[name="rl_prmtitle"]').val()
	}
	
	return sData;
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
					이벤트현황
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			<form name="frmPopSubmit" method="post">
				<input type="hidden" name="pop" value="1" />
				<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
				<input name="rows" type="hidden" value="4" /><%-- r_limitrow --%>
				<input type="hidden" name="r_prmseq" value="" />
			</form>
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm" method="post" onsubmit="return false;">
								<input type="hidden" name="wAuth" value="true" />

							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">이벤트명</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_prmtitle" value="${param.rl_prmtitle}" onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="80"/>
												</div>
											</li>
											<li>
												<label class="search-h">진행여부</label>
												<div class="search-c checkbox">
													<label><input type="checkbox" name="r_prmongoingArr" value="W" onclick="dataSearch();" />진행대기</label>
													<label><input type="checkbox" name="r_prmongoingArr" value="Y" onclick="dataSearch();" />진행중</label>
													<label><input type="checkbox" name="r_prmongoingArr" value="N" onclick="dataSearch();" />진행완료</label>
												</div>
												<%--<c:set var="ongoingynchk1" value="" />
												<c:set var="ongoingynchk2" value="" />
												<c:if test="${param.r_prmongoingyn eq 'Y'}"><c:set var="ongoingynchk1" value="checked" /></c:if>
												<c:if test="${param.r_prmongoingyn eq 'N'}"><c:set var="ongoingynchk2" value="checked" /></c:if>

												<label><input type="radio" name="r_prmongoingyn" value="Y" ${ongoingynchk1} onchange="dataSearch()" />진행중</label>
												<label><input type="radio" name="r_prmongoingyn" value="N" ${ongoingynchk2} onchange="dataSearch()" />진행완료</label>--%>
											</li>
											<li>
												<label class="search-h">구분</label>
												<div class="search-c radio">
													<c:set var="prmtypechk1" value="" />
													<c:set var="prmtypechk2" value="" />
													<c:if test="${param.r_prmtype eq '1'}"><c:set var="prmtypechk1" value="checked" /></c:if>
													<c:if test="${param.r_prmtype eq '2'}"><c:set var="prmtypechk2" value="checked" /></c:if>

													<label><input type="radio" name="r_prmtype" value="1" ${prmtypechk1} onchange="dataSearch()" />공지</label>
													<label><input type="radio" name="r_prmtype" value="2" ${prmtypechk2} onchange="dataSearch()" />품목</label>
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
									<button class="btn btn-info" onclick="location.href='${url}/admin/promotion/promotionAdd.lime'" type="button" title="등록">등록</button>
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