<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<c:if test="${!isLayerPop}">
	<%@ include file="/WEB-INF/views/include/front/commonhead.jsp" %>
	<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>
</c:if>

<script type="text/javascript">
function dataSelect(obj){
	var jsonArray = new Array();
	
	confirmText = '해당 품목을 선택 하시겠습니까?';
	if(confirm(confirmText)){
		// 데이터 세팅.
		var jsonData = new Object();
		var rowObj = $(obj).closest('tr');
		
		jsonData.ITEM_CD = $(rowObj).attr('itemCdAttr');
		jsonData.DESC1 = $(rowObj).attr('itemNmAttr');
		jsonData.UNIT = $(rowObj).attr('itemUnitAttr');
		jsonData.ITI_PALLET = toFloat($(rowObj).attr('itemPalletAttr').replaceAll(',', ''));
		jsonData.RECOMMEND_ITEM_COUNT = $(rowObj).attr('recommendItemCountAttr');
		jsonArray.push(jsonData);
		
		// console.log('jsonArray : ', jsonArray);
		<c:if test="${!isLayerPop}">
			opener.setItemList(jsonArray);
		</c:if>
		<c:if test="${isLayerPop}">
			setItemList(jsonArray);
		</c:if>
	}else{
		return;
	}
		
}
</script>

</head>

<body> <!-- 팝업사이즈 955 * 788 -->

<!-- Wrap -->
<div id="wrap" class="popup-wrapper">
	<!-- Container Fluid -->
	<div class="container-fluid product-search product-detail">
	
		<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div class="panel-title">
			<h2>
				관련품목
			</h2>
		</div>
		
		<div class="boardListArea marT0">
			<!-- <h2 class="title">
				관련품목
			</h2> -->
			<div class="boardList itemList">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="5%" />
						<col width="17%" />
						<col width="*" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<th>NO</th>
							<th>품목코드</th>
							<th>품목명1</th>
							<th>제품정보</th>
							<th>선택</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${itemRecommendList}" var="list" varStatus="status">
							<tr itemCdAttr="${list.ITEM_CD}" itemNmAttr="${list.DESC1}" itemUnitAttr="${list.UNIT4}" itemPalletAttr="${list.ITI_PALLET}" recommendItemCountAttr="${list.RECOMMEND_ITEM_COUNT}">
								<td>${status.count}</td>
								<td class="text-center">${list.ITEM_CD}</td>
								<td class="text-left"><p class="">${list.DESC1}</p></td>
								<td class="text-center"><p class=""><button type="button" class="btn btn-light-gray" <c:if test="${!empty list.ITI_LINK}">onclick="location.href='${list.ITI_LINK}'"</c:if>>제품정보</button></p></td>
								<td class="text-center"><p class=""><button type="button" class="btn btn-green" onclick="dataSelect(this);">품목선택</button></p></td>
							</tr>
						</c:forEach>
						
						<!-- 리스트없음 -->
						<c:if test="${empty itemRecommendList}">
							<tr>
								<td colspan="5" class="list-empty">
									<img src="${url}/include/images/front/common/icon_empty.png" alt="img" /><br />
									관련품목이 없습니다.
								</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div> <!-- boardList -->
			
		</div> <!-- boardListArea -->
	</div>
</div> <!-- Wrap -->
</body>
</html>