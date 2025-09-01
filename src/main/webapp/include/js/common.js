var gridEmptyText = '<div class="emptyData" id="gridEmptyDataDivId">No Data Found.</div>';
$(function() {
	initAutoNumeric(); // autoNumeric initialize.
	$('input').attr('autocomplete', 'off');
});

/**
 * autoNumeric
 * - aSep: 1000단위 구분기호
 * - aPad: true=소수점자리를 무조건 0으로 채움
 * - mDec: 0=숫자만표시
 * - lZero : allow=입력할때 앞에오는 0을 허용하지만 focusout될때 제거, deny=앞에오는0거부, keep=앞에오는0을 계속허용하고 focusout될때도 허용.
 */
var aNAmountOption = {vMin: '-999999999999.99', vMax: '999999999999.99', aSep:',', aPad:false}; //수량  : 소수점 2자리. 양수,음수 둘다.
var aNAmountOption2 = {vMin: '0', vMax: '999999999999.99', aSep:',', aPad:false}; //수량  : 소수점 2자리. 양수만.
var aNMoneyOption = {vMin: '-999999999999.9999', vMax: '999999999999.9999', aSep:',', aPad:false}; //금액 : 소수점 4자리. 양수,음수 둘다.
var aNMoneyOption2 = {vMin: '0', vMax: '999999999999.9999', aSep:',', aPad:false}; //금액 : 소수점 4자리. 양수만.
var aNNumberOption = {vMin: '0', mDec: '0', lZero:'keep', aSep:'', aPad:false}; //오직 정수>양수만, 천단위 구분기호 없음.
var aNNumber2Option = {vMin: '0', mDec: '0', lZero:'keep', aSep:',', aPad:false}; //오직 정수>양수만, 천단위 구분기호 있음.
function initAutoNumeric(){
	$('.amountClass').autoNumeric('init', aNAmountOption); //수량 소수점 2자리. 양수,음수 둘다.
	$('.amountClass2').autoNumeric('init', aNAmountOption2); //수량 소수점 2자리. 양수만.
	$('.moneyClass').autoNumeric('init', aNMoneyOption); //금액 소수점 4자리. 양수,음수 둘다.
	$('.moneyClass2').autoNumeric('init', aNMoneyOption2); //금액 소수점 4자리. 양수만.
	$('.numberClass').autoNumeric('init', aNNumberOption); //오직 정수>양수만, 천단위 구분기호 없음.
	$('.number2Class').autoNumeric('init', aNNumber2Option); //오직 정수>양수만, 천단위 구분기호 있음.
}
function destroyAutoNumeric(){
	$('.amountClass').autoNumeric('destroy');
	$('.amountClass2').autoNumeric('destroy');
	$('.moneyClass').autoNumeric('destroy');
	$('.moneyClass2').autoNumeric('destroy');
	$('.numberClass').autoNumeric('destroy');
	$('.number2Class').autoNumeric('destroy');
}
function initJqGridAutoNumeric(opt, textAlign){ //jqgrid dataInit
	if('undefined' == typeof textAlign || '' == textAlign) textAlign = 'left';
	return function(el) {
		$(el).autoNumeric('init', opt);
		$(el).css('text-align', textAlign);
	}
}

/**
 * 파일 다운로드. 
 */
$.download = function(fileFormName, fileFormHtml){
	$('body').append(fileFormHtml);
	$('form[name="'+fileFormName+'"]').prop('target', 'fileDownLoadIf').submit().remove();
};

var getFileToken = function(f_type){
	var d = new Date();
	if('excel' == f_type) return 'EX'+d.getTime();
	else return 'FI'+d.getTime();
}

/**
 * # 주의사항 #
 * addr1_name & addr2_name의 각각 필드길이가 40byte로 제한적이다.
 * 두 개의 필드를 합쳐서 addr1_name에 40byte를 뿌리고 addr2_name에 나머지 40byte로 뿌려줘야 한다.
 * 
 * 우편번호 팝업 By Input Name
 * zone_name : 우편번호(5자리) Input Name
 * addr1_name : 주소 Input Name > 40byte
 * addr2_name : 상세주소 Input Name > 40byte
 * zip_name : 우편번호(6자리) Input Name
 */
function openPostPop2(zone_name, addr1_name, addr2_name, zip_name, max_byte){
	 new daum.Postcode({
        oncomplete: function(data) {
            var fullAddr = '';
            var extraAddr = '';
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;
            } else {
                fullAddr = data.jibunAddress;
            }
            if(data.userSelectedType === 'R'){
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }
            
            $('input[name="'+zone_name+'"]').val(data.zonecode);
            
            var returnFullAddrArr = getStrByMaxByte(fullAddr, max_byte);
            $('input[name="'+addr1_name+'"]').val(returnFullAddrArr[0]);
            $('input[name="'+addr2_name+'"]').val(returnFullAddrArr[1]);
            
            if('' != toStr(zip_name)){
            	$('input[name="'+zip_name+'"]').val(data.postcode);
            }
            if('' != toStr(addr2_name)){
            	$('input[name="'+addr2_name+'"]').focus();
            }
        }
	 }).open({popupName: 'postPop'});
	// open({q: [검색어], left: [팝업위치 x값], top: [팝업위치 y값], popupName: [팝업이름], autoClose: [자동닫힘유무]})
}

/**************************************************************************************
 * Start. 다음 우편번호 레이어 팝업.
 **************************************************************************************/
//var daum_post_layer = document.getElementById('post_layer');
function openPostPop2_layer(zone_name, addr1_name, addr2_name, zip_name, max_byte){
	new daum.Postcode({
        oncomplete: function(data) {
            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                
                addr += (extraAddr !== '' ? ' '+ extraAddr +'' : '');
                //addr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                
                // 조합된 참고항목을 해당 필드에 넣는다.
                //document.getElementById("sample2_extraAddress").value = extraAddr;
            
            } else {
                //document.getElementById("sample2_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('input[name="'+zone_name+'"]').val(data.zonecode);
            //document.getElementById('sample2_postcode').value = data.zonecode;
            
            var returnFullAddrArr = getStrByMaxByte(addr, max_byte);
			$('input[name="'+addr1_name+'"]').val(returnFullAddrArr[0]);
			$('input[name="'+addr2_name+'"]').val(returnFullAddrArr[1]);
            //document.getElementById("sample2_address").value = addr;
			
			if('' != toStr(zip_name)){
				$('input[name="'+zip_name+'"]').val(data.postcode);
			}
			if('' != toStr(addr2_name)){
				$('input[name="'+addr2_name+'"]').focus();
			}

            // iframe을 넣은 element를 안보이게 한다.
            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
			$('#post_layer').css('display', 'none');
        },
        width : '100%',
        height : '100%',
        maxSuggestItems : 5
    }).embed($('#post_layer')[0]);

    // iframe을 넣은 element를 보이게 한다.
    $('#post_layer').css('display', 'block');

    // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
    initLayerPosition();
}

//우편번호 찾기 화면을 넣을 element
function closeDaumPostcode() {
    // iframe을 넣은 element를 안보이게 한다.
	$('#post_layer').css('display', 'none');
}

// 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
// 직접 $('#post_layer')[0]의 top,left값을 수정해 주시면 됩니다.
function initLayerPosition(){
    var width = 340; //우편번호서비스가 들어갈 element의 width
    var height = 470; //우편번호서비스가 들어갈 element의 height
    var borderWidth = 1; //샘플에서 사용하는 border의 두께

    // 위에서 선언한 값들을 실제 element에 넣는다.
    $('#post_layer').css('width', width+'px');
    $('#post_layer').css('height', height+'px');
    $('#post_layer').css('border', borderWidth + 'px solid');
    
    // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
    $('#post_layer').css('left', (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px');
    // $('#post_layer').css('top', (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px');
}

/**************************************************************************************
 * END. 다음 우편번호 레이어 팝업.
 **************************************************************************************/

/**
 * 우편번호 팝업 By Input Name
 * zone_name : 우편번호(5자리) Input Name
 * addr1_name : 주소 Input Name > 40byte
 * addr2_name : 상세주소 Input Name > 40byte
 * zip_name : 우편번호(6자리) Input Name
 */
function openPostPop(zone_name, addr1_name, addr2_name, zip_name){
	 new daum.Postcode({
        oncomplete: function(data) {
            var fullAddr = '';
            var extraAddr = '';
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;
            } else {
                fullAddr = data.jibunAddress;
            }
            if(data.userSelectedType === 'R'){
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }
            
            $('input[name="'+zone_name+'"]').val(data.zonecode);
            $('input[name="'+addr1_name+'"]').val(fullAddr);
            if('' != toStr(zip_name)){
            	$('input[name="'+zip_name+'"]').val(data.postcode);
            }
            if('' != toStr(addr2_name)) $('input[name="'+addr2_name+'"]').focus();
        }
	 }).open({popupName: 'postPop'});
	// open({q: [검색어], left: [팝업위치 x값], top: [팝업위치 y값], popupName: [팝업이름], autoClose: [자동닫힘유무]})
}

/**
 * 우편번호 팝업 By Input Id 
 * zone_id : 우편번호(5자리) input Id
 * addr1_id : 주소 input Id
 * addr2_id : 상세주소 input Id
 * zip_id : 우편번호(6자리) input Id
 */
function openPostPopById(zone_id, addr1_id, addr2_id, zip_id){
	 new daum.Postcode({
        oncomplete: function(data) {
            var fullAddr = '';
            var extraAddr = '';
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;
            } else {
                fullAddr = data.jibunAddress;
            }
            if(data.userSelectedType === 'R'){
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }
            
            $('#'+zone_id).val(data.zonecode);
            $('#'+addr1_id).val(fullAddr);
            if('' != toStr(zip_id)){
            	$('#'+zip_id).val(data.postcode);
            }
            
            if('' != toStr(addr2_id)) $('#'+addr2_id).focus();
        }
    }).open({popupName: 'postPop'});
	// open({q: [검색어], left: [팝업위치 x값], top: [팝업위치 y값], popupName: [팝업이름], autoClose: [자동닫힘유무]})
}

function confirmView(confirm_msg){
	$.confirm({
	    title: '',
	    content: confirm_msg,
	    buttons: {
	        confirm: function () {
	        	return true;
	        },
	        cancel: function () {
	        	return false;
	        },
	    }
	});
}

