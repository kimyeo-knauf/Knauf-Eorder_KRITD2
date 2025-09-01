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
$(document).ready(function() {
	var drEvent = $('.dropify').dropify();

	drEvent.on('dropify.beforeClear', function(event, element){
	    return confirm("Do you really want to delete \"" + element.filename + "\" ?");
	});
});
/**
 * QMS 오더 뷰 화면
 */
function qmsOrderPopOpen(qmsId){
	opener.qmsOrderPopOpen(qmsId);
}

function fileSave(){

	if (confirm('저장 하시겠습니까?')) {
		formPostSubmit('', '${url}/front/order/qmsOrderPopFileSave.lime');
	}
	
}

function fileDown(r_filename, r_qmsNo, r_fileExt, r_filetype){
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/front/order/qmsOrderFileDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_filename" value="' + r_filename + '" />';
	fileFormHtml += '	<input type="hidden" name="r_realfilename" value="' + r_qmsNo + "." + r_fileExt + '" />';
	fileFormHtml += '	<input type="hidden" name="r_filetype" value="' + r_filetype + '" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); 
}

function chk_file_type(obj) {
	var file_kind = obj.value.lastIndexOf('.');
	var file_name = obj.value.substring(file_kind+1,obj.length);
	var file_type = file_name.toLowerCase();
	var check_file_type=new Array();
	check_file_type=['pdf','jpeg','jpg','gif','png','bmp'];

	if(check_file_type.indexOf(file_type)==-1) {

		alert('.pdf, .jpeg, .jpg, .gif, .png, .bmp 파일만 선택 가능합니다.');
		var parent_Obj=obj.parentNode;
		var node=parent_Obj.replaceChild(obj.cloneNode(true),obj);
		
		document.getElementById(obj.id).value = "";
		
		return false;
	}
}
</script>
</head>
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
			파일 업로드
		</h3>
	</div>
	<form name="frm" method="post" enctype="multipart/form-data">
	<table class="display table dataTable" style="width:100%!important" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="5%" />
			<col width="18%" />
			<col width="30%" />
			<col width="20%" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>NO</th>
				<th>QMS 오더번호</th>
				<th>현장명</th>
				<th>파일</th>
				<th>다운로드</th>
			</tr>
		</thead>
		<tbody>
			<input type="hidden" id="qmsIdTxt"  name="qmsIdTxt" value="${qmsIdTxt}"></input>
			<input type="hidden" id="qmsFileListSize"  name="qmsFileListSize" value="${fn:length(qmsFileList)}"></input>
			<c:forEach items="${qmsFileList}" var="list" varStatus="status">
				<tr>
					<td class="text-center">${list.RNUM}</td>
					<td class="text-center"><a class="qmsOrderLink" href="#" onclick="javascript:qmsOrderPopOpen('${list.QMS_ORD_NO}');">${list.QMS_ORD_NO}</a>
						<input type="hidden" name="qmsOrdNo_${status.index}" value="${list.QMS_ORD_NO}"></input>
					</td>
					<td >${list.SHIPTO_NM}</td>
					<td>
						<%-- <input type="file" class="dropify" accept='.pdf, .jpeg, .jpg, .gif, .png, .bmp' id="qmsFile_${status.index}" name="qmsFile_${status.index}" value="" onchange='chk_file_type(this)' <c:if test="${!empty configList.SYSTEMLOGO}">data-default-file="${url}/data/config/${configList.SYSTEMLOGO}"</c:if> /> --%>
						<input type="file" accept='.pdf, .jpeg, .jpg, .gif, .png, .bmp' id="qmsFile_${status.index}" name="qmsFile_${status.index}" value="" onchange='chk_file_type(this)' <c:if test="${!empty configList.SYSTEMLOGO}">data-default-file="${url}/data/config/${configList.SYSTEMLOGO}"</c:if> />
					</td>
					<td>
						<a href="javascript:;" onclick="fileDown('${list.QMS_FILE_NM}', '${list.QMS_ORD_NO}', '${list.QMS_FILE_EXT}', '${list.QMS_FILE_TYPE}');">${list.QMS_FILE_ORG_NM}</a> <!-- IE9 -->
					</td>
				</tr>
			</c:forEach>
			
		</tbody>
	</table>
	</form>
	
	</div>
	
	<div class="qmsBtnDiv row">
		<button class="btn btn-md btn-info" onclick="javascript:fileSave();" type="button" title="저장">저장</button>
		<button class="btn btn-md btn-gray" onclick="javascript:self.close();" type="button" title="닫기">닫기</button>
	</div>
	</div>
</body>

</html>