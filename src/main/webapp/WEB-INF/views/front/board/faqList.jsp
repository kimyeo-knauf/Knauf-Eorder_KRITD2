<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
$(function(){

});

$(document).ready(function() {

});

// FAQ 상세 팝업
function boardViewPop(obj, bdSeq){
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 955;
		var heightPx = 720;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
		$('form[name="frmPop"]').find('input[name="r_bdseq"]').val(bdSeq);
	
		window.open('', 'faqViewPop', options);
		$('form[name="frmPop"]').prop('action', '${url}/front/board/faqViewPop.lime');
		$('form[name="frmPop"]').submit();
	}
	else{
		// 모달팝업
		//$('#boardViewPopMId').modal('show');
		var link = '${url}/front/board/faqViewPop.lime?r_bdseq='+bdSeq+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#boardViewPopMId').modal({
			remote: link
		});
	}
}

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/board/faqList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/board/faqList.lime');
}

</script>
</head>
<body>

<div id="subWrap" class="subWrap">

	<!-- Header -->
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>

	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="faqViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_bdseq" type="hidden" value="" />
	</form>

	<div class="container-fluid">
		<div class="full-content">

			<div class="row no-m">
				<div class="page-breadcrumb"><strong>FAQ</strong></div>

				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/board/noticeList.lime">정보공유</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/board/noticeList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/noticeList.lime')}">selected="selected"</c:if> >공지사항</option>
								<option value="${url}/front/board/faqList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/faqList.lime')}">selected="selected"</c:if> >FAQ</option>
								<option value="${url}/front/board/referenceList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/referenceList.lime')}">selected="selected"</c:if> >자료실</option>
								<option value="${url}/front/board/sampleList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/sampleList.lime')}">selected="selected"</c:if> >샘플요청</option>
								<%-- 2025-08-11 hsg 클라이언트의 요청에 주석처리  <option value="${url}/front/board/chatList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/chatList.lime')}">selected="selected"</c:if> >채팅 피드백</option> --%>
							</select>
						</li>
					</ul>
				</div>
			</div> <!-- Row -->

		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->

	<!-- Container -->
	<main class="container" id="container">

		<!-- Content -->
		<div class="content">
			<form name="frm" method="post" >

				<%-- Start. Use For Paging --%>
				<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
				<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitrow --%>
				<%-- End. --%>
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">

					<div class="searchArea">
						<div class="col-md-6">
							<em>제목</em>
							<input type="text" class="form-control" name="rl_bdtitle" value="${param.rl_bdtitle}" />
						</div>
						<div class="col-md-4 right">
							<em class="high">유형</em>
							<select class="form-control form-sm" name="r_bdtype" onchange="dataSearch()">
								<c:forEach items="${faqCategoryList}" var="list" varStatus="stat">
									<c:if test="${stat.first}">
										<option value="">선택하세요</option>
									</c:if>
									<option value="${list.CC_CODE}" <c:if test="${param.r_bdtype eq list.CC_CODE }">selected</c:if>>${list.CC_NAME}</option>
								</c:forEach>
							</select>
						</div>
						<div class="col-md-1 empty searchBtn">
							<button type="button" onclick="dataSearch();">Search</button>
						</div>

					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<button type="button" class="full-width" onclick="dataSearch();">Search</button>
					</div>

					<div class="boardListArea">
						<h2>
							Total <strong>${listTotalCount}</strong>EA
							<div class="title-right little">
<%--								<button type="button" class="btn-excel"><img src="${url}/include/images/front/common//icon_excel@2x.png" alt="img" /></button>--%>
							</div>
						</h2>

						<div class="boardList">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="8%" />
									<col width="12%" />
									<col width="50%" />
									<col width="15%" />
									<col width="15%" />
								</colgroup>
								<thead>
								<tr>
									<th>NO</th>
									<th>유형</th>
									<th>제목</th>
									<th>등록자</th>
									<th>등록일</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>${listTotalCount -((r_page-1) * r_limitrow + status.index)}</td>
										<td>${list.BD_TYPENM}</td>
										<td class="text-left"><a href="#" onclick="boardViewPop(this, '${list.BD_SEQ}');" class="nowrap">${list.BD_TITLE}</a></td>
										<td>${list.USER_NM}</td>
										<td>${fn:substring(list.BD_INDATE,0,10)}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="10%" />
									<col width="15%" />
									<col width="50%" />
									<col width="25%" />
								</colgroup>
								<thead>
								<tr>
									<th>NO</th>
									<th>유형</th>
									<th>제목</th>
									<th>등록자</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>${listTotalCount -((r_page-1) * r_limitrow + status.index)}</td>
										<td>${list.BD_TYPENM}</td>
										<td class="text-left"><a href="#" onclick="boardViewPop(this, '${list.BD_SEQ}');" class="nowrap">${list.BD_TITLE}</a></td>
										<td>${list.USER_NM}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</div> <!-- boardList -->

						<!-- BEGIN paginate -->
						<c:if test="${!empty list}">
							<%@ include file="/WEB-INF/views/include/front/pager.jsp" %>
						</c:if>
						<!-- END paginate -->

					</div> <!-- boardListArea -->
					
					<section>
						<c:if test="${!empty main2BannerList}">
							<div class="banArea"><!-- 1300 * 220 -->
								<ul id="content-slider" class="content-slider">
									<c:forEach items="${main2BannerList}" var="bn2List" varStatus="stat">
										<li>
											<c:if test="${bn2List.BN_LINKUSE eq 'Y'}">
												<a <c:if test="${!empty bn2List.BN_LINK}">href="${bn2List.BN_LINK}" target="_blank"</c:if> <c:if test="${empty bn2List.BN_LINK}">href="javascript:;"</c:if> >
													<img class="hide-xxs" src="${url}/data/banner/${bn2List.BN_IMAGE}"  width="1300" height="220" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
													<img class="hide500" src="${url}/data/banner/${bn2List.BN_MOBILEIMAGE}"  width="500" height="150" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
												</a>
											</c:if>
											<c:if test="${bn2List.BN_LINKUSE eq 'N'}">
												<img class="hide-xxs" src="${url}/data/banner/${bn2List.BN_IMAGE}"  width="1300" height="220" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
												<img class="hide500" src="${url}/data/banner/${bn2List.BN_MOBILEIMAGE}"  width="500" height="150" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="${bn2List.BN_ALT}" />
											</c:if>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
					</section>

				</div> <!-- Col-md-12 -->
			</div> <!-- Row -->

			</form>
		</div> <!-- Content -->
	</main> <!-- Container -->

	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>

	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>

	<!-- Modal -->
	<div class="modal fade" id="boardViewPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content">
			</div>
		</div>
	</div>
	
</div> <!-- Wrap -->

</body>
</html>