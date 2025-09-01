<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cvt" uri="/WEB-INF/tld/Converter.tld" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- <meta http-equiv='Refresh' content='60'> -->
<title>Daily Accumulated Order Volume</title>

<link href="/eorder/include/css/custom.css?20240415" rel="stylesheet" type="text/css" />
<link href="/eorder/include/images/common/favicon.ico" rel="shortcut icon" />

<style type='text/css'>

body {
	font-family: 'KnaufOffice';
}

h1 {
	color:black;
	text-align: center;
}

h2 {
	color: black;
	text-align: center;
}

table {
	width: 95%;
	margin: 5px 20px 10px 20px;
	border: 3px grey solid;
	border-collapse:collapse;
	text-align: center;
	font-size: 18px;
	font-weight: bold;
}

table th {
	text-align: center;
    padding: 5px;
    border: 1px black solid;
	background-color: beige;
	text-align: center;
    font-weight: bold;
}

table td {
	text-align: right;
    padding: 5px;
    border: 1px black solid;
    font-weight: normal;
}

table .td-left {
	text-align: left;
	font-weight: bold;
}

table .td-center {
	text-align: center;
	font-weight: bold;
}

table .td-summ {
	color: white;
	background-color: #68B3FC;
	font-weight: bold;
}

table .td-summ-right {
	border-right-width: 3px;
	border-right-style: solid;
	border-right-color: grey;
}

table .td-total {
	color: white;
	background-color: #00488D;
	font-weight: bold;
}

.table-n-shipped {
	width: 650px;
	margin: 5px 20px 10px 20px;
	border-collapse: collapse; 
	border: 3px grey solid; 
	text-align: center;
	font-size: 18px;
	font-weight: bold;
}

.table-n-shipped .td-center {
	text-align: center;
	font-weight: bold;
}

.table-n-shipped .td-left {
	text-align: left;
	font-weight: bold;
}

.table-n-shipped .td-center {
	text-align: center;
	font-weight: bold;
}

.padding-div {
	height: 20px; 
	width: 100%; 
}

.footer-div {
	height: 60px; 
	width: 100%; 
}
</style>


<script type="text/javascript">
</script>

</head>
<body>


<h1>Daily Accumulated Order Volume check_OR</h1>
<!-- 
<div class='padding-div'></div>
<h2>Not Shipped Volume(M2, KG, PAC) : ${fromDt} ~ ${toDt}</h2>
<p>

<table class='table-n-shipped'>
	<colgroup>
		<col width="200" />
		<col width="150" />
		<col width="150" />
		<col width="150" />
	</colgroup>
	<tr>
		<th>Plant</th>
		<th>Board</th>
		<th>Bond</th>
		<th>Gyptex</th>
	</tr>
	<c:forEach items="${nShippedVolumes}" var="itemList" varStatus="status2">
		<tr>
			<td class='td-center'>${itemList.PLANT_CD}</td>
			<td><fmt:formatNumber value="${cvt:toInt(itemList.BOARD)}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${cvt:toInt(itemList.BOND)}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${cvt:toInt(itemList.GYPTEX)}" pattern="#,###" /></td>
		</tr>
	</c:forEach>
</table>
-->
 
<div class='padding-div'></div>
<div class='padding-div'></div>
<c:forEach items="${dailyAccumlist}" var="dayList" varStatus="status">
	<div class='padding-div'></div>
	<c:choose>
		<c:when test="${0 eq status.index}"><h2>Today : ${dayList.day}</h2></c:when>
		<c:when test="${1 eq status.index}"><h2>Tomorrow : ${dayList.day}</h2></c:when>
		<c:when test="${2 eq status.index}"><h2>3rd : ${dayList.day}</h2></c:when>
		<c:otherwise><h2>${status.index + 1}th : ${dayList.day}</h2></c:otherwise>
	</c:choose>
	
	<table>
		<colgroup>
			<col width="10%" />
			<col width="10%" />
			<col width="6%" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
			<col width="7%" />
			<col width="7%" />
			<col width="7%" />
			<col width="7%" />
			<col width="7%" />
			<col width="7%" />
			<col width="7%" />
		</colgroup>
		<tr>
			<th>Plant</th>
			<th>Type</th>
			<th>Unit</th>
			<th>당일</th>
			<th>익일</th>
			<th class='td-summ-right'>합계</th>
			<th>CM1</th>
			<th>CM2</th>
			<th>CP</th>
			<th>DM1</th>
			<th>DM2</th>
			<th>GC</th>
			<th>DP</th>
		</tr>
		
		<c:forEach items="${dayList.volList}" var="volList" varStatus="status2">
			<tr>
				<c:choose>
					<c:when test="${'Total' eq volList.PLANT_CD}">
						<c:choose>
							<c:when test="${'M2' eq volList.UNIT}"><td class='td-center td-total' rowspan='3'><span>${volList.PLANT_CD}</span></td></c:when>
							<c:otherwise></c:otherwise>
						</c:choose>
						<td class='td-left td-total'>${volList.CATEG}</td>
						<td class='td-center td-total'>${volList.UNIT}</td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.ROUTE_513)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.ROUTE_503)}" pattern="#,###" /></td>
						<td class='td-total td-summ-right'><fmt:formatNumber value="${cvt:toInt(volList.SUMM)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.CM1)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.CM2)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.CP)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.DM1)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.DM2)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.GC)}" pattern="#,###" /></td>
						<td class='td-total'><fmt:formatNumber value="${cvt:toInt(volList.DP)}" pattern="#,###" /></td>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${'M2' eq volList.UNIT}"><td class='td-center' rowspan='3'><span>${volList.PLANT_CD}<br />${volList.PLANT_NM}</span></td></c:when>
							<c:otherwise></c:otherwise>
						</c:choose>
						<td class='td-left'>${volList.CATEG}</td>
						<td class='td-center'>${volList.UNIT}</td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.ROUTE_513)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.ROUTE_503 )}" pattern="#,###" /></td>
						<td class='td-summ td-summ-right'><fmt:formatNumber value="${cvt:toInt(volList.SUMM)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.CM1)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.CM2)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.CP)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.DM1)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.DM2)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.GC)}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${cvt:toInt(volList.DP)}" pattern="#,###" /></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>

	</table>
</c:forEach>

<!-- 
<div class='footer-div'></div>
<span>IP  :  ${ip}</span><br >
<span>DEVICE  : ${device}</span>
 -->
 
<div class='footer-div'></div>

</body>
</html>