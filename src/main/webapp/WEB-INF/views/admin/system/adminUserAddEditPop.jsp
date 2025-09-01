<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<%-- <script type="text/javascript" src="${url}/include/js/select2/select2.js"></script> --%>
<%-- <link rel="stylesheet" href="${url}/include/js/select2/select2.css" /> --%>

<c:if test="${'VIEW' eq  page_type}">
<style type="text/css">
	.dropify-wrapper .dropify-message {display: none;}
	.modal .profile-img .dropify-wrapper .dropify-preview {margin-left: 50px;}
</style>
</c:if>

<script type="text/javascript">
var pate_type = toStr('${page_type}'); // ADD/EDIT/VIEW
if('ADD' != pate_type && 'EDIT' != pate_type && 'VIEW' != pate_type) window.open('about:blank', '_self').close(); 

$(function(){
	if('VIEW' == pate_type){
		$('form[name="frmPop"]').find(':input,select,checkbox,radio').prop('disabled', true);
		$('form[name="frmPop"]').find('.closePopButtonClass').prop('disabled', false);
		
		// 이렇게 까지...
		/* 
		$('form[name="frmPop"]').find(':input,select,checkbox,radio').each(function(i,e){
			//alert('nodeName : '+$(e)[0].nodeName+'\ntagName : '+$(e)[0].tagName);
			var nodeName = $(e)[0].nodeName;
			var nowElem = '';
			if('INPUT' == nodeName){
				if('text' == $(e).prop('type')){
					nowElem = $(e).val();
					$(e).parent().append(nowElem);
					$(e).remove();
				}
				if('radio' == $(e).prop('type')){
					nowElem = toStr($('input:radio[name="'+$(e).prop('name')+'"]:checked').val());
					if('' != nowElem){
						var pTd = $(e).closest('td');
						$(pTd).empty();
						$(pTd).append(nowElem);
					}
				}
				if('checkbox' == $(e).prop('type')){
					$('input:checkbox[name="'+$(e).prop('name')+'"]').each(function(i2,e2){
						if($(e2).is(':checked')){
							if('' == nowElem) nowElem = $(e2).val();
							else nowElem += ','+$(e2).val();
						}
					});
					var pTd = $(e).closest('td');
					$(pTd).empty();
					$(pTd).append(nowElem);
				}
				if('password' == $(e).prop('type')){
					$(e).remove();
				}
			}
			if('SELECT' == nodeName){
				nowElem = $('select[name="'+$(e).prop('name')+'"] option:selected').val();
				$(e).parent().append(nowElem);
				$(e).remove();
			}
		});
		 */
	}
	
	// initGroup();
	if('ADD' != pate_type && 'VIEW' != pate_type){
		//$('#select2-chosen-1').append(toStr('${csSalesMap.SALESUSER_NAME}')+'('+toStr('${csSalesMap.SALESUSERID}')+')'); // select2.js 소싱그룹 세팅.
		////$('input[type="checkbox"]').uniform('refresh');
	} //End.
});

// select2 JS Init.
// CS : 엽업 고정은 1:N 으로 고정은 1명만 가능한것이 아님 > CS 마이페이지에서 설정.
/* 
function initGroup() {
	$('#m_salesuserid').select2({ // 소싱그룹.
	    minimumInputLength: 2,
	    placeholder: '영업사원아이디 및 영업사원명을 입력해 주세요.',
	    ajax: {
	        url: "${url}/admin/base/getAdminUserListAjax.lime",
	        dataType: 'json',
	        quietMillis: 100,
	        data: function(term, page) {
	            return {
	            		ri_authority: 'SH,SM,SR',
	            		rl_name_code: term,
	            };
	        },
	        results: function(data, page) {
	            return {results: data}
	        }
	    },
	    formatResult: function(list) { 
	      return '<div>영업 '+list.AUTHORITY+' '+list.USER_NM+'('+list.USERID+')</div>';
	    },
	    formatSelection: function(list) {
	    	var csuserid = list.CSUSERID;
	   		var salesuserid = list.SALESUSERID;
	   		$('input[name="m_salesuserid"]').val(salesuserid);
	   		
	   		return salesuserid+'('+csuserid+')';
	   	},
	    id: function(list) {
	    	return list.SALESUSERID+'('+list.CSUSERID+')';
	    }
	});
}
*/

// 저장 또는 수정.
function inUpDataPop(obj){
	$(obj).prop('disabled', true);
	
	var ckflag = dataValidationPop();
	if(!ckflag){
		$(obj).prop('disabled', false);
		return;
	}
	
	confirmText = ('ADD' != pate_type) ? '수정 하시겠습니까?' : '저장 하시겠습니까?';
	
	if(confirm(confirmText)){
		$('form[name="frmPop"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/system/insertUpdateAdminUserAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					
					if('ADD' == pate_type) opener.reloadGridList();
					else opener.dataSearch();	
					
					window.open('about:blank', '_self').close();
				}
				$(obj).prop('disabled', false);
				return;
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			},
			/* 
			beforeSend: function(xhr){
				$('#ajax_indicator').show().fadeIn('fast');
			},
			uploadProgress: function(event, position, total, percentComplete){
			},
	        complete: function( xhr ){
	        	$('#ajax_indicator').fadeOut();
			}
			*/
		});
	}else{
		$(obj).prop('disabled', false);
	}
}

// 유효성 체크.
function dataValidationPop(){
	var ckflag = true;
	
	if(ckflag) ckflag = validation($('input[name="m_usernm"]')[0], '성명', 'value');
	if(ckflag) ckflag = validation($('input[name="m_cellno"]')[0], '휴대폰번호', 'value,phone');
	if(ckflag) ckflag = validation($('input[name="m_telno"]')[0], '전화번호', 'value,tel');
	if(ckflag) ckflag = validation($('input[name="m_useremail"]')[0], '이메일', 'value,email');
	
	if(ckflag && 'ADD' == pate_type){
		// 아이디 체크.
		if(ckflag) ckflag = validation($('input[name="m_userid"]')[0], '아이디', 'value');
		if(ckflag && $('input[name="m_userid"]').val() != $('input[name="c_dupcheckedid"]').val()) {
			alert('아이디 중복체크를 해주세요.');
			ckflag = false;
		}
		if(ckflag && $('input[name="h_exist"]').val() != 'N') {
			alert('잘못된 아이디입니다.');
			$('input[name="m_userid"]').focus();
			ckflag = false;
		}
		
		// 비밀번호 체크.
		if(ckflag && !passWordCheck('ADD', '0', 'm_userpwd', '')){ 
			ckflag = false; 
		}
	}
	
	if(ckflag && 'EDIT' == pate_type){
		if('' != $('input[name="m_userpwd"]').val()){
			if(!passWordCheck('EDIT', '0', 'm_userpwd', '')){ 
				ckflag = false; 
			}
		}
	}
	
	return ckflag;
}

// 아이디 체크.
function idCheck(obj) {
	$(obj).prop('disabled', true);
	
	var objVal = $('input[name="m_userid"]').val();
	objVal = objVal.replace(/ /gi, ""); // 아이디 공백제거.
	
	$('input[name="m_userid"]').val(objVal);
	$('input[name="c_dupcheckedid"]').val(objVal);
	
	var ckflag = true;
	if(ckflag) ckflag = validation($('input[name="m_userid"]')[0], '아이디', 'value,userid');
	if(!ckflag){
		$('input[name="m_userid"]').val('');
		$(obj).prop('disabled', false);
		return;	
	}
	
	$.ajax({
		async : false,
		url : '${url}/common/checkUserIdAjax.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : {
			r_userid : objVal
		},
		success : function(data){
			if('0000' == data.RES_CODE){
				alert('사용 가능한 아이디 입니다.');
				$('input[name="h_exist"]').val("N");
			}
			else{
				//alert(data.RES_MSG);
				$('input[name="h_exist"]').val("Y");
				$('input[name="m_userid"]').focus();
			}
			$(obj).prop('disabled', false);
		},
		error : function(request,status,error){
			alert('Error');
			$(obj).prop('disabled', false);
		}
	});
}
</script>
</head>

<body class="bg-n">
	
	<c:set var="text1" value="등록" />
	<c:set var="text2" value="저장" />
	<c:if test="${'EDIT' eq  page_type}">
		<c:set var="text1" value="수정" />
		<c:set var="text2" value="수정" />
	</c:if>
	<c:if test="${'VIEW' eq  page_type}">
		<c:set var="text1" value="확인" />
		<c:set var="text2" value="" />
	</c:if>
	
	<form name="frmPop" method="post" enctype="multipart/form-data">
	<input name="r_parentuserid" type="hidden" value="${param.r_parentuserid}" /> <%-- 등록/수정시 필수 --%>
	<input name="r_userid" type="hidden" value="${param.r_userid}" /> <%-- 수정시 필수 --%>
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close closePopButtonClass" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						내부 사용자 ${text1}
						<div class="btnList writeObjectClass">
							<button class="btn btn-gray" onclick="inUpDataPop(this);" type="button" title="${text2}">${text2}</button>
						</div>
					</h4>
				</div>
				<div class="modal-body">
					<div class="table-responsive">
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="25%" />
								<col width="18%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<td rowspan="6" class="profile-img">
										<input type="file" class="dropify" name="m_userfile" value="" <c:if test="${!empty adminUser.USER_FILE}">data-default-file="${url}/data/user/${adminUser.USER_FILE}"</c:if> />
									</td>
									<th>권한 및 상위단계</th>
									<td>
										<c:if test="${'AD' eq parentAdminUser.AUTHORITY}">관리</c:if>
										<c:if test="${'CS' eq parentAdminUser.AUTHORITY}">CS</c:if>
										<c:if test="${'MK' eq parentAdminUser.AUTHORITY}">마케팅</c:if>
										<c:if test="${'SH' eq parentAdminUser.AUTHORITY or 'SM' eq parentAdminUser.AUTHORITY or 'SR' eq parentAdminUser.AUTHORITY}">
											영업 ${parentAdminUser.AUTHORITY} ${parentAdminUser.USER_NM}
										</c:if>
										<c:if test="${'QM' eq parentAdminUser.AUTHORITY}">QMS</c:if>
										<c:if test="${'CI' eq parentAdminUser.AUTHORITY}">CI</c:if>
										<%-- 
										<select class="w-md" name="" disabled="disabled">
											<option value="">${parentAdminUser.AUTHORITY}</option>
										</select>
										 --%>
									</td>
								</tr>
								<tr>
									<th>성명 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 40);" name="m_usernm" value="${adminUser.USER_NM}"  />
									</td>
								</tr>
								<tr>
									<th>직책</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 100);" name="m_userposition" value="${adminUser.USER_POSITION}" />
									</td>
								</tr>
								<tr>
									<th>휴대폰번호 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_cellno" value="${adminUser.CELL_NO}" placeholder="숫자만 입력해 주세요." />
										<c:if test="${!empty adminUser.CELL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
									</td>
								</tr>
								<tr>
									<th>전화번호 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 20);" name="m_telno" value="${adminUser.TEL_NO}" placeholder="숫자만 입력해 주세요." />
										<c:if test="${!empty adminUser.TEL_NO}"><span class="warning">※ 숫자만 입력해 주세요.</span></c:if>
									</td>
								</tr>
								<tr>
									<th>이메일 *</th>
									<td>
										<input type="text" class="w-md" onkeyup="checkByte(this, 50);" name="m_useremail" value="${adminUser.USER_EMAIL}" />
									</td>
								</tr>
								<%-- 
								<tr>
									<th>selectbox</th>
									<td colspan="3">
										<select name="a1">
											<option value="0">선택하세요</option>
											<option value="111">111</option>
											<option value="222" selected="selected">222</option>
											<option value="333">333</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>radio</th>
									<td colspan="3">
										<input type="radio" name="a2" value="A2-1" />A2-1
										<input type="radio" name="a2" value="A2-2" checked="checked" />A2-2
										<input type="radio" name="a2" value="A2-3" />A2-3
									</td>
								</tr>
								<tr>
									<th>checkbox</th>
									<td colspan="3">
										<input type="checkbox" name="a3" value="A3-1" />A3-1
										<input type="checkbox" name="a3" value="A3-2" checked="checked" />A3-2
										<input type="checkbox" name="a3" value="A3-3" checked="checked" />A3-3
									</td>
								</tr>
								--%>
							</tbody>
						</table>
						
						<h5>계정</h5>
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="15%" />
								<col width="35%" />
								<col width="15%" />
								<col width="35%" />
							</colgroup>
							<tbody>
								<tr>
									<th>아이디 *</th>
									<td>
										<input type="hidden" name="c_dupcheckedid" value="" /><%--중복체크한 ID--%>
										<input type="hidden" name="h_exist" value="" />
										
										<input type="text" <c:if test="${'ADD' eq page_type}">class="w-65"</c:if> name="m_userid" value="${adminUser.USERID}" <c:if test="${'ADD' ne page_type}">readonly="readonly"</c:if> onkeyup="checkByte(this, 10);" />
										<c:if test="${'ADD' eq page_type}">
											<button type="button" class="btn btn-default btn-xs m-r-xs" onclick="idCheck(this);" >중복체크</button>
										</c:if>
									</td>
									<th>비밀번호 *</th>
									<td>
										<input type="password" name="m_userpwd" value="" placeholder="6~16자리 영문,숫자,특수문자 조합" />
									</td>
								</tr>
							</tbody>
						</table>
						
						<%-- CS : 엽업 고정은 1:N 으로 고정은 1명만 가능한것이 아님 > CS 마이페이지에서 설정. --%>
						<%-- 
						<c:if test="${'CS' eq parentAdminUser.AUTHORITY}">
						<h5>영업담당</h5>
						<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="15%" />
								<col width="35%" />
								<col width="15%" />
								<col width="35%" />
							</colgroup>
							<tbody>
								<tr>
									<th>담당자</th>
									<td colspan="3">
										<input type="text" class="w-81" name="m_salesuserid" id="m_salesuserid" value="${csSalesMap.SALESUSERID}" maxlength="30" />
										<i class="fa fa-search i-search"></i>
										<span class="rest">* 고정은 1명만 가능합니다.</span>
									</td>
								</tr>
							</tbody>
						</table>
						</c:if>
						--%>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
	
</body>
</html>