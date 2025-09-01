function escapeXss(str) {
	$('body').append('<span id="xssSpanId" style="display:none;"></span>');
	$('#xssSpanId').html(str);
	var res = $('#xssSpanId').text();
	$('#xssSpanId').remove();
	return res;
}

function isApp(){
	// APP인 경우.
	if(navigator.userAgent.toLowerCase().indexOf('mobileapp') != -1 || navigator.userAgent.toLowerCase().indexOf('iosapp') != -1){
	    return true;
	}
	// WEB인 경우.
	return false;
}

/***
 * Validation Check
 **/
function validation(obj, msg, flag, lastMsg){ 
	var data = obj.value;
	var josa = '';//조사
	
	var userid_reg = /^[A-Za-z0-9+]*$/; // 아이디 : 영문,숫자,영문+숫자
	//var userid_reg = /^[A-Za-z0-9+]{4,12}$/;
	var email_reg = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
	//var email_reg = /^[\w]([-_\.]?[\w])*@[\w]([-_\.]?[\w])*\.[\w]{2,3}$/i; //이메일
	
	var epost1_reg = /^[\w]([-_\.]?[\w])*$/i; //이메일 앞
	var epost2_reg = /^[\w]([-_\.]?[\w])*\.[\w]{2,3}$/i; //이메일 뒤
	var tel_reg = /^0[\d]{1,2}[\d]{3,4}[\d]{4}$/; //일반전화번호'-' 제외
	var phone_reg = /^01[\d]{1}[\d]{3,4}[\d]{4}$/; //휴대폰 '-' 제외
	var alltlp_reg = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?[0-9]{3,4}?[0-9]{4}$/; // 휴대폰+일반전화번호+050+070 체크, '-' 제외
	var biznum_reg = /[\d]{3}[\d]{2}[\d]{5}$/; //사업자번호 자리수 체크 '-' 제외
	var date_reg = /^[\d]{4}-[\d]{2}-[\d]{2}$/; //날짜 YYYY-MM-DD
	var yyyymmdd_reg = /^[\d]{4}-[\d]{2}-[\d]{2}$/; //날짜 YYYYMMDD
	var time_reg = /^[\d]{2}:[\d]{2}:[\d]{2}$/; //시간 00:00:00
	
	var kor_reg = /[^ㄱ-ㅎㅏ-ㅣ가-힣]/; //한글만 허용
	var num_reg = /[^\d]/; //숫자만 허용
	var npoint_reg = /^-?(\d{1,3}([.]\d{0,2})?)?$/; //정수부분 3자리 소수점아래 둘쨰자리까지 허용
	var eng_reg = /[^\w\_\-\[\]\(\)]/; // 영어-대소문자 모두 허용
	var enn_reg = /[^A-Za-z0-9]/; //영문-대소문자 모두와 숫자만 허용
	var notspc_reg = /[^\wㄱ-ㅎㅏ-ㅣ가-힣\(\)\-\,\s\.\[\]\-\_\/\?]/; //특수문자 불가
	
	var img_reg = /\.gif$|\.jpg$|\.png$/i; //이미지
	var atc_reg = /\.gif$|\.jpg$|\.jpeg$|\.png$|\.doc$|\.xls$|\.xlsx$|\.ppt$|\.pptx$|\.pdf$|\.hwp$|\.txt$/i;	//첨부파일
	var url_reg = /(?:(?:(https?|ftp|telnet):\/\/|[\s\t\r\n\[\]\`\<\>\"\'])((?:[\w$\-_\.+!*\'\(\),]|%[0-9a-f][0-9a-f])*\:(?:[\w$\-_\.+!*\'\(\),;\?&=]|%[0-9a-f][0-9a-f])+\@)?(?:((?:(?:[a-z0-9\-가-힣]+\.)+[a-z0-9\-]{2,})|(?:[\d]{1,3}\.){3}[\d]{1,3})|localhost)(?:\:([0-9]+))?((?:\/(?:[\w$\-_\.+!*\'\(\),;:@&=ㄱ-ㅎㅏ-ㅣ가-힣]|%[0-9a-f][0-9a-f])+)*)(?:\/([^\s\/\?\.:<>|#]*(?:\.[^\s\/\?:<>|#]+)*))?(\/?[\?;](?:[a-z0-9\-]+(?:=[^\s:&<>]*)?\&)*[a-z0-9\-]+(?:=[^\s:&<>]*)?)?(#[\w\-]+)?)/gmi;
	
	if(flag.indexOf("value") > -1 && data == ''){
		if ( 'Y' == checkBatChimYn( msg ) ) josa = '을';
		if ( 'N' == checkBatChimYn( msg ) ) josa = '를';
		if('' == toStr(lastMsg)) lastMsg = "입력해 주세요.";
		alert(msg+josa+' '+lastMsg);
		obj.focus();
		return false;
	}
	
	if(data != ''){
		if(flag.indexOf("userid") > -1){
			if(!userid_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.\n영문,숫자 또는 영문+숫자만 입력해 주세요.");
				obj.focus();
				return false;
			}
		}
		if(flag.indexOf("email") > -1){
			if(!email_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		if(flag.indexOf("epost1") > -1){
			if(!epost1_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		if(flag.indexOf("epost2") > -1){
			if(!epost2_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
	
		if(flag.indexOf("tel") > -1){
			if(!tel_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("phone") > -1){
			if(!phone_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("alltlp") > -1){
			if(!alltlp_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("biznum") > -1){
			if(!biznum_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다. ('-'를 빼고 입력해 주세요.)");
				obj.focus();
				return false;
			}
		}
		
		// 사업자등록번호 유효한지 체크 : '-' 제외한 10자리 입력
		if(flag.indexOf("biznumacc") > -1){
			var c1 = data.substring(0,1); 
			var c2 = data.substring(1,2); 
			var c3 = data.substring(2,3); 
			var c4 = data.substring(3,4); 
			var c5 = data.substring(4,5); 
			var c6 = data.substring(5,6); 
			var c7 = data.substring(6,7); 
			var c8 = data.substring(7,8); 
			var c9 = data.substring(8,9); 
			var c10 = data.substring(9,10); 
			  
			var a1 = (c1*1)+(c2*3)+(c3*7)+(c4*1)+(c5*3)+(c6*7)+(c7*1); 
			var a2 = a1 % 10; 
			var a3 = (c8 * 3) % 10; 
			var a4 = c9 * 5; 
			var a5 = Math.round(a4/10-0.5); 
			var a6 = a4 - (a5*10); 
			var a7 = (a2+a3+a5+a6) % 10; 
			var a8 = (10 - a7) % 10; 

			if (a8 != c10){
				alert('정확한 사업자등록번호를 입력해 주세요.');
				obj.focus();
				return false;
			}
			return true; 
		}
		
		if(flag.indexOf("date") > -1){
			if(!date_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.(YYYY-MM-DD)");
				obj.focus();
				return false;
			}
			if(!isValidDate(data)){
				alert(msg+" 값이 정확하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("yyyymmdd") > -1){
			if(!date_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.(YYYYMMDD)");
				obj.focus();
				return false;
			}
			if(!isValidDate(data)){
				alert(msg+" 값이 정확하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("time") > -1){
			if(!time_reg.test(data)){
				alert(msg+" 형식이 일치하지 않습니다.(00:00:00)");
				obj.focus();
				return false;
			}
			if(!isValidTime(data)){
				alert(msg+" 값이 정확하지 않습니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("kor") > -1){
			if(kor_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 한글만 입력하여 주세요.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("num") > -1){
			if(num_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 숫자만 입력하여 주세요.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("npoint") > -1){
			if(!npoint_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 1000이하의 소수점 둘재자리 까지만 입력하여 주세요.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("eng") > -1){
			if(eng_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 영문자만 입력하여 주세요.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("enn") > -1){
			if(enn_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 영문과 숫자만 입력하여 주세요.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("notspc") > -1){
			if(notspc_reg.test(data)){
				if ( 'Y' == checkBatChimYn( msg ) ) josa = '은';
				if ( 'N' == checkBatChimYn( msg ) ) josa = '는';
				alert(msg+josa+" 특수문자는 입력할 수 없습니다. ");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("img") > -1){
			if(!img_reg.test(data)){
				alert(" 이미지파일은 GIF,JPG,PNG 그림 파일만 가능합니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("atc") > -1){
			if(!atc_reg.test(data)){
				alert("첨부파일은 JPG,GIF,PNG,DOC,XLS,XLSX,PPT,TXT 파일만 가능합니다.");
				obj.focus();
				return false;
			}
		}
		
		if(flag.indexOf("url") > -1){
			if(!url_reg.test(data)){
				alert("유효하지 않는 URL 입니다. http:// 까지 입력하세요");
				obj.focus();
				return false;
			}
		}
		
	}// data != ''
	
	return true;
}

/***
 * 한글 마지막 문자 받침 존재여부 
 * return Y=받침존재, N=받침없음.
 **/
function checkBatChimYn( msg ){
	var checkYn = 'Y';
	if ( msg.charCodeAt( msg.length-1 ) % 28 == 16) {	//받침존재안함
		checkYn = 'N';
	}
	return checkYn;
}

/***
 * 비밀번호 체크
 * : 6~16자리이며, 동일문자&숫자,연속문자&숫자 3자리이상 불가/영문+숫자+특수문자
 * @param processType >>> ADD=등록, EDIT=수정
 * @param confirmType >>> 0=비밀번호 [다시확인-Input]이 없는경우, 1=있는경우
 * @param passInp >>> 비밀번호 Input Name
 * @param passInp2 >>> 비밀번호 [다시확인-Input] Name > confirmType 1인경우 [필수]
 * @returns true, false
 */
function passWordCheck(processType, confirmType, passInp, passInp2) {
	var ckfalg = true;
	
	var i, temp;
	var arr = new Array(0,0,0);
	var patt = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}$/;	//비밀번호 패턴
	var passVal = $('input[name="'+passInp+'"]').val();
	var pass2Val = $('input[name="'+passInp2+'"]').val();

	if(ckfalg && 'ADD' == processType){
		if(ckfalg && '' == passVal){
			alert('비밀번호를 입력해 주세요.');
			$( 'input[name="'+passInp+'"]').focus(); 
			ckfalg = false;
		}
	}
	
	if(ckfalg && '1' == confirmType){
		if(ckfalg && ('' ==pass2Val || passVal != pass2Val)){ 
			alert('비밀번호와 일치하지 않습니다. 다시 입력해 주세요.');
			$( 'input[name="'+passInp2+'"]').val('');
			$( 'input[name="'+passInp2+'"]').focus();
			ckfalg = false;
		}
	}
	
	if(ckfalg && passVal != ''){
		 //비밀번호 패턴일치 여부
		 if(ckfalg && (!patt.test(passVal))){
			 alert("비밀번호는 영문,숫자,특수문자를 혼합하여 6~16자리로 사용 가능합니다.");
			 $( 'input[name="'+passInp+'"]').val('');
			 $( 'input[name="'+passInp2+'"]').val('');
			 $( 'input[name="'+passInp+'"]').focus();
			  return false;
		 }
	 
		 //동일문자 and 동일숫자 여부 check
		 for(i=0; i<passVal.length; i++){
			 temp = passVal.charCodeAt(i);
			 arr[2] = arr[1];
			 arr[1] = arr[0];
			 arr[0] = temp;
			 if(arr[0] == arr[1] && arr[1] ==arr[2] && arr[0] == arr[2]){
				 alert("동일문자를 3번 이상 사용할 수 없습니다.");
				 //alert("비밀번호는 같은 문자가 세번 연속 될 수 없습니다.");
				 $( 'input[name="'+passInp+'"]').val('');
				 $( 'input[name="'+passInp+'"]').focus();
				 ckfalg = false;
				 return false;
			}
		 }

		 //연속문자 and 연속숫자 여부 check
		 var SamePass_1 = 0; //연속성(-) 카운트
		 var SamePass_2 = 0; //연속성(+) 카운트
		 
		 var chr_pass_0;
		 var chr_pass_1;
		 var chr_pass_2;
			 
		 for(var i=0; i < passVal.length; i++){
			 chr_pass_0 = passVal.charAt(i);
			 chr_pass_1 = passVal.charAt(i+1);
			 chr_pass_2 = passVal.charAt(i+2);
			 
			 //연속성(-) 카운트
			 if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1){
				 SamePass_1 = SamePass_1 + 1;
			 }
			 
			 //연속성(+) 카운트
			 if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1){
				 SamePass_2 = SamePass_2 + 1;
			 }
		 }
			
		 if(SamePass_1 > 0 || SamePass_2 > 0 ){
			 alert("연속된 문자열을 3자 이상 사용 할 수 없습니다.");
			 $( 'input[name="'+passInp+'"]').val('');
			 $( 'input[name="'+passInp+'"]').focus();
			 ckfalg = false;
		 }
	}
	
	return ckfalg;
}

/***
 * form submit - post 
 **/
function formPostSubmit(f_name, url){
	var frmobj = '';
	
	if('' == f_name){
		frmobj = $('form[name="frm"]');
	}else{
		frmobj = $('form[name="'+f_name+'"]');
	}
	
	if('' == url){
		frmobj.submit();
	}else{
		frmobj.attr('action', url).submit();
	}
}
function formPostSubmit2(url, params){ //params > aaa=111&bbb=222&ccc=333
	var tempFormName = 'frm_temp_post';
	var htmlText = '<form name="'+tempFormName+'" method="post" action="'+url+'">';
	
	if('' != toStr(params)){
		var arr = params.split('&');
		for(var i=0,j=arr.length; i<j; i++){
			if(0 < arr[i].split('=').length){
				var key = arr[i].split('=')[0];
				var value = arr[i].split('=')[1];
				htmlText += '<input type="hidden" name="'+key+'" value="'+value+'" />';
			}
		}
	}
	htmlText += '</form>';
	$('body').append(htmlText);
	
	$('form[name="'+tempFormName+'"]').submit().remove();
}

/***
 * form submit - get 
 **/
function formGetSubmit(url, param){
	$(location).attr('href', url+'?'+param);
}

/***
 * 숫자에 천단위 찍기 
 **/
function addComma(num) {
	var i = toStr(num).split(".");
	i[0] = i[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	
	var rVal = i.join(".");
	return rVal;
}

/***
 * replaceAll
 * str : 문자열 대체를 처리할 원 문자열
 * targetStr : 바꿀 문자
 * replaceStr : 바뀌어질 문자 
 **/
function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
}

/***
 *  숫자만 입력 > onkeydown="return onlyNumber(event);"
 **/
function onlyNumber(event) {
    var key = window.event ? event.keyCode : event.which;    
    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
    || key  == 8  || key  == 46 )
    ) {
        return true;
    }else {
        return false;
    }    
}

/***
 * 기간설정
 * sInpName : 검색시작 Input Name
 * eInpName : 검색종료 Input Name
 * reqdate : 기간 일수
 **/
function datePeriod(sInpName, eInpName, reqdate){
	if( reqdate != 0 && (reqdate == null || reqdate == '') ){
		$('input[name="'+sInpName+'"]').val('');
		$('input[name="'+eInpName+'"]').val('');
		return;
	}
	
	var date = new Date();
	
	var s_yyyy =  date.getFullYear();
	var s_mm = date.getMonth()+1;
	var s_dd = date.getDate();
	
	var e_yyyy = s_yyyy;
	var e_mm = s_mm;
	var e_dd = s_dd;
	
	while( s_dd <= reqdate ){ // 일수로 계산. 현재일이 0이면 안되므로 <=로 처리
		//1월달인 경우 년도를 빼줌.
		if( s_mm == 1 ){ 			
			s_yyyy -= 1;			
			s_mm = 12;				
		}
		//1월이 아닌경우 1달 뺌.
		else{ 
			s_mm -= 1;
		}
		
		//일수가 31인 경우
		if( s_mm == 1 || s_mm == 3 || s_mm == 5 || s_mm == 7 || s_mm == 8 || s_mm == 10 || s_mm == 12) {		
			s_dd += 31;	
		}
		 //2월인 경우
		else if( s_mm == 2 ){
			//29일인 경우
			if(s_yyyy%4==0){ 
				s_dd += 29;
			}
			//28일인 경우
			else{
				s_dd += 28;
			}
		}else{
			s_dd += 30;
		}
	}
	s_dd -= reqdate;
	
	if( s_mm < 10 ) s_mm = "0"+s_mm;
	if( s_dd < 10 ) s_dd = "0"+s_dd;
	var startDate = s_yyyy+'-'+s_mm+'-'+s_dd;
	$('input[name="'+sInpName+'"]').val(startDate);
	
	if( e_mm < 10 ) e_mm = "0"+e_mm;
	if( e_dd < 10 ) e_dd = "0"+e_dd;
	var endDate = e_yyyy+'-'+e_mm+'-'+e_dd;
	$('input[name="'+eInpName+'"]').val(endDate);
}


/*** S : 체크박스 관련 ***/
// 체크박스 전체체크 및 해제
function checkAll(pobj, ckval){
	$( pobj ).each( function( i, obj ){
		if( !$( obj ).attr( 'disabled' ) ){
			$( obj ).prop( 'checked', ckval );
		}
	});
}
function checkAll2(obj, childObjName){ // obj=전체 체크박스, childObjName=선택되어질 체크박스명.
	var checkTf = $(obj).is(':checked');
	 $('input:checkbox[name="'+childObjName+'"]').each( function(i,e){
		if(!$(e).attr('disabled')){
			$(e).prop('checked', checkTf);
		}
	});
}
function checkAll3(obj, childObjName){ // obj=전체 체크박스, childObjName=선택되어질 체크박스명. // checkAll2와 동일하나, uniform() 지원.
	var checkTf = $(obj).is(':checked');
	 $('input:checkbox[name="'+childObjName+'"]').each( function(i,e){
		if(!$(e).attr('disabled')){
			$(e).prop('checked', checkTf);
		}
	});
	 
	 $('input:checkbox[name="'+childObjName+'"]').uniform();
}
/*** E : 체크박스 관련 ***/

/**
 * replaceAll
 */
String.prototype.replaceAll = function(str1, str2) {
	var temp_str = this.trim();
	temp_str = temp_str.replace(eval("/" + str1 + "/gi"), str2);
	return temp_str;
}

/**
 * parameter
 * @param name
 * @returns
 */
function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

/**
 * 윈도우 팝업 생성
 */
function createPopUp(url, params, name, option){
	window.open(url+'?'+params, name, option);
}

//* 
/**
 * 파일 사이즈 가져오기
 * @return byte
 */
function getFileSizeByte(file){
	var browser=navigator.appName;	// 브라우저 확인
	if (browser=="Microsoft Internet Explorer"){ //익스
		var oas = new ActiveXObject("Scripting.FileSystemObject");
		fileSize = oas.getFile( file.value ).size;
	}
	else{
		fileSize = file.files[0].size;
	}
	return fileSize;
}

/**
 * 오늘날짜를 기준으로 이전날짜 구하기
 * @param today date형
 * @param dateType
 * @param num
 * @returns {String}
 */
function addDate(today, dateType, num) {
	var number = parseInt(num);
	var res;
	
	switch (dateType) {
		case "Y" : 
			res = new Date(today.setYear(today.getFullYear() + number));
			break;
		case "M" :		
			res = new Date(today.setMonth(today.getMonth() + number));
			break;
		case "D" :
			res = new Date(today.setDate(today.getDate() + number));
			break;
	}
	
	return getDateStr(res);
}

/**
 * 날짜를 문자열 형식으로 리턴
 * @param now
 * @returns {String}
 */
function getDateStr(now) {
	return now.getFullYear() + "-" + addZero(now.getMonth() + 1, '0', 2) + "-" + addZero(now.getDate(), '0', 2);
}


/**
 * val 의 자리수가 num 자리가 될때까지 앞에다가 div 를 붙힌다.
 * @param val
 * @param div
 * @param num
 * @returns
 */
function addZero(val, div, num) {
	val = '' + val;
	while (val.length < num) {
		val = div + val;
	}
	return val;
}

/**
 * 배열의 값에 대한 인덱스 리턴
 * @param pArr
 * @param pVal
 * @returns {Number}
 */
function getArrayKey(pArr, pVal) {
	for (var i=0; i<pArr.length; i++) {
		if (pArr[i] == pVal) return i;
	}
	return -1;
}

/**
 * -를 제외한 휴대폰번호를 인자로 받아 첫번째,두번째,세번째 자리의 휴대폰번호를 리턴. 
 * ex. toPhoneNum(1, "01012311231") > return "010"
 */
function toPhoneNum(seq, phoneNum){
	var retStr = '';
	if((seq == 1 || seq == 2 || seq == 3) && '' != phoneNum && 'null' != phoneNum){
		var phoneNumLen = phoneNum.length;
		if(seq == 1) retStr = phoneNum.substring(0, 3);
		else if(seq == 2) retStr = phoneNum.substring(3, phoneNumLen-4);
		else if(seq == 3) retStr = phoneNum.substring(phoneNumLen-4, phoneNumLen);
	}
	return retStr;
}

/**
 * -를 제외한 일반전화번호를 인자로 받아 첫번째,두번째,세번째 자리의 일반전화번호를 리턴. 
 * ex. toTelNum(1, "0212311231") > return "02"
 */
function toTelNum(seq, telNum){
	var retStr = '';
	
	telNum = toStr(telNum);
	if((seq == 1 || seq == 2 || seq == 3) && '' != telNum){
		var telNumLen = telNum.length;
		if('02' == telNum.substring(0, 2)){
			if(seq == 1) retStr = telNum.substring(0, 2);
			else if(seq == 2) retStr = telNum.substring(2, telNumLen-4);
			else if(seq == 3) retStr = telNum.substring(telNumLen-4, telNumLen);
		}
		else{
			if(seq == 1) retStr = telNum.substring(0, 3);
			else if(seq == 2) retStr = telNum.substring(3, telNumLen-4);
			else if(seq == 3) retStr = telNum.substring(telNumLen-4, telNumLen);
		}
	}
	return retStr;
}
function toTelNumALL(telNum, sep){ // sep=구분자
	var retStr = '';
	
	telNum = toStr(telNum).replaceAll(' ', '').replaceAll('-', '');
	if('' != telNum){
		var telNumLen = telNum.length;
		if('02' == telNum.substring(0, 2)){
			retStr = telNum.substring(0, 2)+ sep +telNum.substring(2, telNumLen-4)+ sep +telNum.substring(telNumLen-4, telNumLen);
		}
		else{
			retStr = telNum.substring(0, 3)+ sep +telNum.substring(3, telNumLen-4)+ sep +telNum.substring(telNumLen-4, telNumLen);
		}
	}
	return retStr;
}

/** 
 * 컨텍스트패스 가져오기
 */
function getContextPath(){
	var hostIndex = location.href.indexOf( location.host ) + location.host.length;
	return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
}

/**
 * 문자열 null => 빈값으로 변환. 
 */
function toStr(obj, str) {
	if (typeof str === undefined || str == undefined || str == 'undefined') str = '';
	if (typeof obj === null || obj == null || obj == 'null') return str;
	if (typeof obj === undefined || obj == undefined || obj == 'undefined') return str;
	return obj + '';
}

/**
 * 쿠키저장하기
 */
function setCookie(name,value,expiredays){	//쿠키 저장 함수
	var todayDate= new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + encodeURIComponent(value) + "; path=/; expires=" + todayDate.toGMTString()+";";
}

/**
 * 쿠기삭제하기
 */
function delCookie(name){
	setCookie(name, '', -1);
}

/**
 * 쿠키가져오기
 */
function getCookie(c_name) {
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++) {
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name) {
			return y;
		}
	}
}

function toInt(str, def) {
	if (def == undefined) def = 0;
	if (str == null || str == undefined || str == '') return def;
	else return parseInt(str);
}

function toFloat(str, def) {
	if (def == undefined) def = 0;
	if (str == null || str == undefined || str == '') return def;
	else return parseFloat(str);
}

function getStrByMaxByte(str, maxByte){
	var retArr = new Array();
	var retStr1, retStr2 = '';
	
    var str_len = str.length;
    var rbyte = 0;
    var rlen = 0;
    var one_char = '';
    
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 2; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }
    
    if (rbyte > maxByte) {
    	retStr1 = str.substr(0, rlen);
    	retStr2 = str.substr(rlen, str_len);
    }
    else{
    	retStr1 = str;
    	retStr2 = '';
    }
    
    retArr[0] = retStr1;
    retArr[1] = retStr2;
    return retArr;
}

function checkByte(obj, maxByte) { //maxByte=최대 입력 바이트 수
    var str = obj.value;
    var str_len = str.length;
 
    var rbyte = 0;
    var rlen = 0;
    var one_char = '';
    var str2 = '';
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 2; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }
 
    if (rbyte > maxByte) {
        alert("한글 " + Math.floor(maxByte / 2) + "자 / 영문,숫자 " + maxByte + "자를 초과 입력할 수 없습니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        checkByte(obj, maxByte);
    } else {
        //document.getElementById('byteInfo').innerText = rbyte;
    }
}

/**
 * Use bignumber.js
 * @param obj : 부동소수
 * @param loc : 자리수 제한위치. ex)loc=2이면 소수점 2자리까지.
 * @param mode : 1=내림,2=반올림,3=올림. ex)loc=2이고 mode=2이면 소수점 3번째자리에서 반올림.
 * @return 
 */
function decimalScale(obj, loc, mode){
	obj = replaceAll(toStr(obj), ',', '');
	
	var BN;
	if('1' == mode) BN = BigNumber.clone({ DECIMAL_PLACES: loc, ROUNDING_MODE: 1 }) // ROUND_DOWN 내림
	if('2' == mode) BN = BigNumber.clone({ DECIMAL_PLACES: loc, ROUNDING_MODE: 4 }) // ROUND_HALF_UP 반올림
	if('3' == mode) BN = BigNumber.clone({ DECIMAL_PLACES: loc, ROUNDING_MODE: 0 }) // ROUND_UP
	
	return (new BN(obj)).div(1);
}

/**
 * Use bignumber.js
 * 총합계액으로부터 공급가액/vat 구하기.
 * @param sumPrice : 총합계액
 * @param priceType : 0=영세,1=면세,2=과세
 * @return Array[0]=공급가격, Array[1]=부가세
 */
function getSupPrice(sumPrice, priceType){
	var retArr = new Array();
	
	sumPrice = new BigNumber(sumPrice);
	
	var supPrice = ('2' != priceType) ? decimalScale(sumPrice, 4, 1) : decimalScale((sumPrice.multipliedBy(10)).dividedBy(11), 4, 1);
	supPrice = new BigNumber(supPrice);
	
	var vat =  decimalScale(sumPrice.minus(supPrice), 4, 1);
	vat = new BigNumber(vat);
	
	retArr[0] = supPrice;
	retArr[1] = vat;
	
	return retArr;
}

function writeIndexToStr(num, sep){
	var retStr = '';
	num = Number(num);
	sep = (typeof sep === undefined || sep == undefined || sep == 'undefined' || '' == sep) ? ',' : sep;
	for(var i=0,j=num; i<j; i++){
		if(i==0) retStr = i+'';
		else retStr += sep+i+'';
	}
	return retStr;
}

function removeTag(str){
	return str.replace(/(<([^>]+)>)/ig,'');
}