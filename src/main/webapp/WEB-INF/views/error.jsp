<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.limenets.common.util.Converter"%>
<%
	String forwardUri = Converter.toStr(request.getAttribute("javax.servlet.forward.request_uri"));
	String viewPage = "";
	if(-1 < forwardUri.indexOf("/admin/")){
		viewPage = "admin";
	}
	if(-1 < forwardUri.indexOf("/front/")){
		viewPage = "front";
	}
	
%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="ko" class="ie8"> <![endif]-->
<!--[if gt IE 8]><!--> <html lang="ko"> <!--<![endif]-->
<head>
<%-- <%@ include file="/WEB-INF/views/include/fnt/commonhead.jsp" %> --%>
	<style type="text/css">
		.page-notfound {
			text-align:center;
		}
		.page-notfound p {
			margin:240px 0 45px;
		}
		.page-notfound p img {
			margin:0 auto;
		}
		.page-notfound strong {
			line-height:26px;
			font-size:15px;
			color:#333;
			font-family: NanumGothic;
			font-weight: normal;
		}
		.page-notfound span {
			color:#009b3a;
		}
		.btn-error {
			margin:65px 0 200px;
			width:100%;
			text-align:center;
			border-top: 1px solid #eaeaea;
			padding-top: 65px;
		}
		.btn-error a {
			display:inline-block;
			margin:0 3px;
			padding:12px 40px;
			width:150px;
			font-weight:600;
			font-size:15px;
			color:#fff;
			text-align:center;
			border:1px solid #009b3a;
			border-radius:1px;
			background-color:#009b3a;
			text-decoration: none;
		}
		.btn-error .btn-prev {
			border-color:#494949;
			background-color:#595959;
		}
		
		@media (max-width: 600px) {
			.page-notfound p {
				margin:120px 0 45px;
			}
			.btn-error a {
				margin:0;
				padding:15px 0;
				width:49%;
				min-width:1px;
			}
		}
	</style>
</head>

<body class="page-error">
   <main class="page-content">
       <div class="page-inner">
           <div id="main-wrapper">
               <div class="row">
                   <div class="col-md-7 center">
                       <div class="details">
                           <div class="page-notfound">

								<p><img src="${url}/include/images/common/pagenotfound.png" alt="pagenotfound" /></p>
								<strong>
									찾으시려는 페이지가 <span>제거되었거나 페이지 이름이 변경</span>되었거나 <span>일시적으로 사용하실 수 없습니다.</span><br />
									입력하신 페이지 주소가 정확한지 다시 한번 확인해 보시기 바랍니다.<br />
									<br />
									이용에 불편을 드려 죄송합니다.
								</strong>
				
								<div class="btn-error">
									<%--
									<a href="${url}/kr/index/index.lime" class="btn-home">메인페이지</a> 
									<a href="javascript:history.back();" class="btn-prev">이전페이지</a>
									 --%>
									 <%if("admin".equals(viewPage)){ %>
									 	<a href="${url}/admin/index/index.lime" class="btn-home">메인페이지</a>
									 <%} %>
									 <%if("front".equals(viewPage)){ %>
									 	<a href="${url}/front/index/index.lime" class="btn-home">메인페이지</a>
									 <%} %>
									<a href="javascript:history.back();" class="btn-prev">이전페이지</a>
								</div>
				
							</div>
                       </div>
                   </div>
               </div><!-- Row -->
           </div><!-- Main Wrapper -->
       </div><!-- Page Inner -->
   </main><!-- Page Content -->

</body>
</html>
