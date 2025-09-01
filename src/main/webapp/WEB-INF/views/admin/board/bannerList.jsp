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
var ckNameJqGrid = 'admin/board/bannerList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{ name:"NO",  			 label:'NO', 	  width:80,  align:'center', sortable:false, formatter:getRownum },
	{ name:"BN_TYPE",label:'구분',	  width:140,  align:'center', sortable:true,  formatter:setBannerTypeName, index:"BN_TYPE" },
	{ name:"BN_IMAGE", 		 label:'배너이미지',	  width:375, align:'left',   sortable:false },
	{ name:"BN_LINKUSE",  	 label:'링크', 	  width:140, align:'center',   sortable:true },
	{ name:"BN_LINK",  		 label:'링크주소', 	  width:380,  align:'left',   sortable:false },
	{ name:"USER_NM",	 label:'등록자', 	  width:140,  align:'center', sortable:false,     },
	{ name:"BN_INDATE",	 label:'등록일', 	  width:140,  align:'center', sortable:true,  formatter:subStirngInDate, index:"BN_INDATE"   },
	{ name:"viewPopBtn", 		    label:'상세', 	width:140,   align:'center', sortable:false,     formatter:openViewPop },
	{ name:"editAndDelBtn", 		    label:'기능', 	width:140,   align:'center', sortable:false,     formatter:setEditBtn },
	{ name:"BN_SEQ", hidden:true },
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
		url: "./getBannerListAjax.lime",
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
 * row컬럼
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
 * 구분 이름 한글로 변경
 */
function setBannerTypeName(cellValue,options,rowdata){
	var bannerType = rowdata.BN_TYPE;
	var bannerTypeName = '';

	if('1' === bannerType){
		bannerTypeName = '로그인메인';
	}else if('2' === bannerType){
		bannerTypeName = '거래처메인1';
	}else if('3' === bannerType){
		bannerTypeName = '거래처메인2';
	}
	return bannerTypeName;
}

/**
 * indate 날짜형식 yyyy-mm-dd로 변경
 */
function subStirngInDate(cellValue,options,rowdata){
	var indate = rowdata.BN_INDATE;
	return indate.substring(0,10);
}

/**
 * 상세버튼 GRID format
 */
function openViewPop(cellval, options, rowObject){
	return '<button class="btn btn-default btn-xs" onclick="bannerViewPop(this,\''+rowObject.BN_SEQ+'\');" type="button" title="상세">상세</button>';
}

/**
 * 수정버튼 GRID format
 */
function setEditBtn(cellval, options, rowObject){
	if(isWriteAuth){
		return '<button class="btn btn-default btn-xs" onclick="bannerAddEditPop(this,\''+rowObject.BN_SEQ+'\',\'up\');" type="button" title="수정">수정</button>'
		+ '<button class="btn btn-default btn-xs" onclick="delBanner(this,\''+rowObject.BN_SEQ+'\',\''+rowObject.BN_TYPE+'\');" type="button" title="삭제">삭제</button>';
	}else{
		return '';
	}
}

/**
 * 배너 삭제
 */
function delBanner(obj,bnSeq,bnType){
	var params = { r_bnseq : bnSeq , r_bntype : bnType}
	var recCount = getGridReccount();

	if("1" === bnType && recCount == 1){
		alert('단일 이미지 일 경우 삭제가 불가합니다. ');
		return;
	}

	if(confirm('삭제하시겠습니까?')){
		$.ajax({
			async : false,
			data : params,
			type : 'POST',
			url : '${url}/admin/board/deleteBannerAjax.lime',
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
	var widthPx = 800;
	var heightPx = 500;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;

	return options;
}

/**
 * 배너 등록/수정 폼 팝업
 */
function bannerAddEditPop(obj, bnSeq,processType){
	var bn_type =  $('input:radio[name="r_bntype"]:checked').val();

	if('1' === bn_type ){	//로그인 배너이미지
		var gridReccount = getGridReccount();

		if(gridReccount >= 1 && 'in' === processType){
			alert('로그인 배너이미지는 기본 1개만 등록할 수 있습니다.');
			return;
		}
	}else if('2' === bn_type ){	//메인화면1 (프론트 인덱스 상단 배너이미지)
		var gridReccount = getGridReccount();

		if(gridReccount >= 2 && 'in' === processType){
			alert('메인화면1 배너이미지는 최대 2개까지만 등록할 수 있습니다.');
			return;
		}
	}

	$('input[name="r_bnseq"]').val(bnSeq);
	// POST 팝업 열기.
	window.open('', 'bannerAddEditPop', setPopupOption());

	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/banner/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'bannerAddEditPop');
	$frmPopSubmit.submit();
}

/**
 * 배너 한 건 뷰 팝업
 */
function bannerViewPop(obj, bdSeq){
	$('input[name="r_bnseq"]').val(bdSeq);
	// POST 팝업 열기.
	window.open('', 'bannerViewPop', setPopupOption());

	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/banner/pop/viewPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'bannerViewPop');
	$frmPopSubmit.submit();
}

/**
 * 현재 출력 되고 있는 레코드 개수 반환
 */
function getGridReccount() {
	var gridReccount = $('#gridList').getGridParam('reccount');

	return gridReccount;
}

/**
 * 검색조회 데이터
 */
function getSearchData(){
	var sData = {
		r_bntype : $('input[name="r_bntype"]:checked').val(),
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
					배너관리
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			<form name="frmPopSubmit" method="post">
				<input type="hidden" name="pop" value="1" />
				<input type="hidden" name="r_bnseq" value="" />
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
													<c:set var="bntypechk1" value="" />
													<c:set var="bntypechk2" value="" />
													<c:set var="bntypechk3" value="" />
													<c:if test="${param.r_bntype eq '1' or empty param.r_bntype}"><c:set var="bntypechk1" value="checked" /></c:if>
													<c:if test="${param.r_bntype eq '2'}"><c:set var="bntypechk2" value="checked" /></c:if>
													<c:if test="${param.r_bntype eq '3'}"><c:set var="bntypechk3" value="checked" /></c:if>

													<label><input type="radio" name="r_bntype" value="1" ${bntypechk1} onchange="dataSearch()"/>로그인</label>
													<label><input type="radio" name="r_bntype" value="2" ${bntypechk2} onchange="dataSearch()"/>메인화면1</label>
													<label><input type="radio" name="r_bntype" value="3" ${bntypechk3} onchange="dataSearch()"/>메인화면2</label>
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
									<button class="btn btn-info" onclick="bannerAddEditPop(this, '','in');" type="button" title="등록">등록</button>
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