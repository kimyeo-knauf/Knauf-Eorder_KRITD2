<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>
<script type="text/javascript">
</script>
	
</head>

<body class="bg-n">
	
	<!-- Modal -->
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title">품목상세</h4>
				</div>
				<div class="modal-body">
					<div class="table-responsive">
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="35%" />
								<col width="15%" />
								<col width="*" />
								<col width="10%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<td rowspan="10" class="profile-img text-center">
										<img name="preview" src="${url}/data/item/${item.ITI_FILE1}" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" width="242" height="242" alt="image" />
										<div class="thumbnails">
											<img onmouseover="preview.src=img1.src" name="img1" src="${url}/data/item/${item.ITI_FILE1}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" />
											<c:if test="${!empty item.ITI_FILE2}"><img onmouseover="preview.src=img2.src" name="img2" src="${url}/data/item/${item.ITI_FILE2}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
											<c:if test="${!empty item.ITI_FILE3}"><img onmouseover="preview.src=img3.src" name="img3" src="${url}/data/item/${item.ITI_FILE3}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
											<c:if test="${!empty item.ITI_FILE4}"><img onmouseover="preview.src=img4.src" name="img4" src="${url}/data/item/${item.ITI_FILE4}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
											<c:if test="${!empty item.ITI_FILE5}"><img onmouseover="preview.src=img5.src" name="img5" src="${url}/data/item/${item.ITI_FILE5}" onerror="this.src='${url}/include/images/front/content/none_product.png'" alt="img" /></c:if>
										</div>
									</td>
									<th>품목분류</th>
									<td colspan="3">
										${item.SALES_CD1_NM}
										<c:if test="${!empty item.SALES_CD2_NM}"> > ${item.SALES_CD2_NM}</c:if>
										<c:if test="${!empty item.SALES_CD3_NM}"> > ${item.SALES_CD3_NM}</c:if>
 										<%-- <c:if test="${!empty item.SALES_CD4_NM}"> > ${item.SALES_CD4_NM}</c:if> --%>
									</td>
								</tr>
								<tr>
									<th>품목코드</th>
									<td colspan="3">${item.ITEM_CD}</td>
								</tr>
								<tr>
									<th>품목명1</th>
									<td colspan="3">${item.DESC1}</td>
								</tr>
								<tr>
									<th>품목명2</th>
									<td colspan="3">${item.DESC2}</td>
								</tr>
								<tr>
									<th>두께</th>
									<td>${item.THICK_NM}</td>
									<th>폭</th>
									<td>${item.WIDTH_NM}</td>
								</tr>
								<tr>
									<th>길이</th>
									<td>${item.LENGTH_NM}</td>
									<th>구매단위</th>
									<td>${item.UNIT4}</td>
								</tr>
 								<!-- <tr> 
									<th>SEARCH-TEXT</th>
									<td colspan="3">${item.SEARCH_TEXT}</td>
								</tr> -->
								<tr>
									<th>파레트적재단위</th>
									<td colspan="3"><fmt:formatNumber value="${item.ITI_PALLET}" pattern="#,###.##" /></td>
								</tr>
							</tbody>
						</table>
						
						<h5>추천상품</h5>
						<table class="display table tableList pro nowrap" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="7%" />
								<col width="25%" />
								<col width="*" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th>품목코드</th>
									<th>품목명1</th>
									<th>품목명2</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${itemRecommendList}" var="list" varStatus="status">
								<tr>
									<td>${status.count}</td>
									<td class="text-left">${list.ITEM_CD}</td>
									<td class="text-left">${list.DESC1}</td>
									<td class="text-left">${list.DESC2}</td>
								</tr>
								</c:forEach>
								<c:if test="${empty itemRecommendList}">
									<tr>
										<td colspan="4" class="text-center">등록된 추천 상품이 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>