<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<style type="text/css">
button {
  border: 0;
  background: none;
  cursor:pointer;
}

.main_popup {
  position: fixed;
  z-index: 1005;
  -webkit-box-shadow: 0px 13px 40px -6px #061626;
  box-shadow: 0px 13px 40px -6px #061626;
  top: 50px;
  left: 50px;
  display: none;

  &.on {
    display: block;
    background-color: #fff;
  }

  .img_wrap {
    width: 200px;
    height: 200px;
    display:flex;
    justify-content:center;
    align-items:center;
  }

  .btn_close {
    width: 32px;
    height: 32px;
    position: absolute;
    top: 17px;
    right: 17px;
    font-size: 0;
    border: 0;
    background: none;

    &::before {
      content: "";
      width: 2px;
      height: 32px;
      background-color: #333;
      position: absolute;
      top: 0;
      left: 15px;
      transform: rotate(45deg);
    }
    &::after {
      content: "";
      width: 32px;
      height: 2px;
      background-color: #333;
      position: absolute;
      top: 15px;
      left: 0;
      transform: rotate(45deg);
    }
  }

  .btn_today_close {
    width: 100%;
    height: 45px;
    background-color: #333;
    text-align: center;
    color: #fff;
    font-size: 14px;
    display: block;
    span {
      display: block;
      line-height: 40px;
      vertical-align: bottom;	
      opacity: 0.8;
    }
  }
}
</style>

<script    src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
var splitName = replaceAll(getContextPath(), '/', ''); //쿠키명 구분값
console.log("cookie : " + getContextPath());

/*(function(){var w=window;if(w.ChannelIO){return w.console.error("ChannelIO script included twice.");}var ch=function(){ch.c(arguments);};ch.q=[];ch.c=function(args){ch.q.push(args);};w.ChannelIO=ch;function l(){if(w.ChannelIOInitialized){return;}w.ChannelIOInitialized=true;var s=document.createElement("script");s.type="text/javascript";s.async=true;s.src="https://cdn.channel.io/plugin/ch-plugin-web.js";var x=document.getElementsByTagName("script")[0];if(x.parentNode){x.parentNode.insertBefore(s,x);}}if(document.readyState==="complete"){l();}else{w.addEventListener("DOMContentLoaded",l);w.addEventListener("load",l);}})();
ChannelIO('boot', {
  "pluginKey": "db38b412-585f-4b04-a939-8ea08c3f9e8d"
});*/

$(function(){
	getLogin();

	// login height
	$(window).on('ready load resize', function() {
		var body = $('body'),
			wrap = $('#wrap'),
			heightBody = $(window).height(),
			heightLeft = $('.login-left').height(),
			loginImg = $('.login-img'),
			slideImg = loginImg.find('.lSSlideWrapper ul li');
		if(heightBody > 940) {
			body.css('overflow-y', 'hidden');
		}

		wrap.css({'height': heightLeft, 'overflow': 'hidden'});
		slideImg.css('height', heightLeft);


		var b = Mobile();	
		//var accessDevice = '${sessionScope.loginDto.accessDevice}';
		//if('mobile' != accessDevice) {
		if(b == false)  {
			var cookie_event_banner = getCookieGreetings('chkEventBanner');
			//var cookie_event_pc = getCookieGreetings('chkEventPC');
			//var cookie_event_pc2 = getCookieGreetings('chkEventPC2');

			//if(cookie_event_banner =='done'){ }
			//else { $('#eorder_event_banner_pop').show(); }
			$('#eorder_event_banner_pop').hide();
			
			/* if(cookie_event_pc =='done') { }
			else { $('#eorder_event_pc_pop').show(); }
			
			if(cookie_event_pc2 =='done') { }
			else { $('#eorder_event_pc_pop2').show(); } */
		}
	});

	// login top banner
	$("#login-slider1").lightSlider({
		auto:true,
		loop:true,
		keyPress:true
	});

	// login bottom banner
	$("#login-slider2").lightSlider({
		auto:true,
		loop:true,
		keyPress:true
	});

	// login bottom banner
	$("#login-slider3").lightSlider({
		auto:true,
		loop:true,
		keyPress:true
	});
});

//로그인
function sendLogin(obj) {
	$(obj).prop('disabled', true);
	
	if (!$('#r_userid').val()) {
		alert('아이디를 입력하여 주십시오.');
		$('#r_userid').focus();
		$(obj).prop('disabled', false);
		return false;
	}
	
	if (!$('#r_userpwd').val()) {
		alert('비밀번호를 입력하여 주십시오.');
		$('#r_userpwd').focus();
		$(obj).prop('disabled', false);
		return false;
	}

	var passphrase = "Knauf2023";
    var encryptedText = CryptoJS.AES.encrypt($('#r_userpwd').val(), passphrase);

	var params = null;
	if(isApp()) {
		params = {
				r_userid:$('#r_userid').val(), 
				r_userpwd:encryptedText.toString(), 
				loginToken:$('#loginToken').val(), 
				pageType:'F',
				r_autologinyn:($('input:checkbox[name="autologinyn"]').is(':checked') ? 'Y' : 'N'),
				where:'appajax'
			};
	} else {
		params = {
				r_userid:$('#r_userid').val(), 
				r_userpwd:encryptedText.toString(), 
				loginToken:$('#loginToken').val(), 
				pageType:'F'
			};
	}
	
	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : './loginAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				loginCookie();
				formPostSubmit('frm', '${url}/front/index/index.lime');
				//document.location.href = '${url}/front/index/index.lime';
			}
			else if(data.RES_CODE == '0106'){
				if(confirm('이미 접속중 입니다.\n기존의 접속을 종료 하시겠습니까?')){
					disconnectPreLogin(obj);
					$(obj).prop('disabled', false);
					return;
				}
			}
			else if(data.RES_CODE == '0312' || data.RES_CODE == '0317'){ //비밀번호 변경요청 팝업 (관리자변경,초기화,권장변경일)
				loginCookie();
			
				$('form[name="frm"]').append('<input type="hidden" name="resMsg" value="'+data.RES_MSG+'" />');
				$('form[name="frm"]').append('<input type="hidden" name="resCode" value="'+data.RES_CODE+'" />');
				formPostSubmit('frm', '${url}/front/base/userPswdEdit.lime');
			
				//$('input[name="resMsg"]').val(data.RES_MSG);
				//$('input[name="resCode"]').val(data.RES_CODE);
				//formPostSubmit('pfrm', '${url}/front/base/userPswdEdit.lime');
			
			}else if(data.RES_CODE == '0316'){ //최초 로그인시 마이페이지로 이동
				loginCookie();
				formPostSubmit('frm', '${url}/front/mypage/myInformation.lime');
				//document.location.href = '${url}/front/mypage/myInformation.lime';
			}
			
			$(obj).prop('disabled', false);
		},
		complete: function(xhr, status) {
			var data = xhr.responseJSON;
			if (data && data.RES_CODE && data.RES_CODE != '0000' && data.RES_CODE != '0106' && data.RES_CODE != '0312' && data.RES_CODE != '0317' && data.RES_CODE != '0316') {
				alert(data.RES_MSG);
				if(data.RES_CODE == '0101' || data.RES_CODE == '0104'){
					location.href=getContextPath()+'/front/login/login.lime';
				}
			}
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});
}

// 기존 연결 종료.
function disconnectPreLogin(obj){
	var params = 'r_userid='+$('#r_userid').val();
	if(isApp()){
		params += '&where=appajax';
	}
	
	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : '${url}/common/disconnectPreLoginAjax.lime',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				$('input[name="loginToken"]').val(data.loginToken);
				sendLogin(obj);
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}



//아이디 저장
function loginCookie(){
	var r_userid = $('input[name="r_userid"]').val();
	if($('input[name="c_saveid"]').prop('checked')){ //아이디 저장을 체크하였을때
		setCookie("fid_"+splitName, r_userid, 30); //30일동안 저장
	}
	else{
		setCookie("fid_"+splitName, r_userid, 0); //날짜를 0으로 저장하여 쿠키 삭제
	}
}

//아이디저장 체크하기
function getLogin(){
	 if (getCookie("fid_"+splitName)){
	 	var mb_id = getCookie("fid_"+splitName).split(";");
	 	
	 	mb_id += ",";
	 	if( mb_id.split(",").length > 1 ){
	 		mb_id = mb_id.split(",")[0];
	 	}
	 
	 	$('input[name="r_userid"]').val(mb_id);
	 	$('input[name="c_saveid"]').prop('checked', true);
	 	$('input[name="r_userpwd"]').focus();
	
	 }else{
		 $('input[name="r_userid"]').focus();
	 } 
}

//비밀번호 찾기 팝업
function userPswdSearchPop(){
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 615; 
		var heightPx = 435;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		// #POST# 팝업 열기.
		var popUrl = '${url}/front/common/userPswdSearchPop.lime';
		window.open('', 'userPswdSearchPop', options);
		$('form[name="searchPop"]').prop('action', popUrl);
		$('form[name="searchPop"]').submit();
	}
	else{
		// 모달팝업
		//$('#userPswdSearchPopMId').modal('show');
		var link = '${url}/front/common/userPswdSearchPop.lime?layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#userPswdSearchPopMId').modal({
			remote: link
		});
		
		// 모달팝업 height
		var heightBody = $(window).height();
		$('.modal-content').css('min-height', heightBody - 21);
	}
}

function getCookieValue(cookieNm) {
	var cookieNm = document.cookie.match('(^|[^;]+)\\s*' + cookieNm + '\\s*=\\s*([^;]+)');
	return cookieNm ? cookieNm.pop() : '';
}

$(window).on('ready load resize', function() {
	if(isApp()){
		// 자동로그인
		$('.idpw').addClass('app');
	}
});
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

function setLoginCheckbox(obj){
// 	if($(obj).is(':checked')){
// 		if('c_saveid' == $(obj).prop('name')) $('input:checkbox[name="autologinyn"]').prop('checked', false);
// 		if('autologinyn' == $(obj).prop('name')) $('input:checkbox[name="c_saveid"]').prop('checked', false);
// 	}
}

var eventPcCookie = 'eventPcCookie';

/*function closeEventPC(){
	if(	$('#eventPC').prop("checked") ==true) {
		setCookie('', 'done' , 1);
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
}*/


function closeEventBanner() {
	if(	$('#chkEventBanner').prop("checked") ==true) {
		setCookie('chkEventBanner', 'done' , 1);
	}

	$('#eorder_event_banner_pop').hide();
}

/* function closeEventPC() {
	if(	$('#chkEventPC').prop("checked") ==true) {
		setCookie('chkEventPC', 'done' , 1);
	}
	
	$('#eorder_event_pc_pop').hide();
}

function closeEventPC2() {
	if(	$('#chkEventPC2').prop("checked") ==true) {
		setCookie('chkEventPC2', 'done' , 1);
	}
	
	$('#eorder_event_pc_pop2').hide();
} */

function Mobile() {
	return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

</script>

</head>

<body class="login-wrapper">
	<!-- Wrap -->
	<div id="wrap">
	
	<%-- 비밀번호 변경페이지로 이동 --%>
	<form name="pfrm" method="post">
		<input name="resCode" type="hidden" value="" /> 
		<input name="resMsg" type="hidden" value="" />
	</form>
	
	<%-- 팝업 전송 form --%>
	<form name="searchPop" method="post" target="userPswdSearchPop">
		<input name="pop" type="hidden" value="1" />	
		<input name="p_userid" type="hidden" value="" /> 
	</form>
	
		<!-- Container Fluid -->
		<div class="container-fluid">
			<div class="login-left">
				<section class="slider1">
					<h2>새소식</h2>
					<div class="sliderArea">
						<ul id="login-slider1" class="login-slider">
							<c:forEach items="${noticeList}" var="ntList" varStatus="stat">
								<li>
									<img src="${url}/data/board/${ntList.BD_IMAGE}" width="280px" height="120px" onerror="this.src='${url}/include/images/front/login/none_img.png'" alt="img" /><!-- 280 * 120 -->
									
									<c:if test="${fn:length(ntList.BD_TITLE) >= 40}">
										<span>${fn:substring(ntList.BD_TITLE, 0, 40)}...</span>
									</c:if>
									<c:if test="${fn:length(ntList.BD_TITLE) < 40}">
										<span>${ntList.BD_TITLE}</span>
									</c:if>
								</li>
							</c:forEach>
						</ul>
					</div>
				</section>
				
				<section class="slider2">
					<h2>제품&솔루션</h2>
					<div class="sliderArea">
						<ul id="login-slider2" class="login-slider">
							<li>
								<img src="${url}/include/images/front/content/product02.jpg" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
								<span>방화방수석고보드</span>
							</li>
							<li>
								<img src="${url}/include/images/front/content/product03.jpg" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
								<span>시트락 일반석고보드</span>
							</li>
							<li>
								<img src="${url}/include/images/front/content/product01.jpg" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
								<span>시트락 일반석고보드</span>
							</li>
						</ul>
					</div>
				</section>
			</div>
			
			<div class="login-right">
				<a href="${url}" class="logo-name">
					<img src="${url}/include/images/front/common/usg_boral_logo.png" alt="logo" />
				</a>
				
				<div class="login-box">
					<div class="login-content">
						<h3>크나우프 석고보드 e-Ordering 시스템<strong>거래처 로그인</strong></h3>
						
						<form class="frm" name="frm" method="post">
							<input type="hidden" name="loginToken" id="loginToken" value="${loginToken}" />
							
							<div class="form-group form-id">
								<input type="text" name="r_userid" id="r_userid" onkeypress="if(event.keyCode == 13 && this.value){$('#r_userpwd').focus();}" class="form-control-login" value="" placeholder="아이디를 입력해 주세요" required />
							</div>
							<div class="form-group form-pw">
								<input type="password" name="r_userpwd" id="r_userpwd" onkeypress="if(event.keyCode == 13){sendLogin();}" class="form-control-login" value="" placeholder="비밀번호를 입력해 주세요" required />
							</div>
							
							<div class="idpw">
								<a href="javascript:userPswdSearchPop();" class="text-sm">비밀번호 찾기</a>
								<div class="checkbox">
									<label class="lol-label-checkbox" for="c_saveid">
										<input type="checkbox" id="c_saveid" name="c_saveid" value="Y" onchange="setLoginCheckbox(this);" />
										<span class="lol-text-checkbox">아이디저장</span>
									</label>
								</div>
								<div class="checkbox">
									<label class="lol-label-checkbox" for="autologinyn">
										<input type="checkbox" id="autologinyn" name="autologinyn" value="Y" onchange="setLoginCheckbox(this);" />
										<span class="lol-text-checkbox">자동로그인</span>
									</label>
								</div>
							</div>
							
							<button type="button" class="btn" onclick="sendLogin(this);">LOGIN</button>
						</form>
					</div>
					
					<div class="login-footer">
						<p>Copyright© 2022 KANUF. ALL RIGHTS RESERVED.</p>
						<ul>
							<li><a target="_blank" href="https://www.facebook.com/USGBoral.Korea/"><img src="${url}/include/images/front/login/sns01@2x.png" alt="image" /></a></li>
							<li><a target="_blank" href="https://www.linkedin.com/company/%ED%95%9C%EA%B5%AD-%EC%9C%A0%EC%97%90%EC%8A%A4%EC%A7%80-%EB%B3%B4%EB%9E%84-usg-boral-korea/"><img src="${url}/include/images/front/login/sns02@2x.png" alt="image" /></a></li>
							<%-- <li><a target="_blank" href="https://www.youtube.com/user/BoralPlasterboard"><img src="${url}/include/images/front/login/sns03@2x.png" alt="image" /></a></li> --%>
						</ul>
					</div>
				</div>
			</div>
			
			<div class="login-img">
				<div class="sliderArea">
					<ul id="login-slider3" class="login-slider">
						<c:forEach items="${loginBannerList}" var="bnList" varStatus="stat">
							<c:if test="${bnList.BN_LINKUSE eq 'Y'}">
								<a <c:if test="${!empty bnList.BN_LINK}">href="${bnList.BN_LINK}" target="_blank"</c:if> <c:if test="${empty bnList.BN_LINK}">href="javascript:;"</c:if> >
									<li style="background-image: url('${url}/data/banner/${bnList.BN_IMAGE}');" title="${bnList.BN_ALT}"></li><!-- 860 * 979 -->
								</a>
							</c:if>
							<c:if test="${bnList.BN_LINKUSE eq 'N'}">
									<li style="background-image: url('${url}/data/banner/${bnList.BN_IMAGE}');" title="${bnList.BN_ALT}"></li><!-- 860 * 979 -->
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</div>
			
		</div> <!-- Container Fluid -->
		
	<!-- Modal -->
	<div class="modal fade" id="userPswdSearchPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
			</div>
			<div class="modal-content">
				
			</div>
		</div>
	</div>
		
	</div> <!-- Wrap -->
	
	<!-- 
	<div  id="eorder_event_pc_pop" class="layer_greetings" style='left:50px; top:500px; width:1040px; height:435px;'> 
		<div class="bannerArea" style='width:1040px; height:400px;'>
			<img src="${url}/include/images/common/eorder_event_pc.jpg" alt="이벤트 팝업" />
		</div>
		<div class="bottom">
			<input type="checkbox" name="greetings" id="chkEventPC" />
			<label for="greetings"><span>오늘 하루 이 창을 열지 않음</span></label> 
			<a href="javascript:closeEventPC()" title="창닫기"><img id='img_event_pc' src="${url}/include/images/common/pop_close_icon.png" /></a>
		</div>
	</div>
	
	
	<div  id="eorder_event_pc_pop2" class="layer_greetings" style='left:50px; top:10px; width:450px; height:485px;'> 
		<div class="bannerArea" style='width:450px; height:450px;'>
			<img src="${url}/include/images/common/eorder_event_pc2.jpg" alt="이벤트 팝업" />
		</div>
		<div class="bottom">
			<input type="checkbox" name="greetings" id="chkEventPC2" />
			<label for="greetings"><span>오늘 하루 이 창을 열지 않음</span></label> 
			<a href="javascript:closeEventPC2()" title="창닫기"><img id='img_event_pc' src="${url}/include/images/common/pop_close_icon.png" /></a>
		</div>
	</div>
	
	<div  id="eorder_event_banner_pop" class="layer_greetings" style='width:574px; height:781px; left:20px; top:30px;'>
		<div class="bannerArea" style='width:574px; height:746px;'>
			<img src="${url}/include/images/common/eorder_event_banner.png" alt="이벤트 팝업" />
		</div>
		<div class="bottom">
			<input type="checkbox" name="greetings" id="chkEventBanner" />
			<label for="greetings"><span>오늘 하루 이 창을 열지 않음</span></label> 
			<a href="javascript:closeEventBanner()" title="창닫기"><img id='img_event_banner' src="${url}/include/images/common/pop_close_icon.png"/></a>
		</div>
	
	</div>
	 -->


</body>
</html>



