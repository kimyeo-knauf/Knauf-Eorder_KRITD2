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

/**
 * 파일다운로드
 */
function fileDown(file_name,file_type){
	<c:if test="${!isLayerPop}">
		$('#ajax_indicator').show().fadeIn('fast');
		var token = getFileToken('file');
		
		// 파일 다운로드.
		var fileFormHtml = '';
		fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/front/board/noticeFileDown.lime">';
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
	</c:if>
	
	<c:if test="${isLayerPop}">
		var param = {
			action : 'filedownload',
			downloadurl : 'https://eorder.boral.kr/eorder/data/board/'+file_name, //다운로드 fullurl
			//downloadurl:"http://www.yellowin.co.kr/mobile/1111.jpg", //다운로드 fullurl
			filename: file_name //다운받는 파일명
        };
		webkit.messageHandlers.cordova_iab.postMessage(JSON.stringify(param));
	</c:if>
}

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
                공지사항
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
						<th>첨부파일</th>
						<td colspan="3" class="file-list">
							<c:if test="${!empty boardOne.BD_FILE}">
								<a href="javascript:;" class="file-download" onclick="fileDown('${boardOne.BD_FILE}','${boardOne.BD_FILETYPE}')">
									<img src="${url}/include/images/front/common/icon_file@2x.png" width="26" height="26" alt="file" onerror="this.src='${url}/include/images/front/common/list_noimg.gif'">
									${boardOne.BD_FILE}
								</a>
							</c:if>
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
                    <label class="view-h">첨부파일</label>
                    <div class="view-b file-list">
                        <c:if test="${!empty boardOne.BD_FILE}">
                            <a href="javascript:;" class="file-download" onclick="fileDown('${boardOne.BD_FILE}','${boardOne.BD_FILETYPE}')">
                                <img src="${url}/include/images/front/common/icon_file@2x.png" width="26" height="26" alt="file" onerror="this.src='${url}/include/images/front/common/list_noimg.gif'">
                                ${boardOne.BD_FILE}
                            </a>
                        </c:if>
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