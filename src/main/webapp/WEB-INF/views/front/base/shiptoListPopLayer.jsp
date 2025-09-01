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
var page_type = toStr('${param.page_type}'); // orderadd

// var multi_select = toStr('${r_multiselect}');
// multi_select = ('true' == multi_select) ? true : false;

$(function(){
	getListLayerPopAjax();
});

// 리스트 불러오기 Ajax.
function getListLayerPopAjax(){
	var param = $('#frm_pop_layer').serialize();
	$.ajax({
		async : false,
		data : param,
		type : 'POST',
		url : '${url}/front/base/getShiptoListAjax.lime',
		success : function(data) {
			var list = data.list;
			var listTotalCount = Number(data.listTotalCount);
			var startnumber = Number(data.startnumber);

			var htmlText = '';
			var pageText = '';
			
			$('#listTotalCountStringId').empty();
			$('#listTBodyId').empty();
			$('#layerPopPageinateDivId').remove();
			
			
			if(0 >= listTotalCount){
				htmlText += '<tr>';
				htmlText += '	<td colspan="5" class="list-empty">';
				htmlText += '		<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />';
				htmlText += '		등록된 납품처가 없습니다.';
				htmlText += '	</td>';
				htmlText += '</tr>';
			}
			else{
				$(list).each(function(i,e){
					htmlText += '<tr shiptoCdAttr="'+toStr(e.SHIPTO_CD)+'" shiptoNmAttr="'+toStr(e.SHIPTO_NM)+'" custCdAttr="'+toStr(e.CUST_CD)+'" add1Attr="'+toStr(e.ADD1)+'" add2Attr="'+toStr(e.ADD2)+'" add3Attr="'+toStr(e.ADD3)+'" add4Attr="'+toStr(e.ADD4)+'" zipCdAttr="'+toStr(e.ZIP_CD)+'">';
					htmlText += '	<td>'+addComma(startnumber)+'</td>';
					htmlText += '	<td class="text-left">'+toStr(e.SHIPTO_CD)+'</td>';
					htmlText += '	<td class="text-left"><p class="">'+toStr(e.SHIPTO_NM)+'</p></td>';
					htmlText += '	<td><button type="button" class="btn btn-green" onclick=\'dataSelectLayerPop(this, "2");\' >선택</button></td>';
					
					htmlText += '	<td>';
					if('' == toStr(e.STB_SHIPTOCD)){
						htmlText += '	<button type="button" onclick=\'setBookmarkLayerPopAjax(this, "'+e.SHIPTO_CD+'");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" /></button>';		
					}else{
						htmlText += '	<button type="button" onclick=\'setBookmarkLayerPopAjax(this, "'+e.SHIPTO_CD+'");\'><img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" /></button>';
					}
					htmlText += '	</td>';
					htmlText += '</tr>';
					
					startnumber--;
				});
				
				// 페이징 처리.
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
		
			$('#listTotalCountStringId').append(addComma(listTotalCount));
			$('#listTBodyId').append(htmlText);
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

//페이징.
function pagerLayerPop(curpage) {
	$('input[name="page"]').val(curpage);
	getListLayerPopAjax();
}

//조회.
function dataSearchLayerPop() {
	if($('input[name="r_stbchkyn"]:checked').val() == 'Y'){
		$('input[name="where"]').val('pop');
	}
	
	$('input[name="page"]').val('1');
	getListLayerPopAjax();
}

// 선택. 개별만.
function dataSelectLayerPop(obj, div) { // div : 1=선택후계속,2=선택후 닫기.
	$(obj).prop('disabled', true);
	
	var confirmText = '납품처를 선택 하시겠습니까?';
	
	// 개별
	var rowObj = $(obj).closest('tr');
	var shipto = {
			SHIPTO_CD : rowObj.attr('shiptoCdAttr')
			, SHIPTO_NM : rowObj.attr('shiptoNmAttr')
			, CUST_CD : rowObj.attr('custCdAttr')
			, ADD1 : rowObj.attr('add1Attr')
			, ADD2 : rowObj.attr('add2Attr')
			, ADD3 : rowObj.attr('add3Attr')
			, ADD4 : rowObj.attr('add4Attr')
			, ZIP_CD : rowObj.attr('zipCdAttr')
		};

	if (page_type == 'orderadd' || page_type == 'factreport') {
		confirmText = '해당 납품처를 선택 하시겠습니까?';
		if(confirm(confirmText)){
			setShiptoFromPop(shipto);
			//opener.setShiptoFromPop(shipto);
			$(obj).prop('disabled', false);
		}else{
			$(obj).prop('disabled', false);
			return;
		}
	}
	
	$(obj).prop('disabled', false);
	
	if('2' == div){
		$('#shiptoListPopMId').modal('hide');
		//window.open('about:blank', '_self').close();
	}
}

//즐겨찾기 추가/삭제
function setBookmarkLayerPopAjax(obj, r_shiptocd){
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
				$(obj).html('<img class="favorites" src="${url}/include/images/front/common/icon_star@2x_active.png" width="20" height="20" alt="img" />');
			}else{
				$(obj).html('<img class="favorites" src="${url}/include/images/front/common/icon_star@2x.png" width="20" height="20" alt="img" />');
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

<body> <!-- 팝업사이즈 795 * 652 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

<form name="frm_pop_layer" id="frm_pop_layer" method="post" >
<input type="hidden" name="layer_pop" value="${param.layer_pop}" />
<input type="hidden" name="page_type" value="${param.page_type}" />
<input type="hidden" name="r_multiselect" value="${param.r_multiselect}" />
<input type="hidden" name="where" value="" />

<%-- Start. Use For Paging --%>
<input name="page" type="hidden" value="1" /><%-- r_page --%>
<input name="rows" type="hidden" value="10" /><%-- r_limitrow --%>
<%-- End. --%>

	<!-- Container Fluid -->
	<div class="container-fluid product-search">
	
		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="panel-title">
			<h2>
				납품처선택
				<!-- <div class="searchBtn">
					<button type="button" onclick="dataSearchLayerPop();">Search</button>
				</div> -->
			</h2>
		</div>
		
		<div class="boardView">
			<ul>
				<li class="half wide">
					<label class="view-h">납품처코드</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_shiptocd" value="${param.rl_shiptocd}" onkeypress="if(event.keyCode == 13){dataSearchLayerPop();}" />
					</div>
				</li>
				<li class="half narrow one">
					<label class="view-h">즐겨찾기</label>
					<div class="view-b">
						<div class="table-checkbox">
							<label class="lol-label-checkbox" for="checkbox_layer">
								<input type="checkbox" id="checkbox_layer" name="r_stbchkyn" value="Y" onclick="dataSearchLayerPop();" <c:if test="${param.r_stbchkyn eq 'Y'}">checked</c:if> />
								<span class="lol-text-checkbox">납품처 즐겨찾기 불러오기</span>
							</label>
						</div>
					</div>
				</li>
				<li>
					<label class="view-h">납품처명</label>
					<div class="view-b">
						<input type="text" class="form-control" name="rl_shiptonm" value="${param.rl_shiptonm}" onkeypress="if(event.keyCode == 13){dataSearchLayerPop();}" />
					</div>
				</li>
			</ul>
		</div> <!-- boardView -->
		
		<div class="boardListArea">
			<h2>
				Total <strong id="listTotalCountStringId">0</strong>EA
				<div class="title-right little">
					<button type="button" class="btn btn-line" onclick="dataSearchLayerPop();">조회</button>
				</div>
			</h2>
			
			<div class="boardList" id="listDivId">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="7%" />
						<col width="15%" />
						<col width="48%" />
						<col width="15%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<th>NO</th>
							<th>납품처코드</th>
							<th>납품처명</th>
							<th>기능</th>
							<th>즐겨찾기</th>
						</tr>
					</thead>
					<tbody id="listTBodyId">
						
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