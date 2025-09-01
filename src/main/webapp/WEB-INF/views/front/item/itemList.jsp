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
	var searchFormHeader= '${param.searchFormHeader}'; //Y : header에서 검색
	if('Y' == toStr('${param.r_detailsearch}') || 'Y' == searchFormHeader){
		fn_spread('hiddenContent02');
	}
	
	categorySelect('1', '${param.r_salescd1nm}');
	if('' != '${param.r_salescd1nm}'){
		categorySelect('2', '${param.r_salescd2nm}');
		if('' != '${param.r_salescd2nm}'){
			categorySelect('3', '${param.r_salescd3nm}');
			if('' != '${param.r_salescd3nm}'){
				categorySelect('4', '${param.r_salescd4nm}');
			}
		}
	}
});

$(document).ready(function() {
	if(isApp()){
		$('#excelDownBtnId').hide();
	}	
});

// 페이지이동.
/* 
function tabChange(val){
	document.location.href = val;
}
*/

function gridCheckBoxClicked(id) {
	console.log("Checkbox : " + id);
}


// 카테고리 세팅.
function categorySelect(ct_level, select_val) {
	var r_salescd1nm = $('select[name="r_salescd1nm"] option:selected').val();
	var r_salescd2nm = $('select[name="r_salescd2nm"] option:selected').val();
	var r_salescd3nm = $('select[name="r_salescd3nm"] option:selected').val();
	//var r_salescd4nm = $('select[name="r_salescd4nm"] option:selected').val();
	
	var params = 'r_ctlevel='+ct_level+'&';
	if('2' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&';
	if('3' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&';
	if('4' == ct_level) params += 'r_salescd1nm='+r_salescd1nm+'&r_salescd2nm='+r_salescd2nm+'&r_salescd3nm='+r_salescd3nm+'&';
	
	$.ajax({
		async : false,
		data : params,
		type : 'POST',
		url : '${url}/front/base/getCategoryListAjax.lime',
		success : function(data) {
			var htmlText = '<option value="">선택하세요.</option>';
			var selected = '';
			
			if('1' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				$('select[name="r_salescd2nm"]').empty();
				$('select[name="r_salescd2nm"]').append(htmlText);
				
				$('select[name="r_salescd1nm"]').empty();
				$(data).each(function(i,e){
					selected = '';
					if(e.CATEGORY_NAME == select_val) selected = 'selected="selected"';
					
					htmlText += '<option value="'+e.CATEGORY_NAME+'" '+selected+'>'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd1nm"]').append(htmlText);
			}
			if('2' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				$('select[name="r_salescd3nm"]').empty();
				$('select[name="r_salescd3nm"]').append(htmlText);
				
				$('select[name="r_salescd2nm"]').empty();
				$(data).each(function(i,e){
					selected = '';
					if(e.CATEGORY_NAME == select_val) selected = 'selected="selected"';
					
					htmlText += '<option value="'+e.CATEGORY_NAME+'" '+selected+'>'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd2nm"]').append(htmlText);
			}
			if('3' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				$('select[name="r_salescd4nm"]').append(htmlText);
				
				$('select[name="r_salescd3nm"]').empty();
				$(data).each(function(i,e){
					selected = '';
					if(e.CATEGORY_NAME == select_val) selected = 'selected="selected"';
					
					htmlText += '<option value="'+e.CATEGORY_NAME+'" '+selected+'>'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd3nm"]').append(htmlText);
			}
			if('4' == ct_level){
				$('select[name="r_salescd4nm"]').empty();
				
				$('select[name="r_salescd4nm"]').empty();
				$(data).each(function(i,e){
					selected = '';
					if(e.CATEGORY_NAME == select_val) selected = 'selected="selected"';
					
					htmlText += '<option value="'+e.CATEGORY_NAME+'" '+selected+'>'+e.CATEGORY_NAME+'</option>';
				});
				$('select[name="r_salescd4nm"]').append(htmlText);
			}
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

// 즐겨찾기 추가/삭제.
function setBookmark(obj, proc_type){
	$(obj).prop('disabled', true);
	
	var div = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	var itemCdObj = $('input:checkbox[name="r_'+div+'itbitemcd"]:checked');
	
	if(0 >= $(itemCdObj).length){
		alert('선택 후 진행해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}
	
	var ri_itbitemcd, ri_itbsort = '';
	$(itemCdObj).each(function(i,e){
		if(0==i){
			ri_itbitemcd = $(e).val();
			ri_itbsort = $(e).closest('tr').find('input[name="r_'+div+'itbsort"]').val().replaceAll(',', '');
		}
		else{
			ri_itbitemcd += ','+$(e).val();
			ri_itbsort += ','+$(e).closest('tr').find('input[name="r_'+div+'itbsort"]').val().replaceAll(',', '');
		}
	});
	//alert('ri_itbitemcd : '+ri_itbitemcd+'\nri_itbsort : '+ri_itbsort);

	var confirmText = ('IN' == proc_type) ? '선택하신 품목을 즐겨찾기에 저장 하시겠습니까?' : '선택하신 품목을 즐겨찾기에서 해제 하시겠습니까?';
	if(confirm(confirmText)){
		$.ajax({
			async : false,
			data : {
				r_bookmarkprocesstype : proc_type
				, ri_itbitemcd : ri_itbitemcd
				, ri_itbsort : ri_itbsort
			},
			type : 'POST',
			url : '${url}/front/item/setItemBookmarkAjax.lime',
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					formPostSubmit('', '${url}/front/item/itemList.lime');
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}
	else{
		$(obj).prop('disabled', false);
	}
}

// 품목 상세 post 팝업 띄우기.
function itemDetailPop(obj, itemCd){
	if(!isApp()){
		// 팝업 세팅.
		var widthPx = 955;
		var heightPx = 788;
		var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
		
		$('form[name="frmPop"]').find('input[name="r_itemcd"]').val(itemCd);
		
		window.open('', 'itemViewPop', options);
		$('form[name="frmPop"]').prop('action', '${url}/front/item/itemViewPop.lime');
		$('form[name="frmPop"]').submit();
	}
	else{
		// 모달팝업
		//$('#itemDetailPopMId').modal('show');
		var link = '${url}/front/item/itemViewPop.lime?r_itemcd='+itemCd+'&layer_pop=Y&';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		var widthBody = $(window).width();
		$(document).on('shown.bs.modal', function (e) {
	       $(e.target).find('.modal-content .itemList > table').css('width', widthBody + 30);
	    });
		$('#itemDetailPopMId').modal({
			remote: link
		});
	}
}
$(window).on('ready load resize', function() {
	var widthBody = $(window).width();
	$('.modal-content .itemList > table').css('width', widthBody + 30);
});

// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('', '${url}/front/item/itemList.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');
	formPostSubmit('', '${url}/front/item/itemList.lime');
}

//상세조회 펼침,닫힘.
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

//엑셀다운로드
function excelDown(obj) {
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');

	if(!isApp()){
		formPostSubmit('frm', '${url}/front/item/itemExcelDown.lime');
		$('form[name="frm"]').attr('action', '');
	}else{
		var param = {
			action : 'filedownload',
			downloadurl : 'https://eorder.boral.kr/eorder/front/item/itemExcelDown.lime', //다운로드 fullurl
			filename: file_name //다운받는 파일명
	    };
		webkit.messageHandlers.cordova_iab.postMessage(JSON.stringify(param));
	}
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        //console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}
	
</script>

</head>

<body>
<!-- Wrap -->
<div id="subWrap" class="subWrap">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<%@ include file="/WEB-INF/views/include/front/header.jsp" %>
	
	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>
	
	<div class="container-fluid">
		<div class="full-content">
		
			<div class="row no-m">
				<div class="page-breadcrumb"><strong>품목현황</strong></div>
				
				<div class="page-location">
					<ul>
						<li><a href="${url}/front/index/index.lime"><img src="${url}/include/images/front/common/location_home.png" alt="img" /></a></li>
						<li><a href="${url}/front/item/itemList.lime">품목현황</a></li>
						<li>
							<select onchange="formGetSubmit(this.value, '');">
								<option value="${url}/front/item/itemList.lime" <c:if test="${fn:contains(requestScope['javax.servlet.forward.servlet_path'], '/front/item/itemList.lime')}">selected="selected"</c:if> >품목현황</option>
							</select>
						</li>
					</ul>
				</div>
			</div> <!-- Row -->
			
		</div> <!-- Full Content -->
	</div> <!-- Container Fluid -->
	
	<!-- Container -->
	<main class="container" id="container">
		<form name="frm" method="post" >
		
		<%-- Start. Use For Paging --%>
		<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
		<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitrow --%>
		<%-- End. --%>
		
		<input name="r_detailsearch" type="hidden" value="${param.r_detailsearch}" />
		
		
		<!-- Content -->
		<div class="content">
		
			<!-- Row -->
			<div class="row">
				<!-- Col-md-12 -->
				<div class="col-md-12">
				
					<div class="searchArea">
						<div class="col-md-10 favorites">
							<em class="high">품목분류</em>
							<select class="form-control form-sm" name="r_salescd1nm" id="r_salescd1nm" onchange="categorySelect(2, '');">
								<option value="">선택하세요</option>
							</select>
							<select class="form-control form-sm" name="r_salescd2nm" id="r_salescd2nm" onchange="categorySelect(3, '');">
								<option value="">선택하세요</option>
							</select>
							<select class="form-control form-sm" name="r_salescd3nm" id="r_salescd3nm">
								<option value="">선택하세요</option>
							</select>
 							<!-- <select class="form-control form-xs" name="r_salescd4nm" id="r_salescd4nm"> 
								<option value="">선택하세요</option>
							</select> -->
							
							<div class="etc">
								<em class="hide992">즐겨찾기 품목</em>
								<div class="table-checkbox">
									<label class="lol-label-checkbox" for="checkbox">
										<input type="checkbox" id="checkbox" name="r_checkitembookmark" value="Y" <c:if test="${'Y' eq param.r_checkitembookmark}">checked="checked"</c:if> />
										<span class="lol-text-checkbox">즐겨찾기</span>
									</label>
								</div>
							</div>
						</div>
						<div class="col-md-1 empty searchBtn">
							<button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button>
							<button type="button" onclick="dataSearch();">Search</button>
						</div>
						
						<div id="hiddenContent02" style="display: none; height:auto; margin-bottom:0;"> <!-- 상세조회 더보기  -->

							<!-- <div class="col-md-6"> 
								<em>SEARCH_TEXT</em>
								<input type="text" class="form-control" name="rl_searchtext" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_searchtext}" />
							</div> -->
							<div class="col-md-6">
								<em>두께</em>
								<input type="text" class="form-control" name="rl_thicknm" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_thicknm}" />
							</div>
							<div class="col-md-6 right">
								<em>폭</em>
								<input type="text" class="form-control" name="rl_widthnm" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_widthnm}" />
							</div>
							<div class="col-md-6">
								<em>길이</em>
								<input type="text" class="form-control" name="rl_lengthnm" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_lengthnm}" />
							</div>

							<div class="col-md-6 right">
								<em>품목코드</em>
								<input type="text" class="form-control" name="rl_itemcd" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_itemcd}" />
							</div>

							<div class="col-md-6">
								<em>품목명검색1</em>
								<input type="text" class="form-control" name="rl_desc1" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_desc1}" />
							</div>
							<div class="col-md-6 right">
								<em>품목명검색2</em>
								<input type="text" class="form-control" name="rl_desc2" onkeypress="if(event.keyCode == 13){dataSearch();}" value="${param.rl_desc2}" />
							</div>

							<%-- <div class="col-md-6 right">
								<em>즐겨찾기 품목</em>
								<div class="table-checkbox">
									<label class="lol-label-checkbox" for="checkbox">
										<input type="checkbox" id="checkbox" name="r_checkitembookmark" value="Y" <c:if test="${'Y' eq param.r_checkitembookmark}">checked="checked"</c:if> />
										<span class="lol-text-checkbox">즐겨찾기</span>
									</label>
								</div>
							</div> --%>
						</div>
						
					</div> <!-- searchArea -->
					<div class="searchBtn full-tablet">
						<button class="detailBtn" type="button" onclick="fn_spread('hiddenContent02');">상세조회</button>
						<button type="button" onclick="dataSearch();">Search</button>
					</div>
					
					<div class="boardListArea">
						<h2>
							Total <strong><fmt:formatNumber value="${cvt:toInt(listTotalCount)}" pattern="#,###" /></strong>EA
							<div class="title-right little">
								<button type="button" class="btn btn-yellow" onclick="setBookmark(this, 'IN');" >즐겨찾기 저장</button>
								<button type="button" class="btn btn-gray" onclick="setBookmark(this, 'DEL');">즐겨찾기 해제</button>
								<button type="button" class="btn-excel" id="excelDownBtnId" onclick="excelDown(this);"><img src="${url}/include/images/front/common/icon_excel@2x.png" alt="img" /></button>
							</div>
						</h2>
						
						<div class="boardList itemList">
							<!-- desktop -->
							<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="5%" />
									<col width="6%" />
									<col width="9%" />
									<col width="*" />
									<col width="10%" />
 									<!-- <col width="12%" /> -->
									
									<col width="10%" />
									<col width="10%" />
									<col width="10%" />
									
									<col width="9%" />
									<col width="10%" />
								</colgroup>
								<thead>
									<tr>
										<th>
											<div class="basic-checkbox">
												<input type="checkbox" class="lol-checkbox" name="allCheck" id="allCheck" onclick="checkAll2(this, 'r_itbitemcd');" />
												<label class="lol-label-checkbox" for="allCheck"></label>
											</div>
										</th>
										<th>이미지</th>
										<th>품목코드</th>
										<th>품목명</th>
										<th>구매단위</th>
										<!-- <th>SEARCH_TEXT</th> -->
										
										<th>두께</th>
										<th>폭</th>
										<th>길이</th>

										<th>순서</th>
										<th>즐겨찾기</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="list" varStatus="status">
										<tr>
											<td>
												<div class="basic-checkbox">
													<input type="checkbox" class="lol-checkbox" name="r_itbitemcd" id="checkbx${status.index}" value="${list.ITEM_CD}" 
														onclick='gridCheckBoxClicked("checkbx${status.index}");'/>
													<label class="lol-label-checkbox" for="checkbx${status.index}"></label>
												</div>
											</td>
											<td><img src="${url}/data/item/${list.ITI_FILE1}" onerror="this.src='${url}/include/images/front/common/icon_img@2x.png'" width="40" height="40" alt="img" /></td>
											<td>${list.ITEM_CD}</td>
											<td class="text-left"><a href="javascript:;" class="nowrap" onclick="itemDetailPop(this, '${list.ITEM_CD}');">${list.DESC1}</a></td>
											<td>${list.UNIT4}</td>
											<%-- <td class="text-left">${list.SEARCH_TEXT}</td> --%>
											
											<td class="text-right">${list.THICK_NM}</td>
											<td class="text-right">${list.WIDTH_NM}</td>
											<td class="text-right">${list.LENGTH_NM}</td>

											<td><input type="text" class="form-control text-center numberClass" name="r_itbsort" value="${list.ITB_SORT}" onkeyup="checkByte(this, 5);" /></td>
											<td>
												<c:choose>
													<c:when test="${'Y' eq list.BOOKMARK_YN}"><img src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></c:when>
													<c:otherwise><img src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="11" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												품목현황 내역이 없습니다.
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>
							
							<!-- mobile -->
							<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="10%" />
									<col width="15%" />
									<col width="20%" />
									<col width="55%" />
								</colgroup>
								<thead>
									<tr>
										<th>
											<div class="basic-checkbox">
												<input type="checkbox" class="lol-checkbox" name="mallCheck" id="mallCheck" onclick="checkAll2(this, 'r_mitbitemcd');" />
												<label class="lol-label-checkbox" for="mallCheck"></label>
											</div>
										</th>
										<th>이미지</th>
										<th>품목코드</th>
										<th>품목명</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="list" varStatus="status">
									<tr>
										<td>
											<div class="basic-checkbox">
												<input type="checkbox" class="lol-checkbox" name="r_mitbitemcd" id="mcheckbox${status.index}" value="${list.ITEM_CD}" />
												<label class="lol-label-checkbox" for="mcheckbox${status.index}"></label>
											</div>
										</td>
										<td><img src="${url}/data/item/${list.ITI_FILE1}" onerror="this.src='${url}/include/images/front/common/icon_img@2x.png'" width="40" height="40" alt="img" /></td>
										<td class="text-left">${list.ITEM_CD}</td>
										<td class="text-left"><a href="javascript:;" class="nowrap" onclick="itemDetailPop(this, '${list.ITEM_CD}');">${list.DESC1}</a></td>
									</tr>
									</c:forEach>
									
									<!-- 리스트없음 -->
									<c:if test="${empty list}">
										<tr>
											<td colspan="4" class="list-empty">
												<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
												품목현황 내역이 없습니다.
											</td>
										</tr>
									</c:if>
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
			
		</div> <!-- Content -->
		
		</form>
	</main> <!-- Container -->
	
	<%@ include file="/WEB-INF/views/include/front/bottom.jsp" %>
	
	<%@ include file="/WEB-INF/views/include/front/footer.jsp" %>
	
	<!-- Modal -->
	<div class="modal fade" id="itemDetailPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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