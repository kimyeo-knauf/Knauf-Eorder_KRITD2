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
var ckNameJqGrid = 'admin/board/sampleList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 ####### 140이 날아감
	{ name:"NO",  			 label:'NO', 	  width:80,  align:'center', sortable:false, formatter:getRownum },
	{ name:"bd_FILE", 		 label:'첨부파일',	  width:120, align:'center',   sortable:false, formatter:setIcon }, 
	{ name:"bd_TITLE",  	 label:'제목', 	  width:700, align:'left',   sortable:true }, 
	{ name:"user_NM",  		 label:'등록자', 	  width:140,  align:'center',   sortable:false }, 
	{ name:"bd_INDATE",	 label:'등록일', 	  width:150,  align:'center', sortable:true,  formatter:subStirngInDate, index:"bd_INDATE"   }, 
	{ name:"bd_MODATE",	 label:'완료일', 	  width:150,  align:'center', sortable:true,  formatter:subStirngMoDate, index:"bd_MODATE"   }, 
	{ name:"viewPopBtn", 		    label:'상세', 	width:130,   align:'center', sortable:false,     formatter:openViewPop },
	{ name:"editAndDelBtn", 		    label:'기능', 	width:90,   align:'center', sortable:false,     formatter:setEditBtn },      
	{ name:"state", 		    label:'상태', 	width:80,   align:'center', sortable:false,     formatter:setState},
	{ name:"bd_SEQ", hidden:true },
	{ name:"bd_REPLYYN", hidden:true },
	{ name:"bd_NOTICEYN", hidden:true },
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
	//	  
	
});

/**
 * gridinit
 */ 
function gridInit(){
	
	$("#gridList").jqGrid({
		url: "./getsampleListAjax.lime",
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
			if(!isWriteAuth){// 읽기권한 출력여부 숨김 
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
 * 첨부파일 아이콘
 */
function setIcon(cellValue,options,rowdata) {
	var bd_fileYn = rowdata.bd_FILEYN;
	if('Y' == bd_fileYn){
		return '<img src="${url}/include/images/common/icon_clip.png" class="file" alt="image" />';
	}else{
		return '';
	}
}

/**
 * 출력여부 이름 한글로 변경
 */
function setDisplayTypeName(cellValue,options,rowdata){
	var displayType = rowdata.bd_DISPLAYTYPE;
	var displayName = '';
	
	if('user' === displayType){
		displayName = '거래처출력';
	}else if('admin' === displayType){
		displayName = '로그인출력';
	}
	return displayName;
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
 * 상세버튼 GRID format
 */
function openViewPop(cellval, options, rowObject){		
	console.log("글 넘버 체크중");
	var bdnum = getRownum(cellval,options,'N');
	console.log(bdnum);
	return '<button class="btn btn-default btn-xs" onclick="sampleViewPop(this, \''+rowObject.bd_SEQ+'\' , \''+bdnum+'\');" type="button" title="상세">상세</button>';
}
//, 'rowObject.NO'

/**
 * 삭제버튼 GRID format 
 */
function setEditBtn(cellval, options, rowObject){	
	if(isWriteAuth){
		return '<button onclick="delsample(this,\''+rowObject.bd_SEQ+'\' );" type="button" class="btn btn-default btn-xs">삭제</button>';
	}else{
		return '';
	}
}

/**
 * 답변 여부 버튼 GRID format 
 */
 
 function setState(cellValue,options,rowdata) {
		var bd_replyYn = rowdata.bd_REPLYYN;
		if('Y' == bd_replyYn){
			return '완료';
		}
		else if('R' == bd_replyYn){
			return '반려';
			}
		else if('S' == bd_replyYn){
			return '발송';
			}
		else{
			return '미완료';
		}
	}

//'<button onclick="sampleAddEditPop(this,\''+rowObject.bd_SEQ+'\');" type="button" class="btn btn-default btn-xs">수정</button>'+        // 위에 삭제 앞에 붙여주면 됨

/**
 * 샘플 삭제
 */
function delsample(obj,bdSeq){	
	var params = { r_bdseq : bdSeq , r_bdid : $('input[name="r_bdid"]').val() }
	
	if(confirm('삭제하시겠습니까?')){
		$.ajax({
			async : false,
			data : params,
			type : 'POST',
			url : '${url}/admin/board/deletesampleAjax.lime',
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
	var heightPx = 830;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	return options;
}

/**
 * 샘플 등록/수정 폼 팝업
 */
function sampleAddEditPop(obj, bdSeq,bdnum){		
	$('input[name="r_bdseq"]').val(bdSeq); 	
	document.frmPopSubmit.r_bdnum.value= bdnum;
	console.log(bdnum);
	// POST 팝업 열기.
	window.open('', 'sampleAddEditPop', setPopupOption());
	
	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/sample/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'sampleAddEditPop');
	$frmPopSubmit.submit(); 
}

/**
 * 샘플 한 건 뷰 팝업
 */
function sampleViewPop(obj, bdSeq, bdnum){		
	$('input[name="r_bdseq"]').val(bdSeq); 		
	// POST 팝업 열기.
	document.frmPopSubmit.r_bdnum.value= bdnum;
	console.log(bdnum);
	window.open('', 'sampleViewPop', setPopupOption());
	$frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/sample/pop/viewPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'sampleViewPop');
	$frmPopSubmit.submit();
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
					샘플
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
												<%-- 
												<div class="checkbox pull-left">
														<c:set var="notichkChk" value="" />
														<c:if test="${param.r_bdnoticeyn eq 'Y'}">
															<c:set var="notichkChk" value="checked" />
														</c:if>
														<label class="no-p-r"><input type="checkbox" name="r_bdnoticeyn" value="Y" ${notichkChk} onclick="dataSearch()"/>공지여부</label>
													</div>
												</div>
												--%>
											</li>

											<%--
											<li id="displaytypeTagId">
												<label class="search-h">출력여부</label>
												<div class="search-c radio">
													<c:set var="userChk" value="" />
													<c:set var="adminChk" value="" />
													<c:if test="${param.r_bddisplaytype eq 'user'}"><c:set var="userChk" value="checked" /></c:if>
													<c:if test="${param.r_bddisplaytype eq 'admin'}"><c:set var="adminChk" value="checked" /></c:if>
																										
													<label><input type="radio" name="r_bddisplaytype" value="user" ${userChk} onchange="dataSearch()"/>거래처출력</label>
													<label><input type="radio" name="r_bddisplaytype" value="admin" ${adminChk} onchange="dataSearch()"/>로그인출력</label>													
												</div>
											</li>
											--%>
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
								<!--  div class="btnList writeObjectClass">									
									<button class="btn btn-info" onclick="sampleAddEditPop(this, '');" type="button" title="샘플등록">샘플등록</button>
								</div-->
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