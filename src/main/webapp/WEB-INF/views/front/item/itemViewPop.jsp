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
				품목상세
			</h2>
		</div>
		<div class="boardViewArea">
			<div class="productImg">
				<div class="gallery" align="center">
					<div class="preview" align="center">
						<img name="preview" src="${url}/data/item/${item.ITI_FILE1}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
					</div>
					<div class="thumbnails">
						<img onmouseover="preview.src=img1.src" name="img1" src="${url}/data/item/${item.ITI_FILE1}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
						<c:if test="${!empty item.ITI_FILE2}"><img onmouseover="preview.src=img2.src" name="img2" src="${url}/data/item/${item.ITI_FILE2}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
						<c:if test="${!empty item.ITI_FILE3}"><img onmouseover="preview.src=img3.src" name="img3" src="${url}/data/item/${item.ITI_FILE3}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
						<c:if test="${!empty item.ITI_FILE4}"><img onmouseover="preview.src=img4.src" name="img4" src="${url}/data/item/${item.ITI_FILE4}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
						<c:if test="${!empty item.ITI_FILE5}"><img onmouseover="preview.src=img5.src" name="img5" src="${url}/data/item/${item.ITI_FILE5}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
					</div>
				</div>
			</div>
			
			<div class="boardView marB30">
				<ul>
					<li>
						<label class="view-h">품목분류</label>
						<div class="view-b">
							${item.SALES_CD1_NM}
							<c:if test="${!empty item.SALES_CD2_NM}"> > ${item.SALES_CD2_NM}</c:if>
							<c:if test="${!empty item.SALES_CD3_NM}"> > ${item.SALES_CD3_NM}</c:if>
 							<%-- <c:if test="${!empty item.SALES_CD4_NM}"> > ${item.SALES_CD4_NM}</c:if> --%>
						</div>
					</li>
					<li>
						<label class="view-h">품목코드</label>
						<div class="view-b">
							${item.ITEM_CD}
						</div>
					</li>
					<li>
						<label class="view-h">품목명</label>
						<div class="view-b">
							${item.DESC1}
						</div>
					</li>
					<li>
						<label class="view-h">품목명2</label>
						<div class="view-b">
							${item.DESC2}
						</div>
					</li>
					<li class="half">
						<label class="view-h">두께</label>
						<div class="view-b">
							${item.THICK_NM}
						</div>
					</li>
					<li class="half">
						<label class="view-h">폭</label>
						<div class="view-b">
							${item.WIDTH_NM}
						</div>
					</li>
					<li class="half">
						<label class="view-h">길이</label>
						<div class="view-b">
							${item.LENGTH_NM}
						</div>
					</li>
					<li class="half">
						<label class="view-h">구매단위</label>
						<div class="view-b">
							${item.UNIT4}
						</div>
					</li>
 					<!-- <li class="half">
						<label class="view-h">SEARCH_TEXT</label>
						<div class="view-b">
							${item.SEARCH_TEXT}
						</div>
					</li> -->
					<li class="half">
						<label class="view-h">파레트 적재단위</label>
						<div class="view-b">
							<fmt:formatNumber value="${item.ITI_PALLET}" pattern="#,###.##" />
						</div>
					</li>
					<li class="half">
						<label class="view-h">링크</label>
						<div class="view-b">
							<button type="button" class="link" <c:if test="${!empty item.ITI_LINK}">onclick="location.href='${item.ITI_LINK}'"</c:if>>제품정보 보기</button>
						</div>
					</li>
				</ul>
			</div> <!-- boardView -->
			
		</div> <!-- boardViewArea -->
		
		<div class="boardListArea marT0">
			<h2 class="title">
				관련품목
			</h2>
			<div class="boardList itemList">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup>
						<col width="7%" />
						<col width="17%" />
						<col width="51%" />
						<col width="25%" />
					</colgroup>
					<thead>
						<tr>
							<th>NO</th>
							<th>품목코드</th>
							<th>품목명</th>
							<th>링크</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${itemRecommendList}" var="list" varStatus="status">
							<tr>
								<td>${status.count}</td>
								<td class="text-center">${list.ITEM_CD}</td>
								<td class="text-left"><p class="nowrap">${list.DESC1}</p></td>
								<td class="text-left"><p class="nowrap"><button type="button" class="link" <c:if test="${!empty item.ITI_LINK}">onclick="location.href='${item.ITI_LINK}'"</c:if>>제품정보 보기</button></p></td>
							</tr>
						</c:forEach>
						
						<!-- 리스트없음 -->
						<c:if test="${empty itemRecommendList}">
							<tr>
								<td colspan="4" class="list-empty">
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