<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<%--
### 캐릭터셋 데이터 insert,select 테스트 => 웹:UTF-8, 오라클:KO16MSWIN949
### 캐릭터셋 한글 Byte => UTF-8:3Byte, KO16MSWIN949:2Byte => lime.js => use checkByte function.
### 버튼 더블클릭 방지. => $(obj).prop('disabled', true);
### jquery-confirm plugin 사용 안함 => 동기식 처리가 안되네... alert는 상관없는데 confirm 때문에 소스가 더러워질듯...
--%>

<script type="text/javascript">
$(function(){
	
});

function insertByForm(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	if(!confirm('저장 하시겠습니까?')){
		$(obj).prop('disabled', false);
		return;
	}
	
	formPostSubmit('', '${url}/test/insertTestByForm.lime');
	$(obj).prop('disabled', false);
}

function insertByAjax(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidation();
	if(!ckflag) {
		$(obj).prop('disabled', false);
		return;
	}
	
	if(!confirm('저장 하시겠습니까?')){
		$(obj).prop('disabled', false);
		return;
	}
	
	$.ajax({
		async : false,
		data : {
			m_ts1 : $('input[name="m_ts1"]').val()
			, m_ts2 : $('input[name="m_ts2"]').val()
			, m_ts3 : $('input[name="m_ts3"]').val()
		},
		type : 'POST',
		url : '${url}/test/insertTestByAjax.lime',
		success : function(data){
			if('0000' == data.RES_CODE){
				$('#listTbodyId').empty();
				var htmlBody = '';
				$(data.list).each(function(i,e){
					htmlBody += '<tr>';
					htmlBody += '	<td>'+e.ts_0+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_1)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_2)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_3)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_INDATE1)+'</td>';
					htmlBody += '	<td>'+toStr(e.ts_INDATE2)+'</td>';
					htmlBody += '</tr>';
				});
				$('#listTbodyId').append(htmlBody);

				alert(data.RES_MSG);
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('error');
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			$(obj).prop('disabled', false);
		}
	});
}

function dataValidation(){
	var ckflag = true;
	if(ckflag) ckflag = validation($('input[name="m_ts1"]')[0], '1번값', 'value');
	return ckflag;
}
</script>
</head>

<body>
	<form method="post" name="frm">
	<table border="1">
		<thead>
			<tr>
				<td colspan="3">### Insert.</td>
			</tr>
			<tr>
				<td style="text-align:center;">1</td>
				<td style="text-align:center;">2</td>
				<td style="text-align:center;">3</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<input class="" name="m_ts1" placeholder="필수값 -VARCHAR2(10)" type="text" value="" onkeyup="checkByte(this, 10);" />
				</td>
				<td>
					<input class="" name="m_ts2" placeholder="비밀번호-VARCHAR2(200)" type="text" value="" onkeyup="checkByte(this, 200);" />
				</td>
				<td>
					<input class="" name="m_ts3" placeholder="CLOB" type="text" value="" />
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<button type="button" onclick="insertByForm(this);">Insert By Form</button>
					<button type="button" onclick="insertByAjax(this);">Insert By Ajax</button>
				</td>
			</tr>
		</tbody>
	</table>
	
	<c:if test="${!empty list}">
	<br />
	<table border="1">
		<thead>
			<tr>
				<td colspan="6">### Get List.</td>
			</tr>
			<tr>
				<td style="text-align:center;">SEQ</td>
				<td style="text-align:center;">1</td>
				<td style="text-align:center;">2</td>
				<td style="text-align:center;">3</td>
				<td style="text-align:center;">DATE</td>
				<td style="text-align:center;">TIMESTAMP</td>
			</tr>
		</thead>
		<tbody id="listTbodyId">
			<c:forEach items="${list}" var="list">
			<tr>
				<td>${list.TS_0}</td>
				<td>${list.TS_1}</td>
				<td>${list.TS_2}</td>
				<td>${list.TS_3}</td>
				<td>${list.TS_INDATE1}</td>
				<td>${list.TS_INDATE2}</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:if>
	
	</form>
</body>
</html>