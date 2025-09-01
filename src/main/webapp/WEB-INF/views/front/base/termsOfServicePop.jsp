<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy.MM.dd" var="nowDate" />

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>
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


<body>

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">
	
	<!-- Container Fluid -->
	<div class="container-fluid service">
	
		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="login-panel-title">
			<h4>
				이오더링 서비스 이용수칙
			</h4>
		</div>
		
		<div class="login-panel-body inner">
			
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td>
								${restoreXSSContent}
							</td>
						</tr>
					</tbody>
				</table>
				
			
		</div> <!-- boardListArea -->
		
	</div> <!-- Container Fluid -->

</div> <!-- Wrap -->
</body>



</html>