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
		fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/front/board/sampleFileDown.lime">';  //이파트 손봐야 할듯
		fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
		fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
		fileFormHtml += '	<input type="hidden" name="filetoken" value="'+token+'" />';
		fileFormHtml += '</form>';
		fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
		$.download('frm_filedown', fileFormHtml); //common.js 위치.
		
		var fileTimer = setInterval(function() {
			//console.log('token : ', token);
	        //console.log("cookie : ", getCookie(token));
			if('true' == getCookie(token))
            {
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


function delchat(obj,bdSeq){	
	var params = { r_bdseq : bdSeq , r_bdid : 'chat' }
	console.log(params);
	if(confirm('삭제하시겠습니까?')){
		$.ajax({
			async : false,
			data : params,
			type : 'POST',
			url : '${url}/front/board/deleteChatAjax.lime',
			success : function( data ){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					//dataSearch();
					opener.document.location.reload();
					self.close();
				}
				
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}
}


/**
 * 팝업 옵션값 초기화
 */
 function setPopupOption(){
	var widthPx = 800;
	var heightPx = 780;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	console.log("setPopupOption 기본틀 프론트");

	return options;
}
/**
 * chat 등록/수정 폼 팝업
 */
 function chatAddEditPop(obj, bdSeq){		
	$('input[name="r_bdseq"]').val(bdSeq);
	
	console.log("chatAddEditPop 프론트");
	console.log(bdSeq);
	// POST 팝업 열기.
	window.open('', 'chatAddEditPop', setPopupOption());
	console.log("열림, 프론트");


	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	
	$frmPopSubmit.attr('action', '${url}/front/board/chat/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'chatAddEditPop');
	console.log(frmPopSubmit);
	
	//console.log(frmPopSubmit.r_bdnum.value);


	
	window.opener.location.reload();
	
	$frmPopSubmit.submit(); 
	//window.open('about:blank','_parent').parent.close();
	console.log("열림 완료");
	console.log("refresh");
	
	
}


 /**
  * 팝업 옵션값 초기화
  */
  function valify(){
	  window.opener.location.reload();
	  window.close();
 }

/*
function delchat(obj, bdSeq) { //processType ADD : 등록 , EDIT : 수정
	$(obj).prop('disabled', true);

	if (!dataValidation()) {
		$(obj).prop('disabled', false);
		return;
	}

	$('input[name="r_processtype"]').val(processType);
	if (confirm('삭제하시겠습니까?')) {
		var $frmPop = $('form[name="frmPop"]')
		$frmPop.attr('action',
				'${url}/front/board/deletechatAjax.lime');

		$frmPop.ajaxForm({
			type : 'POST',
			cache : false,
			success : function(data) {
			
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					window.opener.location.reload();

					window.open('about:blank', '_self').close();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request, status, error) {
				alert('Error');
				$(obj).prop('disabled', false);
			}
		}).submit();
	} else {
		$(obj).prop('disabled', false);
	}
}
*/


</script>
</head>

<body onBeforeUnload="valify()"> <!-- 팝업사이즈 955 * 772 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

    <!-- Container Fluid -->
    <div class="container-fluid product-search">

		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		<form name="frmPopSubmit" method="post">
			<input type="hidden" name="pop" value="1" />
			<input type="hidden" name="r_bdseq" value="" />			
			<!-- input type="hidden" name="r_bdnum" value="" /-->			
			<input type="hidden" name="r_bdid_pop" value="chat" />
		</form>
        <div class="panel-title">
            <h2>
                채팅 피드백
            </h2>
        </div>
        <div class="boardView">
            <ul>
				<li>
                    <label class="view-h">글 번호</label>
                    <div class="view-b">
						<%= request.getParameter("r_bdnum") %>
                    </div>
                </li>
                <li>
                    <label class="view-h">제목</label>
                    <div class="view-b">
                        ${boardOne.BD_TITLE}
                    </div>
                </li>
                <!-- <li>
                    <label class="view-h">첨부파일</label>
                    <div class="view-b file-list">
                        <c:if test="${!empty boardOne.BD_FILE}">
                            <a href="javascript:;" class="file-download" onclick="fileDown('${boardOne.BD_FILE}','${boardOne.BD_FILETYPE}')">
                                <img src="${url}/include/images/front/common/icon_file@2x.png" width="22" height="22" alt="file" onerror="this.src='${url}/include/images/front/common/list_noimg.gif'">
                                ${boardOne.BD_FILE}
                            </a>
                        </c:if>
                    </div>
                </li> -->
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
                
                
                <!--  div class="panel-body"-->
					<h4 class="table-title">내용</h4>
					
					<div class="panel-title">
          				  <h2>
            			</h2>
        			</div>
					
					<div class="table-responsive">
						<div class="page-break">
						
							<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
								<tbody>
									<tr>
										<td class="p-v-sm" style='page-break-before: always' id="contentDiv" >
											${restoreXSSContent}
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div style="padding:10px;"> 

					</div>
					<div style="padding:10px;"> 

					</div>
					


				<!-- /div-->
				
				
				<c:if test="${boardOne.BD_REPLYYN ne 'N'}"> 
			        <!-- div class="panel-body"-->
					<h4 class="table-title">답변   		<h5>작성자:	 ${boardOne2.USER_NM}	등록일시:${fn:substring(boardOne2.BD_MODATE,0,16)}</h5>  </h4>
					
					<div class="panel-title">
          				  <h2>
            			</h2>
        			</div>			        
			        
			        
						<div class="table-responsive">
							<div class="page-break">
					
								<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td class="p-v-sm" style='page-break-before: always'  id="contentDiv">
												${boardOne.BD_REPLY}
												
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
				<!-- /div-->
				<div style="padding:10px;"> 

				</div>
				<div style="padding:10px;"> 

				</div>	
			        </c:if>
      
            </ul>
        
		
        </div> <!-- boardView -->
		<button class="btn btn-info" onclick="delchat(this,${boardOne.BD_SEQ});" type="button" title="저장">삭제</button>
		<button class="btn btn-info" onclick="chatAddEditPop(this, ${boardOne.BD_SEQ});" type="button" title="채팅 피드백 등록">수정</button>
		<button class="btn btn-info" onclick=" valify();    " type="button" title="확인">확인</button>
		
		
    </div> <!-- Container Fluid -->

</div> <!-- Wrap -->

</body>

</html>