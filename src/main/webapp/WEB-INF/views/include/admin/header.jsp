<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	headerInfoAjax();
});

//로그아웃
function logout(){
	$.ajax({
		async : false,
		data : null,
		dataType : 'json',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				document.location.href = '${url}/admin/login/login.lime';
			}else{
				alert("error");
			}
		},
		error : function(request,status,error){
			alert('Error');
		},
		type : 'POST',
		url : '${url}/admin/login/logout.lime'
	});
}

function sendSearch() {
	/* 
	if (!$('#psword1').val()) {
		alert('검색어를 입력하여 주십시오.');
		$('#psword1').focus();
		return false;
	} else {
		document.sForm.submit();
	}
	*/
}

function sendSearch2() {
	
	if (!$('#psword2').val()) {
		alert('검색어를 입력하여 주십시오.');
		$('#psword2').focus();
		return false;
	} else {
		document.frmHeaderSearch.submit();
	}
}

// 메뉴닫기 쿠키저장
function menuBtn(){
	/* 
	if ($('body').hasClass('small-sidebar')) {
		setCookie("mnBtn", 'Y', 1);
    }else{
    	setCookie("mnBtn", 'N', 1);
    }
	*/
}

function headerInfoAjax(){
	/* 
	$.ajax({
		async : false,
		data : null,
		dataType : 'json',
		success : function(data) {
			$('#basketCountSpan').html(data.basketCount); //장바구니 갯수
		},
		type : 'POST',
		url : '${url}/admin/index/headerInfoAjax.lime'
	});
	*/
}
</script>

<form class="search-form" method="get" name="frmHeaderSearch" action="${url}/admin/base/productSearchList.lime">
	<div class="input-group">
		<input type="text" name="rl_psword" id="psword2" class="form-control search-input" placeholder="Search..." onkeypress="if(event.keyCode == 13){sendSearch2(); return false;}" />
		<span class="input-group-btn">
			<button type="button" class="btn btn-default close-search waves-effect waves-button waves-classic"><i class="fa fa-times"></i></button>
		</span>
	</div><!-- Input Group -->
</form><!-- Search Form -->

<!-- Navbar -->
<div class="navbar">
	<div class="navbar-inner">
		<div class="sidebar-pusher">
			<a href="javascript:void(0);" class="waves-effect waves-button waves-classic push-sidebar">
				<i class="fa fa-bars"></i>
			</a>
		</div>
		
		<!-- Logo Box -->
		<form action="${url}/admin/base/productSearchList.lime" method="get" name="sForm">
		<div class="logo-box">
			<%-- <div class="search-box">
				<input type="text" name="rl_psword" id="psword1" class="form-control" placeholder="" onkeypress="if(event.keyCode == 13){sendSearch(); return false;}" />
				<a href="javascript:sendSearch();" class="waves-effect waves-button waves-classic btn-search"><i class="fa fa-search"></i></a>
			</div>
			<a href="#" class="waves-effect waves-button waves-classic show-search"><i class="fa fa-search"></i></a> --%>

			<a href="${url}" class="logo"><img src="${url}/data/config/logo.png" alt="logo" /></a>

		</div>
		</form>
		<!-- //Logo Box -->
		
		<div class="logout-button">
			<a href="javascript:logout();" class="waves-effect waves-button waves-classic"><i class="fa fa-sign-out"></i></a>
		</div>
		<div class="topmenu-outer">
			<!-- //Top Menu -->
			<div class="top-menu">
				<!-- Nav -->
				<ul class="nav navbar-nav navbar-left">
					<li>
						<a href="javascript:menuBtn();" class="waves-effect waves-button waves-classic sidebar-toggle"><i class="fa fa-bars"></i></a>
					</li>
					<li>
						<a href="${url}/admin/index/index.lime" class="logo"><img src="${url}/data/config/logo.png" alt="logo" /></a>
					</li>
				</ul>
				<!-- //Nav -->
				
				<!-- Nav -->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown m-l-md">
						<a href="#" class="dropdown-toggle waves-effect waves-button waves-classic" data-toggle="dropdown">
							<span class="user-name">${sessionScope.loginDto.userNm}<i class="fa fa-angle-down"></i></span>
							<img class="img-circle avatar" src="${url}/data/user/${sessionScope.loginDto.userFile}" width="32" height="32" alt="" onerror="this.src='${url}/include/images/admin/img.jpg'" />
						</a>
						<ul class="dropdown-menu dropdown-list" role="menu">
							<li role="presentation"><a href="${url}/admin/mypage/myInformationView.lime"><i class="fa fa-user"></i>나의정보</a></li>
							<li role="presentation"><a href="${url}/admin/mypage/csSalesUserList.lime"><i class="fa fa-sitemap"></i>조직설정</a></li>
							<li role="presentation"><a href="javascript:logout();"><i class="fa fa-sign-out m-r-xs"></i>Logout</a></li>
						</ul>
					</li>
					<li>
						<a href="javascript:logout();" class="log-out waves-effect waves-button waves-classic">
							<span class="f-s-18"><i class="fa fa-sign-out"></i></span>
						</a>
					</li>
				</ul>
				<!-- //Nav -->
			</div>
			<!-- //Top Menu -->
		</div>
	</div>
</div>
<!-- //Navbar -->