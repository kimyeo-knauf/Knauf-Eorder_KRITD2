<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<%-- 
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>
--%>

<script type="text/javascript">
var page_type = toStr('${param.page_type}'); //recommend=추천상품 다중선택 / orderadd=영업사원 주문등록 다중선택.

$(function(){
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
	
	getListLayerPopAjax();
});

//리스트 불러오기 Ajax.
function getListLayerPopAjax(){
	var dv = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	
	var param = $('#frm_pop_layer').serialize();
	$.ajax({
		async : false,
		data : param,
		type : 'POST',
		url : '${url}/front/base/getItemListAjax.lime',
		success : function(data) {
			var list = data.list;
			var listTotalCount = Number(data.listTotalCount);
			var startnumber = Number(data.startnumber);

			var htmlText = '';
			var pageText = '';
			
			$('#listTotalCountStringId').empty();
			$('#'+dv+'listTBodyId').empty();
			$('#layerPopPageinateDivId').remove();
			
			// #################### Desktop ####################
			if('' == dv){
				if(0 >= listTotalCount){
					htmlText += '<tr>';
					htmlText += '	<td colspan="7" class="list-empty">';
					htmlText += '		<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />';
					htmlText += '		품목현황 내역이 없습니다.';
					htmlText += '	</td>';
					htmlText += '</tr>';
				}
				else{
					$(list).each(function(i,e){
						htmlText += '<tr itemCdAttr="'+toStr(e.ITEM_CD)+'" itemNmAttr="'+toStr(e.DESC1)+'" itemUnitAttr="'+toStr(e.UNIT4)+'" itemPalletAttr="'+toStr(e.ITI_PALLET)+'" recommendItemCountAttr="'+toStr(e.RECOMMEND_ITEM_COUNT)+'">';
						htmlText += '	<td>';
						htmlText += '		<div class="basic-checkbox">';
						htmlText += '			<input type="checkbox" class="lol-checkbox" name="c_itemcd" id="checkbox'+i+'" value="'+toStr(e.ITEM_CD)+'" />';
						htmlText += '			<label class="lol-label-checkbox" for="checkbox'+i+'"></label>';
						htmlText += '		</div>';
						htmlText += '	</td>';
						htmlText += '	<td><img src="${url}/data/item/'+toStr(e.ITI_FILE1)+'" onerror=\'this.src="${url}/include/images/front/common/icon_img@2x.png"\' width="30" height="30" alt="img" /></td>';
						htmlText += '	<td>'+toStr(e.ITEM_CD)+'</td>';
						htmlText += '	<td class="text-left"><p class="nowrap">'+toStr(e.DESC1)+'</p></td>';
						htmlText += '	<td class="text-center">'+toStr(e.UNIT4)+'</td>';
						
						htmlText += '	<td class="text-center">';
						if('' != toStr(e.ITI_LINK)){
							htmlText += '		<button type="button" class="btn btn-light-gray" onclick=\'location.href="'+toStr(e.ITI_LINK)+'"\'>제품정보</button>';
						}else{
							htmlText += '		<button type="button" class="btn btn-light-gray">제품정보</button>';
						}
						htmlText += '	</td>';
						
						htmlText += '	<td>';
						if('Y' == toStr(e.BOOKMARK_YN)){
							htmlText += '	<button type="button" onclick=\'setBookmark(this,"'+toStr(e.ITEM_CD)+'","'+toStr(e.ITB_SORT)+'","DEL");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></button>';		
						}else{
							htmlText += '	<button type="button" onclick=\'setBookmark(this,"'+toStr(e.ITEM_CD)+'","'+toStr(e.ITB_SORT)+'","IN");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></button>';
						}
						htmlText += '	</td>';
						htmlText += '</tr>';
					});
				}
			}
			// #################### Mobile ####################
			else{
				if(0 >= listTotalCount){
					htmlText += '<tr>';
					htmlText += '	<td colspan="5" class="list-empty">';
					htmlText += '		<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />';
					htmlText += '		품목현황 내역이 없습니다.';
					htmlText += '	</td>';
					htmlText += '</tr>';
				}
				else{
					$(list).each(function(i,e){
						htmlText += '<tr itemCdAttr="'+toStr(e.ITEM_CD)+'" itemNmAttr="'+toStr(e.DESC1)+'" itemUnitAttr="'+toStr(e.UNIT4)+'" itemPalletAttr="'+toStr(e.ITI_PALLET)+'" recommendItemCountAttr="'+toStr(e.RECOMMEND_ITEM_COUNT)+'">';
						htmlText += '	<td>';
						htmlText += '		<div class="basic-checkbox">';
						htmlText += '			<input type="checkbox" class="lol-checkbox" name="c_mitemcd" id="mcheckbox'+i+'" value="'+toStr(e.ITEM_CD)+'" />';
						htmlText += '			<label class="lol-label-checkbox" for="mcheckbox'+i+'"></label>';
						htmlText += '		</div>';
						htmlText += '	</td>';
						htmlText += '	<td class="text-left">'+toStr(e.ITEM_CD)+'</td>';
						htmlText += '	<td class="text-left"><p class="">'+toStr(e.DESC1)+'</p></td>';
						
						htmlText += '	<td class="text-center">';
						if('' != toStr(e.ITI_LINK)){
							htmlText += '		<button type="button" class="btn btn-light-gray" onclick=\'location.href="'+toStr(e.ITI_LINK)+'"\'>제품정보</button>';
						}else{
							htmlText += '		<button type="button" class="btn btn-light-gray">제품정보</button>';
						}
						htmlText += '	</td>';
						
						htmlText += '	<td>';
						if('Y' == toStr(e.BOOKMARK_YN)){
							htmlText += '	<button type="button" onclick=\'setBookmark(this,"'+toStr(e.ITEM_CD)+'","'+toStr(e.ITB_SORT)+'","DEL");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></button>';		
						}else{
							htmlText += '	<button type="button" onclick=\'setBookmark(this,"'+toStr(e.ITEM_CD)+'","'+toStr(e.ITB_SORT)+'","IN");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></button>';
						}
						htmlText += '	</td>';
						htmlText += '</tr>';
					});
				}
			}
			
			$('#listTotalCountStringId').append(addComma(listTotalCount));
			$('#'+dv+'listTBodyId').append(htmlText);
			
			// 페이징 처리.
			if(0 < listTotalCount){
				var total = Number(data.total);
				var r_page = Number(data.r_page);
				var startpage = Number(data.startpage);
				var endpage = Number(data.endpage);
				var r_limitrow = Number(data.r_limitrow);

				pageText += '<div class="paginate" id="layerPopPageinateDivId">';
				
				if(1 == r_page){
					pageText += '<a href="javascript:;" class="pre_end">맨앞</a>';
					pageText += '<a href="javascript:;" class="pre">이전</a>';
				}else{
					pageText += '<a href=\'javascript:pagerLayerPop("1");\' class="pre_end">맨앞</a>';
					pageText += '<a href=\'javascript:pagerLayerPop("'+(r_page-1)+'");\' class="pre">이전</a>';
				}
				
				for(var i=startpage, j=endpage; i<=j; i++){
					if(i == r_page){
						pageText += '<strong>'+i+'</strong>';					
					}else{
						pageText += '<a href=\'javascript:pagerLayerPop("'+i+'");\'><span>'+i+'</span></a>';					
					}
				}
				
				if(total == r_page){
					pageText += '<a class="next" href="javascript:;">다음</a>';	
					pageText += '<a class="next_end" href="javascript:;">맨뒤</a>';	
				}else{
					pageText += '<a class="next" href=\'javascript:pagerLayerPop("'+(r_page+1)+'");\'>다음</a>';
					pageText += '<a class="next_end" href=\'javascript:pagerLayerPop("'+total+'");\'>맨뒤</a>';
				}
				
				pageText += '</div>';
				
				$('#listDivId').after(pageText);
			}
			
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

// 페이징.
function pagerLayerPop(curpage) {
	$('input[name="page"]').val(curpage);
	getListLayerPopAjax();
}

// 조회.
function dataSearchLayerPop() {
	$('input[name="page"]').val('1');
	getListLayerPopAjax();
}

// 선택.
function dataSelectLayerPop(obj, rowId, div) { // rowId : 빈값=다중선택, !빈값=개별선택 / div : 1=선택후계속,2=선택후 닫기.
	$(obj).prop('disabled', true);
	
	var dv = ($('div .full-desktop').css('display') == 'none') ? 'm' : '';
	
	var confirmText = '품목을 선택 하시겠습니까?';
	
	if('' == rowId){ // 다중.
		var itemCdObj = $('input:checkbox[name="c_'+dv+'itemcd"]:checked');
		
		if(0 >= $(itemCdObj).length){
			alert('선택 후 진행해 주세요.');
			$(obj).prop('disabled', false);
			return;
		}
		
		var jsonArray = new Array();
		
		if('orderadd' == page_type){ // 주문등록.
			confirmText = '해당 품목을 선택 하시겠습니까?';
			if(confirm(confirmText)){
				// 데이터 세팅.
				
				$(itemCdObj).each(function(i,e){
					var jsonData = new Object();
					var rowObj = $(e).closest('tr');
					
					jsonData.ITEM_CD = $(rowObj).attr('itemCdAttr');
					jsonData.DESC1 = $(rowObj).attr('itemNmAttr');
					jsonData.UNIT = $(rowObj).attr('itemUnitAttr');
					jsonData.ITI_PALLET = toFloat($(rowObj).attr('itemPalletAttr').replaceAll(',', ''));
					jsonData.RECOMMEND_ITEM_COUNT = $(rowObj).attr('recommendItemCountAttr');
					jsonArray.push(jsonData);
				});
				
				// console.log('jsonArray : ', jsonArray);
				setItemList(jsonArray);
				//opener.setItemList(jsonArray);
				$(obj).prop('disabled', false);
			}else{
				$(obj).prop('disabled', false);
				return;
			}
			
		}
		
		$(obj).prop('disabled', false);
	}
	else{ // 개별
		// 로직 추가.
	}
	
	if('2' == div){
		$('#openItemPopMId').modal('hide');
		//window.open('about:blank', '_self').close();
	}
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

// 북마크해제
function resetBookmark(){
	$('input[name="r_checkitembookmark"]').prop('checked', false);
}

//즐겨찾기 추가/삭제.
function setBookmark(obj, itemCd, itemSt, proc_type){
	$(obj).prop('disabled', true);
	
	$.ajax({
		async : false,
		data : {
			r_bookmarkprocesstype : proc_type
			, ri_itbitemcd : itemCd
			, ri_itbsort : itemSt
		},
		type : 'POST',
		url : '${url}/front/item/setItemBookmarkAjax.lime',
		success : function(data) {
			if(data.RES_CODE == '0000') {
				var txt = '';
				if(proc_type == 'IN'){
					txt += '<button type="button" onclick=\'setBookmark(this, "'+ itemCd +'", "'+ itemSt +'", "DEL");\'>';
					txt += '<img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" />';
					txt += '</button>';
				}else{
					txt += '<button type="button" onclick=\'setBookmark(this, "'+ itemCd +'", "'+ itemSt +'", "IN");\'>';
					txt += '<img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" />';
					txt += '</button>';
				}
				
				$(obj).parent().html(txt);
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
</script>
</head>

<body> <!-- 팝업사이즈 955 * 738 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

<form name="frm_pop_layer" id="frm_pop_layer" method="post" >
<input type="hidden" name="layer_pop" value="${param.layer_pop}" />
<input type="hidden" name="page_type" value="${param.page_type}" />
<input type="hidden" name="r_multiselect" value="${param.r_multiselect}" />

<%-- Start. Use For Paging --%>
<input name="page" type="hidden" value="1" /><%-- r_page --%>
<input name="rows" type="hidden" value="10" /><%-- r_limitrow --%>
<%-- End. --%>

	<!-- Container Fluid -->
	<div class="container-fluid product-search">
	
		<button type="button" class="close" onclick="Close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="panel-title">
			<h2>
				품목선택
				<!-- 
				<div class="searchBtn">
					<button type="button" onclick="dataSearchLayerPop();">Search</button>
				</div>
				-->
			</h2>
		</div>
		
		<div class="boardView">
			<ul>
				<li>
					<label class="view-h">품목분류</label>
					<div class="view-b">
						<select class="form-control form-sm" name="r_salescd1nm" id="r_salescd1nm" onchange="categorySelect(2, ''); resetBookmark();">
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
					</div>
				</li>

 				<!-- <li class="half">
					<label class="view-h">SEARCH_TEXT</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_searchtext" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_searchtext}" />
					</div>
				</li> -->

				<li class="half">
					<label class="view-h">두께</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_thicknm" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_thicknm}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">폭</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_widthnm" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_widthnm}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">길이</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_lengthnm" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_lengthnm}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">품목코드</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_itemcd" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_itemcd}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">품목명검색1</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_desc1" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_desc1}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">품목명검색2</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_desc2" onkeypress="if(event.keyCode == 13){dataSearchLayerPop(); return false;}" value="${param.rl_desc2}" />
					</div>
				</li>
				<li class="half">
					<label class="view-h">즐겨찾기 품목</label>
					<div class="view-b">
						<div class="table-checkbox">
							<label class="lol-label-checkbox" for="checkbox_layer">
								<input type="checkbox" id="checkbox_layer" name="r_checkitembookmark" value="Y" onclick="dataSearchLayerPop();" <c:if test="${'Y' eq param.r_checkitembookmark}">checked="checked"</c:if> />
								<span class="lol-text-checkbox">즐겨찾기</span>
							</label>
						</div>
					</div>
				</li>
				<li class="half hide-sm">
					<label class="view-h"></label>
					<div class="view-b"></div>
				</li>
			</ul>
		</div> <!-- boardView -->
		
		<div class="boardListArea">
			<h2>
				Total <strong id="listTotalCountStringId">0</strong>EA
				<div class="title-right big">
					<button type="button" class="btn btn-green" onclick="dataSelectLayerPop(this, '', '1');">선택 후 계속</button>
					<button type="button" class="btn btn-gray" onclick="dataSelectLayerPop(this, '', '2');">선택 후 닫기</button>
					<button type="button" class="btn btn-line" onclick="dataSearchLayerPop();">조회</button>
				</div>
			</h2>
			
			<div class="boardList itemList" id="listDivId">
				<!-- desktop -->
				<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="5%" />
						<col width="7%" />
						<col width="10%" />
						<col width="*" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<th>
								<div class="basic-checkbox">
									<input type="checkbox" class="lol-checkbox" id="allCheck" name="allCheck" onclick="checkAll2(this, 'c_itemcd');" />
									<label class="lol-label-checkbox" for="allCheck"></label>
								</div>
							</th>
							<th>이미지</th>
							<th>품목코드</th>
							<th>품목명</th>
							<th>구매단위</th>
							<th>링크</th>
 							<th>즐겨찾기</th>
						</tr>
					</thead>
					<tbody id="listTBodyId">
						<%-- 
						<c:forEach items="${list}" var="list" varStatus="status">
							<tr itemCdAttr="${list.ITEM_CD}" itemNmAttr="${list.DESC1}" itemUnitAttr="${list.UNIT4}" itemPalletAttr="${list.ITI_PALLET}" recommendItemCountAttr="${list.RECOMMEND_ITEM_COUNT}">
								<td>
									<div class="basic-checkbox">
										<input type="checkbox" class="lol-checkbox" name="c_itemcd" id="checkbox${status.index}" value="${list.ITEM_CD}" />
										<label class="lol-label-checkbox" for="checkbox${status.index}"></label>
									</div>
								</td>
								<td><img src="${url}/data/item/${list.ITI_FILE1}" onerror="this.src='${url}/include/images/front/common/icon_img@2x.png'" width="30" height="30" alt="img" /></td>
								<td>${list.ITEM_CD}</td>
								<td class="text-left"><p class="nowrap">${list.DESC1}</p></td>
								<td class="text-center">${list.UNIT4}</td>
								<td class="text-center">
									<button type="button" class="btn btn-light-gray" <c:if test="${!empty list.ITI_LINK}">onclick="location.href='${list.ITI_LINK}'"</c:if>>제품정보</button>
								</td>
								<td>
									<c:choose>
										<c:when test="${list.BOOKMARK_YN eq 'Y'}">
											<button type="button" onclick="setBookmark(this,'${list.ITEM_CD}','${list.ITB_SORT}','DEL');"><img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></button>
										</c:when>
										<c:otherwise>
											<button type="button" onclick="setBookmark(this,'${list.ITEM_CD}','${list.ITB_SORT}','IN');"><img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></button>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
						
						<c:if test="${empty list}">
							<tr>
								<td colspan="7" class="list-empty">
									<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
									품목현황 내역이 없습니다.
								</td>
							</tr>
						</c:if>
						 --%>
					</tbody>
				</table>
				
				<!-- mobile -->
				<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="5%" />
						<col width="20%" />
						<col width="34%" />
						<col width="26%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<th>
								<div class="basic-checkbox">
									<input type="checkbox" class="lol-checkbox" id="mallCheck" name="mallCheck" onclick="checkAll2(this, 'c_mitemcd');" />
									<label class="lol-label-checkbox" for="mallCheck"></label>
								</div>
							</th>
							<th>품목코드</th>
							<th>품목명</th>
							<th>링크</th>
							<th>즐겨찾기</th>
						</tr>
					</thead>
					<tbody id="mlistTBodyId">
						<%-- 
						<c:forEach items="${list}" var="list" varStatus="status">
							<tr itemCdAttr="${list.ITEM_CD}" itemNmAttr="${list.DESC1}" itemUnitAttr="${list.UNIT4}" itemPalletAttr="${list.ITI_PALLET}">
								<td>
									<div class="basic-checkbox">
										<input type="checkbox" class="lol-checkbox" name="c_mitemcd" id="mcheckbox${status.index}" value="${list.ITEM_CD}" />
										<label class="lol-label-checkbox" for="mcheckbox${status.index}"></label>
									</div>
								</td>
								<td class="text-left">${list.ITEM_CD}</td>
								<td class="text-left"><p class="">${list.DESC1}</p></td>
								<td class="text-center">
									<button type="button" class="btn btn-light-gray" <c:if test="${!empty list.ITI_LINK}">onclick="location.href='${list.ITI_LINK}'"</c:if>>제품정보</button>
								</td>
								<td>
									<c:choose>
										<c:when test="${list.BOOKMARK_YN eq 'Y'}">
											<button type="button" onclick="setBookmark(this,'${list.ITEM_CD}','${list.ITB_SORT}','DEL');"><img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></button>
										</c:when>
										<c:otherwise>
											<button type="button" onclick="setBookmark(this,'${list.ITEM_CD}','${list.ITB_SORT}','IN');"><img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></button>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
						
						<c:if test="${empty list}">
							<tr>
								<td colspan="5" class="list-empty">
									<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
									품목현황 내역이 없습니다.
								</td>
							</tr>
						</c:if>
						 --%>
					</tbody>
					
				</table>
			</div> <!-- boardList -->
			
			<!-- BEGIN paginate -->
			<!-- END paginate -->
			
		</div> <!-- boardListArea -->
		
	</div> <!-- Container Fluid -->

</form>
	
</div> <!-- Wrap -->
</body>
</html>