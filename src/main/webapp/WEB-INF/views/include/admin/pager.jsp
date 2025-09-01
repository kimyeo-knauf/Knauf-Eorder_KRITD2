<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<ul class="pagination">
	<c:if test="${ r_page eq 1 }">
		<li><a href="javascript:;" aria-label="Previous"><span aria-hidden="true">Prev</span></a></li>
	</c:if>
	<c:if test="${ r_page ne 1 }">
		<li><a href="javascript:pager(${r_page - 1});" aria-label="Previous"><span aria-hidden="true">Prev</span></a></li>
	</c:if>

	<c:forEach begin="${ startpage }" end="${ endpage }" varStatus="status" >
		<c:if test="${ r_page eq status.index }"><li class="active"><a href="javascript:;">${status.index}</a></li></c:if>
		<c:if test="${ r_page ne status.index }"><li><a href="javascript:javascript:pager(${status.index});">${status.index}</a></li></c:if>
	</c:forEach>
	
	<c:if test="${ totpage ne r_page }">
		<li><a href="javascript:pager(${ r_page + 1 });" aria-label="Next"><span aria-hidden="true">Next</span></a></li>
	</c:if>
	<c:if test="${ totpage eq r_page }">
		<li><a href="javascript:;" aria-label="Next"><span aria-hidden="true">Next</span></a></li>
	</c:if>
</ul>