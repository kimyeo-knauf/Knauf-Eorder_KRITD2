<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="cvt" uri="/WEB-INF/tld/Converter.tld" %>
<script type="text/javascript">
$(function(){
	if(isApp()){
		// 푸시설정
		$('.lnbArea').addClass('app');
	}
});

$(document).ready(function() {
	// SUB HEADER
	var subWrap = $('#subWrap'),
		allImg = $('.site_map_btn').find('img'),
		allImgSrc = allImg.attr('src');
	if( subWrap.hasClass('subWrap') ) {
		allImg.attr('src', allImgSrc.substring(0, allImgSrc.length-4) + '_sub.png');
	} else {
		allImg.attr('src', allImgSrc);
	}
});

//로그아웃
function logout(obj){
	$(obj).prop('disabled', true);
	
	$.ajax({
		async : false,
		data : null,
		dataType : 'json',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				document.location.href = '${url}/front/login/login.lime';
			}else{
				alert("error");
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		},
		type : 'POST',
		url : '${url}/front/login/logout.lime'
	});
	$(obj).prop('disabled', false);
}

//나의정보
function myInformation(){
	formGetSubmit('${url}/front/mypage/myInformation.lime', '');
}

// Controll jquery sweetDropdown.
function clickSubMenu(obj){
	var isOpen = $(obj).hasClass('dropdown-open');
	if(isOpen){ // 열려있다면 닫아라.
		$('.trigger').sweetDropdown('hide');
		$(obj).sweetDropdown('detach');
	}else{ // 닫혀있다면 열어라.
		$(obj).sweetDropdown('attach', '#basic');
		$('.trigger').sweetDropdown('show');
		$(".site_map_btn").show();
		$(".site_map_btn_close").hide();
		$("#fullWrap").slideUp(300);
	}
}

/**
 * 품목(상품) 검색
 */
function searchItems() {

	if('' == $('input[name="rl_desc1"]').val()){
		alert('검색어를 입력해 주세요.');
		return;
	}
	formPostSubmit('sarchTotalFrm', '${url}/front/item/itemList.lime');
}

// 푸시 설정 레이어 팝업 오픈.
function openSetupModal(obj){
	$.ajax({
		async : false,
		data : null,
		dataType : 'json',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				$(document).on('hidden.bs.modal', function (e) { // bootstrap modal refresh
			       $(e.target).removeData('bs.modal');
			    });
				
				var pushData = data.userOne;
				if('Y' == toStr(pushData.USER_APPPUSHYN1)){
					$('input:checkbox[name="v_userapppushyn1"]').prop('checked', true);
				}else{
					$('input:checkbox[name="v_userapppushyn1"]').prop('checked', false);
				}
				
				if('Y' == toStr(pushData.USER_APPPUSHYN2)){
					$('input:checkbox[name="v_userapppushyn2"]').prop('checked', true);
				}else{
					$('input:checkbox[name="v_userapppushyn2"]').prop('checked', false);
				}
				
				if('Y' == toStr(pushData.USER_APPPUSHYN3)){
					$('input:checkbox[name="v_userapppushyn3"]').prop('checked', true);
				}else{
					$('input:checkbox[name="v_userapppushyn3"]').prop('checked', false);
				}
				
				$('#setupModalMId').modal('show');
			}else{
				alert("error");
			}
		},
		error : function(request,status,error){
			alert('Error');
		},
		type : 'POST',
		url : '${url}/front/base/app/getPushYNAjax.lime'
	});
}

// 개별 푸시 알림 여부 Y/N 설정.
function setPushYn(obj){
	var checkBoxName = $(obj).prop('name');
	var tobe_checked = $(obj).is(':checked');
	var now_checked = !tobe_checked;
	
	//alert('checkBoxName : '+checkBoxName+'\nnow_checked : '+now_checked+'\ntobe_checked : '+tobe_checked);
	
	var params = '';
	if('v_userapppushyn1' == checkBoxName) params += 'm_userapppushyn1='+(tobe_checked ? 'Y' : 'N');
	if('v_userapppushyn2' == checkBoxName) params += 'm_userapppushyn2='+(tobe_checked ? 'Y' : 'N');
	if('v_userapppushyn3' == checkBoxName) params += 'm_userapppushyn3='+(tobe_checked ? 'Y' : 'N');
	
	$.ajax({
		async : false,
		data : params,
		dataType : 'json',
		success : function(data) {
			if (data.RES_CODE == '0000') {
				$('input:checkbox[name="'+checkBoxName+'"]').prop('checked', tobe_checked);
			}else{
				alert("error");
			}
		},
		error : function(request,status,error){
			alert('Error');
		},
		type : 'POST',
		url : '${url}/front/base/app/updatePushYNAjax.lime'
	});
}

</script>

<div id="header">
	<div class="headerWrap">
		<div class="inner">
			<h1><img src="${url}/data/config/logo.png" alt="logo" onclick="location.href='${url}/front/index/index.lime'" onerror="this.src='${url}/include/images/front/common/usg_boral_logo.png'" /></h1>
			<ul class="lnbArea">
				<li>
					<button type="button" onclick="clickSubMenu(this);"><em>${sessionScope.loginDto.custNm} <strong>${sessionScope.loginDto.userNm}</strong><img src="${url}/include/images/front/common/arrow.png" alt="arrow" /></em></button>
					<img class="img-circle avatar" src="${url}/data/user/${sessionScope.loginDto.userFile}" onerror="this.src='${url}/include/images/front/common/img.jpg'" alt="프로필사진" onclick="myInformation();" />
					<div class="sweet-dropdown-menu dropdown-anchor-top-left dropdown-has-anchor" id="basic">
						<ul>
							<li><a href="${url}/front/order/orderList.lime">웹주문현황</a></li>
							<li><a href="${url}/front/order/salesOrderList.lime">전체주문현황</a></li>
							<%-- <li><a href="${url}/front/mypage/customerList.lime">회사정보</a></li> --%>
							<li><a href="${url}/front/mypage/myInformation.lime">나의정보</a></li>
						</ul>
					</div>
				</li>
				<li class="setup"><button type="button" onclick="openSetupModal(this);"><img src="${url}/include/images/front/common/icon_setup@2x.png" class="icn" alt="설정" /></button></li>
				<li class="cart"><button type="button" onclick="document.location.href='${url}/front/order/orderList.lime.lime?ri_statuscd=99'"><img src="${url}/include/images/front/common/icon_bag@2x.png" class="icn" alt="장바구니" /><span><fmt:formatNumber value="${cvt:toInt(orderStatus99Cnt)}" pattern="#,###" /></span></button></li>
				<li class="logout"><button type="button" onclick="logout(this);"><img src="${url}/include/images/front/common/icon_logout@2x.png" class="icn" alt="로그아웃" /></button></li>
			</ul>
		</div>
	</div> <!-- headerWrap -->
	
	<div class="gnbArea">
		<ul>
			<li>
				<a href="javascript:;" class="site_map_btn" style="display: inline-block;"><img src="${url}/include/images/front/common/total_menu_icon.png" alt="전체보기" /></a>
				<a href="javascript:;" class="site_map_btn_close" style="display: none;"><img src="${url}/include/images/front/common/total_menu_close_icon.png" alt="닫기" title="닫기" /></a>
			</li>
			<li>
				<a href="${url}/front/order/orderAdd.lime">주문등록</a>
				<a href="${url}/front/order/orderList.lime">웹주문현황</a>
				<a href="${url}/front/order/salesOrderList.lime">전체주문현황</a>
				<a href="${url}/front/report/factReport.lime">리포트</a>
				<a href="${url}/front/item/itemList.lime">품목현황</a>
				<%-- <a href="javascript:;" onclick="formPostSubmit2('${url}/front/item/itemList.lime', '');">품목현황</a> --%>
				<a href="${url}/front/promotion/promotionList.lime">프로모션</a>
				<a href="${url}/front/board/noticeList.lime">정보공유</a>
				<a href="${url}/front/board/sampleList.lime">샘플요청</a><%-- 2025-04-23 hsg E-Order 고객용 페이지 메인메뉴에 ‘샘플요청’ 매뉴 추가.정보공유와 마이페이지 중간에 위치. --%>
				<a href="${url}/front/mypage/myInformation.lime">마이페이지</a>
			</li>
			<li class="btnSearch">
				<!-- 검색바 St -->
				<!-- <a href="javascript:;" class="linkS searchbtn"><img src="/${url}/include/images/front/common/search_icon.png" alt=""/>검색</a> -->
				<div class="top_search_wrap">
				<form name="sarchTotalFrm" id="totalsearchfrm" method="post" >
					<input type="hidden" name="searchFormHeader" id="searchtype" value="Y">
					<div class="search_layer">
						<input type="text" name="rl_desc1" id="earchkey" class="inp" placeholder="검색어를 입력하세요" value="" onkeypress="if(event.keyCode == 13){searchItems();}" maxlength="50" />
						<%-- text 하나 일 때 폼 서브밋 방지용 --%>
						<input type="texte" name="stopSubmitting" style="display: none;">
						<button type="button" class="search_btn" onclick="searchItems()"><img src="${url}/include/images/front/common/search_icon.png" /></button>
					</div>
				</form>
				</div>
				<!-- //검색바 En -->
			</li>
		</ul>
	</div> <!-- gnbArea -->
	
	
	<!-- 전체보기 St-->
	<div class="fullWrapOut" id="fullWrap">
	
		<div class="fullWrap" >
			<ul>
				
				<li class="out total_01">
					<p>웹주문현황</p>
					<ul>
						<li><a href="${url}/front/order/orderAdd.lime">주문등록</a></li>
						<li><a href="${url}/front/order/orderList.lime">웹주문현황</a></li>
						<li><a href="${url}/front/order/salesOrderMainList.lime">거래내역(주문)</a></li>
						<li><a href="${url}/front/order/salesOrderItemList.lime">거래내역(품목)</a></li>
					</ul>
				</li>
				<li class="out total_02">
					<p>전체주문현황</p>
					<ul>
						<li><a href="${url}/front/order/salesOrderList.lime">전체주문현황</a></li>
						<li><a href="${url}/front/order/qmsOrderList.lime">QMS 조회 및 등록</a></li>
					</ul>
				</li>
				<li class="out total_03">
					<p>리포트</p>
					<ul>
						<li><a href="${url}/front/report/factReport.lime">거래사실확인서</a></li>
						<li><a href="${url}/front/report/deliveryReport.lime">납품확인서</a></li>
					</ul>
				</li>
				<li class="out total_04">
					<p>품목현황</p>
					<ul>
						<li><a href="${url}/front/item/itemList.lime">품목현황</a></li>
					</ul>
				</li>
				<li class="out total_05">
					<p>프로모션</p>
					<ul>
						<li><a href="${url}/front/promotion/promotionList.lime" >이벤트</a></li>
					</ul>
				</li>
				<li class="out last total_06">
					<p>정보공유</p>
					<ul>
						<li><a href="${url}/front/board/noticeList.lime">공지사항</a></li>
						<li><a href="${url}/front/board/faqList.lime">FAQ</a></li>
						<li><a href="${url}/front/board/referenceList.lime">자료실</a></li>
						<li><a href="${url}/front/board/sampleList.lime">샘플요청</a></li>
						<li><a href="${url}/front/board/chatList.lime">게시글 등록</a></li>
					</ul>
				</li>
				<%-- 
				<li class="out total_07">
					<p>자사정보관리</p>
					<ul>
						<li><a href="${url}/front/mypage/customerList.lime">회사정보</a></li>
						<li><a href="${url}/front/mypage/myInformation.lime">계정확인</a></li>
					</ul>
				</li>
				--%>
			</ul>
		</div>
		
		<div class="fullWrapM" >
			<span>
				<button type="button" onclick="javascript:myInformation();">${sessionScope.loginDto.custNm}<strong>${sessionScope.loginDto.userNm}</strong><img class="img-circle avatar" src="${url}/data/user/${sessionScope.loginDto.userFile}" onerror="this.src='${url}/include/images/front/common/img.jpg'" alt="프로필사진" /><img src="${url}/include/images/front/common/arrow_right.png" alt="arrow" /></button>
			</span>
			<span>
				<a href="${url}/front/order/orderAdd.lime">주문등록</a>
				<a href="${url}/front/order/orderList.lime">웹주문현황</a>
				<a href="${url}/front/order/salesOrderList.lime">전체주문현황</a>
				<a href="${url}/front/report/factReport.lime">리포트</a>
				<a href="${url}/front/item/itemList.lime">품목현황</a>
				<a href="${url}/front/promotion/promotionList.lime" >프로모션</a>
				<a href="${url}/front/board/noticeList.lime">정보공유</a>
				<a href="${url}/front/board/sampleList.lime">샘플요청</a><%-- 2025-04-23 hsg E-Order 고객용 페이지 메인메뉴에 ‘샘플요청’ 매뉴 추가.정보공유와 마이페이지 중간에 위치. --%>
				<a href="${url}/front/mypage/myInformation.lime">마이페이지</a>
			</span>
		</div>
		
	</div>
	<!-- //전체보기 En-->
</div>

<!-- Modal -->
<div class="modal fade" id="setupModalMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		</div>
		<div class="modal-content">
		
			<!-- Wrap -->
			<div id="wrap" class="popup-wrapper">
				
				<!-- Container Fluid -->
				<div class="container-fluid">
				
					<div class="panel-title">
						<h2>
							알림설정
						</h2>
					</div>
					
					<div class="boardView setupTable">
						<ul>
							<li>
								<div class="view-b right-checkbox">
									<label class="lol-label-checkbox" for="checkbox1">
										<input type="checkbox" class="lol-checkbox" id="checkbox1" name="v_userapppushyn1" onclick="setPushYn(this);" />
										<span class="lol-text-checkbox">주문확정 알림<p><i></i></p></span>
									</label>
								</div>
							</li>
							<li>
								<div class="view-b right-checkbox">
									<label class="lol-label-checkbox" for="checkbox2">
										<input type="checkbox" class="lol-checkbox" id="checkbox2" name="v_userapppushyn2" onclick="setPushYn(this);" />
										<span class="lol-text-checkbox">배차완료 알림<p><i></i></p></span>
									</label>
								</div>
							</li>
							<li>
								<div class="view-b right-checkbox">
									<label class="lol-label-checkbox" for="checkbox3">
										<input type="checkbox" class="lol-checkbox" id="checkbox3" name="v_userapppushyn3" onclick="setPushYn(this);" />
										<span class="lol-text-checkbox">이벤트 알림<p><i></i></p></span>
									</label>
								</div>
							</li>
						</ul>
					</div>
				</div> <!-- Container Fluid -->
			
			</div> <!-- Wrap -->
		</div>
	</div>
</div>