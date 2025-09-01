<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
var ckNameJqGrid = 'admin/order/orderList/jqGridCookie/gridList';
//var ckNameJqGrid = 'front/order/salesOrderList2/jqGridCookie/gridList';
var ckNameJqGridWidth = ckNameJqGrid+'/width';

delCookie(ckNameJqGrid);
delCookie(ckNameJqGridWidth);

function setCookie(name,value,expiredays){	//쿠키 저장 함수
	var todayDate= new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + encodeURIComponent(value) + "; path=/; expires=" + todayDate.toGMTString()+";";
}

function delCookie(name){
	setCookie(name, '', -1);
}
</script>
</head>
<body>

</body>
</html>