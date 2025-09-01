<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy.MM.dd" var="nowDate" />
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>
<style type="text/css">
/* .ui-jqgrid-btable .ui-state-highlight { background: gray; } */
.cke_screen_reader_only {height: 0 !important;}
#pageInnerDiv {padding-top: 0;}
</style>

<script type="text/javascript">
$(function(){
	
});

/**
 * 파일다운로드
 */
function fileDown(file_name,file_type){		
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');
	
	// 파일 다운로드.
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/referenceFileDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
	fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
	fileFormHtml += '	<input type="hidden" name="filetoken" value="'+token+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); // common.js 위치.
	
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        //console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}

</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
		<!-- Page Inner -->
		<div class="page-inner" id="pageInnerDiv">
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">									
										
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
								<h4 class="panel-title">자료실</h4>
								<div class="btnList writeObjectClass">								 
								</div>
							</div>
							
							<div class="panel-body">
								<div id="topView" class="tableSearch top-view2">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목</label>
												<div class="search-c">
													${boardOne.BD_TITLE}
												</div>
											</li>
											<li>
												<label class="search-h">첨부파일</label>
												<div id="rFileDivId" class="search-c">
													<c:if test="${!empty boardOne.BD_FILE}">
														<a href="javascript:;" onclick="fileDown('${boardOne.BD_FILE}','${boardOne.BD_FILETYPE}')"><img src="/eorder/data/board/${boardOne.BD_FILE}" width="25" height="25" onerror="this.src='/eorder/include/images/admin/list_noimg.gif'">
																${boardOne.BD_FILE}
														</a>
													</c:if>
												</div>
											</li>
											<li>
												<label class="search-h">유형</label>
												<div class="search-c">
													${boardOne.BD_TYPENM}
												</div>
											</li>
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													${boardOne.USER_NM}
												</div>
											</li>
											<li>
												<label class="search-h">등록일</label>
												<div class="search-c">
													<!--${fn:substring(boardOne.BD_MODATE eq null ? boardOne.BD_INDATE:boardOne.BD_MODATE,0,10)}-->
													${fn:substring(boardOne.BD_INDATE,0,10)}
												</div>
											</li>
											<li>
												<label class="search-h">수정일</label>
												<div class="search-c">
													${fn:substring(boardOne.BD_MODATE,0,10)}
												</div>
											</li>
											<!-- 2025-05-14 정보공유 자료실 링크여부 추가 ijy -->
											<li>
												<label class="search-h">링크 여부</label>
												<div class="search-c">
													<c:if test="${!(boardOne.BD_LINKUSE eq 'Y')}">미사용</c:if>
													<c:if test="${boardOne.BD_LINKUSE eq 'Y'}"><a href="${boardOne.BD_LINK}" target="_blank">${boardOne.BD_LINK}</a></c:if>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							
							<div class="panel-body">
								<h5 class="table-title">내용</h5>
								<div class="table-responsive">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td class="p-v-sm">
													${restoreXSSContent}
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
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
</body>

</html>