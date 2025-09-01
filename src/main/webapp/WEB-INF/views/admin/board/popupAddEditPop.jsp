<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>
<%@ include file="/WEB-INF/views/include/admin/commonpop.jsp" %>

<script type="text/javascript">
var page_type = toStr('${page_type}'); // ADD/EDIT/VIEW
if('ADD' != page_type && 'EDIT' != page_type && 'VIEW' != page_type) window.open('about:blank', '_self').close();

$(function(){
	if('VIEW' == page_type){
		$('form[name="frmPop"]').find(':input,select,checkbox,radio').prop('disabled', true);
		$('form[name="frmPop"]').find('.closePopButtonClass').prop('disabled', false);
	}
	
	if('ADD' != page_type && 'VIEW' != page_type){
		//$('#select2-chosen-1').append(toStr('${csSalesMap.SALESUSER_NAME}')+'('+toStr('${csSalesMap.SALESUSERID}')+')'); // select2.js 소싱그룹 세팅.
		////$('input[type="checkbox"]').uniform('refresh');
	} //End.
	
	$('.dropify-filename-inner').each(function(i,e){
		var fileInputName = $(e).closest('li').find('input').attr('name');
		var fileName = '${popupOne.PU_IMAGE}';
		var fileType = '${popupOne.PU_IMAGETYPE}';

		var textHtml = '<a href="javascript:;" onclick=\'fileDown("'+fileName+'","'+fileType+'");\'>'+fileName+'</a>';

		$(e).html(textHtml);
	});

	// dropify 파일 확장자,크기 체크
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileExtension', function(evt, el){
		alert('gif,png,jpg,jpeg 파일만 업로드 할 수 있습니다.');
		evt.stopImmediatePropagation();
	});

	drEvent.on('dropify.error.fileSize', function(evt, el){
		alert('이미지는 10MB 이하로 등록해 주세요.');
		evt.stopImmediatePropagation();
	});

	initDatePicker();

	toggledByLinkuse('${popupOne.PU_LINKUSE}');
});

/**
 * 달력(datePicker) 설정
 */
function initDatePicker() {
	var $m_pusdate = $('input[name="m_pusdate"]'),
		$m_puedate = $('input[name="m_puedate"]');

	//시작일 데이트피커
	$m_pusdate.datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$m_puedate.datepicker('setStartDate', minDate);
	});

	//마감일 데이트피커
	$m_puedate.datepicker({
		language: 'kr',
		format : 'yyyy-mm-dd',
		todayHighlight: true,
		autoclose : true,
		clearBtn : true,
	}).on('changeDate', function (selected) {
		console.log('selected.date + '+selected.date);
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';
		$m_pusdate.datepicker('setEndDate', maxDate);
	});

	//수정 시 이전날짜 이후날짜 제한 설정
	var popup_sdate = '${popupOne.PU_SDATE}',
		popup_edate = '${popupOne.PU_EDATE}';

	if(popup_sdate){
		$m_pusdate.datepicker('setDate', popup_sdate);
		$m_puedate.datepicker('option','minDate',popup_sdate);
	}

	if(popup_edate){
		$m_puedate.datepicker('setDate', popup_edate);
		$m_pusdate.datepicker('option','maxDate',popup_edate);
	}
}

/**
 * 데이터 유효성 체크
 */
function dataValidation(){	
	var ckflag = true;
	
	if (ckflag && !$('input[name="m_putitle"]').val()) {
		alert('제목을 입력하여 주십시오.');
		$('input[name="m_putitle"]').focus();
		ckflag = false;
	}
	
	if('ADD' == page_type){
		if (ckflag && !$('input[name="m_puimage"]').val()) {
			alert('이미지를 등록해주세요.');
			ckflag = false;
		}	
	}
	
	if (ckflag && !$('input[name="m_pusdate"]').val()) {
		alert('시작일을 선택해주세요.');
		$('input[name="m_pusdate"]').focus();
		ckflag = false;
	}
	
	if (ckflag && !$('input[name="m_puedate"]').val()) {
		alert('종료일을 선택해주세요.');
		$('input[name="m_puedate"]').focus();
		ckflag = false;
	}
	
	if(ckflag) ckflag = validation($('input[name="m_puwidth"]')[0], 'width', 'value,num');
	if(ckflag) ckflag = validation($('input[name="m_puheight"]')[0], 'height', 'value,num');
	if(ckflag) ckflag = validation($('input[name="m_pux"]')[0], '좌표값 x', 'value,num');
	if(ckflag) ckflag = validation($('input[name="m_puy"]')[0], '좌표값 y', 'value,num');

	if('Y' == $('input:radio[name="m_pulinkuse"]:checked').val()){
		if(ckflag){
			if(ckflag) ckflag = validation($('input[name="m_pulink"]')[0], 'URL', 'value,url');
		}
	}
	
	return ckflag;
}

/**
 * 팝업관리 등록/수정
 */
function dataInUp(obj){
	$(obj).prop('disabled', true);

	if(!dataValidation()){
		$(obj).prop('disabled', false);
		return;
	}

	if(confirm('저장하시겠습니까?')){
		var $frmPop = $('form[name="frmPop"]')
		$frmPop.attr('action', '${url}/admin/board/insertUpdatePopupAjax.lime');

		$frmPop.ajaxForm({
			type : 'POST',
			cache : false,
			success: function(data) {

				if (data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					opener.reloadGridForPop();
					window.open('about:blank', '_self').close();
				}
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$(obj).prop('disabled', false);
			}
		}).submit();
	}else{
		$(obj).prop('disabled', false);
	}
}

/**
 * 파일다운로드
 */
function fileDown(file_name,file_type){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('file');

	// 파일 다운로드.
	var fileFormHtml = '';
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/popupFileDown.lime">';
	fileFormHtml += '	<input type="hidden" name="r_filename" value="'+file_name+'" />';
	fileFormHtml += '	<input type="hidden" name="r_filetype" value="'+file_type+'" />';
	fileFormHtml += '	<input type="hidden" name="filetoken" value="'+token+'" />';
	fileFormHtml += '</form>';
	fileFormHtml += '<iframe name="fileDownLoadIf" style="display:none;"></iframe>';
	$.download('frm_filedown', fileFormHtml); // common.js 위치.

	var fileTimer = setInterval(function() {
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
	}, 1000 );
}

/**
 * 링크여부에 따라 target,link 필드 숨김
 */
function toggledByLinkuse(val) {
	if('Y' === val){
		// $('select[name="m_putarget"]').prop('disabled', false);
		$('input[name="m_pulink"]').prop('disabled', false);
	}else{
		// $('select[name="m_putarget"]').prop('disabled', true);
		$('input[name="m_pulink"]').prop('disabled', true);
	}
}

/**
 * 팝업이미지 권장사이즈
 */
function setResMsg(bn_type) {
	var recMsg = '';
	if('1' === bn_type){
		recMsg = '* 좌표값(X) 값 300 , 사이즈(Width) 값이 800보다 크면 로그인영역이 가려질 수 있으니 유의하시기 바랍니다.';
	}else{
		recMsg = '';
	}

	$('#recMsgDivId').html(recMsg);
}
</script>
</head>

<body class="bg-n">
	
	<c:set var="text1" value="등록" />
	<c:set var="text2" value="저장" />
	<c:set var="text3" value="팝업등록" />
	<c:if test="${'EDIT' eq  page_type}">
		<c:set var="text1" value="수정" />
		<c:set var="text2" value="수정" />
		<c:set var="text3" value="팝업수정" />
	</c:if>
	<c:if test="${'VIEW' eq  page_type}">
		<c:set var="text1" value="확인" />
		<c:set var="text2" value="" />
		<c:set var="text3" value="팝업" />
	</c:if>
	
	<form name="frmPop" method="post" enctype="multipart/form-data">
		<input name="r_puseq" type="hidden" value="${param.r_puseq}" /> <%-- 수정시 필수 --%>
	
	<div class="modal fade in show">
		<div class="modal-dialog1">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close closePopButtonClass" onclick="window.close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
					<h4 class="modal-title" id="myModalLabel">
						${text3}
						<div class="btnList writeObjectClass">
							<button class="btn btn-info" onclick="dataInUp(this);" type="button" title="${text2}">${text2}</button>
						</div>
					</h4>
				</div>
				
				<div class="modal-body">
				
					<div class="tableSearch modal-view">
						<div class="topSearch">
							<ul>
								<li>
									<label class="search-h">제목 *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control"  name="m_putitle" value="${popupOne.PU_TITLE}" onkeyup="checkByte(this, 140);" maxlength="70"/>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_TITLE}
										</c:if>								
									</div>
								</li>
								<li class="b-t">
									<label class="search-h">구분 *</label>
									<div class="search-c radio">
										<c:if test="${'VIEW' ne page_type}">
										<c:if test="${popupOne.PU_TYPE eq '1' || empty popupOne }"><c:set var='disLogin' value="checked='checked'"/></c:if>
											<c:if test="${popupOne.PU_TYPE eq '2' }"><c:set var='disMain' value="checked='checked'"/></c:if>
										<label><input type="radio" name="m_putype" value="1" onclick="setResMsg(this.value)" ${disLogin}/>로그인</label>
										<label><input type="radio" name="m_putype" value="2" onclick="setResMsg(this.value)" ${disMain}/>메인화면</label>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											<c:if test="${popupOne.PU_TYPE eq '1'}" >로그인</c:if>
											<c:if test="${popupOne.PU_TYPE eq '2'}" >메인화면</c:if>
										</c:if>
									</div>
								</li>
								<li>
									<label class="search-h">이미지등록 *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="file" class="dropify" name="m_puimage" value="" <c:if test="${!empty popupOne.PU_IMAGE}">data-default-file="${url}/data/popup/${popupOne.PU_IMAGE}"</c:if>
												   data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" />
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											<a href="javascript:;" onclick="fileDown('${popupOne.PU_IMAGE}','${popupOne.PU_IMAGETYPE}')"><img src="${url}/data/popup/${popupOne.PU_IMAGE}" width="25" height="25" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" alt="img" />
												${popupOne.PU_IMAGE}
											</a>
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">시작일 *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control p-r-md" onkeyup="checkByte(this, 100);" name="m_pusdate" value="${popupOne.PU_SDATE}" readonly/>
											<i class="fa fa-calendar i-calendar"></i>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${fn:substring(popupOne.PU_SDATE,0,10)}
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">종료일 *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control p-r-md" onkeyup="checkByte(this, 100);" name="m_puedate" value="${popupOne.PU_EDATE}" readonly/>
											<i class="fa fa-calendar i-calendar"></i>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${fn:substring(popupOne.PU_EDATE,0,10)}
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">사이즈(Width) *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="m_puwidth" value="${popupOne.PU_WIDTH}" maxlength="4" />
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_WIDTH}
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">사이즈(Height) *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="m_puheight" value="${popupOne.PU_HEIGHT}" maxlength="4"/>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_HEIGHT}
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">좌표값(X) *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="m_pux" value="${popupOne.PU_X}" maxlength="4"/>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_X}
										</c:if>
									</div>
								</li>
								<li class="half">
									<label class="search-h">좌표값(Y) *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="m_puy" value="${popupOne.PU_Y}" maxlength="4"/>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_Y}
										</c:if>
									</div>
								</li>
								<li>
									<label class="search-h">링크 *</label>
									<div class="search-c radio">
										<c:if test="${'VIEW' ne page_type}">
											<c:if test="${popupOne.PU_LINKUSE eq 'Y' }"><c:set var='linkYes' value="checked='checked'"/></c:if>
											<c:if test="${popupOne.PU_LINKUSE eq 'N' || empty popupOne }"><c:set var='linkNo' value="checked='checked'"/></c:if>
											<label><input type="radio" onclick="toggledByLinkuse(this.value)" name="m_pulinkuse" value="Y" ${linkYes} />Yes</label>
											<label><input type="radio" onclick="toggledByLinkuse(this.value)" name="m_pulinkuse" value="N" ${linkNo} />No</label>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											<c:if test="${popupOne.PU_LINKUSE eq 'Y'}">YES</c:if>
											<c:if test="${popupOne.PU_LINKUSE eq 'N'}">NO</c:if>
										</c:if>
									</div>
								</li>
								<%--<li>
									<label class="search-h">TARGET</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<select class="form-control form-sm-l" name="m_putarget" disabled>
&lt;%&ndash;
											<option value="_blank" <c:if test="${ '_blank' eq  popupOne.PU_TARGET}">selected</c:if>>_blank</option>
											<option value="_self" <c:if test="${ '_self' eq  popupOne.PU_TARGET}">selected</c:if>>_self</option>
&lt;%&ndash;											<option value="_parent" <c:if test="${ '_parent' eq  popupOne.PU_TARGET}">selected</c:if>>_parent</option>&ndash;%&gt;
&lt;%&ndash;											<option value="_top" <c:if test="${ '_top' eq  popupOne.PU_TARGET}">selected</c:if>>_top</option>													&ndash;%&gt;
											</select>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_TARGET}
										</c:if>
									</div>
								</li>--%>
								<li>
									<label class="search-h">URL</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onkeyup="checkByte(this, 100);" name="m_pulink" value="${popupOne.PU_LINK}" disabled/>
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${popupOne.PU_LINK}
										</c:if>										
									</div>
								</li>
							</ul>
						</div>
					</div>

					<c:if test="${'VIEW' ne page_type}">
						<div class="m-t-xs f-red">* 이미지는 gif, png, jpg, jpeg 파일만 가능합니다.</div>
						<c:set var="recMsg" value=""/>
						<c:if test="${ popupOne.PU_TYPE eq '1' || empty popupOne }" ><c:set var="recMsg" value="* 로그인화면 팝업은 사이즈 가로 1000px 세로 900px 이하로 등록해주세요. "/></c:if><!--로그인 팝업 -->
						<c:if test="${ popupOne.PU_TYPE eq '2' }" ><c:set var="recMsg" value=""/></c:if><!--거래처메인1 배너 -->
						<div class="m-t-xs f-red" id="recMsgDivId">${recMsg}</div>
					</c:if>

				</div>
			</div>
		</div>
	</div>
	</form>
	
</body>
</html>