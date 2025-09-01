<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
/* jqgrid without thead */
/* #gbox_gridList .ui-jqgrid-hdiv {display:none !important;} */
</style>
<script type="text/javascript">
var lastSelection, lastSelection2;

$(document).ready(function($){
	getGridList();
});

// 왼쪽 루트 트리뷰 리스트 가져오기.
function getGridList(){
	$('#gridList').jqGrid({
		url : '${url}/admin/system/getCommonCodeTreeListAjax.lime',
		editurl: 'clientArray',
		mtype: 'POST',
		datatype : "json",
		postData : {},
		colModel : [
			{ name:"CC_CODE", label:'코드', align:'center', width: 50, key:true, sortable:false, formatter:setCcCode},
			{ name:"CC_NAME", label:'코드명', align:'left', sortable:false, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '50');}}]} },
			{ name:"CC_DEPTH", hidden:true},
			{ name:"CC_PARENT", hidden:true},
		],
		ExpandColumn : 'CC_NAME',
		height : "auto",
		hoverrows: false,
		//treeGrid : false,
		treeGrid : true,
		treeGridModel : 'adjacency',
		treeReader : {
			level_field : "CC_DEPTH",
			parent_id_field : "CC_PARENT",
			leaf_field : "ISLEAF",
			expanded_field : "EXPANDED",
		},
		treeIcons: {leaf:'ui-icon-blank'},
		loadComplete: function(data){ //로딩완료후
			var ids = $('#gridList').getDataIDs();
			$.each(ids, function(idx, rowId){
				var rowData = $('#gridList').getRowData(rowId);
				var rowDepth = rowData.CC_DEPTH; //댚스
				if(1 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#EEEEEE"});
				}
				else if(2 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#F9F9F9"});
				}
				else if(3 == rowDepth){
					$('#gridList').setRowData(rowId, false, {background:"#D5D5D5"});
				}
			});
		},
		onSelectRow: function(rowId) {
			var h_cccode = $('#gridList').find('#' + rowId).find('input[name="h_cccode"]').val();
			if (h_cccode != '') { // editRow
				editRow(rowId);
			}
			
			getDetail(rowId);
		},
	});
}

// 오른쪽 상세 그리드 리스트 가져오기.
function getGridList2(cc_parent){
	
	var defColModel = [
		{ name:"CC_CODE", label:'코드', width:30, align:'center', key:true, sortable:false, formatter:setCcCode },
		{ name:"CC_NAME", label:'코드명', width:60, align:'left', sortable:false, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '50');}}]} },
		{ name:"CC_USE", label:'상태', width:10, align:'center', sortable:false, editable:true, edittype:'select', editoptions:{value:'Y:Y;N:N'} },
		{ name:"CC_PARENT", hidden:true},
	];
	if(isWriteAuth){
		defColModel = [
			{ name:"SORT_COL", label:'순서', width:100, align:'center', sortable:false, formatter:setSortCol },
			{ name:"CC_CODE", label:'코드', width:250, align:'center', key:true, sortable:false, formatter:setCcCode },
			{ name:"CC_NAME", label:'코드명', width:523, align:'left', sortable:false, editable:true, editoptions:{dataEvents:[{type:'keyup', fn:function(e){checkByte(this, '50');}}]} },
			{ name:"CC_USE", label:'상태', width:250, align:'center', sortable:false, editable:true, edittype:'select', editoptions:{value:'Y:Y;N:N'} },
			{ name:"CC_PARENT", hidden:true},
		];
	}
	
	$("#gridList2").jqGrid({
		url: '${url}/admin/system/getCommonCodeDetailListAjax.lime',
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: {
			r_ccparent : cc_parent
		},
		colModel: defColModel,
		height: '360px',
		autowidth: false,
		rowNum : 0,
		rownumbers: true,
		multiselect:true,
		multiselectWidth: 80,
		pagination: false,
		jsonReader : { 

		},
		loadComplete: function(data) {
			$('#noList').hide(); // NO DATA 리스트 영역.
		},
		onSelectRow: function(rowId){
			var h_cccode = $('#gridList').find('#'+rowId).find('input[name="h_cccode"]').val();
			if (h_cccode != '') { // editRow
				editRowDetail(rowId);
			}
		},
	});
	
	// 2댚스 행 드래그&소트.
	if(isWriteAuth){
		$('#gridList2').jqGrid('sortableRows', {
			update:function(e,ui){
				//var nowRowId = ui.item[0].id; // 지금 드래그한 로우 아이디.
				//console.log('nowRow : ', ui.item[0]);
	
				$('#uForm').empty();
				
				// 행이 변경된 이후 시점에 리스트 데이터.
				var ids = $('#gridList2').jqGrid('getDataIDs');
				//alert(ids.length);
				$.each(ids, function(idx, rowId){
					//Wvar rowData = $('#gridList2').getRowData(rowId);
					//var rowName = rowData.CC_NAME;
					//var rowParent = rowData.CC_PARENT;
					//alert('idx+1 : '+parseInt(idx+1)+'\nrowId : '+rowId+'\nrowName : '+rowName+'\nrowParent : '+rowParent);
					
					$('#uForm').append('<input type="hidden" name="r_cccode" value="' + rowId + '" />');
					$('#uForm').append('<input type="hidden" name="m_ccsort2" value="' + (Number(idx)+1) + '" />');
				});
				
				//console.log($('#uForm').html());
				var formData = $('form[name="uForm"]').serialize();
				$.ajax({
					async : false,
					data : formData,
					type : 'POST',
					url : '${url}/admin/system/updateCommonCodeSortAjax.lime',
					success : function(data) {
						
					},
					error : function(request,status,error){
						alert('Error');
						return;
					}
				});
				
			}
		});
	}
}

// 오른쪽 상세 그리드 리스트 리로드.
function getDetail(cc_parent) {
	if('none' == $('#noList').css('display')){
		//alert('reload !!!');
		$("#gridList2").setGridParam({
			postData : {
				r_ccparent:cc_parent
			}
		}).trigger("reloadGrid");
	}
	else{
		//alert('first load !!!');
		getGridList2(cc_parent);
	}
}

function setSortCol(cellVal, options, rowObj) {
// 	return '<img src="${url}/include/images/common/arrow2.png" />';
	return '<span style="line-height: .3; vertical-align: top; cursor: move;"><i class="fa fa-long-arrow-down"></i><i class="fa fa-long-arrow-up"></i></span>';
}

function setCcCode(cellVal, options, rowObj) {
	if(toStr(rowObj.CODE_TITLE) == '') return '<input type="hidden" name="h_cccode" value="' + rowObj.CC_CODE + '" />' + cellVal;
	else return '<input type="hidden" name="h_cccode" value="'+rowObj.CC_CODE+'" />' + rowObj.CODE_TITLE;
}

function editRow(id) {
	if (id && id !== lastSelection) {
		var grid = $("#gridList");
		// grid.jqGrid('restoreRow', lastSelection); // 이전에 선택한 행 제어
		grid.jqGrid('editRow', id, {keys: false}); // keys true=enter
		lastSelection = id;
	}
}

function editRowDetail(id){
  if (id && id !== lastSelection2) {
	var grid = $("#gridList2");
	//grid.jqGrid('restoreRow',lastSelection); //이전에 선택한 행 제어
	grid.jqGrid('editRow',id, {keys: false}); //keys true=enter
	lastSelection2 = id;
  }
}

function addRoot(obj) {
	var trHtml = '<tr>'
	+ '<td style="padding: 14px 10px 10px;">자동생성</td>'
	+ '<td style="text-align:left;"><input type="text" name="NEW_CC_NAME" style="width: 98%;" onkeyup=\'checkByte(this, "50");\' /></td>'
	+ '</tr>';
	
	$('#gridList tbody').append(trHtml);
	$('#gridList tbody').children(':last').find('input').focus();
}

function saveRoot(obj) {
	$(obj).prop('disabled', true);
	
	// 저장 및 수정 체크.
	var chk = true;
	var chkCnt = 0;
	$('#gridList input[name="CC_NAME"],input[name="NEW_CC_NAME"]').each(function() {
		chkCnt++;
		if (!$(this).val()) {
			chk = false;
			alert('코드명을 입력하여 주십시오.');
			$(this).focus();
			$(obj).prop('disabled', false);
			return false;
		}
	});
	
	if (!chk){
		$(obj).prop('disabled', false);
		return false;
	}
	if (0==chkCnt){
		alert('추가 또는 선택 후 진행해 주세요.');
		$(obj).prop('disabled', false);
		return false;
	}
	// End. 체크.
	
	if (confirm('저장 하시겠습니까?')) {
		$('#uForm').empty();
		
		// 수정.
		$('#gridList input[name="CC_NAME"]').each(function() {
			var trObj = $(this).closest('tr');
			$('#uForm').append('<input type="hidden" name="r_cccode" value="' + toStr(trObj.find('input[name="h_cccode"]').val()) + '" />');
			$('#uForm').append('<input type="hidden" name="m_ccname" value="' + toStr($(this).val()) + '" />');
		});
		
		// 저장.
		$('#gridList input[name="NEW_CC_NAME"]').each(function() {
			if ($(this).val()) {
				$('#uForm').append('<input type="hidden" name="r_cccode" value="" />');
				$('#uForm').append('<input type="hidden" name="m_ccname" value="' + toStr($(this).val()) + '" />');
			}
		});
		
		var formData = $('form[name="uForm"]').serialize();
		console.log('formData : ', formData);
		
		$.ajax({
			async : false,
			data : formData,
			type : 'POST',
			url : '${url}/admin/system/insertUpdateCommonRootCodeAjax.lime',
			success : function(data) {
				alert(data.RES_MSG);
				if (data.RES_CODE == '0000') {
					document.location.reload();
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

function addDetail() {
	var cc_parent = $('#gridList').jqGrid('getGridParam', 'selrow');
	
	if (cc_parent == null) {
		alert('왼쪽 트리뷰에서 부모코드를 선택해 주세요.');
		return false;
	}
	
	var rowData = {CODE_TITLE:'자동생성', CC_CODE:'', CC_PARENT:cc_parent, CC_USE:'Y'};
	var newRow = {position:"last", initdata:rowData};
	$("#gridList2").jqGrid('addRow', newRow);
}

function dataInUp(obj, val) {
	$(obj).prop('disabled', true);
	
	var cc_parent = $('#gridList').jqGrid('getGridParam', 'selrow');
	
	if (cc_parent == null) {
		alert('왼쪽 트리뷰에서 부모코드를 선택해 주세요.');
		$(obj).prop('disabled', false);
		return false;
	}
	
	var chk = $('#gridList2').jqGrid('getGridParam','selarrrow');
	chk += '';
	var chkArr = chk.split(",");
	if (chk == '') {
		alert("선택 후 진행해 주세요.");
		$(obj).prop('disabled', false);
		return false;
	}
	
	if (confirm('처리 하시겠습니까?')) {
		$('#uForm').empty();

		$('#uForm').append('<input type="hidden" name="m_ccuseyn" value="' + val + '" />');
		$('#uForm').append('<input type="hidden" name="m_ccparent" value="' + cc_parent + '" />');
		
		var chk = true;
		for (var i=0; i<chkArr.length; i++) {
			var trObj = $('#jqg_gridList2_' + chkArr[i]).closest('tr');
			
			$('#uForm').append('<input type="hidden" name="r_cccode" value="' + toStr(trObj.find('input[name="h_cccode"]').val()) + '" />');
			$('#uForm').append('<input type="hidden" name="m_ccname" value="' + toStr(trObj.find('input[name="CC_NAME"]').val()) + '" />');
			$('#uForm').append('<input type="hidden" name="m_ccuse" value="' + toStr(trObj.find('select[name="CC_USE"]').val()) + '" />');
			
			//validation
			if(trObj.find('input[name="CC_NAME"]').val() == '') {
				alert("코드명을 입력하세요."); 
				trObj.find('input[name="CC_NAME"]').focus();
				chk = false;
				$(obj).prop('disabled', false);
				return false;
			}
		}
		
		if (!chk){
			$(obj).prop('disabled', false);
			return false;
		}
		
		var formData = $('form[name="uForm"]').serialize();
		var url = '${url}/admin/system/insertUpdateCommonCodeAjax.lime'; 
		$.ajax({
			async : false,
			data : formData,
			type : 'POST',
			url : url,
			success : function(data) {
				alert(data.RES_MSG);
				if (data.RES_CODE == '0000') {
					$("#gridList2").setGridParam({
						postData : {
							r_ccparent: cc_parent
						}
					}).trigger("reloadGrid");
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

</script>
</head>

<body class="page-header-fixed compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					공통코드
					<div class="page-right">
						<%--
						<button type="button" class="btn btn-line text-default" title="검색" onclick="window.location.reload();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line text-default" title="엑셀다운로드" onclick="excelDown();"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
						 --%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="POST" onsubmit="return false">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body">
								<div class="row">
									<div class="col-md-5 col-lg-3">
										<h5 class="table-title no-title"></h5>
										<div class="btnList writeObjectClass">
											<button class="btn btn-warning" type="button" onclick="addRoot(this);">추가</button>
											<button class="btn btn-info" type="button" onclick="saveRoot(this);">저장</button>
										</div>
										<div class="table-responsive in min table-left">
											<table id="gridList" border="0" cellpadding="0" cellspacing="0">
											</table>
										</div>
									</div>
									<div class="col-md-7 col-lg-9">
										<h5 class="table-title no-title"></h5>
										<div class="btnList writeObjectClass">
											<button class="btn btn-warning" type="button" onclick="addDetail();">추가</button>
											<button class="btn btn-info" type="button" onclick="dataInUp(this, '');">저장</button>
											<button class="btn btn-gray" type="button" onclick="dataInUp(this, 'Y');">Y</button>
											<button class="btn btn-github" type="button" onclick="dataInUp(this, 'N');">N</button>
										</div>
										<div class="table-responsive right-sm">
											<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											</table>
											<table id="noList" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0">
												<tbody>
													<tr>
														<td>왼쪽 트리뷰에서 부모코드를 선택해 주세요.</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
				</form>
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
	<form name="uForm" id="uForm"></form>
</body>

</html>