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
		height:33px;
	}
	.topSearch ul .search-c{
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
		height:30px;
	}
	
	.fireproofItem.c{
		text-align: center!important;
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
	.qmsOrderLink{
		color:#1a75ff!important;
	}
	.qmsOrderLink:hover{
		color:#66a3ff!important;
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
	{name:"QMS_ID"       , label:'QMS 오더번호'  , width:140, align:'center', sortable:true, formatter:setDefault ,hidden:true},
	{name:"QMS_SEQ"      , label:'QMS 오더순번'  , width:150, align:'center', sortable:true, formatter:setDefault ,hidden:true},
	{name:"QMS_ORD_NO"   , label:'QMS 오더번호'  , width:150, align:'center', sortable:true, formatter:setQmsLink},
	{name:"SHIPTO_NM"    , label:'현장명'        , width:200, align:'left'  , sortable:true, formatter:setDefault},
	{name:"SHIPTOREP_NM" , label:'담당자명'      , width:110, align:'left'  , sortable:true, formatter:setDefault, editable:true,hidden:true},
	{name:"SHIPTO_EMAIL" , label:'E-Mail 주소'   , width:255, align:'left'  , sortable:true, formatter:setDefault, editable:true},
	{name:"SEND_DT"      , label:'발송여부'      , width:90 , align:'center', sortable:true, formatter:setSendYn , editable:false},
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

function setSendYn(cellValue, options, rowObject) {
	var html = '';
	if(cellValue != undefined && cellValue != ''){
		html = '발송완료<br/>('+cellValue+')';
	}else{
		html = '미발송';
	}
	return html;
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
	
	$("#gridList").jqGrid({
		url: "${url}/admin/order/getQmsPopEmailGridList.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: {qmsIdTxt :$('#qmsIdTxt').val()},
		colModel: updateComModel,
		height: '200',
		autowidth: false,
		/* rowNum : 10,
		rowList : ['10','30','50','100'], */
		multiselect: true,
		rownumbers: true,
		pagination: false,
		/* pager: "#pager",
		pginput : true, */
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
			if('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
			if('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
			
			var resizeIdx = index + minusIdx;
			
			updateColumnWidth[resizeIdx] = width;
			
			setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
	        //alert('Resize Column : '+index+'\nWidth : '+width);
	    },
		sortorder: 'desc',
		jsonReader : { 
			root : 'list'
		},
		loadComplete: function(data){
			console.log('cnt');
			console.log(data);
			$('#listTotalCountSpanId').html(addComma(data.list.length));
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
		onSelectRow : function(rowid) {
			if(rowid && rowid != lastSelection){
	    		//$('#gridList').restoreRow(lastSelection, true);
	    		$('#gridList').jqGrid('saveRow', lastSelection, true, 'clientArray');
	           	lastSelection = rowid; 
	    		$('#gridList').jqGrid('saveRow', rowid, true, 'clientArray');
	    	}

			$('#'+this.id).jqGrid('editRow',rowid, 
				{
					'keys' : true,
					'oneditfunc' : null,
					'successfunc' : null,
					'url' : null,
					'extraparam' : {},
					'aftersavefunc' : function(){ alert('test'); },
					'errorfunc': function(){ 
						$('#'+this.id).jqGrid('saveRow', rowid, true, 'clientArray');
						return;
					},
					'afterrestorefunc' : null,
					'restoreAfterError' : true,
					'mtype' : 'POST'
				});
			
			//$('#gridList').editRow(rowid ,true ,oneditfunc(rowid));
	        //$('#gridList').jqGrid('editRow',rowid,{keys : false,url:null});
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}


function getSearchData(){
	var r_qmsIdTxt = $('#qmsIdTxt').val();
	var sData = {
		qmsIdTxt : r_qmsIdTxt
	};
	return sData;
}

//QMS 오더번호 배열
function setQmsLink(cellValue, options, rowObject) {
	var html = "<a class=\"qmsOrderLink\" href=\"#\" onclick=\"javascript:qmsOrderPopFire('"+cellValue+"');\">"+cellValue+"</a>";
	return html;
}

function setDefaultEmail(){
	//var getDataIDs = $('#gridList').jqGrid("getDataIDs");
	
	var selRows = $('#gridList').getGridParam('selarrrow');

	if(selRows.length == 0 ){
		alert('선택한 행이 없습니다.');
		return;
	}
	
	var emailAddr = $('#emailAddr').val();
	
	for(var i = 0; i < selRows.length; i++) {
		$('#gridList').jqGrid('setCell', selRows[i], 'SHIPTO_EMAIL', emailAddr);
		$('#gridList').jqGrid('saveRow', selRows[i], true, 'clientArray');
		//var rowData = $('#gridList').jqGrid("getRowData",getDataIDs[i]);
	}
	
}


function emailSend(obj){
	if (confirm('이메일을 발송 하시겠습니까?')) {
		$(obj).prop('disabled', true);
		// 선택행을 조회
		var selRows = $('#gridList').getGridParam('selarrrow');
		var resultCnt = 0;
		//선택한 행이 없는 경우
		if(selRows.length == 0 ){
			alert('선택한 행이 없습니다.');
			return;
		}
		
		for(var i = 0; i < selRows.length; i++) {
			$('#gridList').jqGrid('saveRow', selRows[i], true, 'clientArray');
			var rowData = $('#gridList').jqGrid("getRowData",selRows[i]);
			var rowNum  = $('#gridList').jqGrid('getInd',selRows[i]);
			var saveRow = new Object();
			saveRow['qmsId'      ] = rowData['QMS_ID'];
			saveRow['qmsSeq'     ] = rowData['QMS_SEQ'];
			saveRow['shiptoNm'   ] = rowData['SHIPTO_NM'];
			saveRow['shiptorepNm'] = rowData['SHIPTOREP_NM'];
			saveRow['shiptoEmail'] = rowData['SHIPTO_EMAIL'];
			
			$.ajax({
				async : false,
				data  : saveRow,
				type  : 'POST',
				url   : '${url}/admin/order/setQmsMailLog.lime',
				success : function(result){
					resultCnt++;
				},
				error : function(request,status,error){
					alert('error');
					$(obj).prop('disabled', false);
					//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
		}

		if (resultCnt > 0){
			opener.parent.dataSearch();
			alert('이메일 발송이 완료되었습니다.');

			//그리드 재조회
			$('#gridList').setGridParam({
				postData : getSearchData()
			}).trigger("reloadGrid");
			$(obj).prop('disabled', false);
		}
		
	}
}

function qmsOrderPopFire(qmsId){
	// POST 팝업 열기.
	var widthPx = 980;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	var popup = window.open('${url}/front/report/qmsReport.lime?qmsId='+qmsId, 'qmsReport', options);
	popup.focus();
}
	

$(function(){
	getGridList();
});




</script>
</head>
<form name="frmPopSubmit" method="post">
	<input type="hidden" id="qmsIdTxt"  name="qmsIdTxt" value="${qmsIdTxt}"></input>
</form>
<body>
	<div id="ajax_indicator" style="display: none;">
		<p
			style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
			<img src="${url}/include/images/common/loadingbar.gif" />
		</p>
	</div>
	
	<div class="col-md-12">
	<div class="row">
	
	<div class="page-title">
		<h3>
			이메일 발송
			<div class="page-right">
				<h5 class="table-title listT" style="line-height: 32px;">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
			</div>
		</h3>
	</div>
	
	<div class="panel-body no-p">
		<div class="tableSearch">
			<div class="topSearch">
				<ul>
					<li><label class="search-h">이메일 주소 일괄 입력</label>
						<div class="search-c">
							<input type="text" class="search-input form-md-d p-r-md "
								id="emailAddr" name="emailAddr" value=""
								onkeypress="if(event.keyCode == 13){setDefaultEmail();}" /> 
							<button type="button" class="btn btn-line btn-xs pull-left"
								onclick="setDefaultEmail();">일괄적용</button>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="table-responsive in">
		<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
		<!-- <div id="pager"></div> -->
	</div>
	</div>
	
	<div class="qmsBtnDiv row">
		<button class="btn btn-md btn-warning" onclick="javascript:emailSend(this);" type="button" title="메일 발송">메일 발송</button>
		<button class="btn btn-md btn-gray" onclick="javascript:self.close();" type="button" title="닫기">닫기</button>
	</div>
	
</body>

</html>