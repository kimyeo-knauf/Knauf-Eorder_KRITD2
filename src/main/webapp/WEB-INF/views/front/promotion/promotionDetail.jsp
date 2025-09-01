<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
$(document).ready(function() {

});

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/promotion/promotionList.lime');
}

// 품목 상세 post 팝업 띄우기.
function itemDetailPop(obj, itemCd){
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 955;
		var heightPx = 825;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
		$('form[name="frmPop"]').find('input[name="r_itemcd"]').val(itemCd);
	
		window.open('', 'itemViewPop', options);
		$('form[name="frmPop"]').prop('action', '${url}/front/item/itemViewPop.lime');
		$('form[name="frmPop"]').submit();
	}
	else{
		// 모달팝업
		//$('#itemViewPopMId').modal('show');
		var link = '${url}/front/item/itemViewPop.lime?r_itemcd='+itemCd+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#itemViewPopMId').modal({
			remote: link
		});
	 }
}

</script>
</head>
<body>

<div id="subWrap" class="subWrap">

	<!-- Header -->
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>

	<%-- 품목 상세 팝업 필수 파라미터 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>

	<div class="container-fluid">
		<div class="full-content">

			<div class="row no-m">
				<div class="page-breadcrumb"><strong>이벤트상세</strong></div>

				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/promotion/promotionList.lime">프로모션</a></li>
						<li><a>이벤트상세</a></li>
					</ul>
				</div>
			</div> <!-- Row -->

		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->

	<!-- Container -->
	<main class="container" id="container">

		<!-- Content -->
		<div class="content">

			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">

					<div class="boardViewArea">
						<h2 class="title">
							<div class="title-right little">
								<button type="button" class="btn-list" onclick="location.href='${url}/front/promotion/promotionList.lime'"><img src="${url}/include/images/front/common/icon_list@2x.png" alt="img" /></button>
							</div>
						</h2>
					</div> <!-- boardViewArea -->

					<div class="boardViewArea eventView">
						<h2 class="title">
							<c:if test="${promotionOne.PRM_TYPE eq '1'}"><c:set var="PRM_TYPE" value="공지"/></c:if>
							<c:if test="${promotionOne.PRM_TYPE eq '2'}"><c:set var="PRM_TYPE" value="품목"/></c:if>
							<span class="kinds">${PRM_TYPE}</span>
							<strong>${promotionOne.PRM_TITLE}</strong>
							<span>이벤트 기간 <em><fmt:formatDate value="${promotionOne.PRM_SDATE}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${promotionOne.PRM_EDATE}" pattern="yyyy-MM-dd"/></em></span>
						</h2>

						<div class="boardView">

							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tbody>
								<tr>
									<td>
										<p><img src="${url}/data/promotion/${promotionOne.PRM_IMAGE1}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></p>
										<%--
										<p>우리가 좋은 날에는 행복한 하루가 되기 위해서 정말 많은 생각을 하게 된다.</p>
										<p>즐거움이 있을 수 있고 행복이 있을 수 있다 가을이 왔으면 좋겠다.</p>
										--%>
									</td>
								</tr>
								<tr>
									<td class="data">
										<em><fmt:formatDate value="${promotionOne.PRM_INDATE}" pattern="yyyy-MM-dd hh:mm:ss"/></em>
									</td>
								</tr>
								</tbody>
							</table>
						</div> <!-- boardView -->

					</div> <!-- eventView -->

					<c:if test="${promotionOne.PRM_TYPE eq '2'}">
						<div class="product-gallery">

						<h2 class="title">관련품목</h2>

						<ul>
							<c:forEach items="${promotionItemList}" var="list" varStatus="status">
								<li>
									<a href="javascript:;" onclick="itemDetailPop(this,'${list.ITEM_CD}')">
										<ul class="cd-item-wrapper">
											<li class="selected">
												<img src="${url}/data/item/${list.ITI_FILE1}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /> <!-- 300 * 300 -->
											</li>
										</ul>
									</a>
									<div class="cd-item-info">
										<a href="javascript:;" onclick="itemDetailPop(this,'${list.ITEM_CD}')">${list.DESC1}</a>
										<em class="cd-date">
												${list.DESC2}
										</em>
									</div>
								</li>
							</c:forEach>

					</div> <!-- product-gallery -->
					</c:if>
				</div> <!-- Col-md-12 -->
			</div> <!-- Row -->

		</div> <!-- Content -->
	</main> <!-- Container -->

	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>

	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
	
	<!-- Modal -->
	<div class="modal fade" id="itemViewPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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