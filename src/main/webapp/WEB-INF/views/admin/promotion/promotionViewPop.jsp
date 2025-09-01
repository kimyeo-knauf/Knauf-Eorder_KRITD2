<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy.MM.dd" var="nowDate" />
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">
$(function(){

});

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/admin/promotion/promotionViewPop.lime');
}
</script>
</head>

<body class="page-header-fixed pace-done compact-menu"> <!-- 팝업사이즈 1000 * 700 -->

	<!-- Page Content -->
	<main class="page-content content-wrap">
		<!-- Page Inner -->
		<div class="page-inner no-p">
			<form name="frm" method="post" >
				<%-- Start. Use For Paging --%>
				<input name="r_prmseq" type="hidden" value="${promotionOne.PRM_SEQ}" />
				<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
				<input name="rows" type="hidden" value="4" /><%-- r_limitrow --%>

			</form>
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
					
						<div class="panel panel-white promotion-detail">
							<div class="panel-heading clearfix">
								<h4 class="panel-title">프로모션</h4>
							</div>
							
							<div class="panel-body">
								<div id="topView" class="tableSearch top-view3">
									<div class="topSearch">
										<ul>
											<li>
												<label class="search-h">이벤트명</label>
												<div class="search-c">
													${promotionOne.PRM_TITLE}
												</div>
											</li>
											<li>
												<c:if test="${promotionOne.PRM_TYPE eq '1'}"><c:set var="PRM_TYPE" value="공지"/></c:if>
												<c:if test="${promotionOne.PRM_TYPE eq '2'}"><c:set var="PRM_TYPE" value="품목"/></c:if>
												<label class="search-h">이벤트 구분</label>
												<div class="search-c">${PRM_TYPE}</div>
											</li>
											<li>
												<label class="search-h">이벤트 기간</label>
												<div class="search-c" >
													<fmt:formatDate value="${promotionOne.PRM_SDATE}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${promotionOne.PRM_EDATE}" pattern="yyyy-MM-dd"/>
												</div>
											</li>
											<li class="blank">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li>
											<li class="max-img">
												<label class="search-h">리스트 이미지</label>
												<div class="search-c">
													<img src="${url}/data/promotion/${promotionOne.PRM_IMAGE2}" onerror="this.src='${url}/include/images/common/list_noimg.gif'" alt="img" />
												</div>
											</li>
											<li class="max-img">
												<label class="search-h">메인 이미지</label>
												<div class="search-c">
													<img src="${url}/data/promotion/${promotionOne.PRM_IMAGE1}" onerror="this.src='${url}/include/images/common/list_noimg.gif'" alt="img" />
												</div>
											</li>
											<li class="blank max-img">
												<label class="search-h"></label>
												<div class="search-c"></div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<c:if test="${promotionOne.PRM_TYPE eq '2'}">
								<div class="panel-body">
								<h5 class="table-title">관련품목</h5>
								<div class="product-list m-t-sm">
									<ul class="cd-gallery">
										<c:forEach items="${promotionItemList}" var="list" varStatus="status">
											<li>
												<a href="javascript:;" style="cursor: default; text-decoration: none;">
													<ul class="cd-item-wrapper">
														<li class="selected">
															<img src="${url}/data/item/${list.ITI_FILE1}" onerror="this.src='${url}/include/images/common/list_noimg.gif'" alt="image">
														</li>
													</ul>
												</a>
												<div class="cd-item-info">
													<b>
														<a href="javascript:;" style="cursor: default; text-decoration: none;">${list.DESC1}</a>
														<span>${list.DESC2}</span>
													</b>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								
								<!-- BEGIN paginate -->
								<%@ include file="/WEB-INF/views/include/admin/pager.jsp" %>
								<!-- END paginate -->
							</div>
							</c:if>
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