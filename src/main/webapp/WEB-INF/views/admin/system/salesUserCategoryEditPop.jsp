<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<style>
/* jqgrid without thead : gridList thead만 */
#gbox_gridList .ui-jqgrid-hdiv {display:none !important;}
#gbox_gridList .ui-jqgrid-bdiv tr td:nth-child(6) {padding-right: 25px !important;}
</style>

<script src="${url}/include/js/common/dropzone/dropzone.min.js"></script>
<link href="${url}/include/js/common/dropzone/dropzone.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
var save_history_seq = 0;

$(function(){
	
});

//Dropzone
Dropzone.autoDiscover = false;
$(document).ready(function() {
	$("#frm").dropzone({ 
		url: "./updateItemExcelAjax.lime",
		url: "${url}/admin/system/updateSalesUserCategoryEditExcelAjax.lime",
		maxFiles: 1,
		acceptedFiles: ".xls,.XLS,.xlsx,.XLSX",
		maxFilesize: 30,
		
		init: function() {
			// maxFiles 카운터를 초과하면 경고창
			this.on("maxfilesexceeded", function(data) {
				save_history_seq = 0;
				
				$('#ajax_indicator').fadeOut();
				
				this.removeFile(data);
				alert('최대 업로드 파일 수는 1개 입니다.');
			});

			// 등록시 바로 처리하기 위한 컨펌창
			this.on("addedfile", function(data) {
				save_history_seq = 0;
				
				$('#ajax_indicator').show().fadeIn('fast');
				
				if (!confirm('임시 테이블에 업로드 하시겠습니까?')) {
					$('#ajax_indicator').fadeOut();
					this.removeFile(data);
				}
			});
			
			// 성공시
			this.on("success", function(data, response) {
				save_history_seq = 0;
				
				var result;
				var json = response;

				if('object' === typeof json) result = json;
				else result = JSON.parse(json);
				
				var resCode = result.RES_CODE;
				var resMsg = result.RES_MSG;
				
				//$('#resultContentPId').empty();
				//$('#resultContentPId').show();
				
				if('0000' == resCode){
					alert('임시테이블에 정상적으로 저장 되었습니다.\n아래 데이터를 확인하신후 저장 버튼을 눌러주세요.');
					getGridList(result.historySeq);
				}
				else{
					alert(resMsg);
				}
				//if('0000' != resCode){
					//alert(resMsg);
					//$('#resultContentPId').append('MASSAGE<br />');
				//}
				//$('#resultContentPId').append('<span>'+resMsg+'</span>');
				
				$('#ajax_indicator').fadeOut();
				this.removeFile(data);
			});
			
			// 에러시
			this.on("error", function(data, response, xhr) {
				save_history_seq = 0;
				
				console.log('data = '+data);
				alert('ERROR')
			    //$('#resultContentPId').show();
				//$('#resultContentPId').html('ERROR');


				$('#ajax_indicator').fadeOut();
				this.removeFile(data);
			});
		},
	});
});

function getGridList(historySeq){
	$('#gridList').jqGrid({
		url : "${url}/admin/system/getAdminUserAuthorityTempListAjax.lime",
		postData : {
			r_historySeq : historySeq
		},
		datatype : "json",
		mtype: 'POST',
		autowidth: true,
		//width: '100%',
		height: 'auto',
		hoverrows: false,
		viewrecords: false,
		gridview: true,
		//sortname: 'lft',
		//loadonce: true,
		//scrollrows: true,
		colModel : [
			{name: 'USERID', key:true, hidden:true},
			{name: 'AUTHORITY', hidden:true},
			{name: 'USER_DEPTH', hidden:true},
			{name: 'TOTAL_COUNT', hidden:true},
			{name: 'USER_NM', label: '사용자명', width:80, sortable: false, formatter:setUserNM},
			{name: 'AUTH_COUNT', label: '', align:'right', width:20, sortable: false, formatter:setAuthCount},
		],
		ExpandColumn : 'USER_NM',
		treeGrid : true,
		//treedatatype: 'json',
		treeGridModel : 'adjacency',
		treeReader : {
			level_field : "USER_DEPTH",
			parent_id_field : "USER_PARENT",
			leaf_field : "IS_LEAF",
			expanded_field : "IS_EXPAND",
		},
		treeIcons: {leaf:'ui-icon-document-b'},
		loadComplete: function(data){ //로딩완료후
			save_history_seq = historySeq;
			
			var ids = $('#gridList').getDataIDs();
			$.each(ids, function(idx, rowId){
				var rowData = $('#gridList').getRowData(rowId);
				var rowDepth = rowData.USER_DEPTH; //댚스
				var totalCount = rowData.TOTAL_COUNT;

				if(0 == idx) $('#totalCountSpanId').html(addComma(toStr(totalCount)));
				
				if(1 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#FFFFFF"});
				}
				
				else if(2 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#E7E7E7"});
				}
				else if(3 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#DDDDDD"});
				}
				else if(4 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#D1D1D1"});
				}
			});
		},
		onCellSelect: function (rowId, col, content, evt) { //셀 선택시
			
		},
		beforeSelectRow : function(rowId, evt){ //로우 선택전
			return true;
	    },
		onSelectRow: function(rowId) { //로우 선택시
			
		},
	});
}

function setUserNM(cellval, options, rowObject){
	var authority = rowObject.AUTHORITY;
	var userId = rowObject.USERID;
	var userDepth = rowObject.USER_DEPTH;
	var authCount = rowObject.AUTH_COUNT;
	var retVal = cellval;
	
	// 영업유저명 앞에 SH,SM,SR 붙이기.
	if(('SH' == authority || 'SM' == authority || 'SR' == authority) && '2' != userId){
		retVal = authority+' '+cellval;
	}
	
	return retVal;
}

function setAuthCount(cellval, options, rowObject){
	var authority = rowObject.AUTHORITY;
	//var userId = rowObject.USERID;
	var userDepth = rowObject.USER_DEPTH;
	var authCount = rowObject.AUTH_COUNT;
	var retVal = '';
	
	if('AD' == authority || 'CS' == authority || 'MK' == authority){
		if(Number(userDepth) < 2) retVal += toStr(authCount);
	}
	else if('SH' == authority || 'SM' == authority || 'SR' == authority){
		if(Number(userDepth) < 4) retVal += toStr(authCount);
	}
	
	return retVal;
}

function dataIn(obj){
	$(obj).prop('disabled', true);
	
	if(0 == save_history_seq){
		alert('임시 테이블에 엑셀 업로드 후 진행해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('영업조직을 아래와 같이 변경 하시겠습니까?')){
		$.ajax({
			async : false,
			data : {
				r_historyseq : save_history_seq
			},
			type : 'POST',
			url : '${url}/admin/system/updateSalesUserCategoryAjax.lime',
			success : function(data) {
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					window.location.reload();
					//formGetSubmit('${url}/admin/system/adminUser/pop2/salesUserCategoryEditPop.lime', 'pop=1');
				}else{
					
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

function dataDel(obj){
	$(obj).prop('disabled', true);
	
	if(0 == save_history_seq){
		alert('삭제할 임시 데이터가 없습니다.');
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('임시 데이터를 삭제 하시겠습니까?')){
		$.ajax({
			async : false,
			data : {
				r_historyseq : save_history_seq
			},
			type : 'POST',
			url : '${url}/admin/system/deleteTempSalesUserCategoryAjax.lime',
			success : function(data) {
				if (data.RES_CODE == '0000') {
					alert('임시 데이터가 삭제 되었습니다.');
					window.location.reload();
					//formGetSubmit('${url}/admin/system/adminUser/pop2/salesUserCategoryEditPop.lime', 'pop=1');
				}else{
					
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

//샘플파일다운로드
function fileDown(obj, file_type){ // file_type 1=영업조직 다운로드,2=샘플파일 다운로드.
	var fileFormHtml = '';
	
	if('1' == file_type){
		$('#ajax_indicator').show().fadeIn('fast');
		var token = getFileToken('excel');
		$('form[name="frm_excel"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
		
		formPostSubmit('frm_excel', '${url}/admin/system/salesUserCategoryEditExcelDown.lime');
		$('form[name="frm_excel"]').attr('action', '');
		
		$('input[name="filetoken"]').remove();
		var fileTimer = setInterval(function() {
			//console.log('token : ', token);
	        console.log("cookie : ", getCookie(token));
			if('true' == getCookie(token)){
				$('#ajax_indicator').fadeOut();
				delCookie(token);
				clearInterval(fileTimer);
			}
	    }, 1000 );
	}
	else if('2' == file_type){
		// 파일 다운로드.
		fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/base/sampleFileDown.lime">';
		fileFormHtml += '	<input type="hidden" name="r_filename" value="salesUserCategoryExcel.xlsx" />';
		fileFormHtml += '</form>';
		fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
		$.download('frm_filedown', fileFormHtml); // common.js 위치.
	}
}
</script>

</head>
<body class="bg-n">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<form name="frm_excel" method="post"></form>
	
	<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					영업조직 변경
					<div class="page-right">
						<%-- <button type="button" class="btn btn-line f-black" title="목록" onclick="location.href ='${url}/admin/item/itemList.lime'"><i class="fa fa-list-ul"></i><em>목록</em></button> --%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body">
								<h5 class="table-title no-title"></h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-warning" onclick="fileDown(this, '1');">영업조직현황 다운로드</button>
									<button type="button" class="btn btn-info" onclick="fileDown(this, '2');">샘플파일 다운로드</button>
								</div>
								
								<form class="dropzone pull-left full-width" name="frm" id="frm" enctype="multipart/form-data">
									<div class="fallback">
										<input type="file" class="dropify" />
										<input type="button" class="dropify-btn btn-github hide" value="파일업로드" onclick="fileUpload();" /> <!-- IE9 -->
									</div>
								</form>
								
								<p class="dropzone-white pull-left m-t-lg full-width" id="resultContentPId">
									* 위에 엑셀 업로드시 임시 테이블에 저장됩니다.<br />
									* 임시 테이블에 정상적으로 저장 되면, 아래에 저장된 데이터가 보여집니다.<br />
									* 아래, 임시로 저장된 데이터를 확인 하신후 "저장" 버튼 클릭시 최종적으로 운영조직 데이터가 변경 완료 됩니다.<br />
									* "임시 데이터 삭제" 버튼을 클릭시 현재 저장된 임시 데이터가 삭제 됩니다.<br /><br />
									1. 영업조직 현황을 다운로드 받으신후, 샘플파일에 맞게 작성후 업로드 해 주세요.<br />
									2. <b>샘플파일 > "영업담당자 아이디" 컬럼 > 현재 DB에 저장된 영업담당자의 아이디를 모두 입력해 주셔야 합니다.</b><br />  
									3. 샘플파일 > "권한" 컬럼 > RT = 비사용자 그룹으로, 영업담당자 아이디 컬럼에만 입력해 주시면 됩니다.<br />
									4. 샘플파일 > "상위 SH 아이디" 컬럼 > SM,SR 권한의 영업담당자만 입력해 주세요. <br />
									5. 샘플파일 > "상위 SM 아이디" 컬럼 > SR 권한의 영업담당자만 입력해 주세요.<br />
								</p>
							</div>
							
							<div class="panel-body">
								<div class="row">
									<div class="col-md-5 col-lg-3">
										<h5 class="table-title">Total <span id="totalCountSpanId">0</span>, 아래는 임시 테이블에 저장된 데이터 입니다.</h5>
										<div class="btnList writeObjectClass">
											<button type="button" class="btn btn-warning" onclick="dataIn(this);">저장</button>
											<button type="button" class="btn btn-github" onclick="dataDel(this);">임시 데이터 삭제</button>
										</div>

										<div class="table-responsive in table-left">
											<table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											</table>
										</div>
									</div>
									
									<div class="col-md-7 col-lg-9">
									</div>
								</div>
							</div>
						</div>
						
						
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
		</div>
		<!-- //Page Inner -->
</body>