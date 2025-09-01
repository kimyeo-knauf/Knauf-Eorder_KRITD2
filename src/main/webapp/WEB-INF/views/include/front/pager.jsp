<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="paginate">
	<c:if test="${r_page eq 1}">
		<a href="javascript:;" class="pre_end">맨앞</a>
		<a href="javascript:;" class="pre">이전</a>
	</c:if>
	<c:if test="${r_page ne 1}">
		<a href="javascript:pager(1);" class="pre_end">맨앞</a>
		<a href="javascript:pager(${r_page - 1});" class="pre">이전</a>
	</c:if>

	<c:forEach begin="${startpage}" end="${endpage}" varStatus="status" >
		<c:if test="${r_page eq status.index}"><strong>${status.index}</strong></c:if>
		<c:if test="${r_page ne status.index}"><a href="javascript:pager(${status.index});"><span>${status.index}</span></a></c:if>
	</c:forEach>
	
	<!-- total=totpage -->
	<c:if test="${total eq r_page}"> 
		<a class="next" href="javascript:;">다음</a>
		<a class="next_end" href="javascript:;">맨뒤</a>
	</c:if>
	<c:if test="${total ne r_page}">
		<a class="next" href="javascript:pager(${r_page+1});">다음</a>
		<a class="next_end" href="javascript:pager(${total});">맨뒤</a>
	</c:if>
</div>