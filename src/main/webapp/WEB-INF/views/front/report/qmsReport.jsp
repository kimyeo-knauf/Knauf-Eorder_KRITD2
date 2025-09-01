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
<title>내화구조 품질관리서</title>
</head>
<script>
	function doPrint() {
		window.print();
	}

	function init() {
	} 
	
</script>
<body style="width: 100%; height: 100%; font-size:11px; padding: 0; margin: 0;" >
	<div class="btnDiv"
		style="width: 950px; margin-top: 5px; margin-bottom: 5px; text-align: right;">
		<button type="button" class="btn btn-line f-black" onclick="doPrint()">
			<i class="fa fa-print"></i> <em>인쇄</em>
		</button>
	</div>
	
	<c:forEach items="${reportList}" var="reportList" varStatus="reportListStatus">
		<c:set var="qmsPopDetlGridListCount" value="${fn:length(reportList.qmsPopDetlGridList)}" />
		
		<!-- MANUFACTURER -->
		<!-- BEGIN wrapper -->
		<div style="display: flex; page-break-before: always;">
			<div style="float: left; width: 100%; height: 100%; padding: 0 0 0px; margin: 0; background: #fff; ">
			
				<!-- BEGIN body -->
				<div style="clear: both; position: relative; width: 100%; height: 100%; background: #fff;">

					<!-- BEGIN container -->
					<div style="width: 100%;">
						<div style="float: left; margin: 30px 10px 10px; padding: 0 30px; border: 0px solid #fff;">
						
							<!-- 로고 및 보고서 제목 -->
							<!-- <img src="${url}/include/images/front/common/usg_boral_logo.png"
								alt="logo"
								style="position: relative; width: 150px; bottom: 0px; right: 7px" /> -->
							<h1 style="width: 100% !important; float: left; margin: 5px auto 5px; font-weight: 100; letter-spacing: 1px; font-size: 12px; text-align: left; display: inline-block; width: 100%; line-height: 10px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>◼ 건축물의 피난ㆍ방화구조 등의 기준에 관한 규칙[별지 제3호의2서식] <font color="blue"><신설 2021. 12. 23.></font></b></h1>
							<h1 style="width: 100% !important; float: left; margin: 5px auto 10px; font-weight: 100; letter-spacing: 1px; font-size: 20px; text-align: center; display: inline-block; width: 100%; line-height: 20px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
								<b>내화구조 품질관리서</b></h1>						
						
							<!-- QMS NUMBER 및 CREATE DATE -->
							<div style="float: right; border: 0px solid #fff; display: inline-block; margin-top: 0px; margin-bottom: -2px;">
								<c:forEach items="${reportList.qmsMastList}" var="mastlist" varStatus="status">
									<c:set var="qmsPopShiptoAddrLength" value="${fn:length(mastlist.SHIPTO_ADDR)}" />
									<c:set var="qmsPopCustNmLength" value="${fn:length(mastlist.CUST_NM)}" />
									<c:set var="qmsPopCnstrNmLength" value="${fn:length(mastlist.CNSTR_NM)}" />								
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 2px solid #000;">
										<colgroup>
											<col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" />
											<col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" />
											<col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" />
											<col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" /><col width="5%" />
										</colgroup>
										<tbody>
											<!-- 제출인(건축주) -->
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="4" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질관리서 번호</td>
												<td colspan="6" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<td colspan="4" style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질관리서 작성일자</td>
												<td colspan="6" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 2px">
													${fn:substring(mastlist.CREATETIME,0,4)}년
													${fn:substring(mastlist.CREATETIME,5,7)}월
													${fn:substring(mastlist.CREATETIME,8,11)}일</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="2" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													제출인<br />(건축주)</td>
												<td colspan="2"
													style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-size:10px; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명(법인명)</td>
												<td colspan="16"
													style="padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주소</td>
												<td colspan="11" style="border-left: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td colspan="5" style="padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													(전화번호: )</td>
											</tr>
											<!-- 공사현장 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="2" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													공사현장</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													현장명</td>
												<td colspan="16" style="padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.SHIPTO_NM}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													대지위치</td>
												<c:choose>
													<c:when test="${qmsPopShiptoAddrLength > 23}">
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:6px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:when>
													<c:when test="${qmsPopShiptoAddrLength > 16}">
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:8px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:when>
													<c:otherwise>
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:otherwise>
												</c:choose>
												
												<td colspan="2" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													지번</td>
												<c:choose>
													<c:when test="${qmsPopShiptoAddrLength > 23}">
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:6px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:when>
													<c:when test="${qmsPopShiptoAddrLength > 186}">
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:8px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:when>
													<c:otherwise>
														<td colspan="7" style="border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.SHIPTO_ADDR}</td>
													</c:otherwise>
												</c:choose>
											</tr>
											<!-- 자재개요 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="4" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													자재개요</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성능</td>
												<td colspan="16" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<c:choose>
														<c:when test="${mastlist.FIRETIME_05 eq 'Y'}">
															<input type="checkbox" checked>0.5시간&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">0.5시간&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													
													<c:choose>
														<c:when test="${mastlist.FIRETIME_10 eq 'Y'}">
															<input type="checkbox" checked>1시간&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">1시간&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													
													<c:choose>
														<c:when test="${mastlist.FIRETIME_15 eq 'Y'}">
															<input type="checkbox" checked>1.5시간&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">1.5시간&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													
													<c:choose>
														<c:when test="${mastlist.FIRETIME_20 eq 'Y'}">
															<input type="checkbox" checked>2시간&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">2시간&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													
													<c:choose>
														<c:when test="${mastlist.FIRETIME_30 eq 'Y'}">
															<input type="checkbox" checked>3시간&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">3시간&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사용부위</td>
												<td colspan="16" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">													
													<c:choose>
														<c:when test="${mastlist.BEAM_CHECK eq 'Y'}">
															<input type="checkbox" checked>보&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">보&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${mastlist.PILLAR_CHECK eq 'Y'}">
															<input type="checkbox" checked>기둥&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">기둥&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${mastlist.NONWALL_CHECK eq 'Y'}">
															<input type="checkbox" checked>비내력벽&nbsp;&nbsp;
														</c:when>
														<c:otherwise>
															<input type="checkbox">비내력벽&nbsp;&nbsp;
														</c:otherwise>
													</c:choose>
													<input type="checkbox">지붕&nbsp;&nbsp;
													<input type="checkbox">내력벽&nbsp;&nbsp;
													<input type="checkbox">바닥&nbsp;&nbsp;
													<input type="checkbox">기타 </td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													구조명</td>
												<td colspan="15" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.STRUCT_NM}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성적서번호<br />(품질인정번호)</td>
												<td colspan="15" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.Q_RECOG_NUM}</td>
											</tr>
											<!-- 자재 제조업자 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="4" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													자재<br />제조업자</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													송광섭</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													생년월일</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													710216</td>
												<td rowspan="4" colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; overflow: visible;">
													<div><input type="checkbox">성능을 갖춘 <input type="checkbox" checked>품질인정을 받은 내화구조 <u>&nbsp;&nbsp;(m<sup>2</sup>, m<sup>3</sup>, kg, L,개)</u>를 <input type="checkbox" checked>자재유통업자 <input type="checkbox">공사시공자에게 납품했음(수량 후첨부 참조)<br />
													<span style="font-size:10px;">*단위 : 벽체,지붕류(m<sup>2</sup>),목재류(m<sup>3</sup>),뿜칠(kg),도료(L),기타(개)</span></div>
													<div> &nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">년 &nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; height:70px; text-align:right;"><span>소속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;송광섭&nbsp;&nbsp;&nbsp;&nbsp;<img src="${url}/data/config/${reportList.configList.CEOSEAL}" alt="" style="position: relative; width: 72px; top:-10px; right: -30px;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></div></td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회사명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:9px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													크나우프 석고보드</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:10px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													법인등록번호</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													417-81-17256</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													로트번호</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													첨부참조</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주소</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div>전남 여수시 낙포동 197-20</div><div style="width: 100%; text-align: right;">(전화번호 : 02-6902-3100)</div></td>
											</tr>
											<!-- 자재 유통업자 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="4" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													자재<br />유통업자</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													생년월일</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td rowspan="4" colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div><input type="checkbox">성능을 갖춘 <input type="checkbox" checked>품질인정을 받은 내화구조 <u>&nbsp;&nbsp;(m<sup>2</sup>, m<sup>3</sup>, kg, L,개)</u>를 공사시공자에게 납품했음(수량 후첨부 참조)</div>
													<div> &nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">년 &nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">소속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회사명</td>
												<!-- <td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:5px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${qmsPopCustNmLength}</td>  -->
												<c:choose>
													<c:when test="${qmsPopCustNmLength > 11}">
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:6px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CUST_NM}</td>
													</c:when>
													<c:when test="${qmsPopCustNmLength > 8}">
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:8px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CUST_NM}</td>
													</c:when>
													<c:otherwise>
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:10px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CUST_NM}</td>
													</c:otherwise>
												</c:choose>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:10px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													법인등록번호</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.CUST_BIZ_NO}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													로트번호</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													첨부참조</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주소</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.CUST_ADDR}<div></div><div style="width: 100%; text-align: right;">(전화번호 : )</div></td>
											</tr>
											<!-- 공사시공자 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="3" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													공사<br />시공자</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													생년월일</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td rowspan="3" colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div><input type="checkbox">성능을 갖춘 <input type="checkbox" checked>품질인정을 받은 내화구조 <u>&nbsp;&nbsp;(m<sup>2</sup>, m<sup>3</sup>, kg, L,개)</u>를 
													<input type="checkbox">자재제조업자 <input type="checkbox" checked>자재유통업자로부터 인수했음(수량 후첨부 참조)</div>
													<div style="width:100%; text-align:right;">년 &nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">소속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<!-- <div>&nbsp;&nbsp;&nbsp;&nbsp;</div> -->
													<div><input type="checkbox">성능을 갖춘 <input type="checkbox" checked>품질인정을 받은 내화구조를 적정하게 시공했음</div>
													<div style="width:100%; text-align:right;">년 &nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">소속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													회사명</td>	
												<c:choose>
													<c:when test="${qmsPopCnstrNmLength > 10}">
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:6px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CNSTR_NM}</td>
													</c:when>
													<c:when test="${qmsPopCnstrNmLength > 7}">
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:8px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CNSTR_NM}</td>
													</c:when>
													<c:otherwise>
														<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:10px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
															${mastlist.CNSTR_NM}</td>
													</c:otherwise>
												</c:choose>	
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:10px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													법인등록번호</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.CNSTR_BIZ_NO}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													주소</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div>${mastlist.CNSTR_ADDR}</div><div style="width: 100%; text-align: right;">(전화번호 : ${mastlist.CNSTR_TEL})</div></td>
											</tr>
											<!-- 공사감리자 -->
											<tr style="border-bottom: 1px solid #000;">
												<td rowspan="3" colspan="2" style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													공사<br />감리자</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													성명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													자격번호</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.SUPVS_QLF_NO}</td>
												<td rowspan="3" colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; font-size:11px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div><input type="checkbox">성능을 갖춘 <input type="checkbox" checked>품질인정을 받은 내화구조를 적정하게 시공했음을 확인함</div>
													<div>&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">년 &nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</div>
													<div style="width:100%; text-align:right;">소속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;</div></td>												
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사무소명</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.SUPVS_NM}</td>
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													신고번호</td>
												<td colspan="3" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													${mastlist.SUPVS_DEC_NO}</td>
											</tr>
											<tr style="border-bottom: 1px solid #000;">
												<td colspan="2" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													사무소주소</td>
												<td colspan="8" style="border-left: 1px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													<div>${mastlist.SUPVS_ADDR}</div><div style="width: 100%; text-align: right;">(전화번호 : ${mastlist.SUPVS_TEL})</div></td>
											</tr> 
										</tbody>
									</table>
									
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border: 0px solid #000;">
										<colgroup>
											<col width="100%" />
										</colgroup>
										<tbody>
											<tr>
												<td style="padding: 5px; font-weight: 200; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												「건축법」 제52조의4, 같은 법 시행령 제62조제1항제4호 및 「건축물의 피난ㆍ방화구조 등의 기준에 관한 규칙」 제24조의3제2항제3호의2호에 따라 위와 같이 품질관리서를 제출합니다.
												</td>
											</tr>
											<tr>
												<td style="padding: 0px; font-weight: 200; text-align: right; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												년 &nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;일
												</td>
											</tr>
											<tr>
												<td style="padding: 0px; font-weight: 200; text-align: right; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												제출인(건축주) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)
												</td>
											</tr>
										</tbody>
									</table>
									
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 18px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border-bottom: 3px solid #000;">
										<colgroup>
											<col width="100%" />
										</colgroup>
										<tbody>
											<tr>
												<td style="padding: 5px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												<strong>특별시장ㆍ광역시장ㆍ특별자치시장ㆍ특별자치도지사, 시장ㆍ군수ㆍ구청장</strong><span style="font-size: 13px; "> 귀하</span>
												</td>
											</tr>
										</tbody>
									</table>
									
									<table width="100%" cellpadding="0" cellspacing="0"
										style="font-size: 12px; border-collapse: collapse; border-spacing: 0; table-layout: fixed; border-top: 3px solid #000;">
										<colgroup>
											<col width="100%" />
										</colgroup>
										<tbody>
											<tr>
												<td bgcolor="gray" style="padding: 0px; background-color: #a0a0a0; font-weight: 200; font-size:13px; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												<strong>비고</strong>
												</td>
											</tr>
											<tr>
												<td style="border-top:1px solid #000; border-bottom:1px solid #000; padding: 5px; font-weight: 200; font-size: 8px; text-align: left; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												1. 첨부서류: 내화성능 시간이 표시된 시험성적서(법 제52조의5제1항에 따라 품질인정을 받은 경우에는 품질인정서) 사본, 납품 품목 내역<br />
												2. 공사시공자와 공사감리자는 첨부된 시험성적서 또는 품질인정서의 위ㆍ변조 여부를 확인한 뒤 서명 또는 날인해야 합니다.<br />
												3. 공사감리자는 이 서식을 공사감리완료보고서에 첨부하여 건축주에게 제출해야 하며, 건축주는 「건축법」 제22조에 따른 사용승인을 신청할 때
												「건축법 시행규칙」 별지 제17호서식의 사용승인 신청서와 함께 제출해야 합니다.<br />
												4. 내화구조의 납품일 또는 시공완료일 등이 복수인 경우에는 이 서식을 각각 작성합니다.
												</td>
											</tr>
											<tr>
												<td style="padding: 5px; font-weight: 200; text-align: right; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
												210mm x 297mm[백상지 80g/m<sup>2</sup>]
												</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
							</div>
							
						</div>
					
					</div> 
					<!-- END container -->
				</div>
				<!-- END body -->
			</div>
		</div>
		<!-- SUPPLIER -->
		
		<!-- 품목정보 많은경우 추가 시작 -->
		<c:if test="${qmsPopDetlGridListCount > 0}">
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
									style="position: relative; height: 50px; bottom: 0px; right: 0px" />
									
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
													품질관리서 번호</th>
												<td
													style="font-family: 'NanumGothic', Dotum, 돋움, Sans-serif; text-align: center; padding: 0 6px;">
													${mastlist.QMS_ID}-${mastlist.QMS_SEQ}</td>
												<th
													style="border-left: 2px solid #000; border-right: 1px solid #000; padding: 3px; font-weight: 200; text-align: center; font-family: 'NanumGothic', Dotum, 돋움, Sans-serif;">
													품질관리서 작성일자</th>
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
							
							<c:if test="${qmsPopDetlGridListCount < 30}">
								<c:set var="blankLoopCount" value="${30-qmsPopDetlGridListCount}" />
								<c:forEach begin="0" end="${blankLoopCount}" step="1" varStatus="status">
									<div style="width:100%; height:30px;"></div>
								</c:forEach>	
							</c:if>

						</div>
						<!-- END body -->

					</div>
					<!-- END wrapper -->
				</div>
			</div>
		</c:if>
		<!-- 품목정보 많은경우 추가 종료 -->
		
	</c:forEach>
</body>
</html>