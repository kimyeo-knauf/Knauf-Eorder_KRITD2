<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var menuSeqPop = '${requestScope.mnSeq}';
var ss_menu_pop = '${sessionScope.loginDto.menu}';
var isWriteAuth = true; //스크립트에서 제어할 경우 사용.
$(function() {
	// 권한이 있는 메뉴 show && 쓰기 버튼 및 영역 hide.
	var ss_menuarr_pop = ss_menu_pop.split('|');
	var value1 = '', value2 = '';
	$.each(ss_menuarr_pop, function(i,e){
		var temp = e.split(":");
		value1 = temp[0];
		value2 = temp[1];
		
		// 쓰기 버튼 및 영역 hide 또는 읽기 페이지인 경우도 hide.
		if((value1 == menuSeqPop && value2 == 'R') || ('VIEW' == toStr('${page_type}'))){
			$('.writeObjectClass').hide();
			isWriteAuth = false;
		}
	});
});
</script>
