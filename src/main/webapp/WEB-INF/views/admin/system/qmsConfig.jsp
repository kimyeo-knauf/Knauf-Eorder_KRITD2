<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<script type="text/javascript">
$(function(){
	$('.dropify-filename-inner').each(function() {
		var fileName = $(this).html();
		var cfid = $(this).closest('td').find('input[name="cfid"]').val();
		var textHtml = '<a href="${url}/admin/system/fileDown.lime?r_cfid='+cfid+'"></a>'; //'+fileName+'
		$(this).html(textHtml);
	});

});


// 저장.
function dataUp(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if (confirm('저장 하시겠습니까?')) {
		formPostSubmit('', '${url}/admin/system/updateQmsConfig.lime');
	}
	
	$(obj).prop('disabled', false);
}

// 유효성 체크.
function dataValidation(){
	var ckflag = true;
	if(ckflag) ckflag = validation($('input[name="m_mailtitle"]')[0], '메일 제목', 'value');
	if(ckflag) {
		var fileChk = $(".dropify-errors-container").children('ul').children('li').html();
		if(fileChk == undefined) ckflag = true;
		else if (fileChk.indexOf("The file is not allowed") > -1){
			ckflag = false;
			alert("jpg png jpeg gif bmp 이미지 형식만 업로드 가능합니다.");
		}
	}
	return ckflag;
}

// 파일 다운로드.
function fileDown(r_cfid){
	formGetSubmit('${url}/admin/system/fileDown.lime', 'r_cfid='+r_cfid );
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
					QMS 설정
					<!-- <div class="page-right"></div> -->
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="post" enctype="multipart/form-data">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<h4 class="panel-title no-title"></h4>
								<div class="btnList writeObjectClass">
									<button class="btn btn-info" onclick="dataUp(this);" type="button">저장</button>
								</div>
							</div>
							
							<div class="panel-body">
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="5%" />
											<col width="20%" />
											<col width="75%" />
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>구분</th>
												<th>설정</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th class="text-center">1</th>
												<td>메일 제목</td>
												<td><input type="text" class="search-input" name="m_mailtitle" value="${configList.MAILTITLE}" onkeyup="checkByte(this, 3000);" /></td>
											</tr>
											<tr>
												<th class="text-center">2</th>
												<td>하단 이미지</td>
												<td>
													<input type="hidden" name="cfid" value="MAILBOTTOMIMG" />
													<input type="file" class="dropify" name="m_mailbottomimg" data-allowed-file-extensions="jpg png jpeg gif bmp" value="" <c:if test="${!empty configList.MAILBOTTOMIMG}">data-default-file="${url}/data/config/${configList.MAILBOTTOMIMG}"</c:if> />
													<a class="dropify-file hide m-t-xxxxs m-l-xxs" href="javascript:;" onclick="fileDown('MAILBOTTOMIMG');"><i class="fa fa-arrow-circle-down pull-left m-t-xxs m-r-xxxs f-s-15"></i>${configList.MAILBOTTOMIMG}</a> <!-- IE9 -->
												</td>
											</tr>
										</tbody>
									</table>
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