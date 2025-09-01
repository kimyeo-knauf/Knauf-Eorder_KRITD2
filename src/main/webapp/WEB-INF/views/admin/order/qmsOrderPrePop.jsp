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

//### 1 ###################################################################################################
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/order/qmsItemList/jqGridCookie'; // 페이지별 쿠키명 설정. // ####### 설정 #######
ckNameJqGrid += '/gridList'; // 그리드명별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');


var defaultColModel= [ //  ####### 설정 #######
		{name:"QMS_TEMP_ID"    , label:'qms번호'         , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"QMS_DETL_ID"    , label:'qms디테일번호'         , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"ORDERNO"        , label:'오더번호'        , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"LINE_NO"        , label:'라인번호'        , width:80 , align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"ITEM_CD"        , label:'품목코드'        , width:100, align:'center', sortable:false, formatter:setDefault},
		{name:"ITEM_DESC"      , label:'품목'            , width:320, align:'left'  , sortable:false, formatter:setDefault},
		{name:"LOTN"           , label:'Lot No'          , width:100, align:'center', sortable:false, formatter:setDefault, hidden:true},
		{name:"ORDER_QTY"      , label:'오더수량'        , width:80 , align:'center', sortable:false, formatter:setDefault},
		{name:"QMS_ORD_QTY"    , label:'QMS 수량'        , width:80 , align:'center', sortable:false, formatter:setDefault},
		{name:"QMS_REMARK"     , label:'Remark'          , width:330, align:'center', sortable:false, editable:true, formatter:setDefault},
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
	var qmsTempId = $('#qmsTempId').val();
	//alert('id : '+id+'\nlastSelection : '+lastSelection);
    if (id && id !== lastSelection) {
        var grid = $('#gridList_'+qmsTempId);
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

function getGridList(qmsTempId){ 
	// grid init
	var searchData = {
			qmsTempId : $('#qmsTempId').val()
		};

	$("#gridList_"+qmsTempId).jqGrid({
		url: "${url}/admin/order/getQmsPopPreDetlGridList.lime",
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
				var grid = $('#gridList_'+qmsTempId);
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
			
			var grid = $('#gridList_'+qmsTempId);
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
		emptyDataText: '조회된 데이터가 없습니다.', //NO Data Text
		onSelectRow: editRow,
	});
}

$(function(){
	// 1번째 탭 자동 활성화
	$('.nav.nav-tabs').find('a.nav-link')[0].click();
	var qmsTempId = $('#qmsTempId').val()!=''?$('#qmsTempId').val():1;
	getGridList(qmsTempId);
	
	$('.nav-item').click(function(){
		var qmsFullId = $.trim($(this).text());
		var qmsSplit = qmsFullId.split("-");
		getGridList(qmsSplit[1]);
	});

});

function qmsOrderDelete(obj,qmsTempId){
	if (confirm('QMS 사전입력을 정말 취소 하시겠습니까?')) {
		$.ajax({
			async : false,
			data : {'qmsTempId':qmsTempId},
			type : 'POST',
			url : '${url}/admin/order/setQmsFirstOrderCancelAjax.lime',
			success : function(data) {
				alert('취소가 완료되었습니다.');
				if($('#r_reqno').val()){
					opener.parent.location.replace("/eorder/admin/order/orderView.lime?r_reqno="+$('#r_reqno').val());
				}else{
					opener.parent.location.replace("/eorder/admin/order/orderList.lime");
				}
				
				self.close();
			},
			error : function(request,status,error){
				alert('Error');
			}
		});
	}
}


function qmsOrderSave(obj,qmsTempId){
	var qmsTempId = $('#qmsTempId').val();
	var saveRow = {};
	
	/* if(!qmsOrderValidate(obj,qmsTempId)){
		//alert('오더수량을 초과해서 QMS 수량을 입력하실 수 없습니다.');
		return ;
	} */
	
	saveRow['qmsTempId']  = qmsTempId;
	//현장정보
	saveRow['shiptoCd']  = $('#shiptoCd_'+qmsTempId).val();
	saveRow['shiptoNm']  = $('#shiptoNm_'+qmsTempId).val();
	saveRow['shiptoAddr'] = $('#shiptoAddr_'+qmsTempId).val();
	saveRow['shiptoEmail'] = $('#shiptoEmail_'+qmsTempId).val();

	//시공회사명
	saveRow['cnstrCd'] = $('#cnstrCd_'+qmsTempId).val();
	saveRow['cnstrNm'] = $('#cnstrNm_'+qmsTempId).val();
	saveRow['cnstrAddr'] = $('#cnstrAddr_'+qmsTempId).val();
	saveRow['cnstrBizNo'] = $('#cnstrBizNo_'+qmsTempId).val();
	saveRow['cnstrTel'] = $('#cnstrTel_'+qmsTempId).val();

	//감리회사
	saveRow['supvsCd'] = $('#supvsCd_'+qmsTempId).val();
	saveRow['supvsNm'] = $('#supvsNm_'+qmsTempId).val();
	saveRow['supvsAddr'] = $('#supvsAddr_'+qmsTempId).val();
	saveRow['supvsBizNo'] = $('#supvsBizNo_'+qmsTempId).val();
	saveRow['supvsTel'] = $('#supvsTel_'+qmsTempId).val();

	var detlRow = [];
	var getDataIDs = $("#gridList_"+qmsTempId).jqGrid("getDataIDs");
	for(var i = 0; i < getDataIDs.length; i++){
		$('#gridList_'+qmsTempId).jqGrid('saveRow', getDataIDs[i], true, 'clientArray');
		var rowData = $("#gridList_"+qmsTempId).jqGrid("getRowData",getDataIDs[i]);
		detlRow.push(rowData);
	}

	var fireproofChk = [];
	$("input:checkbox[name='fireproof_"+qmsTempId+"']:checked").each(function(){
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
			url : '${url}/admin/order/setQmsOrderPreMastUpdate.lime',
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
				url : '${url}/admin/order/setQmsOrderPreDetlUpdate.lime',
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
					data : {'qmsTempId':qmsTempId },
					type : 'POST',
					url : '${url}/admin/order/setQmsOrderPreFireproofInit.lime',
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
				data : {'qmsTempId':qmsTempId,'keyCode': fireproofChk[i]},
				type : 'POST',
				url : '${url}/admin/order/setQmsOrderPreFireproofUpdate.lime',
				success : function(data) {
					console.log(data);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
		}
		
		//dataSearch();
		alert('저장되었습니다.');
		$(obj).prop('disabled', false);
		//부모페이지 목록으로 이동
		opener.parent.moveOrderList();
		self.close();
	}
}


function setDefaultShipto(qmsTempId){
	$('#shiptoCd_'+qmsTempId).val('');
	$('#shiptoNm_'+qmsTempId).val('');
	$('#shiptoAddr_'+qmsTempId).val('');
	$('#shiptoEmail_'+qmsTempId).val('');

	//$('#cnstrCd_'+qmsTempId).val('');
	$('#cnstrNm_'+qmsTempId).val('');
	$('#cnstrAddr_'+qmsTempId).val('');
	$('#cnstrBizNo_'+qmsTempId).val('');
	//$('#cnstrEmail_'+qmsTempId).val('');
	$('#cnstrTel_'+qmsTempId).val('');

	//$('#supvsCd_'+qmsTempId).val('');
	$('#supvsNm_'+qmsTempId).val('');
	$('#supvsAddr_'+qmsTempId).val('');
	$('#supvsBizNo_'+qmsTempId).val('');
	//$('#supvsEmail_'+qmsTempId).val('');
	$('#supvsTel_'+qmsTempId).val('');
}


//거래처 선택 팝업 띄우기.
function openCorpPop(qmsTempId){
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
	var popUrl = '${url}/admin/order/qmsCorpListPop.lime?qmsTempId='+qmsTempId;
	window.open('', 'customerListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}


function setCorpFromPop(json){
	var qmsTempId = $('#qmsTempId').val();
	$('#shiptoCd_'+qmsTempId).val(json['SHIPTO_CD']);
	$('#shiptoNm_'+qmsTempId).val(json['SHIPTO_NM']);
	$('#shiptoAddr_'+qmsTempId).val(json['SHIPTO_ADDR']);
	$('#shiptoEmail_'+qmsTempId).val(json['SHIPTO_EMAIL']);

	//$('#cnstrCd_'+$('#qmsTempId').val()).val(json['CNSTR_CD']);
	$('#cnstrNm_'+qmsTempId).val(json['CNSTR_NM']);
	$('#cnstrAddr_'+qmsTempId).val(json['CNSTR_ADDR']);
	$('#cnstrBizNo_'+qmsTempId).val(json['CNSTR_BIZ_NO']);
	//$('#cnstrEmail_'+$('#qmsTempId').val()).val(json['CNSTR_EMAIL']);
	$('#cnstrTel_'+qmsTempId).val(json['CNSTR_TEL']);

	//$('#supvsCd_'+$('#qmsTempId').val()).val(json['SUPVS_CD']);
	$('#supvsNm_'+qmsTempId).val(json['SUPVS_NM']);
	$('#supvsAddr_'+qmsTempId).val(json['SUPVS_ADDR']);
	$('#supvsBizNo_'+qmsTempId).val(json['SUPVS_BIZ_NO']);
	//$('#supvsEmail_'+$('#qmsTempId').val()).val(json['SUPVS_EMAIL']);
	$('#supvsTel_'+qmsTempId).val(json['SUPVS_TEL']);
}

function shiptoCdReset(qmsTempId){
	//debugger;
	$('#shiptoCd_'+qmsTempId).val('');
}

//조회
function dataSearch() {
	// 조회조건으로 QMS 수량 재조회
	var tabs = $('.nav-tabs').find('li a');
	
	for(var i = 0; i < tabs.length; i++){
		var qmsOrdNo = tabs[i].innerHTML;
		var qmsTempId = $('#qmsTempId').val();
		var searchData = {
			qmsTempId : qmsTempId
		};
		
		//QMS 디테일 재조회
		$('#gridList_'+qmsTempId).setGridParam({
			postData : searchData
		}).trigger("reloadGrid");
	}
	
}

</script>
</head>
<form name="frmPopSubmit" method="post">
	<input type="hidden" id="qmsTempId" name="qmsTempId" value="${qmsTempId}"></input>
	<input type="hidden" id="r_reqno"   name="r_reqno" value="${param.r_reqno}"></input>
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
		    <a class="nav-link" data-toggle="tab" href="#tab_${mastlist.QMS_TEMP_ID}">${mastlist.REQ_NO}</a>
		  </li>
		</c:forEach>
	</ul>
	
	<div class="tab-content">
		<c:forEach items="${qmsMastList}" var="mastlist" varStatus="status">
		<div class="tab-pane fade" id="tab_${mastlist.QMS_TEMP_ID}">
			<div class="panel panel-white">
			<div class="row">
				<form name="mast_frm_${mastlist.QMS_TEMP_ID}">
				<input type="hidden" id="custCd_${mastlist.QMS_TEMP_ID}" name="custCd_${mastlist.QMS_TEMP_ID}" value="${mastlist.CUST_CD}"/>
				<div class="page-title">
					<h3>
						QMS 정보 입력 <c:if test="${mastlist.DELETEYN eq 'T'}"><span id="saveStat_${mastlist.QMS_TEMP_ID}">(임시저장)</span></c:if>
						<c:if test="${mastlist.QMS_SPLIT_YN eq 'Y' and admin_authority eq 'QM' or (mastlist.ACTIVEYN eq 'N' and createUser eq sessionScope.loginDto.userId) }">
						<div class="page-right">
							<button type="button" class="btn btn-line f-black" title="현장분할" onclick="qmsOrderSplit(this,'${mastlist.QMS_TEMP_ID}')">
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
									<li><label class="search-h"><b>주문번호</b></label>
										<div class="search-c" >
											<span>${mastlist.REQ_NO}</span>
										</div></li>
									<li><label class="search-h">현장 코드</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SHIPTO_CD}"
												id="shiptoCd_${mastlist.QMS_TEMP_ID}" name="shiptoCd_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off" readonly="readonly">
										</div></li>
									<li class="wide"><label class="search-h">현장명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="shiptoNm_${mastlist.QMS_TEMP_ID}" name="shiptoNm_${mastlist.QMS_TEMP_ID}" value="${mastlist.SHIPTO_NM}"
												onchange="shiptoCdReset(${mastlist.QMS_TEMP_ID})" /> <a
												href="javascript:;" onclick="openCorpPop(${mastlist.QMS_TEMP_ID});"><i
												class="fa fa-search i-search" value="${mastlist.SHIPTO_CD}"></i></a>
											<button type="button" class="btn btn-line btn-xs pull-left"
												onclick="setDefaultShipto('${mastlist.QMS_TEMP_ID}');">초기화</button>
										</div></li>
									
									
									<li class="wide"><label class="search-h">주소 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SHIPTO_ADDR}"
												id="shiptoAddr_${mastlist.QMS_TEMP_ID}" name="shiptoAddr_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
									<li class="wide"><label class="search-h">이메일 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SHIPTO_EMAIL}"
												id="shiptoEmail_${mastlist.QMS_TEMP_ID}" name="shiptoEmail_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>시공회사 정보</b></label>
										<div class="search-c"></div></li>
									
									<li class="wide"><label class="search-h">시공회사 명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="cnstrNm_${mastlist.QMS_TEMP_ID}" name="cnstrNm_${mastlist.QMS_TEMP_ID}" value="${mastlist.CNSTR_NM}" /> 
										</div></li>
									
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.CNSTR_ADDR}"
												id="cnstrAddr_${mastlist.QMS_TEMP_ID}" name="cnstrAddr_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">사업자번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.CNSTR_BIZ_NO}"
												id="cnstrBizNo_${mastlist.QMS_TEMP_ID}" name="cnstrBizNo_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.CNSTR_TEL}"
												id="cnstrTel_${mastlist.QMS_TEMP_ID}" name="cnstrTel_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
								</ul>
								<ul>
									<li class="wide"><label class="search-h"><b>감리회사 정보</b></label>
										<div class="search-c"></div></li>
									
									<li class="wide"><label class="search-h">감리회사 명 <span class="red">*</span></label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md "
												id="supvsNm_${mastlist.QMS_TEMP_ID}" name="shiptoNm_${mastlist.QMS_TEMP_ID}" value="${mastlist.SUPVS_NM}" /> 
										</div></li>
									
									<li class="wide"><label class="search-h">주소</label>
										<div class="search-c">
											<input type="text" class="search-input form-sm-d p-r-md" value="${mastlist.SUPVS_ADDR}"
												id="supvsAddr_${mastlist.QMS_TEMP_ID}" name="supvsAddr_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">사업자번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SUPVS_BIZ_NO}"
												id="supvsBizNo_${mastlist.QMS_TEMP_ID}" name="supvsBizNo_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
										</div></li>
									<li><label class="search-h">전화번호</label>
										<div class="search-c">
											<input type="text" class="search-input form-md-d p-r-md" value="${mastlist.SUPVS_TEL}"
												id="supvsTel_${mastlist.QMS_TEMP_ID}" name="supvsTel_${mastlist.QMS_TEMP_ID}" onkeypress="" autocomplete="off">
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
							<h5 class="table-title listT" style="line-height: 32px;">TOTAL <span id="gridList_${mastlist.QMS_TEMP_ID}_cnt">0</span>EA</h5>
						</div>
					</h3>
				</div>
					<div class="table-responsive in">
						<table id="gridList_${mastlist.QMS_TEMP_ID}" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
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
							        <label src="${url}/data/fireproof/${fireprooflist.FILENAME}" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_TEMP_ID}" class="thumb">
							    </c:when>
							    <c:otherwise>
							        <label src="${url}/include/images/admin/list_noimg.gif" for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_TEMP_ID}" class="thumb">
							    </c:otherwise>
							</c:choose>
							<input type="checkbox" id="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_TEMP_ID}" name="fireproof_${mastlist.QMS_TEMP_ID}" value="${fireprooflist.KEYCODE}" <c:if test="${fireprooflist.CHK_YN eq 'Y'}">checked</c:if>></input>
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
				<c:if test="${admin_authority eq 'QM' or (mastlist.CREATEUSER eq sessionScope.loginDto.userId) }">
					<button class="btn btn-lg btn-info"    onclick="qmsOrderSave(this);" type="button" title="QMS 저장">저장</button>
					<button class="btn btn-lg btn-danger"  onclick="qmsOrderDelete(this, '${mastlist.QMS_TEMP_ID}');" type="button" title="삭제">사전입력 취소</button>
				</c:if>
				<c:if test="${admin_authority ne 'QM' and (mastlist.CREATEUSER ne sessionScope.loginDto.userId) }">
					<button class="btn btn-lg btn-gray" onclick="javascript:self.close();" type="button" title="닫기">닫기</button>
				</c:if>
			</div>
		</div>
		</c:forEach>
		</div>
	</div>
	
</body>

</html>