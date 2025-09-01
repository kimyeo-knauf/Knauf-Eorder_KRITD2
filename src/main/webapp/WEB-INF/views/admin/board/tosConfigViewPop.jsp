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


</script>
</head>

<body class="page-header-fixed pace-done compact-menu">
	
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
								<h4 class="panel-title">약관관리</h4>
								<div class="btnList writeObjectClass">								 
								</div>
							</div>
							
							<div class="panel-body">
								<div class="tableSearch top-view3">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">제목</label>
												<div class="search-c">
													${tosConfigOne.TSC_TITLE}
												</div>
											</li>
											<li>
												<label class="search-h">등록자</label>
												<div class="search-c">
													${tosConfigOne.USER_NM}
												</div>
											</li>
											<li>
												<label class="search-h">등록일</label>
												<div class="search-c">
												${fn:substring(tosConfigOne.TSC_INDATE,0,10)}
												</div>
											</li>
											<li class="blank">
												<label class="search-h"></label>
												<div class="search-c"></div>
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