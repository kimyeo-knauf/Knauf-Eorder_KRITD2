<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
<style>

</style>

<script type="text/javascript">
/*(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});*/

$(function(){
	if('Y' == toStr('${param.r_detailsearch}')){
		fn_spread('hiddenContent02');
	}

	//등록일 데이트피커
	$('input[name="r_bdsdate"]').datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_bdedate"]').datepicker('setStartDate', minDate);
	});

	$('input[name="r_bdedate"]').datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$('input[name="r_bdsdate"]').datepicker('setEndDate', maxDate);
	});
	//
});

// 공지 상세 팝업 띄우기.
function boardViewPop(obj, bdSeq){
	if(!isApp()){
		// 팝업 세팅.
		// var widthPx = 955;
		// var heightPx = 720;
		var widthPx = 1370;
		var heightPx = 950;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
		$('form[name="frmPop"]').find('input[name="r_bdseq"]').val(bdSeq);
	
		window.open('', 'noticeViewPop', options);
		$('form[name="frmPop"]').prop('action', '${url}/front/board/noticeViewPop.lime');
		$('form[name="frmPop"]').submit();
		
	}
	else{
		// 모달팝업
		//$('#boardViewPopMId').modal('show');
		var link = '${url}/front/board/noticeViewPop.lime?r_bdseq='+bdSeq+'&layer_pop=Y&';
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
	formPostSubmit('', '${url}/front/board/noticeList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/board/noticeList.lime');
}

//상세조회 펼침
function fn_spread(id){
	if($('#'+id).css('display') == 'none'){
		$('#'+id).show();
		$('input[name="r_detailsearch"]').val('Y');
	}
	else{
		$('#'+id).hide();
		$('input[name="r_detailsearch"]').val('N');
	}
}


</script>
</head>
<body>

<div id="subWrap" class="subWrap">

	<!-- Header -->
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>

	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="noticeViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_bdseq" type="hidden" value="" />
	</form>

	<div class="container-fluid">
		<div class="full-content">

			<div class="row no-m">
				<div class="page-breadcrumb"><strong>공지사항</strong></div>

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
								<%-- 2025-08-11 hsg 클라이언트의 요청에 주석처리 <option value="${url}/front/board/chatList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/board/chatList.lime')}">selected="selected"</c:if> >채팅 피드백</option> --%>
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
				<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitro --%>
				<%-- End. --%>

				<input name="r_detailsearch" type="hidden" value="${param.r_detailsearch}" />
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">

					<div class="searchArea">
						<div class="col-md-6">
							<em>제목</em>
							<input type="text" class="form-control" name="rl_bdtitle" value="${param.rl_bdtitle}" onkeypress="if(event.keyCode == 13){dataSearch();}" maxlength="100"/>
						</div>
						<div class="col-md-3 right">
							<em>첨부파일</em>
							<div class="table-radio">
								<c:set var="bdfileynChk" value="" />
								<c:if test="${param.r_bdfileyn eq 'Y'}">
									<c:set var="bdfileynChk" value="checked" />
								</c:if>
								<label class="lol-label-radio" for="radio1">
									<input type="radio" id="radio1" name="r_bdfileyn" value="Y" ${bdfileynChk} onchange="dataSearch()" />
									<span class="lol-text-radio">Y</span>
								</label>
							</div>
						</div>
						<div class="col-md-1 empty searchBtn">
							<!-- <button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button> -->
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						<div class="col-md-6 right">
							<em>등록일</em>
							<input type="text" class="form-control calendar" name="r_bdsdate" autocomplete="off" value="${param.r_bdsdate}" readonly/> <span>~</span> <input type="text" class="form-control calendar" name="r_bdedate" autocomplete="off" value="${param.r_bdedate}" readonly/>
						</div>
						<div class="col-md-6">
							<em>등록자</em>
							<input type="text" class="form-control" name="rl_usernm" value="${param.rl_usernm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						</div>
						

						<%-- <div id="hiddenContent02" style="display: none; width: 100%; height:auto; margin-bottom:0;"> <!-- 상세조회 더보기  -->
							<div class="col-md-6">
								<em>등록자</em>
								<input type="text" class="form-control" name="rl_usernm" value="${param.rl_usernm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
							</div>
							<div class="col-md-6 right">
								<em>등록일</em>
								<input type="text" class="form-control calendar" name="r_bdsdate" autocomplete="off" value="${param.r_bdsdate}" /> <span>~</span> <input type="text" class="form-control calendar" name="r_bdedate" autocomplete="off" value="${param.r_bdedate}" />
							</div>
						</div> --%>
					</div> <!-- searchArea -->

					<div class="searchBtn full-tablet">
						<!-- <button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button> -->
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
									<th>첨부파일</th>
									<th>제목</th>
									<th>등록자</th>
									<th>등록일</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>
											<c:if test="${list.BD_NOTICEYN eq 'Y'}"><span class="noticeBox">공지</span></c:if>
											<c:if test="${list.BD_NOTICEYN eq 'N'}">${listTotalCount -((r_page-1) * r_limitrow + status.index)}</c:if>
										</td>
										<td><c:if test="${list.BD_FILEYN eq 'Y'}"><img src="${url}/include/images/front/common/icon_file@2x.png" width="26" height="26" alt="file" /></c:if></td>
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
									<col width="20%" />
									<col width="50%" />
									<col width="20%" />
								</colgroup>
								<thead>
								<tr>
									<th>NO</th>
									<th>첨부파일</th>
									<th>제목</th>
									<th>등록자</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>
											<c:if test="${list.BD_NOTICEYN eq 'Y'}">공지</c:if>
											<c:if test="${list.BD_NOTICEYN eq 'N'}">${listTotalCount -((r_page-1) * r_limitrow + status.index)}</c:if>
										</td>
										<td><c:if test="${list.BD_FILEYN eq 'Y'}"><img src="${url}/include/images/front/common/icon_file@2x.png" width="26" height="26" alt="file" /></c:if></td>
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