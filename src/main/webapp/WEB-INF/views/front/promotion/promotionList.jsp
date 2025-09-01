<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">

/*(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();

ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});*/

$(function(){

});

$(document).ready(function() {

});

// 이벤트 상세 팝업
function promotionDetail(prmSeq){
	// GET으로 변경. 2020-07-15 By Hong.
	formGetSubmit('${url}/front/promotion/promotionDetail.lime', 'r_prmseq='+prmSeq);
	
	//$('form[name="frm"]').find('input[name="r_prmseq"]').val(prmSeq);
	//$('form[name="frm"]').prop('action', '${url}/front/promotion/promotionDetail.lime');
	//$('form[name="frm"]').submit();
}

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/promotion/promotionList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/promotion/promotionList.lime');
}

</script>
</head>
<body>

<div id="subWrap" class="subWrap">

	<!-- Header -->
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>

	<div class="container-fluid">
		<div class="full-content">

			<div class="row no-m">
				<div class="page-breadcrumb"><strong>이벤트현황</strong></div>

				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/promotion/promotionList.lime">프로모션</a></li>
						<li>
							<select onchange="tabChange(this.value);">
								<option value="${url}/front/promotion/promotionList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/promotion/promotionList.lime')}">selected="selected"</c:if> >이벤트현황</option>
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

			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
					<form name="frm" method="post" >

						<%-- Start. Use For Paging --%>
						<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
						<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitrow --%>
						<input name="r_prmseq" type="hidden" value="" />
						<input name="r_prmongoing" type="hidden" value="" />
							<%-- End. --%>
						<div class="searchArea">
							<div class="col-md-6">
								<em>이벤트명</em>
								<input type="text" class="form-control" name="rl_prmtitle" value="${param.rl_prmtitle}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							<div class="col-md-3 right">
								<em>이벤트구분</em>
								<div class="table-radio">
									<label class="lol-label-radio" for="radio1">
										<input type="radio" id="radio1" name="r_prmtype" value="1" <c:if test="${param.r_prmtype eq '1'}">checked</c:if> onchange="dataSearch()"/>
										<span class="lol-text-radio">공지</span>
									</label>
									<label class="lol-label-radio" for="radio2">
										<input type="radio" id="radio2" name="r_prmtype" value="2" <c:if test="${param.r_prmtype eq '2'}">checked</c:if> onchange="dataSearch()"/>
										<span class="lol-text-radio">품목</span>
									</label>
								</div>
							</div>
							<div class="col-md-1 empty searchBtn">
								<button type="button" onclick="dataSearch();">Search</button>
							</div>

						</div> <!-- searchArea -->
					</form>
					<div class="searchBtn full-tablet">
						<button type="button" class="full-width">Search</button>
					</div>

					<div class="tab-wrap">

						<!-- Nav tabs -->
						<ul class="tab-header tabs" data-persist="true">
							<li class="selected"><a href="#view1" >진행중</a></li>
							<li><a href="#view2" >진행완료</a></li>
						</ul>

						<!-- Tab panes -->
						<div class="tab-content">
							<div class="tab-pane active" id="view1">

								<form action="">
									<div class="form-group">
										<div class="event-gallery">

											<h2>Total <strong>${currentCnt}</strong> EA</h2>
											<ul>
												<c:forEach items="${currentList}" var="list" varStatus="status">
													<li>
														<a href="javascript:;" onclick="promotionDetail('${list.PRM_SEQ}')">
															<ul class="cd-item-wrapper">
																<li class="selected">
																	<img src="${url}/data/promotion/${list.PRM_IMAGE2}" onerror="this.src='${url}/include/images/front/content/none_img.png'" alt="img" /> <!-- 450 * 303 -->
																</li>
															</ul>
														</a>
														<div class="cd-item-info">
															<a href="javascript:;" onclick="promotionDetail('${list.PRM_SEQ}')">${list.PRM_TITLE}</a>
															<em class="cd-date">
																	${fn:substring(list.PRM_SDATE,0,10)} ~ ${fn:substring(list.PRM_EDATE,0,10)}
															</em>
														</div>
													</li>
												</c:forEach>
												
												<c:if test="${0 >= currentCnt}">
													<li class="list-empty full-width"> <!-- 리스트없음 -->
														<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
														진행중인 이벤트 내역이 없습니다.
													</li>
												</c:if>
											</ul>

										</div>

										<!-- BEGIN paginate -->
										<c:if test="${!empty list}">
											<%@ include file="/WEB-INF/views/include/front/pager.jsp" %>
										</c:if>
										<!-- END paginate -->

									</div>
								</form>
							</div>

							<div class="tab-pane" id="view2">

								<form action="">
									<div class="form-group">
										<div class="event-gallery">

											<h2>Total <strong>${pastCnt}</strong> EA</h2>

											<ul>
												<c:forEach items="${pastList}" var="list" varStatus="status">
													<li>
														<a href="javascript:;" onclick="promotionDetail('${list.PRM_SEQ}')">
															<ul class="cd-item-wrapper">
																<li class="selected">
																	<img src="${url}/data/promotion/${list.PRM_IMAGE2}" onerror="this.src='${url}/include/images/front/content/none_img.png'" alt="img" /> <!-- 450 * 303 -->
																</li>
															</ul>
														</a>
														<div class="cd-item-info">
															<a href="javascript:;" onclick="promotionDetail('${list.PRM_SEQ}')">${list.PRM_TITLE}</a>
															<em class="cd-date">
																	${fn:substring(list.PRM_SDATE,0,10)} ~ ${fn:substring(list.PRM_EDATE,0,10)}
															</em>
														</div>
													</li>
												</c:forEach>
												
												<c:if test="${0 >= pastCnt}">
													<li class="list-empty full-width"> <!-- 리스트없음 -->
														<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
														진행완료된 이벤트 내역이 없습니다.
													</li>
												</c:if>
											</ul>

										</div>

										<!-- BEGIN paginate -->
										<c:if test="${!empty list}">
											<%@ include file="/WEB-INF/views/include/front/pager.jsp" %>
										</c:if>
										<!-- END paginate -->

									</div>
								</form>
							</div>
						</div>

					</div> <!-- tab-wrap -->
					
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

		</div> <!-- Content -->
	</main> <!-- Container -->

	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>

	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>

</div> <!-- Wrap -->

</body>
</html>