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
	if(isApp()){
		$('#photoImgDivId').hide();
	}
});

//저장.
function dataUp(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if(confirm('저장 하시겠습니까?')){
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/front/mypage/myInformationUpdateAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					location.reload();
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			},
		});
	}else{
		$(obj).prop('disabled', false);
	}
}

//유효성 체크.
function dataValidation(){
	var ckflag = true;
	
	if(ckflag){
		if('' != $('input[name="m_userpwd"]').val()){
			if(!passWordCheck('EDIT', '0', 'm_userpwd', '')){ 
				ckflag = false; 
			}
		}
	}
	
	if(ckflag) ckflag = validation($('input[name="m_usernm"]')[0], '담당자명', 'value');
	if(ckflag) ckflag = validation($('input[name="m_cellno"]')[0], '휴대폰번호', 'value,phone');
	if(ckflag) ckflag = validation($('input[name="m_telno"]')[0], '전화번호', 'value,tel');
	if(ckflag) ckflag = validation($('input[name="m_useremail"]')[0], '이메일', 'value,email');
	
	//최조 로그인시 이용수칙 동의
	if(ckflag && '${sessionScope.loginDto.firstLogin}' == 'Y'){
		if($('#checkbox').is(":checked") == false ){
			alert('이용수칙에 동의해주세요.');
			$('input:checkbox[name="m_useragree"]').focus();
			ckflag = false; 
		}
	}
	
	return ckflag;
}

//이미지 미리보기.
function fn_previewImg(name, img, imgDiv){ //img=img ID, imgDiv=div ID
	var obj = $('input[name="'+name+'"]')[0];
	console.log('obj : ', obj);
	
	if($(obj).val() != ''){
		if(window.FileReader){
			 /*IE 9 이상에서는 FileReader  이용*/
			var reader = new FileReader();
			reader.onload = function (e) {
				document.getElementById("imgPId").style.backgroundImage = "url('"+ e.target.result +"')";
			};
			reader.readAsDataURL(obj.files[0]);
			return obj.files[0].name;  // 파일명 return
		}
		else{
			/* IE8 전용 이미지 미리보기 */
			var preImgDiv = document.getElementById(imgDiv);
			var preImg = document.getElementById(img);
			if( preImgDiv ) {
				 preImgDiv.removeChild(preImg);
			}

			obj.select();
			var src = obj.value;
			document.getElementById("imgPId").style.backgroundImage = "url('"+ e.target.result +"')";
			var afterImg = document.getElementById(imgDiv);
			afterImg.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ src + "', sizingMethod='scale')";
		}
	}
}

//이용수칙 팝업 >>> Location footer.jsp
/* 
function openTermsPop(popEndpointNm) {
	window.open('${url}/common/'+popEndpointNm+'.lime', '_blank', 'width=800, height=900');
}
*/

</script>
</head>

<body>
	<div id="subWrap" class="subWrap">
		<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
		
		<div class="container-fluid">
			<div class="full-content">
			
				<div class="row no-m">
					<div class="page-breadcrumb"><strong>나의정보</strong></div>
					
					<div class="page-location">
						<ul>
							<li><a href="#"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
							<li><a>마이페이지</a></li>
							<li>
								<select onchange="formGetSubmit(this.value, '');">
									<option value="" selected>나의정보</option>
									<option value="${url}/front/order/orderList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/orderList.lime')}">selected="selected"</c:if>>웹주문현황</option>
									<option value="${url}/front/order/salesOrderList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/order/salesOrderList.lime')}">selected="selected"</c:if>>전체주문현황</option>
<%--									<option value="${url}/front/mypage/customerList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/mypage/customerList.lime')}">selected="selected"</c:if>>회사정보</option>--%>
								</select>
							</li>
						</ul>
					</div>
				</div> <!-- Row -->
				
			</div> <!-- Full Content -->
		</div> <!-- Container Fluid -->
		
		<!-- Container -->
		<main class="container" id="container">
			<form name="frm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="process_type" value="EDIT" />
				<input type="hidden" name="pageType" value="mypage" />
		
			<!-- Content -->
			<div class="content">
			
				<!-- Row -->
				<div class="row">
					<!-- Col-md-12 -->
					<div class="col-md-12">
					
						<div class="boardViewArea">
							<h2 class="title">
								<!-- <div class="right-checkbox">
									<label class="lol-label-checkbox" for="checkbox">
										<input type="checkbox" class="lol-checkbox" id="checkbox" name="" value="" />
										<span class="lol-text-checkbox">푸시설정<p><i></i></p></span>
									</label>
								</div> -->
								<div class="title-right little">
									<button type="button" onclick="dataUp(this);" class="btn btn-green">저장</button>
								</div>
							</h2>
							
							<div class="profile">
								<p style="background-image: url('${url}/data/user/${user.USER_FILE}'), url('${url}/include/images/front/mypage/profile.jpg');" id="imgPId"></p>
 								<div class="file_input_div" id="photoImgDivId">
									<input type="file" name="m_userfile" class="file_input_hidden dropify" onchange="fn_previewImg('m_userfile', 'imgId', 'imgPId');" <c:if test="${!empty user.USER_FILE}">data-default-file="${url}/data/user/${user.USER_FILE}"</c:if> data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false"/>
									<input type="hidden" name="m_file_delyn" value="N" />
									<button type="button" class="file"><img src="${url}/include/images/front/mypage/icon_plus@2x.png" alt="img" /></button>
								</div>
							</div>
							
							<div class="tableView">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="15%">
										<col width="85%">
									</colgroup>
									<tbody>
										<tr>
											<th>성명</th>
											<td>
												<input type="text" class="form-control t-col-md-10 t-col-lg-7" onkeyup="checkByte(this, 100);" name="m_usernm" value="${user.USER_NM}" />
											</td>
										</tr>
										<tr>
											<th>ID</th>
											<td>
												${user.USERID}
												<input type="hidden" name="r_userid" value="${user.USERID}" />
											</td>
										</tr>
										<tr>
											<th>휴대폰번호<i class="icon-necessary">*</i></th>
											<td>
												<input type="text" class="form-control t-col-md-10 t-col-lg-7 marR10" name="m_cellno" onkeyup="checkByte(this, 11);" value="${user.CELL_NO}" placeholder="숫자만 입력해 주세요." />
												<c:if test="${!empty user.CELL_NO}"><span class="warning"><i class="icon-necessary">※</i>숫자만 입력해 주세요.</span></c:if>
											</td>
										</tr>
										<tr>
											<th>전화번호<i class="icon-necessary">*</i></th>
											<td>
												<input type="text" class="form-control t-col-md-10 t-col-lg-7 marR10" onkeyup="checkByte(this, 11);" name="m_telno" value="${user.TEL_NO}" placeholder="숫자만 입력해 주세요." />
												<c:if test="${!empty user.TEL_NO}"><span class="warning"><i class="icon-necessary">※</i>숫자만 입력해 주세요.</span></c:if>
											</td>
										</tr>
										<tr>
											<th>이메일<i class="icon-necessary">*</i></th>
											<td>
												<input type="text" class="form-control t-col-md-10 t-col-lg-7" name="m_useremail" onkeyup="checkByte(this, 50);" value="${user.USER_EMAIL}" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div> <!-- boardViewArea -->
						
						<div class="boardViewArea marT10">
							<h2 class="table-title">
								계정
							</h2>
							
							<div class="boardView">
								<ul>
									<li class="half">
										<label class="view-h">아이디</label>
										<div class="view-b">
											${user.USERID}
										</div>
									</li>
									<li class="half">
										<label class="view-h">비밀번호<i class="icon-necessary">*</i></label>
										<div class="view-b">
											<input type="password" class="form-control" name="m_userpwd" onkeyup="checkByte(this, 20);" value="" placeholder="8자리 이상 12자리 이하, 영문, 숫자, 특수문자 조합" />
										</div>
									</li>
								</ul>
							</div> <!-- boardView -->
							
							<h2 class="table-title">
								영업담당
							</h2>
							
							<div class="boardView">
								<ul>
									<li>
										<label class="view-h">담당자</label>
										<div class="view-b">
											${user.SALES_NM}
										</div>
									</li>
								</ul>
							</div> <!-- boardView -->
							
							<c:if test="${sessionScope.loginDto.firstLogin eq 'Y'}">
								<h2 class="table-title">
									이용수칙 동의
								</h2>
								<div class="boardView">
									<ul>
										<li>
											<label class="view-h">
												이용수칙
											</label>
											<div class="view-b">
												<button type="button" onclick="openTermsPop('termsOfServicePop');" class="terms">이용수칙 전체보기</button>
												<div class="table-checkbox">
													<label class="lol-label-checkbox" for="checkbox">
														<input type="checkbox" id="checkbox" name="m_useragree" value="Y" <c:if test="${'Y' eq user.USER_AGREE}">checked="checked"</c:if>/>
														<span class="lol-text-checkbox">이용수칙에 동의합니다.</span>
													</label>
												</div>
											</div>
										</li>
									</ul>
								</div> <!-- boardView -->
							</c:if>
							
						</div> <!-- boardViewArea -->
						
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
			</form>
		</main> <!-- Container -->
		
		
		<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>
		
		<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
		
	</div> <!-- Wrap -->

</body>
</html>