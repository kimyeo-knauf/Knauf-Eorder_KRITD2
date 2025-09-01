<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});

$(function(){
	
});

function getCookieValue(cookieNm) {
	var cookieNm = document.cookie.match('(^|[^;]+)\\s*' + cookieNm + '\\s*=\\s*([^;]+)');
	return cookieNm ? cookieNm.pop() : '';
}

</script>
</head>

<body>
<!-- Wrap -->
<div id="wrap">
	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>

	<form name="frmPopSubmit" method="post">
		<input type="hidden" name="pop" value="1" />
		<input type="hidden" name="r_puseq" value="" />
		<input type="hidden" name="r_putype" value="2" />
	</form>
	<!-- Main Wrap -->
	<div class="main_wrap">
		<div class="stage">
			<%--
			동영상 플레이<ul class="slider">
				<li class="item1">
					<div class="playNo"></div>
					<video controls loop="0" src="http://www.noroopaint.com/kor/pr/ad/vod/main_left.mp4" tabindex="-1" muted="true" style="width:1140px; height:518px;" poster="http://www.noroopaint.com/${url}/include/images/front/poster190308_2.jpg">
				</li>
				<li class="item2"><div class="playNo"></div>
					<video controls loop="0" src="http://www.noroopaint.com/kor/pr/ad/vod/main_20190308.mp4" tabindex="-1" muted="true" style="width:1140px; height:518px;" poster="${url}/include/images/front/03.jpg"></video>
				</li>
				<li class="item3"><div class="playNo"></div>
					<video controls loop="0" src="http://www.noroopaint.com/kor/pr/ad/vod/main_20190218.mp4" tabindex="-1" muted="true" style="width:1140px; height:518px;" poster="${url}/include/images/front/02.jpg"></video>
				</li>
			</ul>
			--%>
			<ul class="slider">
				<li class="item1">
					<div class="dashboard">
						<h4>주문현황 <i>[TODAY]</i></h4>
						<span>
							<a href="${url}/front/order/orderList.lime">
								<i><img src="${url}/include/images/front/common/visual-icon4@2x.png" alt="icon" /></i>
								<h6>${orderStatus['00']}</h6>
								<strong><fmt:formatNumber value="${cntFor00}" pattern="#,###" /></strong>
							</a>
							<a href="#">
								<i><img src="${url}/include/images/front/common/visual-icon1@2x.png" alt="icon" /></i>
								<h6>주문확정</h6>
								<%-- 인덱스에서만 오더접수(522) 텍스트를 주문확정으로 변경 2020-05-12 By Hong. --%>
								<%-- 인덱스에서만 오더접수(522) ->주문확정으로 변경요청하여 StatusUtil.java 522 주문확정으로 변경 2020-05-18 By Lee. --%>
								<%-- <h6>${salesOrderStatus['522']}</h6> --%>
								<strong><fmt:formatNumber value="${cntFor522}" pattern="#,###" /></strong>
							</a>
							<a href="#">
								<i><img src="${url}/include/images/front/common/visual-icon2@2x.png" alt="icon" /></i>
								<h6>${salesOrderStatus['530']}</h6>
								<strong><fmt:formatNumber value="${cntFor530}" pattern="#,###" /></strong>
							</a>
							<a href="#">
								<i><img src="${url}/include/images/front/common/visual-icon3@2x.png" alt="icon" /></i>
								<h6>${salesOrderStatus['560']}</h6>
								<strong><fmt:formatNumber value="${cntFor560}" pattern="#,###" /></strong>
							</a>
						</span>
					</div>
					<video class="hide-xxs" src="" tabindex="-1" muted="true" poster="${url}/include/images/front/02_.jpg"><img src="${url}/include/images/front/02.jpg" alt="dashboard" /></video>
					<img class="hide500" src="${url}/include/images/front/02.jpg" alt="dashboard" />
				</li>

				<c:forEach items="${main1BannerList}" var="bnList" varStatus="stat">
					<li class="item${stat.count+1}" style="background-image: url('${url}/data/banner/${bnList.BN_IMAGE}');" title="${bnList.BN_ALT}">
						<c:if test="${bnList.BN_LINKUSE eq 'Y'}">
							<a <c:if test="${!empty bnList.BN_LINK}">href="${bnList.BN_LINK}" target="_blank"</c:if> <c:if test="${empty bnList.BN_LINK}">href="javascript:;"</c:if> >
								<img class="hide-xxs" src="${url}/data/banner/${bnList.BN_IMAGE}" alt="${bnList.BN_ALT}" />
								<img class="hide500" src="${url}/data/banner/${bnList.BN_MOBILEIMAGE}" alt="${bnList.BN_ALT}" />
								<p></p>
							</a>
						</c:if>
						<c:if test="${bnList.BN_LINKUSE eq 'N'}">
							<img class="hide-xxs" src="${url}/data/banner/${bnList.BN_IMAGE}" alt="${bnList.BN_ALT}" /><img class="hide500" src="${url}/data/banner/${bnList.BN_MOBILEIMAGE}" alt="${bnList.BN_ALT}" /><p></p>
						</c:if>
<!-- 						<div class="playNo"></div> -->
<%-- 						<video src="" tabindex="-1" muted="true" poster="${url}/data/banner/${bnList.BN_IMAGE}" style="object-fit: cover;" width="1300" height="500"><img src="${url}/data/banner/${bnList.BN_IMAGE}" width="1300" height="500" alt="${bnList.BN_ALT}" /></video> --%>
					</li>
				</c:forEach>
			</ul>
			<div class="video_btn_wrap">
				<span>
					<button type="button" class="prev">이전</button>
					<button type="button" class="next">다음</button>
				</span>
			</div>

		</div> <!-- stage -->

		<section>
			<h2>주문접수 <button type="button" onclick="location.href='${url}/front/order/orderList.lime'"><img src="${url}/include/images/front/common/icon_plusM.png" alt="more" /></button></h2>
			<div class="newArea">
				<div class="widget">

					<div class="widget-content table-wrap">
						<table class="table table-striped table-checkable table-hover">
							<colgroup>
								<col width="15%">
								<col width="20%">
								<col width="35%">
								<col width="15%">
								<col width="15%">
							</colgroup>
							<thead>
								<tr>
									<th>주문일</th>
									<th>주문번호</th>
									<th>품목명</th>
									<th>단위</th>
									<th>수량</th>
								</tr>
							</thead>

							<tbody>
								<c:forEach items="${listFor00}" var="list" varStatus="stat">
									<tr>
										<td>${fn:substring(list.INDATE, 0, 10)}</td>
										<td><a href="${url}/front/order/orderView.lime?r_reqno=${list.REQ_NO}&">${list.REQ_NO}</a></td>
										<td class="text-left">${list.DESC1}</td>
										<td>${list.UNIT}</td>
										<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" pattern="#,###.##" /></td>
									</tr>
								</c:forEach>
								
								<!-- 리스트없음 -->
								<c:if test="${empty listFor00}">
									<tr>
										<td colspan="5" class="list-empty">
											<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
											주문접수 내역이 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>

					</div>
				</div>
			</div>
		</section>

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

		<section>
			<h2>
				커뮤니티
				<%-- <a target="_blank" href="https://www.youtube.com/user/BoralPlasterboard"><img src="${url}/include/images/front/common/sns04.png" alt="youtube" /></a> --%>
				<a target="_blank" href="https://www.linkedin.com/company/%ED%95%9C%EA%B5%AD-%EC%9C%A0%EC%97%90%EC%8A%A4%EC%A7%80-%EB%B3%B4%EB%9E%84-usg-boral-korea/"><img src="${url}/include/images/front/common/sns03.png" alt="linkedin" /></a>
				<a target="_blank" href="https://www.facebook.com/USGBoral.Korea/"><img src="${url}/include/images/front/common/sns01.png" alt="facebook" /></a>
			</h2>
			<div class="bestAreaAll">
				<div class="bestArea">
					<ul class="tabs" data-persist="true">
						<li class="selected"><a href="#view1">공지사항</a></li>
						<li><a href="#view2">FAQ</a></li>
						<li><a href="#view3">자료실</a></li>
					</ul>
					<div class="tabcontents">
						<div id="view1">
							<div class="widget-notice">
								<c:forEach items="${noticeList}" var="list" varStatus="stat">
									<c:if test="${stat.first}">
									<dl>
										<c:if test="${fn:length(list.BD_TITLE) >= 35}"><dt><a href="${url}/front/board/noticeList.lime">${fn:substring(list.BD_TITLE, 0, 35)}...</a></dt></c:if>
										<c:if test="${fn:length(list.BD_TITLE) < 35}"><dt><a href="${url}/front/board/noticeList.lime">${list.BD_TITLE}</a></dt></c:if>
										<dd>
											<c:if test="${fn:length(noticeFirstContent) >= 105}"><a href="${url}/front/board/noticeList.lime" class="txt">${fn:substring(cvt:removeTag(noticeFirstContent), 0, 105)}...</a></c:if>
											<c:if test="${fn:length(noticeFirstContent) < 105}"><a href="${url}/front/board/noticeList.lime" class="txt">${cvt:removeTag(noticeFirstContent)}</a></c:if>
											<button type="button" class="more" onclick="location.href='${url}/front/board/noticeList.lime'">더보기 +</button>
										</dd>
									</dl>
									</c:if>
									<c:if test="${!stat.first}">
										<ul>
											<li><a href="${url}/front/board/noticeList.lime">${list.BD_TITLE}</a><span>${fn:substring(list.BD_INDATE,0,10)}</span></li>
										</ul>
									</c:if>
								</c:forEach>
							</div>
						</div>

						<div id="view2">
							<div class="widget-notice">
								<c:forEach items="${faqList}" var="list" varStatus="stat">
									<c:if test="${stat.first}">
										<dl>
											<c:if test="${fn:length(list.BD_TITLE) >= 35}"><dt><a href="${url}/front/board/faqList.lime">${fn:substring(list.BD_TITLE, 0, 35)}...</a></dt></c:if>
											<c:if test="${fn:length(list.BD_TITLE) < 35}"><dt><a href="${url}/front/board/faqList.lime">${list.BD_TITLE}</a></dt></c:if>
											<dd>
												<c:if test="${fn:length(faqFirstContent) >= 105}"><a href="${url}/front/board/faqList.lime" class="txt">${fn:substring(cvt:removeTag(faqFirstContent), 0, 105)}...</a></c:if>
												<c:if test="${fn:length(faqFirstContent) < 105}"><a href="${url}/front/board/faqList.lime" class="txt">${cvt:removeTag(faqFirstContent)}</a></c:if>
												<button type="button" class="more" onclick="location.href='${url}/front/board/faqList.lime'">더보기 +</button>
											</dd>
										</dl>
									</c:if>
									<c:if test="${!stat.first}">
										<ul>
											<li><a href="${url}/front/board/faqList.lime">${list.BD_TITLE}</a><span>${fn:substring(list.BD_INDATE,0,10)}</span></li>
										</ul>
									</c:if>
								</c:forEach>
							</div>
						</div>

						<div id="view3">
							<div class="widget-notice">
								<c:forEach items="${referenceList}" var="list" varStatus="stat">
									<c:if test="${stat.first}">
										<dl>
											<c:if test="${fn:length(list.BD_TITLE) >= 35}"><dt><a href="${url}/front/board/referenceList.lime">${fn:substring(list.BD_TITLE, 0, 35)}...</a></dt></c:if>
											<c:if test="${fn:length(list.BD_TITLE) < 35}"><dt><a href="${url}/front/board/referenceList.lime">${list.BD_TITLE}</a></dt></c:if>
											<dd>
												<c:if test="${fn:length(referenceFirstContent) >= 150}"><a href="${url}/front/board/referenceList.lime" class="txt">${fn:substring(cvt:removeTag(referenceFirstContent), 0, 150)}...</a></c:if>
												<c:if test="${fn:length(referenceFirstContent) < 150}"><a href="${url}/front/board/referenceList.lime" class="txt">${cvt:removeTag(referenceFirstContent)}</a></c:if>
												<button type="button" class="more" onclick="location.href='${url}/front/board/referenceList.lime'">더보기 +</button>
											</dd>
										</dl>
									</c:if>
									<c:if test="${!stat.first}">
										<ul>
											<li><a href="${url}/front/board/referenceList.lime">${list.BD_TITLE}</a><span>${fn:substring(list.BD_INDATE,0,10)}</span></li>
										</ul>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>

		<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>

		<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>

	</div> <!-- Main Wrap -->

</div> <!-- Wrap -->

<script type="text/javascript">
// 유투브 스크립트
var $ids = $('video'), tgs = [];
var $eles = $('.slider>li');
var eles = $eles.toArray();
var pt = [];
var center = Math.floor(eles.length/2);
var total = eles.length;
var repeat = 1,count = 0;
var playSlider = function() {
	setCss();
}

function setCss() {
	eles.forEach(function(e,i) {
		pt[i] = $(e).css(['top','height','left','z-index','opacity']);
	});

	for(var i = 0 ; i < center ; i++) {
		eles.unshift(eles.pop());
		eles.forEach(function(e,i) {
			count++;
			$(e).css(pt[i]).removeClass('click');
			$(e).find('.txt').hide();
			$(e).find('.playNo').show();
			if(count == (Math.abs(repeat) * total)) {
				$(eles[center]).addClass('click');
				$(eles[center]).find('.playNo').hide();
				//$('.click video')[0].play();
				count = 0;
			} else {
				$('video')[0].pause();
			}
		});
	}
}

function movePanel() {
	eles.forEach(function(e,i) {
		$(e).removeClass('click');
		$(e).find('.playNo').show();
		$(e).stop(true,true).animate(pt[i],200,function() {
			count++;
			if(count === (Math.abs(repeat) * total)) {
				$(eles[center]).addClass('click');
				$(eles[center]).find('.playNo').hide();
				//TODO  비디오 업로드 요청 시 활성화 (비디오 없이 활성화 크롬 DOM expcetion)
				// $('.click video')[0].play();
				sliderAfter($(eles[center]));
				count = 0,isStop=false;
			} else {
				// $('video')[0].pause();
			}
		});
		// $('video')[i].pause();
	});
}

$eles.on('click',function(e) {
	if(!$(this).hasClass('click') && !$(this).is(':animated')) {
		repeat = center - parseInt(eles.indexOf(this));
		repeat < 0 ?  repeatFn(nextFn) : repeatFn(prevFn);
	}
});

function repeatFn(m) {
	for(var i = 0 ; i < Math.abs(repeat) ; i++) {
		m();
	}
}
$('.prev').on('click',function(e) {
	prevFn();
});
$('.next').on('click',function(e) {
	nextFn();
});

function prevFn() {
	eles.unshift(eles.pop());
	sliderBefore();
	movePanel();
}

function nextFn() {
	eles.push(eles.shift());
	sliderBefore();
	movePanel();
}

function sliderBefore() {
	tgs.forEach(function(e,i) {
		$('video')[0].pause();
	});
}

function sliderAfter(ele) {
	if(ele.find('video').length) {
		current = $.grep(tgs,function(i) {
			return i.a == ele.find('video')[0];
			$('.click video')[0].play();
		})
	}
}

playSlider();
</script>

<script type="text/javascript"> <!-- 레이어 팝업 -->

$(document).ready(function(){
	var popupList = $.parseJSON('${popupList}'),
			popupListLen =  popupList.length;

	for(var i=0; i<popupListLen; i++){
		var pu_seq = popupList[i].PU_SEQ;
		makeLayerPopup(popupList[i]);

		if( $('#greetings_'+pu_seq).is(":hidden")) {

			var cookie_greetings = getCookieGreetings('greetings_'+pu_seq);
			if(cookie_greetings =='done'){
			}else {
				$("#layer_greetings_"+pu_seq).slideDown(1000);
			}

			// $("#layer_greetings_"+pu_seq).width(popupList[i].PU_WIDTH).height(popupList[i].PU_HEIGHT);
			// $("#layer_greetings_"+pu_seq).css('height',popupList[i].PU_HEIGHT+'px');
			// $("#layer_greetings_"+pu_seq).offset({left : popupList[i].PU_X , top : popupList[i].PU_Y});
		}
		// $("#layer_greetings_"+pu_seq).css({'left':$('#bannerArea_'+pu_seq).find('img').offset().left});
		// $( window ).resize(function() {
		// 	$("#layer_greetings_"+pu_seq).css({'left':$('#bannerArea_'+pu_seq).find('img').offset().left});
		// });
	}
});

function makeLayerPopup(popupObj) {

	var htmlStr  =  '';
	// htmlStr +=	'<div class="layer_greetings"  id="layer_greetings_'+popupObj.PU_SEQ+'" width="'+popupObj.PU_WIDTH+'px" height="'+popupObj.PU_HEIGHT+'px" top="'+popupObj.PU_Y+'">';
	htmlStr +=	'<div class="layer_greetings"  id="layer_greetings_'+popupObj.PU_SEQ+'" style="width: '+popupObj.PU_WIDTH+'px; height : '+popupObj.PU_HEIGHT+'px; left: '+popupObj.PU_X+'px; top: '+popupObj.PU_Y+'px;">'; // work
	// htmlStr +=	'<div class="layer_greetings"  id="layer_greetings_'+popupObj.PU_SEQ+'" >';
	// htmlStr +=	'<div class="layer_greetings"  id="layer_greetings_'+popupObj.PU_SEQ+'">';
	htmlStr +=	'<div class="bannerArea"  id="bannerArea_'+popupObj.PU_SEQ+'">';
	if('Y' == popupObj.PU_LINKUSE) htmlStr +=	'<a href="'+popupObj.PU_LINK+'" target="_blank">';
	htmlStr +=	'<img src="${url}/data/popup/'+popupObj.PU_IMAGE+'" alt="레이어팝업" />';
	if('Y' == popupObj.PU_LINKUSE)	htmlStr +=	'</a>';
	htmlStr +=	'</div>';
	htmlStr +=	'<div class="bottom">';
	htmlStr +=	'<input type="checkbox" name="greetings" id="greetings_'+popupObj.PU_SEQ+'" onclick="closeGreetings(\'greetings_'+popupObj.PU_SEQ+'\',\'layer_greetings_'+popupObj.PU_SEQ+'\')" />';
	htmlStr +=	'<label for="greetings_'+popupObj.PU_SEQ+'"><span>오늘 하루 이 창을 열지 않음</span></label>';
	htmlStr +=	'<a href="javascript:closeGreetings(\'greetings_'+popupObj.PU_SEQ+'\',\'layer_greetings_'+popupObj.PU_SEQ+'\')" title="창닫기"><img src="${url}/include/images/common/pop_close_icon.png" /></a>';
	htmlStr +=	'</div>';
	htmlStr +=	'</div>';

	$('body').append(htmlStr);
}

/**
 * 팝업창
 * @param chkId 하루동안 창 닫기 checkbox태그 ID
 * @param layerPopupId 닫기를 클릭한 팝업 DIV태그 ID
 */
function closeGreetings(chkId,layerPopupId){
	if(	$('#'+chkId).prop("checked") ==true) {
		setCookie(chkId, 'done' , 1);
	}

	$('#'+layerPopupId).css({"display":"none"});
}

function getCookieGreetings(c_name) {
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++)
	{
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name)
		{
			return unescape(y);
		}
	}
}
</script>
</body>
</html>