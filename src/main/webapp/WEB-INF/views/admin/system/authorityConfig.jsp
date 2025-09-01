<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<style>
/* jqgrid without thead */
.ui-jqgrid-hdiv {display:none !important;}

/* input[readonly] {background-color:#E7E7E7;} */
</style>
<script type="text/javascript">
$(function(){
	
});

$(document).ready(function($){ 

});

var selectAuthSeq = 0; // 현재 선택한 권한.

// 접근권한 메뉴 리스트 세팅.
function setMenuAuthorityList(rl_seq, rl_code, name){
	$('#gridList2').jqGrid('GridUnload'); // 있어야 다시 호출하네...
	$('#gridList2').jqGrid({
		url : "${url}/admin/system/getMenuListForAuthorityAjax.lime",
		postData : {r_rmrlseq : rl_seq},
		datatype : "json",
		mtype: 'POST',
		autowidth: false,
		//width: '100%',
		height: 'auto',
		hoverrows: false,
		viewrecords: false,
		gridview: true,
		//sortname: 'lft',
		//loadonce: true,
		//scrollrows: true,
		colModel : [
			{ name: 'MN_SEQ', key:true, hidden:true },
			{ name: 'MN_DEPTH', hidden:true },
			{ name: 'MN_NAME', label: '메뉴명', width:628, sortable: false },
			{ name: 'RM_AUTH', label: '권한',width:603,  align: 'center', sortable: false, formatter:setMenuAuth }
		],
		ExpandColumn : 'MN_NAME',
		treeGrid : true,
		//treedatatype: 'json',
		treeGridModel : 'adjacency',
		treeReader : {
			level_field : "MN_DEPTH",
			parent_id_field : "MN_PARENT",
			leaf_field : "IS_LEAF",
			expanded_field : "IS_EXPAND",
		},
		treeIcons: {leaf:'ui-icon-document-b'},
		loadComplete: function(data){ //로딩완료후
			selectAuthSeq = rl_seq;
			
			var ids = $('#gridList2').getDataIDs();
			$.each(ids, function(idx, rowId){
				var rowData = $('#gridList2').getRowData(rowId);
				var rowDepth = rowData.MN_DEPTH; //댚스
				if(1 == rowDepth){
					$('#gridList2').setRowData(rowId, false, {background:"#F1F1F1"});
				}
				else if(2 == rowDepth){
					$('#gridList2').setRowData(rowId, false, {background:"#FFFFFF"});
				}
				else if(3 == rowDepth){
					$('#gridList2').setRowData(rowId, false, {background:"#FFFFFF"});
				}
			});
			
			//
			$('#authNameH5Id').html(name);
			
			$('#gridList2').find('input:radio').uniform();
			//$('#gridList2').find('input:radio').uniform.update();
			//$.uniform.update('input[name^="auth_"]');
			
			$('#noList').hide(); // NO DATA 리스트 영역.
			//$('#authorityBtnDivId').show(); //권한저장 버튼.
		},
	}); 
}

// 메뉴별 세부 권한 세팅.
function setMenuAuth(cellval, options, rowObject) {
	var mnSeq = rowObject.MN_SEQ;
	// var mnDepth = rowObject.MN_DEPTH;
	var childCount = rowObject.CHILD_COUNT;
	var htmlText = '';
	
	if (childCount == 0) {
		htmlText += '<input type="hidden" name="mnSeq" value="' + mnSeq + '" />';
		htmlText += '<p><input type="radio" name="auth_' + mnSeq + '" value="R" ' + (cellval == 'R' ? 'checked="checked"' : '') + ' />READ</p> ';
		htmlText += '<p><input type="radio" name="auth_' + mnSeq + '" value="W" ' + (cellval == 'W' ? 'checked="checked"' : '') + ' />WRITE</p>';
		htmlText += '<p><input type="radio" name="auth_' + mnSeq + '" value="" ' + (cellval == null ? 'checked="checked"' : '') + ' />BLOCK</p>';
	}
	return htmlText;
}

// 부서별 권한 저장.
function insertAuthority(obj){
	$(obj).prop('disabled', true);
	
	if(0 == selectAuthSeq){
		alert('권한을 선택해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	
	if (confirm('권한을 저장 하시겠습니까?')){
		var mnSeqs = '';
		var rmAuths = '';
		$('input[name="mnSeq"]').each(function(i,e) {
			if (i ==0) {
				mnSeqs = $(e).val();
				rmAuths = $('input[name="auth_' + $(e).val() + '"]:checked').val();
			}
			else {
				mnSeqs += ',' + $(e).val();
				rmAuths += ',' + $('input[name="auth_' + $(e).val() + '"]:checked').val();
			}
		});
		
		var params = {r_mnseqs:mnSeqs, r_rmauths:rmAuths, r_rmrlseq:selectAuthSeq};
		$.ajax({
			async : false,
			data : params,
			type : 'POST',
			dataType: 'json',
			url : '${url}/admin/system/insertRoleMenuAjax.lime',
			success : function(data){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
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
					권한관리
					<div class="page-right">
						<%--
						<button type="button" class="btn btn-line text-default" title="검색"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line text-default" title="엑셀다운로드"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
						 --%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="POST">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body">
								<div class="row">
									<div class="col-md-5 col-lg-3">
										<h5 class="table-title no-title"></h5>
										<div class="table-left min">
											<table border="0" cellpadding="0" cellspacing="0">
												<colgroup>
													<col width="25%" />
													<col width="*" />
												</colgroup>
												<thead>
													<tr>
														<th>NO</th>
														<th>권한</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach items="${roleList}" var="list" varStatus="stat">
														<tr>
															<td>${stat.count}</td>
															<td class="text-left">
																<a href="javascript:;" onclick="setMenuAuthorityList('${list.RL_SEQ}', '${list.RL_CODE}', '${list.RL_NAME}');">${list.RL_NAME}</a>
															</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</div>
									
									<div class="col-md-7 col-lg-9">
										<h5 id="authNameH5Id" class="table-title"></h5>
										<div id="authorityBtnDivId" class="btnList writeObjectClass">
											<button class="btn btn-info" onclick="insertAuthority(this);" type="button">권한저장</button> 
											<!-- <a href="javascript:;" onclick="insertAuthority(this);" class="btn btn-primary">권한저장</a> -->
										</div>
										<div class="table-responsive in table-right right-xs">
											<table id="gridList2" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
											</table>
											
											<table id="noList" class="display table noList" width="100%" border="0" cellpadding="0" cellspacing="0">
												<tbody>
													<tr>
														<td>권한을 선택해 주세요.</td>
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
	
</body>

</html>