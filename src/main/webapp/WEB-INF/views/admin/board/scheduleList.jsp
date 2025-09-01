<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<link href='${url}/include/js/common/fullcalendar-3.9.0/fullcalendar.css' rel='stylesheet' />
<script src='${url}/include/js/common/fullcalendar-3.9.0/fullcalendar.js'></script>

<style>
/* input[readonly] {background-color:#E7E7E7;} */

</style>
<script type="text/javascript">

$(document).ready(function() {
	/*
	1.fullcalendar 기본으로 사용하는 date형식 ex) [date] Tue Apr 7 09:00:00 UTC+0900 2020
	2.서버와 주고 받는 데이트형식은 YYYY-MM-DD형식을 사용하기 때문에 moment.js의 format('YYYY-MM-DD') 메소드를 사용하여 dateformat 변환 후 사용
	*/
	$('#calendar').fullCalendar({
		navLinks: false, // can click day/week names to navigate views
		eventLimit: false, // allow "more" link when too many events
		locale:'ko',
		height: 640,
		displayEventTime : false,
		selectable: true,
		events: function(start, end, timezone, callback) {
			$.ajax({
				url: './getScheduleListAjax.lime',
				cache: false,
				dataType: 'json',
				data: {start: start.format('YYYY-MM-DD'), end: end.format('YYYY-MM-DD')}, // .format('YYYY-MM-DD')moment.js dateformat 변경
				type: 'GET',
				success: function (data) {
					var eventArr = [];

					$.each(data, function (key, val) {
						eventArr.push({
							id: val.id,
							// title: val.title,
							start: val.start
// 							end: val.end
						});
					});

					callback(eventArr);
				}
			})
		},
		select: function(selectedDayObj) {

			if (isWriteAuth) {
				addJob(selectedDayObj);
				$('#calendar').fullCalendar('unselect');

			}
		},
		eventClick: function(eventDateObj) {

			var sdate = eventDateObj.start.format('YYYY-MM-DD');
			viewDetail(sdate);
		}
	});


});

function viewDetail(sdate) {
	$.ajax({
		async : false,
		url : './getScheduleListByDateAjax.lime',
		cache : false,
		data : {r_scddate: sdate},
		type : 'POST',
		success : function(data) {
			$('#detailTbodyId').empty();
			$.each(data, function(key, val) {
				var trHtml = '<tr><td rowspan="2" class="vertical-top" style="display: none;">' + sdate + '</td>';
				trHtml += '<td>' + val.USER_NM;
				if (isWriteAuth) {
					trHtml += '<span class="modalBtnArea">';
					trHtml += '<a href="javascript:sendModify(\'' + val.SCD_SEQ + '\');" class="btn btn-info ModifyAClass writeObjectClass">수정</a>';
					trHtml += '<a href="javascript:sendDelete(this,\'' + val.SCD_SEQ + '\');" class="btn btn-default removeAClass writeObjectClass">삭제</a>';
					trHtml += '</span>';
				}
				trHtml += '</td></tr>';
				trHtml += '<tr><td class="vertical-top b-b">' + val.SCD_TITLE.replaceAll('\\n', '<br/>') + '</td></tr>';
				$('#detailTbodyId').append(trHtml);
			});
			$('#addAId').hide();
			$('#calModal').modal('show');
			$('#detailTbodyId').parent().addClass('schedule-view');
		}
	});
	
	var num = $('#detailTbodyId > tr').length;
	$('#detailTbodyId > tr').each(function(i) {
		$('#detailTbodyId').children(':first').children(':first').attr('rowspan', num);
		$('#detailTbodyId').children(':first').children(':first').css('display', 'table-cell');
	});
}

function sendModify(scd_seq) {
	$.ajax({
		async : false,
		url : './getScheduleOneAjax.lime',
		cache : false,
		data : {r_scdseq: scd_seq},
		type : 'POST',
		success : function(data) {
			$('#detailTbodyId').empty();
			$('#r_scdseq').val(scd_seq);
			var trHtml = '<tr><th>작성자</th><td>' + data.USER_NM + '</td></tr>';
			trHtml += '<tr><th>날짜</th><td>' + data.SCD_DATE.substring(0,10) + '</td></tr>';
			trHtml += '<tr><th>업무내용</th><td><textarea name="m_scdtitle" style="width:100%; height:200px;">' + data.SCD_TITLE + '</textarea></td></tr>';
			$('#detailTbodyId').append(trHtml);
			$('#addAId').show();
			$('#detailTbodyId').parent().removeClass('schedule-view');
		},
		error : function(request,status,error){
			alert('Error');
		}
	});
}

function closeDetail() {
	$('#calModal').modal('hide');
}

function sendDelete(obj,scd_seq) {
	if (confirm('삭제 하시겠습니까?')) {
		$.ajax({
			async : false,
			url : './deleteScheduleAjax.lime',
			cache : false,
			data : {r_scdseq : scd_seq},
			type : 'POST',
			success : function(data) {
				if (data.RES_CODE == '0000') {
					document.location.reload();
				}
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}
}

function sendSave(obj) {
	if(!$('textarea[name="m_scdtitle"]').val()){
		alert('내용을 입력해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}

	if (confirm('저장 하시겠습니까?')) {
		$(obj).prop('disabled', true);
		var formData = $('#frmpop').serialize();

		$.ajax({
			async : false,
			url : './insertUpdateScheduleAjax.lime',
			cache : false,
			data : formData,
			type : 'POST',
			success : function(data) {
				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					$('#calendar').fullCalendar('refetchEvents'); //새로고침
					$('#calModal').modal('hide');
				}
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		});
	}
}

function addJob(arg) {
	var dateHtml = '<input type="text" name="m_scddate" value="' + arg.format('YYYY-MM-DD') + '" style="width:100px;" readonly="readonly" />';
	var titleHtml = '<textarea name="m_scdtitle" style="width:100%; height:215px;"></textarea>';
	
	$('#detailTbodyId').empty();
	var trHtml = '<tr><th>작성자</th><td>${sessionScope.loginDto.userNm}</td></tr>';
	trHtml += '<tr><th>날짜</th><td>' + dateHtml + '</td></tr>';
	trHtml += '<tr><th>업무내용</th><td>' + titleHtml + '</td></tr>';
	$('#detailTbodyId').append(trHtml);
	$('#addAId').show();
	$('#calModal').modal('show');
	$('#detailTbodyId').parent().removeClass('schedule-view');
}
</script>
</head>
 
<body class="page-header-fixed compact-menu">
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					월간일정
					<div class="page-right">
						<%--
						<button type="button" class="btn btn-line text-default" title="검색"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onClick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
						<button type="button" class="btn btn-line text-default" title="엑셀다운로드"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
						 --%>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<form name="frm" method="POST">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body">
								
								<div id='calendar'></div>
								
							</div>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
				
				</form>
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
		
		<div class="modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" id="calModal">
			<div class="modal-dialog">
				<div class="modal-content">
					<form name="frmpop" id="frmpop" method="post" onsubmit="return false;">
					<input type="hidden" name="r_scdseq" id="r_scdseq" />

						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<h4 class="modal-title" id="myModalLabel">월간일정</h4>
						</div>
						<div class="modal-body monthDateH b-tb-1 no-p-r no-p-l">
							<table class="table dataTable no-b" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="25%" />
								<col width="*" />
							</colgroup>
							<tbody id="detailTbodyId">
							</tbody>
						</table>
						</div>
						<div class="modal-footer"> 
							<a id="addAId" href="javascript:sendSave(this);" class="btn btn-info writeObjectClass">저장</a>
							<!-- <a id="removeAId" href="javascript:sendDelete();" class="btn btn-default">삭제</a> -->
							<a href="javascript:closeDetail();" class="btn btn-default">닫기</a>
						</div>
					</form>
				</div>
			</div>
		</div>
		
	</main>
	<!-- //Page Content -->
	
</body>
</html>