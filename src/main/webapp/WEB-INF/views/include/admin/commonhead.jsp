<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
<!-- <meta name="robots" content="index,follow"/> -->
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
<link rel='canonical' href='https://eordertest.knaufapac.kr/eorder/'>

<!-- scripts -->
<script src="${url}/include/js/common/jquery/jquery-2.1.4.min.js"></script>
<script src="${url}/include/js/common/jquery-ui/jquery-ui.min.js"></script>
<script src="${url}/include/js/common/jquery/jquery.form.min.js"></script>
<script src="${url}/include/js/common/jqgrid/js/i18n/grid.locale-kr.js"></script>
<script src="${url}/include/js/common/jqgrid/js/jquery.jqGrid.min.js"></script>
<script src="${url}/include/js/common/bootstrap/js/bootstrap.min.js"></script>
<script src="${url}/include/js/common/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<script src="${url}/include/js/common/uniform/jquery.uniform.min.js"></script>
<%-- <script src="${url}/include/js/common/waves/waves.min.js?1"></script> --%>
<script src="${url}/include/js/common/dropify/dropify.min.js"></script>
<script src="${url}/include/js/common/forms-upload/forms-upload.js"></script>
<script src="${url}/include/js/common/jquery-mockjax-master/jquery.mockjax.js"></script>
<script src="${url}/include/js/common/datatables/js/jquery.datatables.js"></script>
<script src="${url}/include/js/common/x-editable/bootstrap3-editable/js/bootstrap-editable.js"></script>
<script src="${url}/include/js/modern.js"></script>
<script src="${url}/include/js/common/pages/table-data.js"></script>
<script src="${url}/include/js/common/ckeditor/ckeditor.js"></script>
<%-- <script src="${url}/include/js/common/ajax/jquery.ajax-cross-origin.min.js"></script> --%>

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
<script src="${url}/include/js/lime.js?20200519"></script>
<script src="${url}/include/js/common.js"></script>
<script src="${url}/include/js/admin.js"></script>

<!-- Styles -->
<link href="${url}/include/js/common/uniform/css/uniform.default.min.css" rel="stylesheet" />
<link href="${url}/include/js/common/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/fontawesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/offcanvasmenueffects/css/menu_cornerbox.css" rel="stylesheet" type="text/css" />
<%-- <link href="${url}/include/js/common/waves/waves.min.css" rel="stylesheet" type="text/css" /> --%>
<link href="${url}/include/js/common/jqgrid/css/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="${url}/include/js/common/jquery-ui/jquery-ui.css" rel="stylesheet" type="text/css" media="screen" />

<link href="${url}/include/js/common/datatables/css/jquery.datatables.min.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/datatables/css/jquery.datatables_themeroller.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/js/common/x-editable/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" type="text/css" />

<!-- Theme Styles -->
<link href="${url}/include/css/modern.css" rel="stylesheet" type="text/css" />
<link href="${url}/include/css/themes/green.css" class="theme-color" rel="stylesheet" type="text/css" />
<link href="${url}/include/css/custom.css" rel="stylesheet" type="text/css" />


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

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lte IE 9]>
<link href="${url}/include/css/IE9.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->

<script type="text/javascript">
$(window).resize(function(){
	var bodyWidth = $('body').width();
	if (bodyWidth < 767) {
		$('body').removeClass('small-sidebar');
	}
	$('.ui-jqgrid .ui-jqgrid-bdiv').css('width', '100%');
});

$(function() {
	$('.tip-box i').bind('click', function() {
		$(this).parents().find('.basic-tip').css('display', 'none');
		$(this).next().css('display', 'inline-block');
	});
	$('.tip-box button').bind('click', function() {
		$(this).parent().css('display', 'none');
	});
});

$(function() {
	$('.show-search').bind('click', function() {
		$('.page-sidebar').removeClass('visible');
		$('.page-inner').removeClass('sidebar-visible');
	});
});

// 팝업창 닫기
function Close() {
	window.close();
}
</script>