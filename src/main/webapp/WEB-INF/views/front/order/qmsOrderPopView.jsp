<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp"%>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>
<c:set var="isLayerPop" value="false" />

<style>
	.topSearch{
		padding:20px!important;
	}
	.topSearch ul .search-h{
		border-bottom:1px solid #e6e6e6;
		height:33px;
	}
	.topSearch ul .search-c{
		border-bottom:1px solid #e6e6e6;
		height:33px;
		padding-left:15px;
	}
	
	.fireproofTable{
		width:100%;
		margin-top:15px;
		border-bottom:1px solid #666;
	}
	.fireproofTable tr td{
		text-align:left;
	}
	.fireproofTable tr td.active{
		background-color: #1a75ff;
	}
	
	.fireproofTable tr td.active{
		background-color: #9fdf9f;
	}
		
	.fireproofTable tr td.title{
		background-color: #FFFF99;
		border-top:1px solid #666;
		border-left:1px solid #666;
		border-right:1px solid #666;
		padding:5px;
		text-align:center;
	}
	
	.fireproofItem{
		border-top:1px solid #666;
		border-left:1px solid #666;
		padding:5px;
		height:32px;
	}
	
	.fireproofItem.c{
		text-align: center!important;
	}
	
	.fireproofTable > tbody > tr > *{
		overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
	.customChk:checked + span + div + label{
		background-color: #efefef;
		border:1px solid red;
	}
	
	div.checker span.checked + label {
		background-color: #efefef;
		border:1px solid red;
	}
	
	.fireproofTable tr:not(:first-child) td:nth-last-child(1){
		border-right:1px solid #666;
	}
	
	.qmsBtnDiv{
		padding-top:30px;
		padding-bottom:30px;
		text-align: right;
	}
	.qmsBtnDiv .btn{
		margin-left:5px;
		margin-right:5px;
	}
	#preview {
        z-index: 9999;
        position: absolute;
        border: 0px solid #ccc;
        background: #333;
        padding: 1px;
        display: none;
        color: #fff;
    }
    
    .search-c {
    	overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
    }
</style>

<script type="text/javascript">
//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/qmsItemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"QMS_ID" , label:'qms번호' , width:80, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"QMS_SEQ", label:'qmsseq 번호' , width:80, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"QMS_DETL_ID", label:'qmsDetl 번호' , width:80, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"ORDERNO", label:'오더번호' , width:80, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"LINE_NO", label:'라인번호' , width:80, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"ITEM_CD", label:'품목코드' , width:100, align:'center', sortable:false, formatter:setDefault},
	{name:"ITEM_DESC", label:'품목'   , width:280, align:'left', sortable:false, formatter:setDefault},
	{name:"LOTN"     , label:'Lot No' , width:100, align:'center', sortable:false, formatter:setDefault},
	{name:"ORDER_QTY", label:'수량'   , width:100, align:'center', sortable:false, formatter:setDefault, hidden:true},
	{name:"QMS_ORD_QTY", label:'QMS 수량', width:100, align:'center', sortable:false, editable:false, formatter:setDefault},
	{name:"QMS_REMARK", label:'Remark' , width:333, align:'center', sortable:false, editable:false, formatter:setDefault},
	
];
var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
//console.log('defaultColumnOrder : ', defaultColumnOrder);
var updateComModel = []; // 전역.
//@@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth = ckNameJqGrid+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
//console.log('globalColumnWidthStr : ', globalColumnWidthStr);
//console.log('globalColumnWidth : ', globalColumnWidth);
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;
var lastSelection;

//행 편집.
function editRow(id){
	//alert('id : '+id+'\nlastSelection : '+lastSelection);
    if (id && id !== lastSelection) {
        var grid = $('#gridList');
		//grid.jqGrid('restoreRow',lastSelection); //이전에 선택한 행 제어
        grid.jqGrid('editRow',id, {keys: false}); //keys true=enter
        lastSelection = id;
    }
}

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

function setDefault(cellValue, options, rowObject) {
	return toStr(cellValue);
}
// 수량.
function setOrderQty(cellValue, options, rowObject) {
	return addComma(toStr(cellValue));
}

function getGridList(){ 
	// grid init
	var searchData = getSearchData();
	console.log(searchData);
	
	$("#gridList").jqGrid({
		url: "${url}/front/order/getQmsPopDetlGridList.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 10000,
		 /*rowList : ['10','30','50','100'], */
		multiselect: false,
		rownumbers: true,
		pagination: false,
		actions : false,
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
			$('#listTotalCountSpanId').html(addComma(data.length));
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
		beforeSelectRow: function(rowid, e) { //셀렉트 불가 옵션
		    return false;
		},
		onSelectRow : function(rowid) {
			if(rowid && rowid != lastSelection){
	    		//$('#gridList').restoreRow(lastSelection, true);
	    		$('#gridList').jqGrid('saveRow', lastSelection, true, 'clientArray');
	           	lastSelection = rowid; 
	    		$('#gridList').jqGrid('saveRow', rowid, true, 'clientArray');
	    	}
		        
			$("#gridList").jqGrid('editRow',rowid, 
					{
						'keys' : false,
						'oneditfunc' : null,
						'successfunc' : null,
						'url' : null,
						'extraparam' : {},
						'aftersavefunc' : null,
						'errorfunc': null,
						'afterrestorefunc' : null,
						'restoreAfterError' : true,
						'mtype' : 'POST'
					});
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

function getSearchData(){
	
	var sData = {
		qmsId : $('#qmsId').val()
		, qmsSeq : $('#qmsSeq').val() != "" ? $('#qmsSeq').val() : 1
	};
	return sData;
}


$(function(){
	// 1번째 탭 자동 활성화
	$('.nav.nav-tabs').find('a.nav-link')[0].click();
	getGridList();
});


function qmsOrderMod(obj,inQmsSeq){
	location.href="qmsOrderPop.lime?qmsId="+$('#qmsId').val()+'-'+inQmsSeq+"&work=mod";
}

function qmsOrderDelete(obj,inQmsSeq){
	if (confirm('정말 삭제 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : {'qmsId':$('#qmsId').val(),'qmsSeq':inQmsSeq},
			type : 'POST',
			url : '${url}/front/order/setQmsOrderMastDelete.lime',
			success : function(data) {
				alert('삭제 완료되었습니다.');
				opener.parent.dataSearch();
				self.close();
			},
			error : function(request,status,error){
				alert('Error');
			}
		});
	}
}

function qmsOrderSave(obj,inQmsSeq){
	var qmsId = $('#qmsId').val();
	var qmsSeq = inQmsSeq;
	var saveRow = {};

	saveRow['qmsId'] = qmsId;
	saveRow['qmsSeq'] = qmsSeq;
	//현장정보
	saveRow['shiptoCd']  = $('#shiptoCd_'+qmsSeq).val();
	saveRow['shiptoAddr']  = $('#shiptoAddr_'+qmsSeq).val();
	saveRow['shiptoEmail']  = $('#shiptoEmail_'+qmsSeq).val();

	//시공회사명
	saveRow['cnstrCd']  = $('#cnstrCd_'+qmsSeq).val();
	saveRow['cnstrAddr']  = $('#cnstrAddr_'+qmsSeq).val();
	saveRow['cnstrBizNo']  = $('#cnstrBizNo_'+qmsSeq).val();
	saveRow['cnstrTel']  = $('#cnstrTel_'+qmsSeq).val();

	//감리회사
	saveRow['supvsCd']  = $('#supvsCd_'+qmsSeq).val();
	saveRow['supvsAddr']  = $('#supvsAddr_'+qmsSeq).val();
	saveRow['supvsBizNo']  = $('#supvsBizNo_'+qmsSeq).val();
	saveRow['supvsTel']  = $('#supvsTel_'+qmsSeq).val();

	var detlRow = [];
	var getDataIDs = $("#gridList").jqGrid("getDataIDs");
	for(var i = 0; i < getDataIDs.length; i++){
		$('#gridList').jqGrid('saveRow', getDataIDs[i], true, 'clientArray');
		var rowData = $("#gridList").jqGrid("getRowData",getDataIDs[i]);
		detlRow.push(rowData);
	}

	var fireproofChk = [];
	$("input:checkbox[name='fireproof_"+inQmsSeq+"']:checked").each(function(){
		fireproofChk.push($(this).val());
	});
	
	if (confirm('저장 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : saveRow,
			type : 'POST',
			url : '${url}/front/order/setQmsOrderMastUpdate.lime',
			success : function(data) {
				console.log(data);
			},
			error : function(request,status,error){
				alert('Error');
			}
		});
		
		for(var i = 0 ; i < detlRow.length; i++){
			$.ajax({
				async : false,
				data : detlRow[i],
				type : 'POST',
				url : '${url}/front/order/setQmsOrderDetlUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
				}
			});
		}

		for(var i = 0 ; i < fireproofChk.length; i++){
			if(i == 0){
				$.ajax({
					async : false,
					data : {'qmsId':qmsId,'qmsSeq':qmsSeq },
					type : 'POST',
					url : '${url}/front/order/setQmsOrderFireproofInit.lime',
					success : function(data) {
						console.log(data);
					},
					error : function(request,status,error){
						alert('Error');
					}
				});
			}
			
			$.ajax({
				async : false,
				data : {'qmsId':qmsId,'qmsSeq':qmsSeq,'keyCode': fireproofChk[i]},
				type : 'POST',
				url : '${url}/front/order/setQmsOrderFireproofUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
				}
			});
		}
		
		alert('저장되었습니다.');
	}
}


/*
 * 내화구조 이미지 프리뷰
 */
$(document).ready(function () {
    var xOffset = 20;
    var yOffset = 30;
    var windowWidth = $( window ).width();
    var scrollHeight = Math.max(
    		  document.body.scrollHeight, document.documentElement.scrollHeight,
    		  document.body.offsetHeight, document.documentElement.offsetHeight,
    		  document.body.clientHeight, document.documentElement.clientHeight
    		);
	var top = 0;
	var left = 0;
	var imgWidth = 350;
    $(document).on("mouseover", ".thumb", function (e) { //마우스 오버시
    	scrollHeight = Math.max(
      		  document.body.scrollHeight, document.documentElement.scrollHeight,
      		  document.body.offsetHeight, document.documentElement.offsetHeight,
      		  document.body.clientHeight, document.documentElement.clientHeight
      		);
    	$("body").append("<p id='preview'><img src='" + $(this).attr("src") + "' width='" + imgWidth + "px' /></p>"); //보여줄 이미지를 선언	

    	if(scrollHeight > (Number(e.pageY) + Number(yOffset) + imgWidth)) {
    		top = e.pageY + xOffset;
        } else {
        	top = scrollHeight - imgWidth;
        }
        
        if((windowWidth - 20) > (Number(e.pageX) + Number(yOffset) + imgWidth)) {
        	left = e.pageX + yOffset;
        } else {
        	left = e.pageX - imgWidth - yOffset;
        }
        $("#preview")
        .css("top", top + "px")
        .css("left", left + "px")
        .fadeIn("fast"); //미리보기 화면 설정 셋팅
    });
    $(document).on("mousemove", ".thumb", function (e) { //마우스 이동시
    	scrollHeight = Math.max(
      		  document.body.scrollHeight, document.documentElement.scrollHeight,
      		  document.body.offsetHeight, document.documentElement.offsetHeight,
      		  document.body.clientHeight, document.documentElement.clientHeight
      		);
    	if(scrollHeight > (Number(e.pageY) + Number(yOffset) + imgWidth)) {
    		top = e.pageY + xOffset;
        } else {
        	top = scrollHeight - imgWidth;
        }

    	if((windowWidth - 20) > (Number(e.pageX) + Number(yOffset) + imgWidth)) {
        	left = e.pageX + yOffset;
        } else {
        	left = e.pageX - imgWidth - yOffset;
        }
    	$("#preview")
        .css("top", top + "px")
        .css("left", left + "px");
    });
    $(document).on("mouseout", ".thumb", function () { //마우스 아웃시
        $("#preview").remove();
    });
});

</script>
</head>
<form name="frmPopSubmit" method="post">
	<input type="hidden" id="qmsId"  name="qmsId" value="${qmsId}"></input>
	<input type="hidden" id="qmsSeq" name="qmsSeq" value="${qmsSeq}"></input>
</form>
<body>
	<div id="ajax_indicator" style="display: none;">
		<p
			style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
			<img src="${url}/include/images/common/loadingbar.gif" />
		</p>
	</div>
	
	<div class="col-md-12">
	<ul class="nav nav-tabs" >
		<c:forEach items="${qmsMastList}" var="mastlist" varStatus="status">
		  <li class="nav-item ">
		    <a class="nav-link <c:if test="${status.index == 0}">active</c:if>" data-toggle="tab" href="#${mastlist.QMS_SEQ}">${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</a>
		  </li>
		</c:forEach>
	</ul>
	
	<div class="tab-content">
		<c:forEach items="${qmsMastList}" var="mastlist" varStatus="status">
		<div class="tab-pane fade show <c:if test="${status.index == 0}">active</c:if>" id="${mastlist.QMS_SEQ}">
			<div class="">
			<div class="row">
				<form name="frm_${mastlist.QMS_SEQ}">

				<div class="page-title">
					<h3>
						QMS 정보 조회
						<!-- <div class="page-right">
							<button type="button" class="btn btn-line f-black" title="새로고침"
								onclick="document.location.reload();">
								<i class="fa fa-refresh"></i><em>현장분할</em>
							</button>
						</div> -->
					</h3>
				</div>

					<div class="panel-body no-p">
						<div class="tableSearch">
							<div class="topSearch">
								<ul>
									<li><label class="search-h"><b>현장정보</b></label>
										<div class="search-c"></div></li>
									<li><label class="search-h"><b>QMS 오더번호</b></label>
										<div class="search-c" >
											<span>${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</span>
										</div></li>
									<li class="wide"><label class="search-h">현장명</label>
										<div class="search-c">
											<span id="shiptoNm_${mastlist.QMS_SEQ}">${mastlist.SHIPTO_NM}</span>
										</div></li>
									<%-- <li><label class="search-h">현장 코드</label>
										<div class="search-c">
											<span id="shiptoCd_${mastlist.QMS_SEQ}">${mastlist.SHIPTO_CD}</span>
										</div></li> --%>
									<li><label class="search-h">주소</label>
										<div class="search-c">
											<span id="shiptoAddr_${mastlist.QMS_SEQ}">${mastlist.SHIPTO_ADDR}</span>
										</div></li>
									<li><label class="search-h">이메일</label>
										<div class="search-c">
											<span id="shiptoEmail_${mastlist.QMS_SEQ}">${mastlist.SHIPTO_EMAIL}</span>
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>시공회사
												정보</b></label>
										<div class="search-c"></div></li>
									<li class="wide"><label class="search-h">시공회사명</label>
										<div class="search-c">
										<span id="cnstrNm_${mastlist.QMS_SEQ}">${mastlist.CNSTR_NM}</span>
										</div></li>
									<%-- <li><label class="search-h">시공회사 코드</label>
										<div class="search-c">
										<span id="cnstrCd_${mastlist.QMS_SEQ}">${mastlist.CNSTR_CD}</span>
										</div></li> --%>
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
										<span id="cnstrAddr_${mastlist.QMS_SEQ}" >${mastlist.CNSTR_ADDR}</span>
										</div></li>
									<li><label class="search-h">사업자번호</label>
										<div class="search-c">
										<span id="cnstrBizNo_${mastlist.QMS_SEQ}">${mastlist.CNSTR_BIZ_NO}</span>
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
										<span id="cnstrTel_${mastlist.QMS_SEQ}">${mastlist.CNSTR_TEL}</span>
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>감리회사
												정보</b></label>
										<div class="search-c"></div></li>
									<li class="wide"><label class="search-h">감리회사명</label>
										<div class="search-c">
										<span id="supvsNm_${mastlist.QMS_SEQ}">${mastlist.SUPVS_NM}</span>
										</div></li>
									<%-- <li><label class="search-h">감리회사 코드</label>
										<div class="search-c">
										<span id="supvsCd_${mastlist.QMS_SEQ}">${mastlist.SUPVS_CD}</span>
										</div></li> --%>
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
										<span id="supvsAddr_${mastlist.QMS_SEQ}">${mastlist.SUPVS_ADDR}</span>
										</div></li>
									<li><label class="search-h">사업자번호</label>
										<div class="search-c">
										<span id="supvsBizNo_${mastlist.QMS_SEQ}">${mastlist.SUPVS_BIZ_NO}</span>
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
										<span id="supvsTel_${mastlist.QMS_SEQ}">${mastlist.SUPVS_TEL}</span>
										</div></li>
								</ul>
							</div>
							<div >&nbsp;</div>
						</div>
					</div>
					
				<div class="page-title" style="margin-top:15px;">
					<h3>
						품목정보
						<div class="page-right">
							<h5 class="table-title listT" style="line-height: 32px;">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
						</div>
					</h3>
				</div>
					<div class="table-responsive in">
						<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
					</div>
					
					<div >&nbsp;</div>
					<div >&nbsp;</div>
					
					<table class="fireproofTable">
					<tr>
						<td class="title" colspan="2"><b>FIREPROOF CONTRUCTION TYPE</b></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<c:set var="fireIndex" value="1"/>
					<c:forEach items="${qmsFireproofList}" var="fireprooflist" varStatus="status">
						<c:if test="${fireIndex == 1}">
						<tr>
						</c:if>
						
						<c:if test="${fireprooflist.CHK_YN eq 'Y'}">
						<td class="active">
							<div class="fireproofItem">
								<c:choose>
								    <c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
								        <label src="${url}/data/fireproof/${fireprooflist.FILENAME}" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
								    </c:when>
								    <c:otherwise>
								        <label src="${url}/include/images/admin/list_noimg.gif" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
								    </c:otherwise>
								</c:choose>
							</div>
						</td>
						</c:if>
						
						<c:if test="${fireprooflist.CHK_YN eq 'N'}">
						<td>
							<div class="fireproofItem">
								<c:choose>
								    <c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
								        <label src="${url}/data/fireproof/${fireprooflist.FILENAME}" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
								    </c:when>
								    <c:otherwise>
								        <label src="${url}/include/images/admin/list_noimg.gif" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
								    </c:otherwise>
								</c:choose>
							</div>
						</td>
						</c:if>
						
						<c:if test="${fireprooflist.LAST_YN eq 'Y' || fireprooflist.RLAST == fireprooflist.RCNT}">
							<c:if test="${fireIndex < 4}">
								<c:set var="fireIndex" value="${fireIndex+1}"/>
								<c:forEach begin="${fireIndex}" end="4" step="1" varStatus="status2">
									<td><div class="fireproofItem">&nbsp;</div></td>
									<c:set var="fireIndex" value="${fireIndex+1}"/>
								</c:forEach>
							</c:if>
						</c:if>
						
						<c:if test="${fireIndex >= 4}">
							<c:if test="${fireprooflist.RNUM <= 4}">
								<td class="fireproofItem c" rowspan="${fireprooflist.ROWSPAN_CNT}">${fireprooflist.FIRETIME} 시간</td>
							</c:if>
							<c:set var="fireIndex" value="0"/>
							</tr>
						</c:if>
						
						<c:set var="fireIndex" value="${fireIndex + 1}"/>
					</c:forEach>
					</table>
					
				</div>
				
				<div class="qmsBtnDiv row">
					<c:if test="${admin_authority eq 'QM' or (mastlist.ACTIVEYN eq 'N' and createUser eq sessionScope.loginDto.userId) }">
						<button class="btn btn-md btn-info"    onclick="qmsOrderMod(this, '${mastlist.QMS_SEQ}');" type="button" title="QMS 입력">수정</button>
						<button class="btn btn-md btn-danger"    onclick="qmsOrderDelete(this, '${mastlist.QMS_SEQ}');" type="button" title="QMS 입력">삭제</button>
					</c:if>
						<button class="btn btn-md btn-gray" onclick="javascript:self.close();" type="button" title="QMS 입력">닫기</button>
				</div>
			</div>
			</div>
		</div>
		</c:forEach>
	</div>
	
</body>

</html>