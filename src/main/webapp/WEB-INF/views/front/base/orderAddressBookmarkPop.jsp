<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!--><html lang="ko"><!--<![endif]-->
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>

<script type="text/javascript">
var page_type = toStr('${param.page_type}'); // orderadd=영업사원 주문등록 개별선택.

$(function(){
	
});

// 선택. 개별만.
function dataSelect(obj, div) { // div : 1=선택후계속,2=선택후 닫기.
	$(obj).prop('disabled', true);
	
	var confirmText = '해당 주소를 선택 하시겠습니까?';
	
	var rowObj = $(obj).closest('tr');
	var orderAddress = {
			OAB_SEQ : $(rowObj).attr('seqAttr')
			, OAB_ZIPCD : $(rowObj).attr('zipCdAttr')
			, OAB_ADD1 : $(rowObj).attr('add1Attr')
			, OAB_ADD2 : $(rowObj).attr('add2Attr')
			, OAB_RECEIVER : $(rowObj).attr('receiverAttr')
			, OAB_TEL1 : $(rowObj).attr('tel1Attr')
			, OAB_TEL2 : $(rowObj).attr('tel2Attr')
		};

	if (page_type == 'orderadd') {
		if(confirm(confirmText)){
			<c:if test="${!isLayerPop}">
				opener.setOrderAddressBookmarkFromPop(orderAddress);
			</c:if>
			<c:if test="${isLayerPop}">
				setOrderAddressBookmarkFromPop(orderAddress);
			</c:if>
			
			$(obj).prop('disabled', false);
		}else{
			$(obj).prop('disabled', false);
			return;
		}
	}
	
	$(obj).prop('disabled', false);
	
	if('2' == div){
		<c:if test="${!isLayerPop}">
			window.open('about:blank', '_self').close();
		</c:if>
		<c:if test="${isLayerPop}">
			$('#openOrderAddressBookmarkPopMId').modal('hide');
		</c:if>
	}
}

// 삭제. 개별만.
function dataDelete(obj, rowId) { 
	$(obj).prop('disabled', true);
	
	var confirmText = '주소록에서 삭제 하시겠습니까?';
	var rowObj = $(obj).closest('tr');
	var oabSeq = $(rowObj).attr('seqAttr');
	
	// ajax
	if (page_type == 'orderadd') {
		if(confirm(confirmText)){
			$.ajax({
				async : false,
				url : '${url}/front/base/pop/deleteOrderAddressBookmarkAjax.lime',
				cache : false,
				type : 'POST',
				dataType: 'json',
				data : {  
					ri_oabseqs : oabSeq
				},
				success : function(data){
					if('0000' == data.RES_CODE){
						alert(data.RES_MSG);
						<c:if test="${!isLayerPop}">
							formPostSubmit('frm_pop', '${url}/front/base/pop/orderAddressBookmarkPop.lime');
						</c:if>
						<c:if test="${isLayerPop}">
							var oabSeq = $(obj).closest('tr').attr('seqAttr');
							
							var trCnt = $(obj).closest('tbody').find('tr').length;
							
							$('#addressTrId_'+oabSeq).remove();
							$('#maddressTrId_'+oabSeq).remove();
							
							trCnt -= 1;
							
							var no = trCnt;
							var mno = trCnt;
							
							$('.addressTrClass').each(function(i,e){
								$(e).find('.noTdClass').html(addComma(no));
								no--;
							});
							$('.maddressTrClass').each(function(i,e){
								$(e).find('.mnoTdClass').html(addComma(mno));
								mno--;
							});
						</c:if>
					}
					$(obj).prop('disabled', false);
				},
				error : function(request,status,error){
					alert('Error');
					$(obj).prop('disabled', false);
				}
			});
		}else{
			$(obj).prop('disabled', false);
			return;
		}
	}
	
	$(obj).prop('disabled', false);
}


// 페이징.
function pager(curpage) {
	$('input[name="page"]').val(curpage);
	formPostSubmit('frm_pop', '${url}/front/base/pop/orderAddressBookmarkPop.lime');
}

// 조회.
function dataSearch() {
	$('input[name="page"]').val('1');

	formPostSubmit('frm_pop', '${url}/front/base/pop/orderAddressBookmarkPop.lime');
}
</script>
</head>

<body> <!-- 팝업사이즈 955 * 733 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">

<form name="frm_pop" method="post" >
<input type="hidden" name="pop" value="${param.pop}" />
<input type="hidden" name="page_type" value="${param.page_type}" />

<%-- Start. Use For Paging --%>
<input name="page" type="hidden" value="${r_page}" /><%-- r_page --%>
<input name="rows" type="hidden" value="${r_limitrow}" /><%-- r_limitrow --%>
<%-- End. --%>

<c:set value="${startnumber}" var="startnumber" />
<c:set value="${startnumber}" var="mstartnumber" />

	<!-- Container Fluid -->
	<div class="container-fluid productSearch">
	
		<button type="button" class="close" onclick="Close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="panel-title">
			<h2>
				주소록
			</h2>
		</div>
		<!-- 2024-12-24 hsg Camel Clutch first 여가 시작. E-order front – 주문 등록 – 주소록 List에서 Keyword 서치 기능 추가 -->
		<!-- DropDown List(구분) 속성 : 납품 주소, 인수자명, 연락처, 연락처2 -->
		<div class="boardView marB30">
			<ul>
				<li class="half wide">
					<label class="view-h">품목분류</label>
					<div class="view-b" style="width:50%;">
						<select class="form-control form-sm" name="r_srchGbn" id="r_srchGbn" width="100px">
							<option value="">선택하세요</option>
							<option value="ADD1" <c:if test="${param.r_srchGbn=='ADD1'}"> selected </c:if>>납품 주소</option>
							<option value="RECEIVER" <c:if test="${param.r_srchGbn=='RECEIVER'}"> selected </c:if>>인수자명</option>
							<option value="TEL1" <c:if test="${param.r_srchGbn=='TEL1'}"> selected </c:if>>연락처</option>
							<option value="TEL2" <c:if test="${param.r_srchGbn=='TEL2'}"> selected </c:if>>연락처2</option>
						</select>
							<input type="text" class="form-control" style="width:50%;" name="r_inputText" id="r_inputText" value="${param.r_inputText}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
						<span class="searchBtn" width="100px; align:right;">
							<button type="button" onclick="dataSearch();">Search</button>
						</span>
					</div>
				</li>
			</ul>
		</div> <!-- boardView -->
		<!-- 2024-12-24 hsg Camel Clutch first 여그가 끝. -->
		
		<div class="boardListArea no-m">
			<!-- 2024-12-24 hsg Camel Clutch second 시작. E-order front – 주문 등록 – 주소록 List에서 Keyword 서치 기능 추가 -->
			<h2>
				Total <strong><fmt:formatNumber value="${cvt:toInt(listTotalCount)}" pattern="#,###" /></strong>
			</h2>
			<!-- 2024-12-24 hsg second Camel Clutch second 끝. -->
			
			<div class="boardList">
				<!-- desktop -->
				<table class="full-desktop" width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="7%" />
						<col width="24%" />
						<col width="13%" />
						<col width="14%" />
						<col width="14%" />
						<col width="12%" />
						<col width="8%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<th>NO</th>
							<th>납품주소</th>
							<th>인수자명</th>
							<th>연락처</th>
							<th>연락처2</th>
							<th>등록일시</th>
							<th>선택</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="list" varStatus="status">
							<tr id="addressTrId_${list.OAB_SEQ}" class="addressTrClass" seqAttr="${list.OAB_SEQ}" zipCdAttr="${list.OAB_ZIPCD}" add1Attr="${list.OAB_ADD1}" add2Attr="${list.OAB_ADD2}" receiverAttr="${list.OAB_RECEIVER}" tel1Attr="${list.OAB_TEL1}" tel2Attr="${list.OAB_TEL2}">
								<td class="noTdClass"><fmt:formatNumber value="${cvt:toInt(startnumber)}" pattern="#,###" /></td>
								<td class="text-left"><p class="nowrap"><c:if test="${!empty list.OAB_ZIPCD}">[${list.OAB_ZIPCD}] </c:if> ${list.OAB_ADD1} ${list.OAB_ADD2}</p></td>
								<td class="text-left">${list.OAB_RECEIVER}</td>
								<td class="text-left">${list.OAB_TEL1}</td>
								<td class="text-left">${list.OAB_TEL2}</td>
								<td>
									<fmt:formatDate value="${list.OAB_INDATE}" pattern="yyyy-MM-dd"/>
								</td>
								<td><button type="button" class="btn btn-green" onclick="dataSelect(this, '2');">선택</button></td>
								<td><button type="button" class="btn btn-light-gray" onclick="dataDelete(this);">삭제</button></td>
							</tr>
							<c:set var="startnumber" value="${startnumber-1}" />
						</c:forEach>
						
						<c:if test="${empty list}">
							<tr>
								<td colspan="8" class="list-empty">
									<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
									등록된 주소가 없습니다.
								</td>
							</tr>
						</c:if>
					</tbody>
				</table>
				
				<!-- mobile -->
				<table class="full-mobile" width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="10%" />
						<col width="45%" />
						<col width="25%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<th>NO</th>
							<th>납품주소</th>
							<th>인수자명</th>
							<th>기능</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="list" varStatus="status">
							<tr id="maddressTrId_${list.OAB_SEQ}" class="maddressTrClass" seqAttr="${list.OAB_SEQ}" zipCdAttr="${list.OAB_ZIPCD}" add1Attr="${list.OAB_ADD1}" add2Attr="${list.OAB_ADD2}" receiverAttr="${list.OAB_RECEIVER}" tel1Attr="${list.OAB_TEL1}" tel2Attr="${list.OAB_TEL2}">
								<td class="mnoTdClass"><fmt:formatNumber value="${cvt:toInt(mstartnumber)}" pattern="#,###" /></td>
								<td class="text-left"><p class=""><c:if test="${!empty list.OAB_ZIPCD}">[${list.OAB_ZIPCD}] </c:if> ${list.OAB_ADD1} ${list.OAB_ADD2}</p></td>
								<td class="text-left">${list.OAB_RECEIVER}</td>
								<td>
									<button type="button" class="btn btn-green" onclick="dataSelect(this, '2');">선택</button>
									<button type="button" class="btn btn-light-gray" onclick="dataDelete(this);">삭제</button>
								</td>
							</tr>
							<c:set var="mstartnumber" value="${mstartnumber-1}" />
						</c:forEach>
						
						<c:if test="${empty list}">
							<tr>
								<td colspan="4" class="list-empty">
									<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
									등록된 주소가 없습니다.
								</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div> <!-- boardList -->
			
			<!-- BEGIN paginate -->
			<c:if test="${!isLayerPop}">
				<c:if test="${!empty list}">
					<%@ include file="/WEB-INF/views/include/front/pager.jsp" %>
				</c:if>
			</c:if>
			<!-- END paginate -->
			
		</div> <!-- boardListArea -->
		
	</div> <!-- Container Fluid -->
	
</form>	
	
</div> <!-- Wrap -->

</body>
</html>