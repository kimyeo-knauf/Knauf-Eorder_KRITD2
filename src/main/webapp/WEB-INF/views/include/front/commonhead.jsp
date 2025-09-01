<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>

<meta name="keywords" content="크나우프, 이오더링">
<meta name="title" content="neweorder.knaufapac.kr">
<meta name="description" content="크나우프 석고보드 이오더링 시스템입니다.">

<meta property='og:title' content='neweorder.knaufapac.kr' />
<meta property='og:url' content='https://neweorder.knaufapac.kr/eorder/' />   
<meta property='og:image' content='https://neweorder.knaufapac.kr/eorder/include/images/common/usg_boral_logo.png' />
<meta property='og:description' content='크나우프 석고보드 이오더링 시스템입니다.' />

<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<title><c:if test="${empty sessionScope.BROWSERTITLE}">neweorder.knaufapac.kr</c:if>${sessionScope.BROWSERTITLE}</title>
<link rel="shortcut icon" href="${url}/data/config/favicon.ico" type="image/x-icon" /><!-- 파비콘 -->

<link rel="shortcut icon" href="${url}/include/images/common/icon1.png" type="image/x-icon" />
<link rel="apple-touch-icon" href="${url}/include/images/common/icon2.png" type="image/x-icon" />

<!-- scripts -->
<script src="${url}/include/js/common/jquery/jquery-2.1.4.min.js"></script>
<script src="${url}/include/js/common/jquery-ui/jquery-ui.min.js"></script>
<script src="${url}/include/js/common/jquery/jquery.form.min.js"></script>
<script src="${url}/include/js/common/jquery-confirm/jquery-confirm.js"></script>
<%-- <script src="${url}/include/js/common/ajax/jquery.ajax-cross-origin.min.js"></script> --%>

<script src="${url}/include/js/front/jquery.sweet-dropdown.min.js"></script> <!-- HEADER MYPAGE -->
<script src="${url}/include/js/front/lightslider.js"></script> <!-- BANNER -->
<script src="${url}/include/js/front/tabcontent.js"></script> <!-- TAB -->

<script src="${url}/include/js/common/bootstrap/js/bootstrap.js?202007082"></script><!-- modal -->
<script src="${url}/include/js/common/bootstrap-datepicker/js/bootstrap-datepicker.js"></script><!-- datepicker -->
<script src="${url}/include/js/common/bootstrap-datepicker/js/locales/bootstrap-datepicker.kr.js"></script><!-- datepicker locale kr -->
<script src="${url}/include/js/common/bootstrap-datetimepicker/js/moment.min.js"></script>
<script src="${url}/include/js/common/bootstrap-datetimepicker/js/moment-locale-ko.js"></script>
<link href="${url}/include/js/common/bootstrap-datepicker/css/datepicker.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/bootstrap-datepicker/css/datepicker3.css" rel="stylesheet" type="text/css" />

<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="${url}/include/js/common/ckeditor/ckeditor.js"></script>
<script src="${url}/include/js/common/autoNumeric/autoNumeric.js"></script>
<script src="${url}/include/js/common/bignumber/bignumber.js"></script>
<script src="${url}/include/js/lime.js?202007082"></script>
<script src="${url}/include/js/common.js?202007082"></script>
<script src="${url}/include/js/front.js?202007082"></script>
<script src="${url}/include/js/placeholders.min.js"></script>
<script src="${url}/include/js/common/dropify/dropify.min.js"></script>

<!-- css -->
<link href="${url}/include/css/front/bootstrap.css?202007082" rel="stylesheet" type="text/css" />
<link href="${url}/include/css/front/style.css?20240411" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/jquery-confirm/css/jquery-confirm.css" rel="stylesheet" type="text/css" />


<!-- Start. Responsive jQuery DateTime Picker -->
<!-- Ref. Contributors : https://github.com/nehakadam/DateTimePicker/contributors -->
<!-- Ref. Repository : https://github.com/nehakadam/DateTimePicker -->
<!-- Ref. Documentation : https://nehakadam.github.io/DateTimePicker -->
<!-- Ref. https://www.jqueryscript.net/time-clock/Responsive-User-friendly-Datetime-Picker-jQuery-DateTimePicker.html -->
<script src="${url}/include/js/common/jquery-datetimepicker/js/DateTimePicker.js"></script>
<script src="${url}/include/js/common/jquery-datetimepicker/js/i18n/DateTimePicker-i18n.js"></script>
<script src="${url}/include/js/common/jquery-datetimepicker/js/i18n/DateTimePicker-i18n-ko.js"></script>
<link href="${url}/include/js/common/jquery-datetimepicker/css/DateTimePicker.css" rel="stylesheet" type="text/css" />
<!-- End. -->

<!--[if lt IE 9]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE8.js"></script>
<![endif]-->
<!--[if lt IE 7]>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE7.js"></script>
<![endif]-->


<script type="text/javascript">
//### Set PUSH Start. ###
var pushid;
var repeat;
$(document).ready(function() {
	// 푸시 키 가져와서 세팅.(로그인 페이지 제외) / 앱에서만 실행.
	if(isApp()){
		var nUrl = window.location.href;
		if(-1 == nUrl.indexOf('/login/login.lime')){
			document.location = '#location_get';
			
			pushid = toStr('${sessionScope.loginDto.userPushId}');
			if('' == pushid){
				var pJson = {"action": "getpushid", "callback": "get_pushid"};
				setTimeout(function(){
					webkit.messageHandlers.cordova_iab.postMessage(JSON.stringify(pJson)); // function get_pushid
				}, 1000);
				//webkit.messageHandlers.cordova_iab.postMessage(JSON.stringify(pJson)); // function get_pushid
			}
			else{
				setPushId(); // 푸시키 저장 및 세션세팅.
			}
		}
	} // End.
});

// 앱링크 : 푸시키를 얻기위한.
function get_pushid(push_id) {
	//alert('push_id : '+push_id);
	pushid = push_id;
	setPushId();
}

// 푸시키 저장 및 세션세팅.
function setPushId(){
	// 푸시키 저장 및 세션세팅.
	$.ajax({
		async : false,
		data : {pushid : pushid}, // 전역변수.
		type : 'POST',
		url : '${url}/front/base/app/setPushIdAjax.lime',
		success : function(data){
			if('0000' == data.RES_CODE){
				
			}else{
				
			}
		}
	});
}
//### Set PUSH End. ###

// HEADER ALL MENU
$(document).on("click",".site_map_btn",function() {
	$(this).hide();
	$(".site_map_btn_close").show();
	$("#fullWrap").slideToggle(300);
	$("#fullWrap").toggleClass("on");
});

$(document).on("click",function(e) {
	var target = $(e.target);
	var chkSearch = target.parents(".site_map_btn").length;
	if(chkSearch == 0) {
		$(".site_map_btn").show();
		$(".site_map_btn_close").hide();
		$("#fullWrap").removeClass("on");
		$("#fullWrap").slideUp(300);
	}
});

//HEADER SEARCH
function searchlist() {
	if(!$("#searchkey").val()) {
		alert('검색어를 입력 해 주십시오.');
		return false;
	}
	$("#totalsearchfrm").submit();
}
function searchlist2(acturl, searchtype) {
	if(!$("#searchkey2").val()) {
		alert('검색어를 입력 해 주십시오.');
		return false;
	}
	$("#searchkey").val($("#searchkey2").val());
	$("#searchtype").val(searchtype);
	$("#totalsearchfrm").attr("action", acturl);
	$("#totalsearchfrm").submit();
}

// HEADER FIXING
$(window).scroll(function() {
	if($(window).scrollTop() >= 186) {
		$('#header .gnbArea').addClass('fixed-header');
		$('#header .fullWrapOut').addClass('fixed-header-sub');
		$('#header .fullWrapM').addClass('fixed-header-mobile');
	} else if($(window).scrollTop() >= 62) {
		$('#subWrap .gnbArea').addClass('fixed-header');
		$('#subWrap .fullWrapOut').addClass('fixed-header-sub');
		$('#subWrap .fullWrapM').addClass('fixed-header-mobile');
	} else {
		$('#header .gnbArea').removeClass('fixed-header');
		$('#header .fullWrapOut').removeClass('fixed-header-sub');
		$('#header .fullWrapM').removeClass('fixed-header-mobile');
	}
});

$(document).ready(function() {
	// BANNER
	$("#content-slider").lightSlider({
		auto:true,
		loop:true,
		keyPress:true
	});
	
	$(".mask").hover(function() {
		$(this).parent().find('.maskSpanClass').toggleClass("pad");
	});

	// FOOTER SELECT
	$('.select').on('click','.placeholder',function() {
		var parent = $(this).closest('.select');
		if( ! parent.hasClass('is-open')) {
			parent.addClass('is-open');
		$('.select.is-open').not(parent).removeClass('is-open');
		} else {
			parent.removeClass('is-open');
		}
	}).on('click','ul>li',function() {
		var parent = $(this).closest('.select');
		parent.removeClass('is-open').find('.placeholder').text( $(this).text() );
	});

	// hide .topbtn first
	$(".topbtn").hide();

	// fade in .topbtn
	$(function () {
		$(window).scroll(function () {
			if ($(this).scrollTop() > 100) {
				$('.topbtn').fadeIn();
			} else {
				$('.topbtn').fadeOut();
			}
		});

		// scroll body to 0px on click
		$('.topbtn a').click(function () {
			$('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});
	});
});

// 팝업창 닫기
function Close() {
	window.close();
}

$(window).on('ready load resize', function() {
	if(isApp()){
		// 모달팝업 height
		var widthBody = $(window).width(),
			heightBody = $(window).height();
		if(widthBody < 768) {
			$('.modal-content').css('min-height', heightBody - 21);
		}
		// inner height (footer)
		$('.service .inner').css('height', heightBody - 133);
	}
});
</script>
