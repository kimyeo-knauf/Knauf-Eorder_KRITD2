<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.limenets.common.util.Converter"%>
<!DOCTYPE html>

<head>
<meta charset="UTF-8">
<title>Site Error</title>

<link href="/eorder/include/css/custom.css?20240415" rel="stylesheet" type="text/css" />
<link href="/eorder/include/images/common/favicon.ico" rel="shortcut icon" />

	<style type="text/css">
		body {
			font-family: 'KnaufOffice';
		}

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
								<p><img src="${url}/eorder/include/images/common/pagenotfound.png" alt="pagenotfound" /></p>
								<strong>
									찾으시려는 페이지가 <span>제거되었거나 페이지 이름이 변경</span>되었거나 <span>일시적으로 사용하실 수 없습니다.</span><br />
									입력하신 페이지 주소가 정확한지 다시 한번 확인해 보시기 바랍니다.<br />
									<br />
									이용에 불편을 드려 죄송합니다.
								</strong>
							</div>
                       </div>
                   </div>
               </div><!-- Row -->
           </div><!-- Main Wrapper -->
       </div><!-- Page Inner -->
   </main><!-- Page Content -->

</body>
</html>
