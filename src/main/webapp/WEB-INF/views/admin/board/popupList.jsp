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
var ckNameJqGrid = 'admin/board/popupList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{ name:"NO",  			 label:'NO', 	  width:80,  align:'center', sortable:false, formatter:getRownum },
	{ name:"PU_TYPE",label:'구분',	  width:140,  align:'center', sortable:true,  formatter:setPopupTypeName, index:"PU_TYPE" },
	{ name:"PU_TITLE", 		 label:'제목',	  width:755, align:'left'    },
	{ name:"PU_SDATE",	 label:'시작일', 	  width:140,  align:'center', sortable:true,  formatter:subStirngInSDate, index:"PU_SDATE"   },
	{ name:"PU_EDATE",	 label:'종료일', 	  width:140,  align:'center', sortable:true,  formatter:subStirngInEDate, index:"PU_EDATE"   },
	{ name:"USER_NM",	 label:'등록자', 	  width:140,  align:'center', sortable:false,     },
	{ name:"viewPopBtn", 		    label:'상세', 	width:140,   align:'center', sortable:false,     formatter:openViewPop },
	{ name:"editAndDelBtn", 		    label:'기능', 	width:140,   align:'center', sortable:false,     formatter:setEditBtn },
	{ name:"PU_SEQ", hidden:true },
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
	}1
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
		url: "./getPopupListAjax.lime",
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
			boardTotalCnt = data.listTotalCount;
			$('#listTotal').text('TOTAL '+boardTotalCnt+'EA');
			/*
			if(!isWriteAuth){// 읽기 권한 수정/삭제 버튼 숨김 
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
 * NO컬럼 format
 */
function getRownum(cellValue,options,rowdata){
	
	var gridParam = $('#gridList').jqGrid('getGridParam');
	var totCnt = gridParam.records; // 게시물 전체 개수.	
	var nowPage = parseInt(gridParam.page);
	var rowLimit = parseInt(gridParam.rowNum, 10); //FIXME : 지금 리스트 개수는 20 50 100인데 10하드코딩 되어 있음 체크
	var rowIdx = options.rowId-1;
	
	var rn = totCnt - ((nowPage-1) * rowLimit) - rowIdx; 
	return rn.toString();	
}

/**
 * 출력여부 이름 한글로 변경
 */
function setPopupTypeName(cellValue,options,rowdata){
	var popupType = rowdata.PU_TYPE;
	var popupTypeName = '';
	
	if('1' === popupType){
		popupTypeName = '로그인';
	}else if('2' === popupType){
		popupTypeName = '메인화면';
	}
	return popupTypeName;
}

/**
 * 시작일(sdate) 날짜형식 yyyy-mm-dd로 변경
//FIXME EDATE랑 통합
 */
function subStirngInSDate(cellValue,options,rowdata){
	var sdate = rowdata.PU_SDATE;	
	return sdate.substring(0,10);
}

/**
 * 종료일(edate) 날짜형식 yyyy-mm-dd로 변경 
//FIXME SDATE랑 통합
 */
function subStirngInEDate(cellValue,options,rowdata){
	var edate = rowdata.PU_EDATE;
	return edate.substring(0,10);
}

/**
 * 상세버튼 GRID format 
 */
function openViewPop(cellval, options, rowObject){		
// 	return '<span onclick=\'popupViewPop(this, "'+rowObject.bd_SEQ+'");\' style="text-decoration: underline;">'+ cellval +'</span>'; //제목명 클릭 시 상세팝업
	return '<button class="btn btn-default btn-xs" onclick="popupViewPop(this,\''+rowObject.PU_SEQ+'\');" type="button" title="상세">상세</button>';
}

/**
 * 수정버튼 GRID format 
 */
function setEditBtn(cellval, options, rowObject){
	
	if(isWriteAuth){
		return '<button class="btn btn-default btn-xs" onclick="popupAddEditPop(this,\''+rowObject.PU_SEQ+'\');" type="button" title="수정">수정</button>'  
		+ '<button class="btn btn-default btn-xs" onclick="delPopup(this,\''+rowObject.PU_SEQ+'\');" type="button" title="삭제">삭제</button>';
	}else{
		return '';
	}
	
}

/**
 * 팝업관리 등록/수정 폼 팝업
 */
function popupAddEditPop(obj, puSeq){		
	$('input[name="r_puseq"]').val(puSeq); 	
	// POST 팝업 열기.
	window.open('', 'popupAddEditPop', setPopupOption());
	
	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/popup/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'popupAddEditPop');
	$frmPopSubmit.submit(); 
}

/**
 * 팝업 한 건 뷰 팝업
 */
function popupViewPop(obj, puSeq){
	$('input[name="r_puseq"]').val(puSeq); 		
	// POST 팝업 열기.
	window.open('', 'popupViewPop', setPopupOption());
	
	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/popup/pop/viewPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'popupViewPop');
	$frmPopSubmit.submit();
}

/**
 * 팝업 삭제
 */
function delPopup(obj,puSeq){	
	var params = { r_puseq : puSeq }
	
	if(confirm('삭제하시겠습니까?')){
		$.ajax({
			async : false,
			data : params,
			type : 'POST',
			url : '${url}/admin/board/deletePopupAjax.lime',
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
	}
	
}

/**
 * 팝업 옵션값 초기화
 */
function setPopupOption(){
	var widthPx = 1000;
	var heightPx = 500;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	return options;
}

/**
 * 검색조회 데이터
 */
function getSearchData(){
	var sData = {
		r_putype : $('input[name="r_putype"]:checked').val(),
		rl_usernm : $('input[name="rl_usernm"]').val()
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
					팝업관리
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			<form name="frmPopSubmit" method="post">
				<input type="hidden" name="pop" value="1" />
				<input type="hidden" name="r_puseq" value="" />			
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
											<li id="displaytypeTagId">
												<label class="search-h">구분</label>
												<div class="search-c radio">
													<c:set var="putypechk1" value="" />
													<c:set var="putypechk2" value="" />
													<c:if test="${param.r_putype eq '1'}"><c:set var="putypechk1" value="checked" /></c:if>
													<c:if test="${param.r_putype eq '2'}"><c:set var="putypechk2" value="checked" /></c:if>
																										
													<label><input type="radio" name="r_putype" value="1" ${putypechk1} onchange="dataSearch()"/>로그인</label>
													<label><input type="radio" name="r_putype" value="2" ${putypechk2} onchange="dataSearch()"/>메인화면</label>													
												</div>
											</li>
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													<input type="text" class="search-input" name="rl_usernm" value="${param.rl_usernm}" onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="40"/>
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
									<button class="btn btn-info" onclick="popupAddEditPop(this, '');" type="button" title="등록">등록</button>
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