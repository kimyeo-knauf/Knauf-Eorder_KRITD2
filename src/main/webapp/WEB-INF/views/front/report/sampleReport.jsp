<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp"%>
<!DOCTYPE HTML>
<!--[if IE 8]><html lang="ko" class="ie8"><![endif]-->
<!--[if gt IE 8]><!-->
<html lang="ko">
<!--<![endif]-->

<head>
<%@ include file="/WEB-INF/views/include/front/commonhead.jsp"%>
<style>
@media print {
	.btnDiv {
		display: none;
	}
}

.topSearch {
	padding: 20px !important;
}

.topSearch ul .search-h {
	border-bottom: 1px solid #e6e6e6;
	height: 33px;
}

.topSearch ul .search-c {
	border-bottom: 1px solid #e6e6e6;
	height: 33px;
	padding-left: 15px;
}

.fireproofTable {
	width: 100%;
	margin-top: 15px;
	border-bottom: 1px solid #000;
	
}

.fireproofTable > tbody > tr > *{
	overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.fireproofTable tr td {
	text-align: left;
}

.fireproofTable tr td.active {
	background-color: #1a75ff !important;
	-webkit-print-color-adjust: exact;
}

.fireproofTable tr td.active {
	background-color: #9fdf9f !important;
	-webkit-print-color-adjust: exact;
}

.fireproofTable tr td.title {
	background-color: #f4f4b3;
	border-top: 1px solid #000;
	border-left: 1px solid #000;
	border-right: 1px solid #000;
	padding: 5px;
	text-align: center;
}

.fireproofItem {
	border-top: 1px solid #666;
	border-left: 1px solid #666;
	line-height:20px;
	padding-left:2px;
	padding-right:2px;
	font-size:12px;
}

.fireproofItem.c {
	text-align: center !important;
}

.customChk:checked+span+div+label {
	background-color: #efefef;
	border: 1px solid red;
}

div.checker span.checked+label {
	background-color: #efefef;
	border: 1px solid red;
}

.fireproofTable tr:not(:first-child) td:nth-last-child(1) {
	border-right: 1px solid #666;
}

.qmsBtnDiv {
	padding-top: 30px;
	padding-bottom: 30px;
	text-align: right;
}

.qmsBtnDiv .btn {
	margin-left: 5px;
	margin-right: 5px;
}

.button {
	width: 100px;
	background-color: grey;
	border: none;
	color: #fff;
	padding: 4px 0;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 15px;
	margin: 4px;
	cursor: pointer;
}
</style>
<!-- <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" /> -->
<title>아니요 샘플인데요</title>
</head>
<script>
	function doPrint() {
		window.print();
	}
</script>
<body style="width: 100%; height: 100%; padding: 0; margin: 0;">
	<div class="btnDiv"
		style="width: 950px; margin-top: 5px; margin-bottom: 5px; text-align: right;">
		<button type="button" class="btn btn-line f-black" onclick="doPrint()">
			<i class="fa fa-print"></i> <em>인쇄</em>
		</button>
	</div>
	<c:forEach items="${reportList}" var="reportList"
		varStatus="reportListStatus">
		<c:set var="qmsPopDetlGridListCount"
			value="${fn:length(reportList.qmsPopDetlGridList)}" />
		<!-- MANUFACTURER -->
		<!-- BEGIN wrapper -->
		<div style="display: flex; page-break-before: always;">
			<div style="float: left; width: 950px; height: 100%; padding: 0 0 50px; margin: 0; background: #fff; ">

				<!-- BEGIN body -->
				<div
					style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

					<!-- BEGIN container -->
					<div style="width: 100%;">

						<div
							style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #fff;">

							<!-- 로고 및 보고서 제목 -->
							<img src="${url}/include/images/front/common/usg_boral_logo.png"
								alt="logo"
								style="position: relative; width: 150px; bottom: 0px; right: 7px" />
							<h1 style="width: 100% !important; float: left; margin: 5px auto 30px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 30px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>내화구조 품질확인서(제조업자용 - A표)</b></h1>

							<!-- QMS NUMBER 및 CREATE DATE -->
							<div
								style="float: right; border: 0px solid #fff; display: inline-block; margin-top: 0px; margin-bottom: -2px;">
								<c:forEach items="${reportList.qmsMastList}" var="mastlist"
									varStatus="status">
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid #000;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="20%" />
											<col width="35%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 번호</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<th
													style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 작성일자</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
													${fn:substring(mastlist.CREATETIME,0,4)}년
													${fn:substring(mastlist.CREATETIME,5,7)}월
													${fn:substring(mastlist.CREATETIME,8,11)}일</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- MANUFACTURER -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													제조업자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													크나우프 석고보드㈜</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													전남 여수시 낙포동 197-20</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													417-81-17256</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													02-6902-3100</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<img
													src="${url}/data/config/${reportList.configList.CEOSEAL}"
													alt="(인)" width="80" height="80" />
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													인정받은 내화구조 주요 재료,제품을 공급업자에게 납품하였음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.TEAM_NM}</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.SALESREP_NM}</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- SUPPLIER -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													공급업자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_BIZ_NO}</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<span>(인)</span>
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													인정받은 내화구조 주요 재료,제품을 제조업자로부터 인수하였음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- CONSTRUCTION SITE -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="10%" />
											<col width="35%" />
											<col width="10%" />
											<col width="45%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공현장</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													현 장 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주&nbsp;&nbsp;&nbsp;&nbsp;소</th>
												<td
													style="border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													감리회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_NM}</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
								<br />

								<!-- ITEM -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="25%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												인수,인계 물량</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<td colspan="2"
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-weight: 600; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												규격:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; font-weight: 600;">
												수량: (매)</td>
											<td
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												Lot Number:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 600; text-align: center;">
												내화구조 인정표시 확인</td>
										</tr>
										<!-- 반복 리스트로 해야함 -->
										<!-- begin -->
										<c:forEach items="${reportList.qmsPopDetlGridList}"
											var="qmsPopDetlGridList" varStatus="status">
											<c:if test="${qmsPopDetlGridListCount < 6}">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.ITEM_DESC}</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														${qmsPopDetlGridList.QMS_ORD_QTY}</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.LOTN}</td>
													<td style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														<div style="border: 2px solid #000;width: 40px; height: 17px; border-radius: 50px; position: absolute; right: 15%;"></div>(&nbsp;&nbsp;확인&nbsp;&nbsp;/&nbsp;&nbsp;미확인&nbsp;&nbsp;)</td>
												</tr>
											</c:if>
										</c:forEach>
										
										<c:if test="${qmsPopDetlGridListCount < 6}">
											<c:forEach begin="1" end="${5 - qmsPopDetlGridListCount}" step="1" varStatus="status2">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
												</tr>
											</c:forEach>
										</c:if>
										
										<c:if test="${qmsPopDetlGridListCount > 5}">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													별첨. 품목정보 페이지 참조</td>
											</tr>
										</c:if>
										<!-- end -->
									</tbody>
								</table>
								<br />
								<!-- FIREPROOF CONSTRUCTION TYPE -->
								<table class="fireproofTable">
									<tr>
										<td class="title" colspan="2"><b style="font-size:13px;">내화구조 인정개요</b></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td colspan="4"><div class="fireproofItem"
												style="text-align: center;">
												<b>상품명(인정번호)</b>
											</div></td>
										<td><div class="fireproofItem">
												<b>내화시간</b>
											</div></td>
									</tr>
									<c:set var="fireIndex" value="1" />
									<c:forEach items="${reportList.qmsFireproofList}"
										var="fireprooflist" varStatus="status">
										<c:if test="${fireIndex == 1}">
											<tr>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'Y'}">
											<td class="active">
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'N'}">
											<td>
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if
											test="${fireprooflist.LAST_YN eq 'Y' || fireprooflist.RLAST == fireprooflist.RCNT}">
											<c:if test="${fireIndex < 4}">
												<c:set var="fireIndex" value="${fireIndex+1}" />
												<c:forEach begin="${fireIndex}" end="4" step="1"
													varStatus="status2">
													<td>
														<div class="fireproofItem">&nbsp;</div>
													</td>
													<c:set var="fireIndex" value="${fireIndex+1}" />
												</c:forEach>
											</c:if>
										</c:if>

										<c:if test="${fireIndex >= 4}">
											<c:if test="${fireprooflist.RNUM <= 4}">
												<td class="fireproofItem c"
													rowspan="${fireprooflist.ROWSPAN_CNT}">${fireprooflist.FIRETIME}
													시간</td>
											</c:if>
											<c:set var="fireIndex" value="0" />
											</tr>
										</c:if>

										<c:set var="fireIndex" value="${fireIndex + 1}" />
									</c:forEach>
								</table>

								<br />

								<!-- ATTACHMENT -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="15%" />
										<col width="85%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-bottom: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												붙임서류</th>
											<!-- 반복 리스트로 해야함 -->
											<td>
												<table width="100%" border="0" cellpadding="0"
													cellspacing="0"
													style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed;">
													<colgroup>
														<col width="100%" />
													</colgroup>

													<tbody>
														<!-- 반복 리스트로 해야함 -->
														<!-- begin -->
														<tr>
															<td
																style="border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 300; text-align: left; padding: 3px;">
																내화구조 인정서 사본, 내화구조 인정세부내용, 현장 시공상태 체크리스트 양식</td>
														</tr>
														<!-- end -->
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

						</div>
						<!-- END container -->

					</div>
					<!-- END body -->

				</div>
				<!-- END wrapper -->
			</div>
		</div>
		<!-- SUPPLIER -->

		<!-- 품목정보 많은경우 추가 시작 -->
		<c:if test="${qmsPopDetlGridListCount > 5}">
			<div style="display: flex; page-break-before: always;">
				<div
					style="float: left; width: 950px; height: 100%; padding: 0 0 50px; margin: 0; background: #fff; ">

					<!-- BEGIN body -->
					<div
						style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

						<!-- BEGIN container -->
						<div style="width: 100%;">
							<div
								style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #fff;">

								<!-- 로고 및 보고서 제목 -->
								<img src="${url}/include/images/front/common/usg_boral_logo.png"
									alt="logo"
									style="position: relative; width: 150px; bottom: 0px; right: 7px" />
									
								<h1 style="width: 100% !important; float: left; margin: 5px auto 30px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 30px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>품목정보</b></h1>
								
								<!-- QMS NUMBER 및 CREATE DATE -->
								<c:forEach items="${reportList.qmsMastList}" var="mastlist" varStatus="status">
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px #000 solid;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="20%" />
											<col width="35%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 번호</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<th
													style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 작성일자</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
													${fn:substring(mastlist.CREATETIME,0,4)}년
													${fn:substring(mastlist.CREATETIME,5,7)}월
													${fn:substring(mastlist.CREATETIME,8,11)}일</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
								
								<br/>

								<!-- ITEM -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="25%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												인수,인계 물량</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<td colspan="2"
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-weight: 600; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												규격:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; font-weight: 600;">
												수량: (매)</td>
											<td
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												Lot Number:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 600; text-align: center;">
												내화구조 인정표시 확인</td>
										</tr>
										<!-- 반복 리스트로 해야함 -->
										<!-- begin -->
										<c:forEach items="${reportList.qmsPopDetlGridList}"
											var="qmsPopDetlGridList" varStatus="status">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2"
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${qmsPopDetlGridList.ITEM_DESC}</td>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px; text-align: center;">
													${qmsPopDetlGridList.QMS_ORD_QTY}</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${qmsPopDetlGridList.LOTN}</td>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px; text-align: center;">
													<div style="border: 2px solid #000;width: 40px; height: 17px; border-radius: 50px; position: absolute; right: 15%;"></div>(&nbsp;&nbsp;확인&nbsp;&nbsp;/&nbsp;&nbsp;미확인&nbsp;&nbsp;)</td>
											</tr>

										</c:forEach>
										<!-- end -->
									</tbody>
								</table>
							</div>
							<!-- END container -->

						</div>
						<!-- END body -->

					</div>
					<!-- END wrapper -->
				</div>
			</div>
		</c:if>
		<!-- 품목정보 많은경우 추가 종료 -->

		<!-- BEGIN wrapper -->
		<div style="display: flex; page-break-before: always;">
			<div
				style="float: left; width: 950px; height: 100%; padding: 0 0 50px; margin: 0; background: #fff; ">

				<!-- BEGIN body -->
				<div
					style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

					<!-- BEGIN container -->
					<div style="width: 100%;">

						<div
							style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #454545;">

							<!-- 로고 및 보고서 제목 -->
							<img src="${url}/include/images/front/common/usg_boral_logo.png"
								alt="logo"
								style="position: relative; width: 150px; bottom: 0px; right: 7px" />
							<h1
								style="width: 100% !important; float: left; margin: 5px auto 10px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 30px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>내화구조 품질확인서(공급업자용 - B표)</b></h1>

							<!-- QMS NUMBER 및 CREATE DATE -->
							<div
								style="float: right; border: 0px solid #000; display: inline-block; margin-top: 0px; margin-bottom: -2px;">
								<c:forEach items="${reportList.qmsMastList}" var="mastlist"
									varStatus="status">
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px #000 solid;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="20%" />
											<col width="35%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 번호</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<th
													style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 작성일자</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
													${fn:substring(mastlist.CREATETIME,0,4)}년
													${fn:substring(mastlist.CREATETIME,5,7)}월
													${fn:substring(mastlist.CREATETIME,8,11)}일</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- SUPPLIER -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													공급업자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_BIZ_NO}</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<span>(인)</span>
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													제조사로부터 공급받은 내화구조 주요 재료,제품 정량을 시공업자에게 납품하였음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- CONTRUCTION COMPANY -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공업자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_BIZ_NO}</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_TEL}</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<span>(인)</span>
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													내화구조로 인정받은 내화구조 주요 재료,제품을 공급업자로부터 인수하였음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- CONTRUCTION SITE -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="10%" />
											<col width="35%" />
											<col width="10%" />
											<col width="45%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공현장</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													현 장 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주&nbsp;&nbsp;&nbsp;&nbsp;소</th>
												<td
													style="border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													제조회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													크나우프 석고보드㈜</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													감리회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_NM}</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
								<br />

								<!-- ITEM -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="25%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												인수,인계 물량</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<td colspan="2"
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-weight: 600; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												규격:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; font-weight: 600;">
												수량: (매)</td>
											<td
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												Lot Number</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 600; text-align: center;">
												내화구조 인정표시 확인</td>
										</tr>
										<!-- 반복 리스트로 해야함 -->
										<!-- begin -->
										<c:forEach items="${reportList.qmsPopDetlGridList}"
											var="qmsPopDetlGridList" varStatus="status">
											<c:if test="${qmsPopDetlGridListCount < 6}">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.ITEM_DESC}</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														${qmsPopDetlGridList.QMS_ORD_QTY}</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.LOTN}</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														<div style="border: 2px solid #000;width: 40px; height: 17px; border-radius: 50px; position: absolute; right: 15%;"></div>(&nbsp;&nbsp;확인&nbsp;&nbsp;/&nbsp;&nbsp;미확인&nbsp;&nbsp;)</td>
												</tr>
											</c:if>
										</c:forEach>
										<c:if test="${qmsPopDetlGridListCount < 6}">
											<c:forEach begin="1" end="${5 - qmsPopDetlGridListCount}" step="1" varStatus="status2">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
												</tr>
											</c:forEach>
										</c:if>
										<c:if test="${qmsPopDetlGridListCount > 5}">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													별첨. 품목정보 페이지 참조</td>
											</tr>
										</c:if>
										<!-- end -->
									</tbody>
								</table>

								<br />
								<!-- FIREPROOF CONSTRUCTION TYPE -->
								<table class="fireproofTable">
									<tr>
										<td class="title" colspan="2"><b style="font-size:13px;">내화구조 인정개요</b></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td colspan="4"><div class="fireproofItem"
												style="text-align: center;">
												<b>상품명(인정번호)</b>
											</div></td>
										<td><div class="fireproofItem">
												<b>내화시간</b>
											</div></td>
									</tr>
									<c:set var="fireIndex" value="1" />
									<c:forEach items="${reportList.qmsFireproofList}"
										var="fireprooflist" varStatus="status">
										<c:if test="${fireIndex == 1}">
											<tr>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'Y'}">
											<td class="active">
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'N'}">
											<td>
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if
											test="${fireprooflist.LAST_YN eq 'Y' || fireprooflist.RLAST == fireprooflist.RCNT}">
											<c:if test="${fireIndex < 4}">
												<c:set var="fireIndex" value="${fireIndex+1}" />
												<c:forEach begin="${fireIndex}" end="4" step="1"
													varStatus="status2">
													<td>
														<div class="fireproofItem">&nbsp;</div>
													</td>
													<c:set var="fireIndex" value="${fireIndex+1}" />
												</c:forEach>
											</c:if>
										</c:if>

										<c:if test="${fireIndex >= 4}">
											<c:if test="${fireprooflist.RNUM <= 4}">
												<td class="fireproofItem c"
													rowspan="${fireprooflist.ROWSPAN_CNT}">${fireprooflist.FIRETIME}
													시간</td>
											</c:if>
											<c:set var="fireIndex" value="0" />
											</tr>
										</c:if>

										<c:set var="fireIndex" value="${fireIndex + 1}" />
									</c:forEach>
								</table>

								<br />

								<!-- ATTACHMENT -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="15%" />
										<col width="85%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-bottom: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												붙임서류</th>
											<!-- 반복 리스트로 해야함 -->
											<td>
												<table width="100%" border="0" cellpadding="0"
													cellspacing="0"
													style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed;">
													<colgroup>
														<col width="100%" />
													</colgroup>

													<tbody>
														<!-- 반복 리스트로 해야함 -->
														<!-- begin -->
														<tr>
															<td
																style="border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 300; text-align: left; padding: 3px;">
																내화구조 인정서 사본, 내화구조 인정세부내용, 현장 시공상태 체크리스트 양식</td>
															</td>
														</tr>
														<!-- end -->
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

						</div>
						<!-- END container -->

					</div>
					<!-- END body -->

				</div>
				<!-- END wrapper -->
			</div>
		</div>
		<!-- CONTRUCTION COMPANY -->
		<!-- BEGIN wrapper -->
		<div style="display: flex; page-break-before: always;">
			<div
				style="float: left; width: 950px; height: 100%; padding: 0 0 50px; margin: 0; background: #fff; ">

				<!-- BEGIN body -->
				<div
					style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

					<!-- BEGIN container -->
					<div style="width: 100%;">

						<div
							style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #454545;">

							<!-- 로고 및 보고서 제목 -->
							<img src="${url}/include/images/front/common/usg_boral_logo.png"
								alt="logo"
								style="position: relative; width: 150px; bottom: 0px; right: 7px" />
							<h1
								style="width: 100% !important; float: left; margin: 5px auto 10px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 30px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>내화구조 품질확인서(시공업자용 - C표)</b></h1>

							<!-- QMS NUMBER 및 CREATE DATE -->
							<div
								style="float: right; border: 0px solid #000; display: inline-block; margin-top: 0px; margin-bottom: -2px;">
								<c:forEach items="${reportList.qmsMastList}" var="mastlist"
									varStatus="status">
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px #000 solid;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="20%" />
											<col width="35%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 번호</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<th
													style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질확인서 작성일자</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
													${fn:substring(mastlist.CREATETIME,0,4)}년
													${fn:substring(mastlist.CREATETIME,5,7)}월
													${fn:substring(mastlist.CREATETIME,8,11)}일</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- CONTRUCTION COMPANY -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공업자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_BIZ_NO}</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CNSTR_TEL}</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<span>(인)</span>
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													내화구조 인정세부내용에 따라 적정하게 시공하였음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- SUPERVISOR -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="20%" />
											<col width="25%" />
											<col width="10%" />
											<col width="5%" />
											<col width="30%" />
											<col width="10%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													감리자</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회 사 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소 재 지</th>
												<td colspan="3"
													style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사업자등록번호</th>
												<td
													style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_BIZ_NO}</td>
												<th
													style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													전화번호</th>
												<td colspan="2"
													style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SUPVS_TEL}</td>
												<td rowspan="3"
													style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
													<span>(인)</span>
												</td>
											</tr>
											<tr>
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													내화구조 인정세부내용에 따라 적정하게 시공되었음을 확인함.</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													소속</td>
												<td
													style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="2"
													style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												</td>
											</tr>
										</tbody>
									</table>

									<br />

									<!-- CONTRUCTION SITE -->
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
										<colgroup>
											<col width="10%" />
											<col width="35%" />
											<col width="10%" />
											<col width="45%" />
										</colgroup>
										<tbody>
											<tr style="border-bottom: 2px solid #000;">
												<td colspan="2"
													style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													시공현장</td>
											</tr>
											<tr style="border-bottom: 2px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													현 장 명</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_NM}</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주&nbsp;&nbsp;&nbsp;&nbsp;소</th>
												<td
													style="border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.SHIPTO_ADDR}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													제조회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													크나우프 석고보드㈜</td>
												<th
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													공급회사</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
													${mastlist.CUST_NM}</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
								<br />

								<!-- ITEM -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="25%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												시공물량</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<td colspan="2"
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-weight: 600; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												규격:</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; font-weight: 600;">
												수량: (매)</td>
											<td
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												Lot Number</td>
											<td
												style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 600; text-align: center;">
												내화구조 인정표시 확인</td>
										</tr>
										<!-- 반복 리스트로 해야함 -->
										<!-- begin -->
										<c:forEach items="${reportList.qmsPopDetlGridList}"
											var="qmsPopDetlGridList" varStatus="status">
											<c:if test="${qmsPopDetlGridListCount < 6}">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.ITEM_DESC}</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														${qmsPopDetlGridList.QMS_ORD_QTY}</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														${qmsPopDetlGridList.LOTN}</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														<div style="border: 2px solid #000;width: 40px; height: 17px; border-radius: 50px; position: absolute; right: 15%;"></div>(&nbsp;&nbsp;확인&nbsp;&nbsp;/&nbsp;&nbsp;미확인&nbsp;&nbsp;)</td>
												</tr>
											</c:if>
										</c:forEach>
										<c:if test="${qmsPopDetlGridListCount < 6}">
											<c:forEach begin="1" end="${5 - qmsPopDetlGridListCount}" step="1" varStatus="status2">
												<tr style="border-bottom: 1px solid #000;">
													<td colspan="2"
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td
														style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
													<td
														style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
														&nbsp;</td>
													<td style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
														&nbsp;</td>
												</tr>
											</c:forEach>
										</c:if>
										<c:if test="${qmsPopDetlGridListCount > 5}">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="5"
													style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													별첨. 품목정보 페이지 참조</td>
											</tr>
										</c:if>
										<!-- end -->
									</tbody>
								</table>

								<br />
								<!-- FIREPROOF CONSTRUCTION TYPE -->
								<table class="fireproofTable">
									<tr>
										<td class="title" colspan="2"><b style="font-size:13px;">내화구조 인정개요</b></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td colspan="4"><div class="fireproofItem"
												style="text-align: center;">
												<b>상품명(인정번호)</b>
											</div></td>
										<td><div class="fireproofItem">
												<b>내화시간</b>
											</div></td>
									</tr>
									<c:set var="fireIndex" value="1" />
									<c:forEach items="${reportList.qmsFireproofList}"
										var="fireprooflist" varStatus="status">
										<c:if test="${fireIndex == 1}">
											<tr>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'Y'}">
											<td class="active">
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if test="${fireprooflist.CHK_YN eq 'N'}">
											<td>
												<div class="fireproofItem">
													<c:choose>
														<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
															<label
																src="${url}/data/fireproof/${fireprooflist.FILENAME}"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:when>
														<c:otherwise>
															<label src="${url}/include/images/admin/list_noimg.gif"
																for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
																class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</c:if>

										<c:if
											test="${fireprooflist.LAST_YN eq 'Y' || fireprooflist.RLAST == fireprooflist.RCNT}">
											<c:if test="${fireIndex < 4}">
												<c:set var="fireIndex" value="${fireIndex+1}" />
												<c:forEach begin="${fireIndex}" end="4" step="1"
													varStatus="status2">
													<td>
														<div class="fireproofItem">&nbsp;</div>
													</td>
													<c:set var="fireIndex" value="${fireIndex+1}" />
												</c:forEach>
											</c:if>
										</c:if>

										<c:if test="${fireIndex >= 4}">
											<c:if test="${fireprooflist.RNUM <= 4}">
												<td class="fireproofItem c"
													rowspan="${fireprooflist.ROWSPAN_CNT}">${fireprooflist.FIRETIME}
													시간</td>
											</c:if>
											<c:set var="fireIndex" value="0" />
											</tr>
										</c:if>

										<c:set var="fireIndex" value="${fireIndex + 1}" />
									</c:forEach>
								</table>

								<br />

								<!-- ATTACHMENT -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="15%" />
										<col width="85%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-bottom: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												붙임서류</th>
											<!-- 반복 리스트로 해야함 -->
											<td>
												<table width="100%" border="0" cellpadding="0"
													cellspacing="0"
													style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed;">
													<colgroup>
														<col width="100%" />
													</colgroup>

													<tbody>
														<!-- 반복 리스트로 해야함 -->
														<!-- begin -->
														<tr>
															<td
																style="border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 300; text-align: left; padding: 3px;">
																내화구조 인정서 사본, 내화구조 인정세부내용, 현장 시공상태 체크리스트 양식</td>
															</td>
														</tr>
														<!-- end -->
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

						</div>
						<!-- END container -->

					</div>
					<!-- END body -->

				</div>
				<!-- END wrapper -->
			</div>
		</div>
		<!-- SUPERVISOR -->
		<!-- BEGIN wrapper -->
		<c:choose>
			<c:when test="${reportListStatus.last}">
				<div style="page-break-before: always;">
			</c:when>
			<c:otherwise>
				<div style="display: flex; page-break-before: always;">
			</c:otherwise>
		</c:choose>
		<div
			style="float: left; width: 950px; height: 100%; padding: 0 0 50px; margin: 0; background: #fff; ">

			<!-- BEGIN body -->
			<div
				style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

				<!-- BEGIN container -->
				<div style="width: 100%;">

					<div
						style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #454545;">

						<!-- 로고 및 보고서 제목 -->
						<img src="${url}/include/images/front/common/usg_boral_logo.png"
							alt="logo"
							style="position: relative; width: 150px; bottom: 0px; right: 7px" />
						<h1
							style="width: 100% !important; float: left; margin: 5px auto 10px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 30px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
							<b>내화구조 품질확인서(감리자용 - D표)</b></h1>

						<!-- QMS NUMBER 및 CREATE DATE -->
						<div
							style="float: right; border: 0px solid #000; display: inline-block; margin-top: 0px; margin-bottom: -2px;">
							<c:forEach items="${reportList.qmsMastList}" var="mastlist"
								varStatus="status">
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px #000 solid;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="20%" />
										<col width="35%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 1px solid #000;">
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												품질확인서 번호</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
												${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
											<th
												style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												품질확인서 작성일자</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
												${fn:substring(mastlist.CREATETIME,0,4)}년
												${fn:substring(mastlist.CREATETIME,5,7)}월
												${fn:substring(mastlist.CREATETIME,8,11)}일</td>
										</tr>
									</tbody>
								</table>

								<br />

								<!-- SUPERVISOR -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="5%" />
										<col width="30%" />
										<col width="10%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												감 리 자</td>
										</tr>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												회 사 명</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SUPVS_NM}</td>
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												소 재 지</th>
											<td colspan="3"
												style="border-right: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SUPVS_ADDR}</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<th
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												사업자등록번호</th>
											<td
												style="border-bottom: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SUPVS_BIZ_NO}</td>
											<th
												style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												전화번호</th>
											<td colspan="2"
												style="border-bottom: 2px solid #000; border-right: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SUPVS_TEL}</td>
											<td rowspan="3"
												style="border: 2px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center;">
												<span>(인)</span>
											</td>
										</tr>
										<tr>
											<td colspan="5"
												style="border-left: 1px solid #000; border-right: 2px solid #000; padding: 3px; padding-left: 80px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												내화구조 인정세부내용에 따라 적정하게 시공되었음을 확인하고, 별도 점검표를 작성하였음.</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<td
												style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												소속</td>
											<td
												style="border-top: 1px solid #000; border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
											</td>
											<td
												style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												성명</td>
											<td colspan="2"
												style="border-right: 2px solid #000; border-left: 1px solid #000; border-top: 1px solid #000; padding: 3px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
											</td>
										</tr>
									</tbody>
								</table>

								<br />

								<!-- CONSTRUCTION SITE -->
								<table width="100%" cellpadding="0" cellspacing="0"
									style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
									<colgroup>
										<col width="20%" />
										<col width="25%" />
										<col width="10%" />
										<col width="45%" />
									</colgroup>
									<tbody>
										<tr style="border-bottom: 2px solid #000;">
											<td colspan="2"
												style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												시공현장</td>
										</tr>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												현 장 명</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SHIPTO_NM}</td>
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												주&nbsp;&nbsp;&nbsp;&nbsp;소</th>
											<td
												style="border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.SHIPTO_ADDR}</td>
										</tr>
										<tr style="border-bottom: 2px solid #000;">
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												공급회사</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.CUST_NM}</td>
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												시공회사</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
												${mastlist.CNSTR_NM}</td>
										</tr>
										<tr style="border-bottom: 1px solid #000;">
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												인허가관청명</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
											</td>
											<th
												style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												TEL.</th>
											<td
												style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 3px;">
											</td>
										</tr>
									</tbody>
								</table>
							</c:forEach>
							<br />

							<!-- ITEM -->
							<table width="100%" cellpadding="0" cellspacing="0"
								style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
								<colgroup>
									<col width="20%" />
									<col width="25%" />
									<col width="10%" />
									<col width="25%" />
									<col width="20%" />
								</colgroup>
								<tbody>
									<tr style="border-bottom: 2px solid #000;">
										<td colspan="2"
											style="border: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
											시공물량</td>
									</tr>
									<tr style="border-bottom: 1px solid #000;">
										<td colspan="2"
											style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; text-align: center; font-weight: 600; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
											규격:</td>
										<td
											style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; font-weight: 600;">
											수량: (매)</td>
										<td
											style="border-bottom: 2px solid #000; border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
											Lot Number:</td>
										<td
											style="border-bottom: 2px solid #000; border-top: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 600; text-align: center;">
											내화구조 인정표시 확인</td>
									</tr>
									<!-- 반복 리스트로 해야함 -->
									<!-- begin -->
									<c:forEach items="${reportList.qmsPopDetlGridList}"
										var="qmsPopDetlGridList" varStatus="status">
										<c:if test="${qmsPopDetlGridListCount < 6}">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2"
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${qmsPopDetlGridList.ITEM_DESC}</td>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
													${qmsPopDetlGridList.QMS_ORD_QTY}</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${qmsPopDetlGridList.LOTN}</td>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
													<div style="border: 2px solid #000;width: 40px; height: 17px; border-radius: 50px; position: absolute; right: 15%;"></div>(&nbsp;&nbsp;확인&nbsp;&nbsp;/&nbsp;&nbsp;미확인&nbsp;&nbsp;)</td>
											</tr>
										</c:if>
									</c:forEach>
									<c:if test="${qmsPopDetlGridListCount < 6}">
										<c:forEach begin="1" end="${5 - qmsPopDetlGridListCount}" step="1" varStatus="status2">
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2"
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													&nbsp;</td>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
													&nbsp;</td>
												<td
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													&nbsp;</td>
												<td style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: left; padding: 1px; text-align: center;">
													&nbsp;</td>
											</tr>
										</c:forEach>
									</c:if>
									<c:if test="${qmsPopDetlGridListCount > 5}">
										<tr style="border-bottom: 1px solid #000;">
											<td colspan="5"
												style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000; padding: 1px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												별첨. 품목정보 페이지 참조</td>
										</tr>
									</c:if>
									<!-- end -->
								</tbody>
							</table>

							<br />
							<!-- FIREPROOF CONSTRUCTION TYPE -->
							<table class="fireproofTable">
								<tr>
									<td class="title" colspan="2"><b>내화구조 인정개요</b></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td colspan="4"><div class="fireproofItem"
											style="text-align: center;">
											<b>상품명(인정번호)</b>
										</div></td>
									<td><div class="fireproofItem">
											<b>내화시간</b>
										</div></td>
								</tr>
								<c:set var="fireIndex" value="1" />
								<c:forEach items="${reportList.qmsFireproofList}"
									var="fireprooflist" varStatus="status">
									<c:if test="${fireIndex == 1}">
										<tr>
									</c:if>

									<c:if test="${fireprooflist.CHK_YN eq 'Y'}">
										<td class="active">
											<div class="fireproofItem">
												<c:choose>
													<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
														<label
															src="${url}/data/fireproof/${fireprooflist.FILENAME}"
															for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
															class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
													</c:when>
													<c:otherwise>
														<label src="${url}/include/images/admin/list_noimg.gif"
															for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
															class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
													</c:otherwise>
												</c:choose>
											</div>
										</td>
									</c:if>

									<c:if test="${fireprooflist.CHK_YN eq 'N'}">
										<td>
											<div class="fireproofItem">
												<c:choose>
													<c:when test="${fn:length(fireprooflist.FILENAME) > 0}">
														<label
															src="${url}/data/fireproof/${fireprooflist.FILENAME}"
															for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
															class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
													</c:when>
													<c:otherwise>
														<label src="${url}/include/images/admin/list_noimg.gif"
															for="${fireprooflist.KEYCODE}_${fireprooflist.RNUM}_${mastlist.QMS_SEQ}"
															class="thumb"><b>${fireprooflist.FIREPROOFTYPE}</b></label>
													</c:otherwise>
												</c:choose>
											</div>
										</td>
									</c:if>

									<c:if
										test="${fireprooflist.LAST_YN eq 'Y' || fireprooflist.RLAST == fireprooflist.RCNT}">
										<c:if test="${fireIndex < 4}">
											<c:set var="fireIndex" value="${fireIndex+1}" />
											<c:forEach begin="${fireIndex}" end="4" step="1"
												varStatus="status2">
												<td>
													<div class="fireproofItem">&nbsp;</div>
												</td>
												<c:set var="fireIndex" value="${fireIndex+1}" />
											</c:forEach>
										</c:if>
									</c:if>

									<c:if test="${fireIndex >= 4}">
										<c:if test="${fireprooflist.RNUM <= 4}">
											<td class="fireproofItem c"
												rowspan="${fireprooflist.ROWSPAN_CNT}">${fireprooflist.FIRETIME}
												시간</td>
										</c:if>
										<c:set var="fireIndex" value="0" />
										</tr>
									</c:if>

									<c:set var="fireIndex" value="${fireIndex + 1}" />
								</c:forEach>
							</table>

							<br />

							<!-- ATTACHMENT -->
							<table width="100%" cellpadding="0" cellspacing="0"
								style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid black;">
								<colgroup>
									<col width="15%" />
									<col width="85%" />
								</colgroup>
								<tbody>
									<tr style="border-bottom: 2px solid #000;">
										<th
											style="border-bottom: 2px solid #000; background-color: #f4f4b3; padding: 3px; font-weight: 600; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
											붙임서류</th>
										<!-- 반복 리스트로 해야함 -->
										<td>
											<table width="100%" border="0" cellpadding="0"
												cellspacing="0"
												style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed;">
												<colgroup>
													<col width="100%" />
												</colgroup>

												<tbody>
													<!-- 반복 리스트로 해야함 -->
													<!-- begin -->
													<tr>
														<td
															style="border-left: 1px solid #000; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; font-weight: 300; text-align: left; padding: 3px;">
															내화구조 인정서 사본, 내화구조 인정세부내용, 현장 시공상태 체크리스트 양식</td>
														</td>
													</tr>
													<!-- end -->
												</tbody>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

					</div>
					<!-- END container -->

				</div>
				<!-- END body -->

			</div>
			<!-- END wrapper -->
		</div>
		</div>
	</c:forEach>
</body>

</html>