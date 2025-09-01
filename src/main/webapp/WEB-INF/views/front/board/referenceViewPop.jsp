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
		fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/front/board/referenceFileDown.lime">';
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
			filename: file_name //다운받는 파일명
	    };
		webkit.messageHandlers.cordova_iab.postMessage(JSON.stringify(param));
	</c:if>
}

</script>
</head>

<body> <!-- 팝업사이즈 955 * 772 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

    <!-- Container Fluid -->
    <div class="container-fluid product-search">

		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
        <div class="panel-title">
            <h2>
                자료실
            </h2>
        </div>

        <div class="boardView">
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
                                <img src="${url}/include/images/front/common/icon_file@2x.png" width="22" height="22" alt="file" onerror="this.src='${url}/include/images/front/common/list_noimg.gif'">
                                ${boardOne.BD_FILE}
                            </a>
                        </c:if>
                    </div>
                </li>
                <li>
                    <label class="view-h">유형</label>
                    <div class="view-b">
                        ${boardOne.BD_TYPENM}
														<c:if test="${not empty boardOne.BD_TYPENM2}">
															&gt; ${boardOne.BD_TYPENM2}
															<c:if test="${not empty boardOne.BD_TYPENM3}">
																&gt; ${boardOne.BD_TYPENM3}
															</c:if>
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
                        ${fn:substring(boardOne.BD_MODATE==null?boardOne.BD_INDATE:boardOne.BD_MODATE,0,10)}
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