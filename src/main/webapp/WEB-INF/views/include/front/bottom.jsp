<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
$(function(){
	/* $.ajax({
		async : true,
		data : null,
		dataType : 'json',
		success : function(data) {
			//console.log('data : ', data);
			$('#bottomVACH5Id').empty();
			$('#bottomVACEmId').empty();
			
			var account = data.account;
			if(null == account) {
				$('#bottomVACEmId').append('입금계좌가 등록되지 않았습니다.');
				return;
			}
			
			var bankName = account.AYRLN;
			var bankAccount = account.AYCBNK;
			
			if('씨티' == bankName) bankName = '시티은행 입금계좌';
			else if('우리은행' == bankName) bankName = '우리은행 입금계좌';
			else if('국민은행' == bankName) bankName = '국민은행 입금계좌';
			else if('새마을금고' == bankName) bankName = '새마을금고 입금계좌';
			else bankName = '은행';
			
			$('#bottomVACH5Id').append(bankName);
			
			if('은행' == bankName) bankAccount = '등록되지 않았습니다.';
			
			$('#bottomVACEmId').append(bankAccount);
		},
		error : function(request,status,error){
			alert('Error');
		},
		type : 'POST',
		url : '${url}/front/base/getCustVAccountAjax.lime'
	}); */
});
</script>
<section>
	<div class="bottomArea">
		<ul>
			<li>
				<%-- 
				<c:set var="bankName">${custVAccount.AYRLN}</c:set>
				<c:choose>
					<c:when test="${'씨티' eq bankName}"><c:set var="bankName">씨티은행</c:set></c:when>
					<c:when test="${'우리은행' eq bankName}"><c:set var="bankName">우리은행</c:set></c:when>
					<c:when test="${'국민은행' eq bankName}"><c:set var="bankName">국민은행</c:set></c:when>
					<c:when test="${'새마을금고' eq bankName}"><c:set var="bankName">새마을금고</c:set></c:when>
					<c:otherwise><c:set var="bankName">은행</c:set></c:otherwise>
				</c:choose>
				--%>
				<h5 id="bottomVACH5Id">입금계좌</h5>
				<span>
					<img class="img-circle avatar" src="${url}/include/images/front/common/citi.png" alt="icon" />
					<em id="bottomVACEmId"> </em>
				</span>
			</li>
			<li>
				<h5>영업담당자</h5>
				<span>
					<img class="img-circle avatar" src="${url}/data/user/${ctMap.USER_FILE}" onerror="this.src='${url}/include/images/front/common/img.jpg'" alt="영업담당자" />
					<em>
						${ctMap.USER_NM} ${ctMap.USER_POSITION}
						<a class="hide-xxs">${fn:replace(ctMap.CELL_NO, '-', '.')}</a>
						<a class="hide500" href="tel:${fn:replace(ctMap.CELL_NO, '-', '.')}">${fn:replace(ctMap.CELL_NO, '-', '.')}</a>
						<%-- 
						<a class="hide-xxs">${fn:replace(ctMap.CELL_NO, '-', '.')}</a>
						<a class="hide500" href="tel:${fn:replace(ctMap.CELL_NO, '-', '.')}">${fn:replace(ctMap.CELL_NO, '-', '.')}</a>
						--%>
					</em>
				</span>
			</li>
			<li>
				<h5>CS담당자</h5>
				<span>
					<img class="img-circle avatar" src="${url}/data/user/${ctMap.CSUSER_FILE}" onerror="this.src='${url}/include/images/front/common/img.jpg'" alt="cs담당자" />
					<em>
						${ctMap.CSUSER_NM} ${ctMap.CSUSER_POSITION}
						<a class="hide-xxs">${fn:replace(ctMap.CSUSER_TEL, '-', '.')}</a>
						<a class="hide500" href="tel:${fn:replace(ctMap.CSUSER_TEL, '-', '.')}">${fn:replace(ctMap.CSUSER_TEL, '-', '.')}</a>
						<%-- 
						<a class="hide-xxs">${fn:replace(ctMap.CSUSER_CELL, '-', '.')}</a>
						<a class="hide500" href="tel:${fn:replace(ctMap.CSUSER_CELL, '-', '.')}">${fn:replace(ctMap.CSUSER_CELL, '-', '.')}</a>
						--%>
					</em>
				</span>
			</li>
		</ul>
	</div>
</section>