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
#pageInnerDiv {
		padding-top: 0;
		size: A4;
        margin: 0;
        }
@media print {
            .page-break { page-break-inside:avoid; page-break-after:auto }
        }

    
}

</style>

<script type="text/javascript">
$(function(){
	
});
//어드민 보드 샘플 뷰 팝(커밋 확인용)
/**
 * 파일다운로드
 */
function fileDown(file_name,file_type){		
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');
	
	// 파일 다운로드.
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/sampleFileDown.lime">';
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
/**
 * 팝업 옵션값 초기화
 */
function setPopupOption(){
	var widthPx = 800;
	var heightPx = 830;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	return options;
}

/**
 * 샘플 등록/수정 폼 팝업
 */
function sampleAddEditPop(obj, bdSeq){		
	$('input[name="r_bdseq"]').val(bdSeq); 	
	//console.log(bdnum);
	// POST 팝업 열기.
	window.open('', 'sampleAddEditPop', setPopupOption());
	//console.log("열림");
	var $frmPopSubmit = $('form[name="frmPopSubmit"]');
	$frmPopSubmit.attr('action', '${url}/admin/board/sample/pop/addEditPop.lime');
	$frmPopSubmit.attr('method', 'post');
	$frmPopSubmit.attr('target', 'sampleAddEditPop');
	$frmPopSubmit.submit(); 
}
	 
	  function valify(){
		  //window.opener.location.reload();
		  opener.reloadGridForPop();
		  window.close();
	 }

</script>
</head>

<body class="page-header-fixed pace-done compact-menu" onBeforeUnload="valify()">
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
					<div class="col-md-10">									
						<form name="frmPopSubmit" method="post">
							<input type="hidden" name="pop" value="1" />
							<input type="hidden" name="r_bdseq" value="" />			
							<input type="hidden" name="r_bdid_pop" value="sample" />
							<input type="hidden" name="r_bdnum" value="" />
						</form>				
						<div class="panel panel-white">
							<div class="panel-heading clearfix">
								<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
								<h4 class="panel-title">샘플요청</h4>
													
								<div class="btnList writeObjectClass">					
									<button class="btn btn-info" onclick="window.print();" type="button" title="인쇄">인쇄</button>											 
								</div>
							</div>
							
							<div class="panel-body">
								<div id="topView" class="tableSearch top-view2">
									<div class="topSearch">
										<ul>
											<li>											
												<label class="search-h">글 번호</label>																									
												<div class="search-c">
													<%= request.getParameter("r_bdnum") %>
												</div>												
											</li>
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
												<label class="search-h">등록자</label>
												<div class="search-c" >
													${boardOne.USER_NM}
												</div>
											</li>
											<li>
												<label class="search-h">등록일</label>
												<div class="search-c"  > 
													<!--${fn:substring(boardOne.BD_MODATE eq null ? boardOne.BD_INDATE:boardOne.BD_MODATE,0,10)}-->
													${fn:substring(boardOne.BD_INDATE,0,10)}
												</div>
											</li>
											<li>
												<label class="search-h">완료일</label>
												<div class="search-c" >
													${fn:substring(boardOne.BD_MODATE,0,10)}   <!-- 10 -> 16 바꿔봄 -->
												</div>
											</li>
											<!--  li class="blank3">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li-->
										</ul>
									</div>
									
								</div>
							</div>	
															
								<!-- div class="panel panel-white"-->
																        
								<li class="one">									
								<!-- /div-->
								<div style="padding:20px;"> 
									<h4   style=" padding:10px; border-bottom:1px solid black; padding: 15px;  font-weight: bold;">내용</h4>
											
				                    <div class="view-b" style="padding:20px;">
				                        ${restoreXSSContent}
				                        <div style="padding:10px;"> 

										</div>
										<div style="padding:10px;"> 
					
										</div>
				                    </div>
				                   
				                </li>			                
				                <c:if test="${boardOne.BD_REPLYYN ne 'N'}">  <!--  N 이 아닐 결우에 -->
				                	
												                	
				                	<li class="one">
				                	<div style="padding:20px;">
				                		<h4   style=" padding:10px; border-bottom:1px solid black; padding: 15px;  font-weight: bold;">Comment</h4>
				                	
				                    <div class="view-b" style="padding:20px;">
				                    	 ${restoreXSSContent2}
				                         <!-- ${boardOne.BD_REPLY} -->
				                         <div style="padding:10px;"> 

										</div>
										<div style="padding:10px;"> 
					
										</div>
				                    </div>
				                    </div>
				                	</li>
				                </c:if>
								<div style="float: right; padding:20px;">
									<button class="btn btn-info" onclick="sampleAddEditPop(this, ${boardOne.BD_SEQ});" type="button" title="sample등록" >처리</button>
									<button class="btn btn-info" onclick="window.close()" type="button" title="닫기 버튼"  >취소</button>
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