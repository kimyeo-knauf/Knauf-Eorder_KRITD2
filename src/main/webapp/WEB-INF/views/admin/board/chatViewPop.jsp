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
  * 팝업 옵션값 초기화
  */
  function valify(){
	  //window.opener.location.reload();
	  window.close();
 }

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
				
				
				
				<div style="padding:10px;"> 

				</div>
				<div style="padding:10px;"> 

				</div>	
      
            </ul>
        
		
        </div> <!-- boardView -->
		<!-- <button class="btn btn-info" onclick="delchat(this,${boardOne.BD_SEQ});" type="button" title="저장">삭제</button>
		<button class="btn btn-info" onclick="chatAddEditPop(this, ${boardOne.BD_SEQ});" type="button" title="채팅 피드백 등록">수정</button> -->
		<button class="btn btn-info" onclick=" valify();    " type="button" title="확인">확인</button>
		
		
    </div> <!-- Container Fluid -->

</div> <!-- Wrap -->

</body>

</html>