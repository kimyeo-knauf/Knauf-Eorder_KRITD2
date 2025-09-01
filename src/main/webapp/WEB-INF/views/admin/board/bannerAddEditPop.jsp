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
		var fileInputName = $(e).closest('li').find('input').attr('name')
	        ,fileName
		    ,fileType;

		if('m_bnimage' === fileInputName ){
			fileName = '${bannerOne.BN_IMAGE}';
			fileType = '${bannerOne.BN_IMAGETYPE}';
		}else{
			fileName = '${bannerOne.BN_MOBILEIMAGE}';
			fileType = '${bannerOne.BN_MOBILEIMAGETYPE}';
		}

		var textHtml = '<a href="javascript:;" onclick=\'fileDown("'+fileName+'","'+fileType+'");\'>'+fileName+'</a>';
		$(e).html(textHtml);
	});

	// dropify 업로드 파일 사이즈
	var drEvent = $('.dropify').dropify();
	drEvent.on('dropify.error.fileExtension', function(evt, el){		
		alert('gif,png,jpg,jpeg 파일만 업로드 할 수 있습니다.');		
		evt.stopImmediatePropagation();
	});
	
	drEvent.on('dropify.error.fileSize', function(evt, el){		
		alert('이미지는 10MB 이하로 등록해 주세요.');
		evt.stopImmediatePropagation();
	});

	//초기화면 로그인 배너이미지 최적 사이즈 출력
	if('ADD' === page_type){
		setResMsg('1');
	}

	toggledByLinkuse('${bannerOne.BN_LINKUSE}');
});

/**
 * 데이터 유효성 체크
 */
function dataValidation(){
	var ckflag = true;
	
	if('ADD' == page_type){
		if (ckflag && !$('input[name="m_bnimage"]').val()) {
			alert('배너이미지를 등록해주세요.');
			ckflag = false;
		}

		var bn_type =  $('input:radio[name="m_bntype"]:checked').val();
		if('1' != bn_type ){
			if (ckflag && !$('input[name="m_bnmobileimage"]').val()) {
				alert('모바일 배너이미지를 등록해주세요.');
				ckflag = false;
			}
		}

		var gridReccount = opener.getGridReccount();
		var bn_type =  $('input:radio[name="m_bntype"]:checked').val();
		if(bn_type === '2' && gridReccount >= 2){
			alert('메인화면1 이미지는 최대 2개까지만 등록할 수 있습니다.');
			return;
		}
	}
	
	if('Y' == $('input:radio[name="m_bnlinkuse"]:checked').val()){
		if(ckflag){
			if(ckflag) ckflag = validation($('input[name="m_bnlink"]')[0], 'URL', 'value,url');
		}
	}

	return ckflag;
}

/**
 * 배너관리 등록/수정
 */
function dataInUp(obj){
	$(obj).prop('disabled', true);

	if(!dataValidation()){
		$(obj).prop('disabled', false);
		return;
	}

	if(confirm('저장하시겠습니까?')){
		var $frmPop = $('form[name="frmPop"]')
		$frmPop.attr('action', '${url}/admin/board/insertUpdateBannerAjax.lime');

		$frmPop.ajaxSubmit({
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
		})
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
	fileFormHtml += '<form name="frm_filedown" method="post" action="${url}/admin/board/bannerFileDown.lime">';
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
 * 배너이미지 권장사이즈
 */
function setResMsg(bn_type) {
	var recMsg = '';
	if('1' === bn_type){
		recMsg = '* 로그인화면 배너이미지 사이즈는 가로1190px, 세로979px 입니다.';
		$('#bannerMobile').hide();
	}else if ('2' === bn_type){
		recMsg = '* 거래처화면 메인1 배너이미지 사이즈는 가로1300px, 세로500px 입니다. (모바일 가로500px, 세로350px)';
		$('#bannerMobile').show();
	}else{
		recMsg = '* 거래처화면 메인2 배너이미지 사이즈는 가로1300px, 세로220px 입니다. (모바일 가로500px, 세로150px)';
		$('#bannerMobile').show();
	}

	$('#recMsgDivId').html(recMsg);
}

/**
 * 링크여부에 따라 URL 필드 숨김
 */
function toggledByLinkuse(val) {
	if('Y' === val){
		$('input[name="m_bnlink"]').prop('disabled', false);
	}else{
		$('input[name="m_bnlink"]').prop('disabled', true);
	}
}
</script>
</head>

<body class="bg-n">
	
	<c:set var="text1" value="등록" />
	<c:set var="text2" value="저장" />
	<c:set var="text3" value="전시배너 등록" />
	<c:if test="${'EDIT' eq  page_type}">
		<c:set var="text1" value="수정" />
		<c:set var="text2" value="수정" />
		<c:set var="text3" value="전시배너 수정" />
	</c:if>
	<c:if test="${'VIEW' eq  page_type}">
		<c:set var="text1" value="확인" />
		<c:set var="text2" value="" />
		<c:set var="text3" value="전시배너" />
	</c:if>
	
	<form name="frmPop" method="post" enctype="multipart/form-data">
		<input name="r_bnseq" type="hidden" value="${param.r_bnseq}" /> <%-- 수정시 필수 --%>
	
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
									<label class="search-h">구분 *</label>
									<div class="search-c radio more">
										<c:if test="${'VIEW' ne page_type}">
											<c:if test="${bannerOne.BN_TYPE eq '1' || empty bannerOne }"><c:set var='disLogin' value="checked='checked'"/></c:if>
											<c:if test="${bannerOne.BN_TYPE eq '2' }"><c:set var='disMain1' value="checked='checked'"/></c:if>
											<c:if test="${bannerOne.BN_TYPE eq '3' }"><c:set var='disMain2' value="checked='checked'"/></c:if>
											<label><input type="radio" name="m_bntype" onclick="setResMsg(this.value)" value="1" ${disLogin}/>로그인</label>
											<label><input type="radio" name="m_bntype" onclick="setResMsg(this.value)" value="2" ${disMain1}/>메인화면1</label>
											<label><input type="radio" name="m_bntype" onclick="setResMsg(this.value)" value="3" ${disMain2}/>메인화면2</label>
 										</c:if>

										<c:if test="${'VIEW' eq page_type}">
 											<c:if test="${bannerOne.BN_TYPE eq '1'}" >로그인</c:if>
											<c:if test="${bannerOne.BN_TYPE eq '2'}" >거래처메인1</c:if>
											<c:if test="${bannerOne.BN_TYPE eq '3'}" >거래처메인2</c:if>
 										</c:if>
									</div>
								</li>
								<li>
									<label class="search-h">배너이미지 *</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="file" class="dropify" name="m_bnimage" value="" <c:if test="${!empty bannerOne.BN_IMAGE}">data-default-file="${url}/data/banner/${bannerOne.BN_IMAGE}"</c:if>
												   data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" />
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											<c:if test="${!empty bannerOne.BN_IMAGE}">
												<a href="javascript:;" onclick="fileDown('${bannerOne.BN_IMAGE}','${bannerOne.BN_IMAGETYPE}')"><img src="${url}/data/banner/${bannerOne.BN_IMAGE}" width="25" height="25" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" alt="image">
													${bannerOne.BN_IMAGE}
												</a>
											</c:if>
										</c:if>
									</div>
								</li>
								<li id="bannerMobile" <c:if test="${bannerOne.BN_TYPE eq '1'}" >style="display: none;"</c:if>>
									<label class="search-h">모바일 배너이미지 * </label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="file" class="dropify" name="m_bnmobileimage" value="" <c:if test="${!empty bannerOne.BN_MOBILEIMAGE}">data-default-file="${url}/data/banner/${bannerOne.BN_MOBILEIMAGE}"</c:if>
												   data-max-file-size="10M" data-allowed-file-extensions='["gif", "png", "jpg", "jpeg"]' data-show-errors="false" />
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											<c:if test="${!empty bannerOne.BN_MOBILEIMAGE}">
												<a href="javascript:;" onclick="fileDown('${bannerOne.BN_MOBILEIMAGE}','${bannerOne.BN_MOBILEIMAGETYPE}')"><img src="${url}/data/banner/${bannerOne.BN_MOBILEIMAGE}" width="25" height="25" onerror="this.src='${url}/include/images/admin/list_noimg.gif'" alt="image">
														${bannerOne.BN_MOBILEIMAGE}
												</a>
											</c:if>
										</c:if>
									</div>
								</li>
								<li>
									<label class="search-h">링크 *</label>
									<div class="search-c radio">
										<c:if test="${'VIEW' ne page_type}">
											<c:if test="${bannerOne.BN_LINKUSE eq 'Y'  }"><c:set var='linkYes' value="checked='checked'"/></c:if>
											<c:if test="${bannerOne.BN_LINKUSE eq 'N' || empty bannerOne }"><c:set var='linkNo' value="checked='checked'"/></c:if>
											<label><input type="radio" name="m_bnlinkuse" onclick="toggledByLinkuse(this.value)" value="Y" ${linkYes}/>Yes</label>
											<label><input type="radio" name="m_bnlinkuse" onclick="toggledByLinkuse(this.value)" value="N" ${linkNo}/>No</label>
										</c:if>

										<c:if test="${'VIEW' eq page_type}">
											<c:if test="${bannerOne.BN_LINKUSE eq 'Y'}">YES</c:if>
											<c:if test="${bannerOne.BN_LINKUSE eq 'N'}">NO</c:if>											
										</c:if>
									</div>
								</li>
								<li>
									<label class="search-h">URL</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<c:if test="${empty bannerOne.BN_LINK}"><c:set var="m_bnlinkValue" value="http://"/></c:if>
											<c:if test="${!empty bannerOne.BN_LINK}"><c:set var="m_bnlinkValue" value="${bannerOne.BN_LINK}"/></c:if>
											<input type="text" class="form-control" onkeyup="checkByte(this, 100);" name="m_bnlink" onkeyup="checkByte(this, 150);" value="${m_bnlinkValue}" disabled/>
										</c:if>

										<c:if test="${'VIEW' eq page_type}">
											${bannerOne.BN_LINK}
										</c:if>
									</div>
								</li>
								<%-- TEXT HIDDEN
								<li>
									<label class="search-h">TEXT</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" onkeyup="checkByte(this, 20);" name="m_bntext"  onkeyup="checkByte(this, 150);"value="${bannerOne.BN_TEXT}" />
										</c:if>

										<c:if test="${'VIEW' eq page_type}">
											${bannerOne.BN_TEXT}
										</c:if>
									</div>
								</li>
								--%>
								<li>
									<label class="search-h">ALT 값</label>
									<div class="search-c">
										<c:if test="${'VIEW' ne page_type}">
											<input type="text" class="form-control" name="m_bnalt" onkeyup="checkByte(this, 100);" value="${bannerOne.BN_ALT}" />
										</c:if>
										<c:if test="${'VIEW' eq page_type}">
											${bannerOne.BN_ALT}
										</c:if>

									</div>
								</li>
							</ul>
						</div>
					</div>
					<c:if test="${'VIEW' ne page_type}">
						<c:set var="recMsg" value=""/>
						<c:if test="${bannerOne.BN_TYPE eq '1'}" ><c:set var="recMsg" value="* 로그인화면 배너이미지 사이즈는 가로1190px, 세로979px 입니다."/></c:if><!--로그인 배너 -->
						<c:if test="${bannerOne.BN_TYPE eq '2'}" ><c:set var="recMsg" value="* 거래처화면 메인1 배너이미지 사이즈는 가로1300px, 세로500px 입니다. (모바일 가로500px, 세로350px)"/></c:if><!--거래처메인1 배너 -->
						<c:if test="${bannerOne.BN_TYPE eq '3'}" ><c:set var="recMsg" value="* 거래처화면 메인2 배너이미지 사이즈는 가로1300px, 세로220px 입니다. (모바일 가로500px, 세로150px)"/></c:if><!--거래처메인2 배너 -->
						<div class="f-red f-s-16 display-inline" id="recMsgDivId">${recMsg}</div>
					</c:if>

				</div>
			</div>
		</div>
	</div>
	</form>
	
</body>
</html>