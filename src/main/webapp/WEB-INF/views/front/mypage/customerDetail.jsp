<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
$(function(){
	insertShiptoUser(); //납품처계정 자동생성
	
});

//납품처계정 자동생성
function insertShiptoUser() {
	var r_custcd = $('input[name="m_custcd"]').val();
	
	var param = 'r_custcd='+r_custcd;
	$.ajax({
		async : false,
		data : param,
		type : 'POST',
		url : '${url}/common/insertShiptoUserAjax.lime',
		success : function(data){
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
	
}


//비밀번호초기화,사용여부 업데이트
function dataUp(obj, userId, use) {
	$(obj).prop('disabled', true);
	var initpwd = ( use == '' ? 'Y' : 'N' );
	
	if (confirm('처리 하시겠습니까?')) {
		var param = 'r_initpwd='+initpwd+'&m_useruse='+use+'&ri_userid='+userId;
		$.ajax({
			async : false,
			data : param,
			type : 'POST',
			url : '${url}/front/mypage/updateUserAjax.lime',
			success : function(data){
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					//location.reload();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	} // confirm.
	else{
		$(obj).prop('disabled', false);
	}
}

//계정생성/수정 팝업.
function userAddEditPop(obj, userId, process){ //process=ADD/EDIT/VIEW
	var custcd = $('input[name="m_custcd"]').val();
	var custnm = $('input[name="m_custnm"]').val();
	
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 615;
		var heightPx = 500;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
		$('form[name="frmPop"]').find('input[name="r_userid"]').val(userId);
		$('form[name="frmPop"]').find('input[name="r_custcd"]').val(custcd);
		$('form[name="frmPop"]').find('input[name="r_custnm"]').val(custnm);
		
		// #POST# 팝업 열기.
		var popUrl = ('VIEW' == process) ? '${url}/front/mypage/user/pop/viewPop.lime' : '${url}/front/mypage/user/pop/addEditPop.lime';
		window.open('', 'userAddEditViewPop', options);
		$('form[name="frmPop"]').prop('action', popUrl);
		$('form[name="frmPop"]').submit();
	}
	else{
		// 모달팝업
		//$('#userAddEditPopMId').modal('show');
		var link = ('VIEW' == process) ? '${url}/front/mypage/user/pop/viewPop.lime?' : '${url}/front/mypage/user/pop/addEditPop.lime?';
		link += 'r_userid='+userId+'&r_custcd='+custcd+'&r_custnm='+custnm+'&layer_pop=Y&';
		
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#userAddEditPopMId').modal({
			remote: link
		});
	}
}

</script>
</head>

<body>
	<div id="subWrap" class="subWrap">
		<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
		
		<%-- 팝업 전송 form --%>
		<form name="frmPop" method="post" target="userAddEditViewPop">
			<input name="pop" type="hidden" value="1" />
			<input name="r_userid" type="hidden" value="" /> <%-- 수정시 필수 --%>
			<input name="r_custcd" type="hidden" value="" /> <%-- 등록/수정시 필수 --%>
			<input name="r_custnm" type="hidden" value="" /> <%-- 등록시 필수 --%>
		</form>
		
		<div class="container-fluid">
			<div class="full-content">
			
				<div class="row no-m">
					<div class="page-breadcrumb"><strong>회사정보</strong></div>
					
					<div class="page-location">
						<ul>
							<li><a href="#"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
							<li><a>자사정보관리</a></li>
							<li>
								<select onchange="formGetSubmit(this.value, '');">
									<option value="${url}/front/mypage/customerList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/mypage/customerList.lime')}">selected="selected"</c:if> >회사정보</option>
									<option value="${url}/front/mypage/myInformation.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/mypage/myInformation.lime')}">selected="selected"</c:if> >계정확인</option>
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
					
					<form name="frm" method="post">
						<input name="m_custcd" type="hidden" value="${param.m_custcd}" />
						<input name="m_custnm" type="hidden" value="${param.m_custnm}" />
						
						<c:set var="btnYN" value="N" />
						<c:if test="${sessionScope.loginDto.authority eq 'CO'}"><c:set var="btnYN" value="Y" /></c:if>
						
					<!-- Col-md-12 -->
					<div class="col-md-12">
						<div class="boardListArea">
							<h2 class="title">
								${param.m_custnm}
								
								<c:if test="${btnYN eq 'Y'}">
									<div class="title-right little">
										<button type="button" class="btn btn-green" onclick="userAddEditPop(this, '', 'ADD');">계정생성</button>
								<button type="button" class="btn-list" onclick="location.href='${url}/front/mypage/customerList.lime'"><img src="${url}/include/images/front/common/icon_list@2x.png" alt="img" /></button>
									</div>
								</c:if>
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="10%" />
										<col width="17%" />
										<col width="10%" />
										<col width="17%" />
										<col width="10%" />
										<col width="10%" />
										<c:if test="${btnYN eq 'Y'}"><col width="*" /></c:if>
										<col width="14%" />
									</colgroup>
									<thead>
										<tr>
											<th>거래처코드</th>
											<th>거래처명</th>
											<th>아이디</th>
											<th>담당자명</th>
											<th>휴대폰번호</th>
											<th>전화번호</th>
											<th>이메일</th>
											<c:if test="${btnYN eq 'Y'}"><th>관리</th></c:if>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${userList}" var="list" varStatus="status">
										<tr>
											<td>${list.CUST_CD}</td>
											<td class="text-left">${list.CUST_NM}</td>
											<td>${list.USERID}</td>
											<td>${list.USER_NM}</td>
											<td>${fn:replace(list.CELL_NO,'-','')}</td>
											<td>${fn:replace(list.TEL_NO,'-','')}</td>
											<td class="text-left"><p class="nowrap">${list.USER_EMAIL}</p></td>
											<c:if test="${btnYN eq 'Y'}">
											<td>
												<button type="button" class="btn btn-light-gray" onclick="dataUp(this, '${list.USERID}', '');">PW초기화</button>
												<button type="button" class="btn btn-default" onclick="userAddEditPop(this, '${list.USERID}', 'EDIT')">수정</button>
											</td>
											</c:if>
										</tr>
										</c:forEach>
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="25%" />
										<col width="35%" />
										<col width="20%" />
										<c:if test="${btnYN eq 'Y'}"><col width="*" /></c:if>
									</colgroup>
									<thead>
										<tr>
											<th>거래처코드</th>
											<th>거래처명</th>
											<th>아이디</th>
											<c:if test="${btnYN eq 'Y'}"><th>관리</th></c:if>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${userList}" var="list" varStatus="status">
											<tr>
												<td>${list.CUST_CD}</td>
												<td class="text-left">${list.CUST_NM}</td>
												<td>${list.USERID}</td>
												<c:if test="${btnYN eq 'Y'}">
												<td>
													<button type="button" class="btn btn-light-gray" onclick="dataUp(this, '${list.USERID}', '');">PW초기화</button>
													<button type="button" class="btn btn-default" onclick="userAddEditPop(this, '${list.USERID}', 'EDIT')">수정</button>
												</td>
												</c:if>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div> <!-- boardList -->
						</div> <!-- boardListArea -->
						
						<div class="boardListArea">
							<h2 class="title">
								납품처
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="10%">
										<col width="17%">
										<col width="10%">
										<col width="17%">
										<col width="10%">
										<col width="10%">
										<col width="*">
										<col width="14%">
									</colgroup>
									<thead>
										<tr>
											<th>납품처코드</th>
											<th>납품처명</th>
											<th>아이디</th>
											<th>담당자명</th>
											<th>휴대폰번호</th>
											<th>전화번호</th>
											<th>이메일</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${shiptoList}" var="list" varStatus="status">
										<tr>
											<td>${list.SHIPTO_CD}</td>
											<td class="text-left">${list.SHIPTO_NM}</td>
											<td>${list.USERID}</td>
											<td class="text-left">${list.USER_NM}</td>
											<td>${list.CELL_NO}</td>
											<td>${list.TEL_NO}</td>
											<td class="text-left"><p class="nowrap">${list.USER_EMAIL}</p></td>
											<td>
												<button type="button" class="btn btn-light-gray" onclick="dataUp(this, '${list.USERID}', '');">PW초기화</button>
												<button type="button" class="btn btn-default" onclick="userAddEditPop(this, '${list.USERID}', 'EDIT')">수정</button>
											</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="25%">
										<col width="35%">
										<col width="20%">
										<col width="20%">
									</colgroup>
									<thead>
										<tr>
											<th>납품처코드</th>
											<th>납품처명</th>
											<th>아이디</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${shiptoList}" var="list" varStatus="status">
										<tr>
											<td>${list.SHIPTO_CD}</td>
											<td class="text-left">${list.SHIPTO_NM}</td>
											<td>${list.USERID}</td>
											<td>
												<button type="button" class="btn btn-light-gray" onclick="dataUp(this, '${list.USERID}', '');">PW초기화</button>
												<button type="button" class="btn btn-default" onclick="userAddEditPop(this, '${list.USERID}', 'EDIT')">수정</button>
											</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div> <!-- boardList -->
							
						</div> <!-- boardListArea -->
						
					</div> <!-- Col-md-12 -->
					</form>
				</div> <!-- Row -->
				
			</div> <!-- Content -->
		</main> <!-- Container -->
		
		
		<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>
		
		<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
		
		<!-- Modal -->
		<div class="modal fade" id="userAddEditPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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