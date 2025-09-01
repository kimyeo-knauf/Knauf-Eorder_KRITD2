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

<body> <!-- 팝업사이즈 955 * 720 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

    <!-- Container Fluid -->
    <div class="container-fluid product-search">

		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
        <div class="panel-title">
            <h2>
                FAQ
            </h2>
        </div>

		<div class="tableView full-desktop">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<colgroup>
					<col width="15%">
					<col width="35%">
					<col width="15%">
					<col width="35%">
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td colspan="3">
							${boardOne.BD_TITLE}
						</td>
					</tr>
					<tr>
						<th>유형</th>
						<td colspan="3">
							${boardOne.BD_TYPENM}
						</td>
					</tr>
					<tr>
						<th>등록자</th>
						<td>
							${boardOne.USER_NM}
						</td>
						<th>등록일</th>
						<td>
							${fn:substring(boardOne.BD_INDATE,0,10)}
						</td>
					</tr>
					<tr class="one">
						<td colspan="4">
							${restoreXSSContent}
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
        <div class="boardView full-mobile">
            <ul>
                <li>
                    <label class="view-h">제목</label>
                    <div class="view-b">
                        ${boardOne.BD_TITLE}
                    </div>
                </li>
                <li>
                    <label class="view-h">유형</label>
                    <div class="view-b">
                        ${boardOne.BD_TYPENM}
                    </div>
                </li>
                <li class="half">
                    <label class="view-h">등록자</label>
                    <label class="view-b">
                        ${boardOne.USER_NM}
                    </label>
                </li>
                <li class="half">
                    <label class="view-h">등록일</label>
                    <div class="view-b">
                        ${fn:substring(boardOne.BD_INDATE,0,10)}
                    </div>
                </li>
                <li class="one">
                    <div class="view-b">
                        ${restoreXSSContent}
                    </div>
                </li>
            </ul>
        </div> <!-- boardView -->

    </div> <!-- Container Fluid -->

</div> <!-- Wrap -->

</body>

</html>