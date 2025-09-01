<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>

<script type="text/javascript">
$(function(){
	$('#detailData').hide();
	$('#detailData2').hide();
});

//거래처계정 리스트
function getUserList(){
	$('#detailData').show();
	$('#detailData2').hide();
	
	$.ajax({
		async : false,
		data : {
			r_custcd : $('input[name="m_custcd"]').val(),
			r_authority : 'CO'
		},
		type : 'POST',
		url : '${url}/front/mypage/getCoUserListAjax.lime',
		success : function(data) {
			var htmlText = '';
			var mhtmlText = '';
			$(data.list).each(function(i,e){
				// PC.
				htmlText += '<tr>';
				htmlText += '<td>'+ (i+1) +'</td>';
				htmlText += '<td>'+ e.USER_USE +'</td>';
				htmlText += '<td>'+ e.USERID +'</td>';
				htmlText += '<td>'+ e.USER_NM +'</td>';
				htmlText += '<td>'+ toStr(e.TEL_NO).replaceAll('-', '') +'</td>';
				htmlText += '<td>'+ toStr(e.CELL_NO).replaceAll('-', '') +'</td>';
				htmlText += '<td class="text-left">'+ toStr(e.USER_EMAIL) +'</td>';
				htmlText += '<td>'+ toStr(e.INDATE).substring(0,10) +'</td>';
				htmlText += '</tr>';

				// 모바일.
				mhtmlText += '<tr>';
				mhtmlText += '<td>'+ (i+1) +'</td>';
				mhtmlText += '<td>'+ e.USER_USE +'</td>';
				mhtmlText += '<td>'+ e.USERID +'</td>';
				mhtmlText += '<td>'+ e.USER_NM +'</td>';
				mhtmlText += '</tr>';
			});
			$('#userTbody').html(htmlText);
			$('#userMobileTbody').html(mhtmlText);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

//납품처계정 리스트
function getShiptoList(){
	$('#detailData2').show();
	$('#detailData').hide();
	
	$.ajax({
		async : false,
		data : {
			r_custcd : $('input[name="m_custcd"]').val(),
			where : 'mypage',
			r_stbuserid : $('input[name="userId"]').val()
		},
		type : 'POST',
		url : '${url}/front/mypage/getShipToListAjax.lime',
		success : function(data) {
			var htmlText = '';
			var mhtmlText = '';
			$(data.list).each(function(i,e){
				// PC.
				htmlText += '<tr>';
				htmlText += '<td>'+ (i+1) +'</td>';
				htmlText += '<td>'+ e.SHIPTO_CD +'</td>';
				htmlText += '<td class="text-left">'+ e.SHIPTO_NM +'</td>';
				// htmlText += '<td class="text-left">'+ toStr(e.ZIP_CD)+' '+toStr(e.ADD1)+' '+toStr(e.ADD2)+' '+toStr(e.ADD3)+' '+toStr(e.ADD4)+'</td>';
				htmlText += '<td class="text-left">'+ toStr(e.ZIP_CD)+' '+toStr(e.ADD1)+' '+toStr(e.ADD2)+'</td>';

				if(toStr(e.STB_SHIPTOCD) == ''){ img = '<img src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" />';}
				else{img = '<img src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" />';}
				
				htmlText += '<td><button type="button" onclick=\'setBookmarkAjax(this, "'+e.SHIPTO_CD+'");\'>'+ img +'</button></td>';
				htmlText += '</tr>';

				// 모바일.
				mhtmlText += '<tr>';
				mhtmlText += '<td>'+ (i+1) +'</td>';
				mhtmlText += '<td class="text-left">'+ e.SHIPTO_NM +'</td>';
				// mhtmlText += '<td class="text-left">'+ toStr(e.ZIP_CD)+' '+toStr(e.ADD1)+' '+toStr(e.ADD2)+' '+toStr(e.ADD3)+' '+toStr(e.ADD4)+'</td>';
				mhtmlText += '<td class="text-left">'+ toStr(e.ZIP_CD)+' '+toStr(e.ADD1)+' '+toStr(e.ADD2)+'</td>';

				if(toStr(e.STB_SHIPTOCD) == ''){ img = '<img src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" />';}
				else{img = '<img src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" />';}
				
				mhtmlText += '<td><button type="button" onclick=\'setBookmarkAjax(this, "'+e.SHIPTO_CD+'");\'>'+ img +'</button></td>';
				mhtmlText += '</tr>';
			});
			$('#shiptoTbody').html(htmlText);
			$('#shiptoMobileTbody').html(mhtmlText);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

//계정관리 사용 X  수정일 : 2020. 05. 18.
/*
function customerDetail(){
	formPostSubmit('frm', '${url}/front/mypage/customerDetail.lime');
}
*/


//즐겨찾기 추가/삭제
function setBookmarkAjax(obj, r_shiptocd){
	$(obj).prop('disabled', true);
	$.ajax({
		async : false,
		data : {
			r_stbshiptocd : r_shiptocd
		},
		type : 'POST',
		url : '${url}/front/base/setShiptoBookmarkAjax.lime',
		success : function(data) {
			if(data.inCnt > 0){
				$(obj).html('<img src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" />');
			}else{
				$(obj).html('<img src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" />');
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});
}


</script>
</head>

<body>
	<div id="subWrap" class="subWrap">
		<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
		
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
									<option value="${url}/front/mypage/myInformation.lime">계정확인</option>
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
						<input type="hidden" name="m_custcd" value="${customer.CUST_CD}" />
						<input type="hidden" name="m_custnm" value="${customer.CUST_NM}" />
						<input type="hidden" name="userId" value="${sessionScope.loginDto.userId}" />
						
					<!-- Col-md-12 -->
					<div class="col-md-12">
					
						<div class="boardListArea">
							<h2 class="title">
								자사정보
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="5%" />
										<col width="15%" />
										<col width="10%" />
										<col width="10%" />
										<col width="8%" />
										<col width="10%" />
										<col width="22%" />
										<col width="10%" />
<%--										<col width="10%" />--%>
									</colgroup>
									<thead>
										<tr>
											<th>코드</th>
											<th>거래처명</th>
											<th>거래처 계정</th>
											<th>영업담당</th>
											<th>납품처</th>
											<th>납품처 계정</th>
											<th>거래처 주소</th>
											<th>등록일</th>
<%--											<th>계정관리</th>--%>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>${customer.CUST_CD}</td>
											<td class="text-left">${customer.CUST_NM}</td>
											<td><a href="javascript:getUserList();" class="dataBtn">${customer.CUSTOMER_USER_CNT}</a></td>
											<td>${customer.AUTHORITY}${customer.USER_NM}</td>
											<td><a href="javascript:getShiptoList();" class="dataBtn2">${customer.SHIPTO_CNT}</a></td>
											<td>${customer.SHIPTO_USER_CNT}</td>
											<td class="text-left">${customer.ZIP_CD} ${customer.ADD1} ${customer.ADD2}</td>
											<td>
												<c:if test="${!empty customer.INSERT_DT}">
													${fn:substring(customer.INSERT_DT,0,4)}-${fn:substring(customer.INSERT_DT,4,6)}-${fn:substring(customer.INSERT_DT,6,8)}
												</c:if>
											</td>
<%--											<td><button type="button" class="btn btn-gray" onclick="customerDetail();">계정관리</button></td>--%>
										</tr>
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="35%" />
										<col width="23%" />
										<col width="17%" />
<%--										<col width="25%" />--%>
									</colgroup>
									<thead>
										<tr>
											<th>거래처명</th>
											<th>거래처 계정</th>
											<th>납품처</th>
<%--											<th>계정관리</th>--%>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="text-left">${customer.CUST_NM}</td>
											<td><a href="javascript:getUserList();" class="dataBtn">${customer.CUSTOMER_USER_CNT}</a></td>
											<td><a href="javascript:getShiptoList();" class="dataBtn2">${customer.SHIPTO_CNT}</a></td>
<%--											<td><button type="button" class="btn btn-gray" onclick="customerDetail();">계정관리</button></td>--%>
										</tr>
									</tbody>
								</table>
							</div> <!-- boardList -->
						</div> <!-- boardListArea -->
						
						<div class="boardListArea" id="detailData">
							<h2 class="title">
								거래처 계정
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="5%" />
										<col width="10%" />
										<col width="10%" />
										<col width="*" />
										<col width="15%" />
										<col width="15%" />
										<col width="18%" />
										<col width="10%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>사용여부</th>
											<th>ID</th>
											<th>담당자</th>
											<th>전화번호</th>
											<th>휴대폰번호</th>
											<th>이메일</th>
											<th>등록일</th>
										</tr>
									</thead>
									<tbody id="userTbody">
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="10%" />
										<col width="20%" />
										<col width="35%" />
										<col width="35%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>사용여부</th>
											<th>ID</th>
											<th>담당자</th>
										</tr>
									</thead>
									<tbody id="userMobileTbody">
									</tbody>
								</table>
							</div> <!-- boardList -->
						</div> <!-- boardListArea -->
						
						<div class="boardListArea" id="detailData2">
							<h2 class="title">
								납품처
							</h2>
							
							<div class="boardList">
								<!-- desktop -->
								<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="7%" />
										<col width="15%" />
										<col width="25%" />
										<col width="*" />
										<col width="10%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>납품처코드</th>
											<th>납품처명</th>
											<th>주소</th>
											<th>즐겨찾기</th>
										</tr>
									</thead>
									<tbody id="shiptoTbody">
									</tbody>
								</table>
								
								<!-- mobile -->
								<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="8%" />
										<col width="30%" />
										<col width="40%" />
										<col width="22%" />
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>납품처명</th>
											<th>주소</th>
											<th>즐겨찾기</th>
										</tr>
									</thead>
									<tbody id="shiptoMobileTbody">
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
		
	</div> <!-- Wrap -->

</body>
</html>