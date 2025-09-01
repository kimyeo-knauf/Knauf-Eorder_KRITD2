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
	.fireproofTable{
		width:100%;
		margin-top:15px;
		border-bottom:1px solid #666;
	}
	.fireproofTable tr td{
		text-align:left;
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
		background-color: #fff;
		border-top:1px solid #666;
		border-left:1px solid #666;
		padding:5px;
		height:32px;
	}
	
	.fireproofItem.c{
		text-align: center!important;
	}
	
	.customChk:checked + span + div + label{
		background-color: #efefef;
		border:1px solid red;
	}
	
	label{
		
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
	span.red{
		color:#F25656;
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

	.fireproofTable > tbody > tr > *{
		overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
</style>

<script type="text/javascript">

//creating event listeners
window.addEventListener('beforeunload', beforeUnload);

function beforeUnload(){
	// 표준에 따라 기본 동작 방지
	event.preventDefault();
	
	// 창 닫힘
	if (self.screenTop > 9000) {
		console.log('창닫힘');
	} else if(document.readyState == "complete") {
		console.log('새로고침');
	 
	 // 다른 사이트로 이동
	} else if(document.readyState == "loading") {
		console.log('창이동');
	}
	//opener.qmsOrderTempReset($('#qmsId').val());
	navigator.sendBeacon("${url}/admin/order/setQmsOrderTempReset.lime?qmsId="+$('#qmsId').val());
	
	// Chrome에서는 returnValue 설정이 필요함
	event.returnValue = '';
	return true; 
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
    getGridList();
});

//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/qmsItemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');


var qmsSplitYn;

var defaultColModel= [ //  ####### 설정 #######
		{name:"QMS_ID"         , label:'qms번호'         , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"QMS_SEQ"        , label:'qmsseq 번호'     , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"QMS_ORD_NO"     , label:'QMS 오더 번호'   , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"QMS_DETL_ID"    , label:'qmsDetl 번호'    , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"QMS_SPLIT_YN"   , label:'현장분할가능여부', width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"ORDERNO"        , label:'오더번호'        , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"LINE_NO"        , label:'라인번호'        , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"ITEM_CD"        , label:'품목코드'        , width:100, align:'center', sortable:false, formatter:setDefault},
		{name:"ITEM_DESC"      , label:'품목'            , width:280, align:'left'  , sortable:false, formatter:setDefault},
		{name:"LOTN"           , label:'Lot No'          , width:100, align:'center', sortable:false, formatter:setDefault},
		{name:"ORDER_QTY"      , label:'오더수량'        , width:80 , align:'center', sortable:false, formatter:setDefault},
		{name:"QMS_ORD_BALANCE", label:'QMS 완료'        , width:80 , align:'center', sortable:false, formatter:setDefault},
		{name:"QMS_ORD_QTY"    , label:'QMS 수량'        , width:80 , align:'center', sortable:false, editable:true, formatter:setDefault},
		{name:"QMS_REMARK"     , label:'Remark'          , width:243, align:'center', sortable:false, editable:true, formatter:setDefault},
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

function getGridList(qmsSeq){ 
	// grid init
	var searchData = {
			 qmsId : $('#qmsId').val()
			,qmsSeq : qmsSeq != "" ? qmsSeq : 1
			,work : 'write'
		};

	var qmsSplitYn = $('#qmsSplitYn').val();
	console.log("${url}/admin/order/getQmsPopDetlGridList.lime");
	$("#gridList_"+qmsSeq).jqGrid({
		url: "${url}/admin/order/getQmsPopDetlGridList.lime",
		//editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 10000,
		/* rowList : ['10','30','50','100'], */
		multiselect: false,
		rownumbers: true,
		pagination: false,
		actions : false,
		//sortable: true,
		sortable: { // ####### 설정 #######
			update: function(relativeColumnOrder){
				var grid = $('#gridList_'+qmsSeq);
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
			
			var grid = $('#gridList_'+qmsSeq);
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
			$('#'+this.id+'_cnt').html(addComma(data.length));
		},
		gridComplete: function(){ 
			// 조회된 데이터가 없을때
			var grid = $('#'+this.id);
		    var emptyText = grid.getGridParam('emptyDataText'); //NO Data Text 가져오기.
		    var container = grid.parents('.ui-jqgrid-view'); //Find the Grid's Container
			if(0 == grid.getGridParam('records')){
				//container.find('.ui-jqgrid-hdiv, .ui-jqgrid-bdiv').hide(); //Hide The Column Headers And The Cells Below
		        //container.find('.ui-jqgrid-titlebar').after(''+emptyText+'');
            }
		},
		onSelectRow : function(rowid) {
			var gridId = '#'+this.id;
			
			if(rowid && rowid != lastSelection){
	    		//$('#gridList').restoreRow(lastSelection, true);
	    		$(gridId).jqGrid('saveRow', lastSelection, true, 'clientArray');
	           	lastSelection = rowid; 
	    		$(gridId).jqGrid('saveRow', rowid, true, 'clientArray');
	    	}
			var oldRow = $('#'+this.id).jqGrid("getRowData",rowid);
			if(oldRow['QMS_SPLIT_YN'] == 'Y'){
				// 특정 cell 수정 가능하게
				//$('#'+this.id).jqGrid('setCell', rowid,  'QMS_ORD_QTY', "", 'editable-cell'); 
				
				$(gridId).jqGrid('editRow',rowid, 
					{
						'keys' : true,
						'oneditfunc' : null,
						'successfunc' : null,
						'url' : null,
						'extraparam' : {},
						'aftersavefunc' : function(){ alert('test'); },
						'errorfunc': function(){ 
							$(gridId).jqGrid('saveRow', rowid, true, 'clientArray');
							var newRow = $('#'+this.id).jqGrid("getRowData",rowid);
							
							var orderQty  = Number(newRow['ORDER_QTY']!=''?newRow['ORDER_QTY']:0);
							var qmsOrdBal = Number(newRow['QMS_ORD_BALANCE']!=''?newRow['QMS_ORD_BALANCE']:0);
							var qmsOrdQty = Number(newRow['QMS_ORD_QTY']!=''?newRow['QMS_ORD_QTY']:0);
							
							$.ajax({
								async : false,
								data : newRow,
								type : 'POST',
								url : '${url}/admin/order/getQmsOrderQtyCheck.lime',
								success : function(data) {
									var qmsBalance = orderQty - Number(data['QMS_BALANCE']);
									//alert(qmsBalance);
									if(qmsOrdQty > qmsBalance){
										
										alert('입력 가능한 QMS 수량인 '+qmsBalance+'을 초과해서 입력하실 수 없습니다.');
										//$('#'+this.id).jqGrid('setCell', rowid, 'ORDER_QTY', oldRow['ORDER_QTY']);
										//$('#'+this.id).jqGrid('setCell', rowid, 'QMS_ORD_BALANCE', oldRow['QMS_ORD_BALANCE']);
										$("#qmsOrderSaveBtn").prop('disabled', false);
										$(gridId).jqGrid('setCell', rowid, 'QMS_ORD_QTY', Number(qmsBalance));
										dataSearch();
										return;
									}
									
								},
								error : function(request,status,error){
									alert('Error');
								}
							});
							
							
							return;
						},
						'afterrestorefunc' : null,
						'restoreAfterError' : true,
						'mtype' : 'POST'
					});
				$('#'+this.id).setColProp('QMS_ORD_QTY',{editable:true});
			}else{
				$('#'+this.id).setColProp('QMS_ORD_QTY',{editable:false});
				// 특정 cell 수정 못하게
				//$('#'+this.id).jqGrid('setCell', rowid,  'QMS_ORD_QTY', "", 'not-editable-cell');
			}
		
		},
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		//onSelectRow: editRow,
	});
}

$(function(){
	// 1번째 탭 자동 활성화
	$('.nav.nav-tabs').find('a.nav-link')[0].click();
	var qmsSeq = $('#qmsSeq').val()!=''?$('#qmsSeq').val():1;
	getGridList(qmsSeq);
	
	$('.nav-item').click(function(){
		var qmsFullId = $.trim($(this).text());
		var qmsSplit = qmsFullId.split("-");
		getGridList(qmsSplit[1]);
	});

	qmsSplitYn = $('#qmsSplitYn').val();

});


function qmsOrderSplit(obj,inQmsSeq){
	var custCd = $('#custCd_'+inQmsSeq).val();

	var qmsId = $('#qmsId').val();
	var qmsSeq = inQmsSeq;
	var saveRow = {};
	
	saveRow['qmsId']  = qmsId;
	saveRow['qmsSeq'] = qmsSeq;
	//현장정보
	saveRow['shiptoCd']  = $('#shiptoCd_'+qmsSeq).val();
	saveRow['shiptoNm']  = $('#shiptoNm_'+qmsSeq).val();
	saveRow['shiptoAddr'] = $('#shiptoAddr_'+qmsSeq).val();
	saveRow['shiptoEmail'] = $('#shiptoEmail_'+qmsSeq).val();

	//시공회사명
	saveRow['cnstrCd'] = $('#cnstrCd_'+qmsSeq).val();
	saveRow['cnstrNm'] = $('#cnstrNm_'+qmsSeq).val();
	saveRow['cnstrAddr'] = $('#cnstrAddr_'+qmsSeq).val();
	saveRow['cnstrBizNo'] = $('#cnstrBizNo_'+qmsSeq).val();
	saveRow['cnstrTel'] = $('#cnstrTel_'+qmsSeq).val();

	//감리회사
	saveRow['supvsCd'] = $('#supvsCd_'+qmsSeq).val();
	saveRow['supvsNm'] = $('#supvsNm_'+qmsSeq).val();
	saveRow['supvsAddr'] = $('#supvsAddr_'+qmsSeq).val();
	//saveRow['supvsBizNo'] = $('#supvsBizNo_'+qmsSeq).val();
	saveRow['supvsQlfNo'] = $('#supvsQlfNo_'+qmsSeq).val();
	saveRow['supvsDecNo'] = $('#supvsDecNo_'+qmsSeq).val();
	saveRow['supvsTel'] = $('#supvsTel_'+qmsSeq).val();

	var detlRow = [];
	var getDataIDs = $("#gridList_"+inQmsSeq).jqGrid("getDataIDs");
	for(var i = 0; i < getDataIDs.length; i++){
		$('#gridList_'+inQmsSeq).jqGrid('saveRow', getDataIDs[i], true, 'clientArray');
		var rowData = $("#gridList_"+inQmsSeq).jqGrid("getRowData",getDataIDs[i]);
		detlRow.push(rowData);
	}

	var fireproofChk = [];
	$("input:checkbox[name='fireproof_"+inQmsSeq+"']:checked").each(function(){
		fireproofChk.push($(this).val());
	});
	
	$.ajax({
		async : false,
		data : saveRow,
		type : 'POST',
		url : '${url}/admin/order/setQmsOrderMastTempUpdate.lime',
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
			url : '${url}/admin/order/setQmsOrderDetlTempUpdate.lime',
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
				url : '${url}/admin/order/setQmsOrderFireproofInit.lime',
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
			url : '${url}/admin/order/setQmsOrderFireproofUpdate.lime',
			success : function(data) {
				console.log(data);
			},
			error : function(request,status,error){
				alert('Error');
			}
		});
	}
	
	// 오더 스플릿
	$.ajax({
		async : false,
		data  : { 'qmsId':$('#qmsId').val(),'qmsSeq':inQmsSeq,'custCd':custCd },
		type  : 'POST',
		url   : '${url}/admin/order/setQmsOrderMastSplit.lime',
		success : function(result){
			if (result){
				opener.parent.dataSearch();
				alert('현장분할이 완료 되었습니다.\r현재 QMS 오더번호의 분할된 현장을 모두 조회합니다.');
				
				// 닫기 이벤트 제거
				window.removeEventListener('beforeunload', beforeUnload);
				location.href="/eorder/admin/order/qmsOrderPop.lime?qmsId="+$('#qmsId').val()+'&work=split';
			}
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

function qmsOrderCancel(obj,inQmsSeq){
	$.ajax({
		async : false,
		data : {'qmsId':qmsId,'qmsSeq':qmsSeq },
		type : 'POST',
		url : '${url}/admin/order/setQmsOrderFireproofInit.lime',
		success : function(data) {
			console.log(data);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

function qmsOrderDelete(obj,inQmsSeq){
	if (confirm('정말 삭제 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : {'qmsId':$('#qmsId').val(),'qmsSeq':inQmsSeq},
			type : 'POST',
			url : '${url}/admin/order/setQmsOrderMastDelete.lime',
			success : function(data) {
				alert('삭제 완료되었습니다.');
				opener.parent.dataSearch();
				// 닫기 이벤트 제거
				window.removeEventListener('beforeunload', beforeUnload);
				self.close();
			},
			error : function(request,status,error){
				alert('Error');
			}
		});
	}
}

function qmsOrderValidate(obj,inQmsSeq){
	var getDataIDs = $("#gridList_"+inQmsSeq).jqGrid("getDataIDs");
	
	var validate = true;
	for(var i = 0; i < getDataIDs.length; i++){
		$('#gridList_'+inQmsSeq).jqGrid('saveRow', getDataIDs[i], true, 'clientArray');
		var newRow = $("#gridList_"+inQmsSeq).jqGrid("getRowData",getDataIDs[i]);

		var orderQty  = Number(newRow['ORDER_QTY']!=''?newRow['ORDER_QTY']:0);
		var qmsOrdBal = Number(newRow['QMS_ORD_BALANCE']!=''?newRow['QMS_ORD_BALANCE']:0);
		var qmsOrdQty = Number(newRow['QMS_ORD_QTY']!=''?newRow['QMS_ORD_QTY']:0);
		$.ajax({
			async : false,
			data : newRow,
			type : 'POST',
			url : '${url}/admin/order/getQmsOrderQtyCheck.lime',
			success : function(data) {
				var qmsBalance = orderQty - Number(data['QMS_BALANCE']);
				//alert(qmsBalance);
				if(qmsOrdQty > qmsBalance){
					alert('입력 가능한 QMS 수량인 '+qmsBalance+'을 초과해서 입력하실 수 없습니다.');
					$("#qmsOrderSaveBtn").prop('disabled', false);
					$('#gridList_'+inQmsSeq).jqGrid('setCell', getDataIDs[i], 'QMS_ORD_QTY', Number(qmsBalance));
					validate = false;
				}
				
			},
			error : function(request,status,error){
				alert('Error');
				validate = false;
			}
		});
	}
	
	return validate;
}

function qmsOrderSaves(obj){
	var tabs = $('.nav-tabs').find('li a');
	
	console.log(tabs.text());

	if (confirm('저장 하시겠습니까?')) {
		$(obj).prop('disabled', true);
		for(var i = 0; i < tabs.length; i++){
			
			var qmsOrdNo = tabs[i].innerHTML.split('-');
			var qmsId  = qmsOrdNo[0];
			var qmsSeq = qmsOrdNo[1];
			var saveRow = {};
			
			if(!qmsOrderValidate(obj,qmsSeq)){
				//alert('오더수량을 초과해서 QMS 수량을 입력하실 수 없습니다.');
				return ;
			}
			
			saveRow['qmsId']  = qmsId;
			saveRow['qmsSeq'] = qmsSeq;
			//현장정보
			saveRow['shiptoCd']  = $('#shiptoCd_'+qmsSeq).val();
			saveRow['shiptoNm']  = $('#shiptoNm_'+qmsSeq).val();
			saveRow['shiptoAddr'] = $('#shiptoAddr_'+qmsSeq).val();
			saveRow['shiptoEmail'] = $('#shiptoEmail_'+qmsSeq).val();
	
			//시공회사명
			saveRow['cnstrCd'] = $('#cnstrCd_'+qmsSeq).val();
			saveRow['cnstrNm'] = $('#cnstrNm_'+qmsSeq).val();
			saveRow['cnstrAddr'] = $('#cnstrAddr_'+qmsSeq).val();
			saveRow['cnstrBizNo'] = $('#cnstrBizNo_'+qmsSeq).val();
			saveRow['cnstrTel'] = $('#cnstrTel_'+qmsSeq).val();
	
			//감리회사
			saveRow['supvsCd'] = $('#supvsCd_'+qmsSeq).val();
			saveRow['supvsNm'] = $('#supvsNm_'+qmsSeq).val();
			saveRow['supvsAddr'] = $('#supvsAddr_'+qmsSeq).val();
			//saveRow['supvsBizNo'] = $('#supvsBizNo_'+qmsSeq).val();
			saveRow['supvsQlfNo'] = $('#supvsQlfNo_'+qmsSeq).val();
			saveRow['supvsDecNo'] = $('#supvsDecNo_'+qmsSeq).val();
			saveRow['supvsTel'] = $('#supvsTel_'+qmsSeq).val();
	
			var detlRow = [];
			var getDataIDs = $("#gridList_"+qmsSeq).jqGrid("getDataIDs");
			for(var l = 0; l < getDataIDs.length; l++){
				$('#gridList_'+qmsSeq).jqGrid('saveRow', getDataIDs[l], true, 'clientArray');
				var rowData = $("#gridList_"+qmsSeq).jqGrid("getRowData",getDataIDs[l]);
				detlRow.push(rowData);
			}
	
			var fireproofChk = [];
			$("input:checkbox[name='fireproof_"+qmsSeq+"']:checked").each(function(){
				fireproofChk.push($(this).val());
			});
	
			if(saveRow['shiptoNm']==''){
				alert('현장정보 항목의 [현장명]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			}else if(saveRow['shiptoAddr']==''){
				alert('현장정보 항목의 [주소]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			}else if(saveRow['shiptoEmail']==''){
				alert('현장정보 항목의 [이메일]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			}else if(saveRow['cnstrNm']==''){
				alert('시공회사 정보 항목의 [시공회사명]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			}
			/* else if(saveRow['cnstrAddr']==''){
				alert('시공회사 정보 항목의 [주소]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			} */
			else if(saveRow['supvsNm']==''){
				alert('감리회사 정보 항목의 [감리회사명]을 입력해주세요.');
				$(obj).prop('disabled', false);
				return false;
			}
			/* else if(saveRow['supvsCd']==''){
				alert('감리회사 정보 항목의 [주소]을 입력해주세요.');
				return false;
			} */
			if( $('input:checkbox[name^="fireproof_"]:checked').length == 0 ){
				alert('최소 1개 이상의 내화구조유형을 선택해야 합니다.');
				$(obj).prop('disabled', false);
				return false;
			}
			
			
			$.ajax({
				async : false,
				data : saveRow,
				type : 'POST',
				url : '${url}/admin/order/setQmsOrderMastUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
			
			for(var j = 0 ; j < detlRow.length; j++){
				
				$.ajax({
					async : false,
					data : detlRow[j],
					type : 'POST',
					url : '${url}/admin/order/setQmsOrderDetlUpdate.lime',
					success : function(data) {
						//console.log(data);
					},
					error : function(request,status,error){
						alert('Error');
						$(obj).prop('disabled', false);
					}
				});
			}
	
			for(var k = 0 ; k < fireproofChk.length; k++){
				if(k == 0){
					$.ajax({
						async : false,
						data : {'qmsId':qmsId,'qmsSeq':qmsSeq },
						type : 'POST',
						url : '${url}/admin/order/setQmsOrderFireproofInit.lime',
						success : function(data) {
							console.log(data);
						},
						error : function(request,status,error){
							alert('Error');
							$(obj).prop('disabled', false);
						}
					});
				}
				
				$.ajax({
					async : false,
					data : {'qmsId':qmsId,'qmsSeq':qmsSeq,'keyCode': fireproofChk[k]},
					type : 'POST',
					url : '${url}/admin/order/setQmsOrderFireproofUpdate.lime',
					success : function(data) {
						console.log(data);
					},
					error : function(request,status,error){
						alert('Error');
						$(obj).prop('disabled', false);
					}
				});
				
			}

			
		}
		

		opener.parent.dataSearch();
		dataSearch();
		alert('저장되었습니다.');
		// 닫기 이벤트 제거
		window.removeEventListener('beforeunload', beforeUnload);
		self.close();
		$(obj).prop('disabled', false);
	}
	
	
	
	
}


function qmsOrderSave(obj,inQmsSeq){
	var qmsId = $('#qmsId').val();
	var qmsSeq = inQmsSeq;
	var saveRow = {};
	
	if(!qmsOrderValidate(obj,inQmsSeq)){
		
		//alert('오더수량을 초과해서 QMS 수량을 입력하실 수 없습니다.');
		return ;
	}
	
	saveRow['qmsId']  = qmsId;
	saveRow['qmsSeq'] = qmsSeq;
	//현장정보
	saveRow['shiptoCd']  = $('#shiptoCd_'+qmsSeq).val();
	saveRow['shiptoNm']  = $('#shiptoNm_'+qmsSeq).val();
	saveRow['shiptoAddr'] = $('#shiptoAddr_'+qmsSeq).val();
	saveRow['shiptoEmail'] = $('#shiptoEmail_'+qmsSeq).val();

	//시공회사명
	saveRow['cnstrCd'] = $('#cnstrCd_'+qmsSeq).val();
	saveRow['cnstrNm'] = $('#cnstrNm_'+qmsSeq).val();
	saveRow['cnstrAddr'] = $('#cnstrAddr_'+qmsSeq).val();
	saveRow['cnstrBizNo'] = $('#cnstrBizNo_'+qmsSeq).val();
	saveRow['cnstrTel'] = $('#cnstrTel_'+qmsSeq).val();

	//감리회사
	saveRow['supvsCd'] = $('#supvsCd_'+qmsSeq).val();
	saveRow['supvsNm'] = $('#supvsNm_'+qmsSeq).val();
	saveRow['supvsAddr'] = $('#supvsAddr_'+qmsSeq).val();
	//saveRow['supvsBizNo'] = $('#supvsBizNo_'+qmsSeq).val();
	saveRow['supvsQlfNo'] = $('#supvsQlfNo_'+qmsSeq).val();
	saveRow['supvsDecNo'] = $('#supvsDecNo_'+qmsSeq).val();
	saveRow['supvsTel'] = $('#supvsTel_'+qmsSeq).val();

	var detlRow = [];
	var getDataIDs = $("#gridList_"+inQmsSeq).jqGrid("getDataIDs");
	for(var i = 0; i < getDataIDs.length; i++){
		$('#gridList_'+inQmsSeq).jqGrid('saveRow', getDataIDs[i], true, 'clientArray');
		var rowData = $("#gridList_"+inQmsSeq).jqGrid("getRowData",getDataIDs[i]);
		detlRow.push(rowData);
	}

	var fireproofChk = [];
	$("input:checkbox[name='fireproof_"+inQmsSeq+"']:checked").each(function(){
		fireproofChk.push($(this).val());
	});

	if(saveRow['shiptoNm']==''){
		alert('현장정보 항목의 [현장명]을 입력해주세요.');
		return false;
	}else if(saveRow['shiptoAddr']==''){
		alert('현장정보 항목의 [주소]을 입력해주세요.');
		return false;
	}else if(saveRow['shiptoEmail']==''){
		alert('현장정보 항목의 [이메일]을 입력해주세요.');
		return false;
	}else if(saveRow['cnstrNm']==''){
		alert('시공회사 정보 항목의 [시공회사명]을 입력해주세요.');
		return false;
	}
	/* else if(saveRow['cnstrAddr']==''){
		alert('시공회사 정보 항목의 [주소]을 입력해주세요.');
		return false;
	} */
	else if(saveRow['supvsNm']==''){
		alert('감리회사 정보 항목의 [감리회사명]을 입력해주세요.');
		return false;
	}
	/* else if(saveRow['supvsCd']==''){
		alert('감리회사 정보 항목의 [주소]을 입력해주세요.');
		return false;
	} */
	
	if (confirm('저장 하시겠습니까?')) {
		$(obj).prop('disabled', true);
		$.ajax({
			async : false,
			data : saveRow,
			type : 'POST',
			url : '${url}/admin/order/setQmsOrderMastUpdate.lime',
			success : function(data) {
				console.log(data);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
		
		for(var i = 0 ; i < detlRow.length; i++){
			
			$.ajax({
				async : false,
				data : detlRow[i],
				type : 'POST',
				url : '${url}/admin/order/setQmsOrderDetlUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
		}

		for(var i = 0 ; i < fireproofChk.length; i++){
			if(i == 0){
				$.ajax({
					async : false,
					data : {'qmsId':qmsId,'qmsSeq':qmsSeq },
					type : 'POST',
					url : '${url}/admin/order/setQmsOrderFireproofInit.lime',
					success : function(data) {
						console.log(data);
					},
					error : function(request,status,error){
						alert('Error');
						$(obj).prop('disabled', false);
					}
				});
			}
			
			$.ajax({
				async : false,
				data : {'qmsId':qmsId,'qmsSeq':qmsSeq,'keyCode': fireproofChk[i]},
				type : 'POST',
				url : '${url}/admin/order/setQmsOrderFireproofUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
		}
		opener.parent.dataSearch();
		dataSearch();
		alert('저장되었습니다.');
		// 닫기 이벤트 제거
		window.removeEventListener('beforeunload', beforeUnload);
		self.close();
		$(obj).prop('disabled', false);
	}
}


function setDefaultShipto(inQmsSeq){
	$('#shiptoCd_'+inQmsSeq).val('');
	$('#shiptoNm_'+inQmsSeq).val('');
	$('#shiptoAddr_'+inQmsSeq).val('');
	$('#shiptoEmail_'+inQmsSeq).val('');

	//$('#cnstrCd_'+inQmsSeq).val('');
	$('#cnstrNm_'+inQmsSeq).val('');
	$('#cnstrAddr_'+inQmsSeq).val('');
	$('#cnstrBizNo_'+inQmsSeq).val('');
	//$('#cnstrEmail_'+inQmsSeq).val('');
	$('#cnstrTel_'+inQmsSeq).val('');

	//$('#supvsCd_'+inQmsSeq).val('');
	$('#supvsNm_'+inQmsSeq).val('');
	$('#supvsAddr_'+inQmsSeq).val('');
	//$('#supvsBizNo_'+inQmsSeq).val('');
	$('#supvsQlfNo_'+inQmsSeq).val('');
	$('#supvsDecNo_'+inQmsSeq).val('');
	//$('#supvsEmail_'+inQmsSeq).val('');
	$('#supvsTel_'+inQmsSeq).val('');
}


//거래처 선택 팝업 띄우기.
function openCorpPop(inQmsSeq){
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 805;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="customerListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderlist" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/order/qmsCorpListPop.lime?qmsId='+$('#qmsId').val()+'&qmsSeq='+inQmsSeq;
	window.open('', 'customerListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}


function setCorpFromPop(json,inQmsSeq){
	$('#shiptoCd_'+inQmsSeq).val(json['SHIPTO_CD']);
	$('#shiptoNm_'+inQmsSeq).val(json['SHIPTO_NM']);
	$('#shiptoAddr_'+inQmsSeq).val(json['SHIPTO_ADDR']);
	$('#shiptoEmail_'+inQmsSeq).val(json['SHIPTO_EMAIL']);

	//$('#cnstrCd_'+$('#qmsSeq').val()).val(json['CNSTR_CD']);
	$('#cnstrNm_'+inQmsSeq).val(json['CNSTR_NM']);
	$('#cnstrAddr_'+inQmsSeq).val(json['CNSTR_ADDR']);
	$('#cnstrBizNo_'+inQmsSeq).val(json['CNSTR_BIZ_NO']);
	//$('#cnstrEmail_'+$('#qmsSeq').val()).val(json['CNSTR_EMAIL']);
	$('#cnstrTel_'+inQmsSeq).val(json['CNSTR_TEL']);

	//$('#supvsCd_'+$('#qmsSeq').val()).val(json['SUPVS_CD']);
	$('#supvsNm_'+inQmsSeq).val(json['SUPVS_NM']);
	$('#supvsAddr_'+inQmsSeq).val(json['SUPVS_ADDR']);
	//$('#supvsBizNo_'+inQmsSeq).val(json['SUPVS_BIZ_NO']);
	$('#supvsQlfNo_'+inQmsSeq).val(json['SUPVS_QLF_NO']);
	$('#supvsDecNo_'+inQmsSeq).val(json['SUPVS_DEC_NO']);
	//$('#supvsEmail_'+$('#qmsSeq').val()).val(json['SUPVS_EMAIL']);
	$('#supvsTel_'+inQmsSeq).val(json['SUPVS_TEL']);
}

function shiptoCdReset(inQmsSeq){
	//debugger;
	$('#shiptoCd_'+inQmsSeq).val('');
}

//조회
function dataSearch() {
	// 조회조건으로 QMS 수량 재조회
	var tabs = $('.nav-tabs').find('li a');
	
	for(var i = 0; i < tabs.length; i++){
		var qmsOrdNo = tabs[i].innerHTML.split('-');
		var qmsId  = qmsOrdNo[0];
		var qmsSeq = qmsOrdNo[1];

		var searchData = {
			 qmsId : qmsId
			,qmsSeq : qmsSeq != "" ? qmsSeq : 1
			,work : 'write'
		};
		
		//QMS 디테일 재조회
		$('#gridList_'+qmsSeq).setGridParam({
			postData : searchData
		}).trigger("reloadGrid");
	}
	
}


﻿document.onkeydown = function() {
	// 새로고침 방지 ( Ctrl+R, Ctrl+N, F5 )
	if ( event.ctrlKey == true && ( event.keyCode == 78 || event.keyCode == 82 ) || event.keyCode == 116) {
	event.keyCode = 0;
	event.cancelBubble = true;
	event.returnValue = false;
	}
	
	// 윈도우 창이 닫힐 경우
	if (event.keyCode == 505) {
	    alert(document.body.onBeforeUnload);
	}
}


</script>
</head>
<form name="frmPopSubmit" method="post">
	<input type="hidden" id="qmsId"  name="qmsId" value="${qmsId}"></input>
	<input type="hidden" id="qmsSeq" name="qmsSeq" value="${qmsSeq}"></input>
	<input type="hidden" id="qmsSplitYn" name="qmsSplitYn" value="${qmsSplitYn}"></input>
</form>
<body >
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
		    <a class="nav-link" data-toggle="tab" href="#tab_${mastlist.QMS_SEQ}">${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</a>
		  </li>
		</c:forEach>
	</ul>
	
	<div class="tab-content">
		<c:forEach items="${qmsMastList}" var="mastlist" varStatus="status">
		<div class="tab-pane fade" id="tab_${mastlist.QMS_SEQ}">
			<div class="panel panel-white">
			<div class="row">
				<form name="mast_frm_${mastlist.QMS_SEQ}">
				<input type="hidden" id="custCd_${mastlist.QMS_SEQ}" name="custCd_${mastlist.QMS_SEQ}" value="${mastlist.CUST_CD}"/>
				<div class="page-title">
					<h3>
						QMS 정보 입력<%--  <c:if test="${mastlist.DELETEYN eq 'T'}"><span id="saveStat_${mastlist.QMS_SEQ}">(임시저장)</span></c:if> --%>
						<c:if test="${mastlist.QMS_SPLIT_YN eq 'Y' and admin_authority eq 'QM' or (mastlist.ACTIVEYN eq 'N' and createUser eq sessionScope.loginDto.userId) }">
						<div class="page-right">
							<button type="button" class="btn btn-line f-black" title="현장분할" onclick="qmsOrderSplit(this,'${mastlist.QMS_SEQ}')">
								<i class="fa fa-file-text-o"></i><em>현장분할</em>
							</button>
						</div>
						</c:if>
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
									<li><label class="search-h">현장 코드</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SHIPTO_CD}"
												id="shiptoCd_${mastlist.QMS_SEQ}" name="shiptoCd_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off" readonly="readonly">
										</div></li>
									<li class="wide"><label class="search-h">현장명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="shiptoNm_${mastlist.QMS_SEQ}" name="shiptoNm_${mastlist.QMS_SEQ}" value="${mastlist.SHIPTO_NM}"
												onchange="shiptoCdReset(${mastlist.QMS_SEQ})" /> <a
												href="javascript:;" onclick="openCorpPop(${mastlist.QMS_SEQ});"><i
												class="fa fa-search i-search" value="${mastlist.SHIPTO_CD}"></i></a>
											<button type="button" class="btn btn-line btn-xs pull-left"
												onclick="setDefaultShipto('${mastlist.QMS_SEQ}');">초기화</button>
										</div></li>
									
									
									<li class="wide"><label class="search-h">주소 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SHIPTO_ADDR}"
												id="shiptoAddr_${mastlist.QMS_SEQ}" name="shiptoAddr_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li class="wide"><label class="search-h">이메일 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SHIPTO_EMAIL}"
												id="shiptoEmail_${mastlist.QMS_SEQ}" name="shiptoEmail_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>시공회사 정보</b></label>
										<div class="search-c"></div></li>
									
									<li class="wide"><label class="search-h">시공회사 명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="cnstrNm_${mastlist.QMS_SEQ}" name="cnstrNm_${mastlist.QMS_SEQ}" value="${mastlist.CNSTR_NM}"
												 /> 
												<%-- <a href="javascript:;" onclick="openUserListPop('sales');"><i
												class="fa fa-search i-search" value="${mastlist.CNSTR_NM}"></i></a>
											<button type="button" class="btn btn-line btn-xs pull-left"
												onclick="setDefaultCnstr('${mastlist.QMS_SEQ}');">초기화</button> --%>
										</div></li>
									<%-- <li><label class="search-h">시공회사 코드</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.CNSTR_CD}"
												id="cnstrCd_${mastlist.QMS_SEQ}" name="cnstrCd_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off" >
										</div></li> --%>
									
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.CNSTR_ADDR}"
												id="cnstrAddr_${mastlist.QMS_SEQ}" name="cnstrAddr_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">사업자번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.CNSTR_BIZ_NO}"
												id="cnstrBizNo_${mastlist.QMS_SEQ}" name="cnstrBizNo_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.CNSTR_TEL}"
												id="cnstrTel_${mastlist.QMS_SEQ}" name="cnstrTel_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>감리회사 정보</b></label>
										<div class="search-c"></div></li>
									
									<li class="wide"><label class="search-h">감리회사 명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="supvsNm_${mastlist.QMS_SEQ}" name="shiptoNm_${mastlist.QMS_SEQ}" value="${mastlist.SUPVS_NM}"
												 /> 
												<%-- <a href="javascript:;" onclick="openUserListPop('sales');"><i
												class="fa fa-search i-search" value="${mastlist.SHIPTO_CD}"></i></a>
											<button type="button" class="btn btn-line btn-xs pull-left"
												onclick="setDefaultSupvs('${mastlist.QMS_SEQ}');">초기화</button> --%>
										</div></li>
									<%-- <li><label class="search-h">감리회사 코드</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SUPVS_CD}"
												id="supvsCd_${mastlist.QMS_SEQ}" name="supvsCd_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li> --%>
									
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SUPVS_ADDR}"
												id="supvsAddr_${mastlist.QMS_SEQ}" name="supvsAddr_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li class="wide"><label class="search-h">자격번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SUPVS_QLF_NO}"
												id="supvsQlfNo_${mastlist.QMS_SEQ}" name="supvsQlfNo_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li class="wide"><label class="search-h">신고번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SUPVS_DEC_NO}"
												id="supvsDecNo_${mastlist.QMS_SEQ}" name="supvsDecNo_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SUPVS_TEL}"
												id="supvsTel_${mastlist.QMS_SEQ}" name="supvsTel_${mastlist.QMS_SEQ}" onkeypress="" autocomplete="off">
										</div></li>
								</ul>
							</div>
							
							
						</div>
					</div>
					<div style="margin-top:20px;">&nbsp;&nbsp;&nbsp;<span class="red">*</span> 항목은 필수 입력 사항입니다.</div>
				<div class="page-title" style="margin-top:15px;">
					<h3>
						품목정보
						<div class="page-right">
							<h5 class="table-title listT" style="line-height: 32px;">TOTAL <span id="gridList_${mastlist.QMS_SEQ}_cnt">0</span>EA</h5>
						</div>
					</h3>
				</div>
					<div class="table-responsive in">
						<table id="gridList_${mastlist.QMS_SEQ}" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
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
					
					<td>
						<div class="fireproofItem">
							<c:choose>
							    <c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
							        <label src="${url}/data/fireproof/${fireprooflist.FILENAME}" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb">
							    </c:when>
							    <c:otherwise>
							        <label src="${url}/include/images/admin/list_noimg.gif" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" class="thumb">
							    </c:otherwise>
							</c:choose>
							<input type="checkbox" id="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}" name="fireproof_${mastlist.QMS_SEQ}" value="${fireprooflist.KEYCODE}" <c:if test="${fireprooflist.CHK_YN eq 'Y'}">checked</c:if>></input>
							${fireprooflist.FIREPROOFTYPE}</label>
						</div>
					</td>
					
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
				
			</div>
			<div class="qmsBtnDiv row">
				<c:if test="${admin_authority eq 'QM' or (mastlist.ACTIVEYN eq 'N' and createUser eq sessionScope.loginDto.userId) }">
					<button class="btn btn-lg btn-info"    onclick="qmsOrderSaves(this);" type="button" title="QMS 저장" id="qmsOrderSaveBtn">저장</button>
					<button class="btn btn-lg btn-danger"  onclick="qmsOrderDelete(this, '${mastlist.QMS_SEQ}');" type="button" title="삭제">삭제</button>
				</c:if>
					<button class="btn btn-lg btn-gray" onclick="javascript:self.close();" type="button" title="닫기">닫기</button>
			</div>
		</div>
		</c:forEach>
		</div>
	</div>
	
</body>

</html>