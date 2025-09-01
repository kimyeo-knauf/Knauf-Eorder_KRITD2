<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<!-- https://craftpip.github.io/jquery-confirm/ -->
<script src="${url}/include/js/common/jquery-confirm/jquery-confirm.js"></script>
<link href="${url}/include/js/common/jquery-confirm/css/jquery-confirm.css" rel="stylesheet" />

<script type="text/javascript">
$(function(){
	//console.log('plantListToJson : ', $.parseJSON('${plantListToJson}'));
	//console.log('holyDayListToJson : ', $.parseJSON('${holyDayListToJson}'));
	//console.log('orderWeekListToJson : ', $.parseJSON('${orderWeekListToJson}'));
	
	setDatePickerTime('1');
});

$(document).ready(function() {
	console.log('Order Edit');
	
	$('input[name="select_pickingdt"]').datepicker({
		language: 'kr',
	    format : 'yyyy-mm-dd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
		startDate: 'today'
	}).on('changeDate', function(selected) {
		var selectDate = new Date(selected.date.valueOf());
		var yyyymmdd = getDateStr(selectDate);
		// 주문품목 확정처리 > 전체 피킹일자 선택.
		$('input[name="m_pickingdt"]').each(function(i,e){
			$(e).val(yyyymmdd);
		});
    });
	
	activeDatePicker();
});

// 동적으로 datepicker init. 
function activeDatePicker(){
	$('input[name="m_pickingdt"]').each(function(i,e){
		$(e).datepicker({
			language: 'kr',
		    format : 'yyyy-mm-dd',
		    todayHighlight: true,
		    autoclose : true,
			clearBtn: true,
			startDate: 'today'
		}).on('changeDate', function(selected) {
	    
		});
	});
}


function setDatePickerTime(type){ // type : 1=헤더의 납품요청일시
	//var startDateTimeClass = 'bdStartDateClass';
	//var endDateTimeInClass = 'bdEndDateClass';
	var getDateVal = '';
	if('1' == type){
		getDateVal = toStr($('input[name="v_requestdate"]').val());
	}
	
	var dateNow = ('' == getDateVal) ? new Date() : new Date(getDateVal);
	$('#dateTimePickerDivId').DateTimePicker({
		mode:'datetime', // date, time or datetime
		defaultDate: moment(dateNow).hours(0).minutes(0).seconds(0).milliseconds(0),
		dateSeparator:'-',
		timeSeparator:':',
		timeMeridiemSeparator:' ',
		dateTimeSeparator:' ',
		monthYearSeparator:' ',
		dateTimeFormat:'yyyy-MM-dd HH:mm',
		dateFormat:'yyyy-MM-dd',
		timeFormat:'HH:mm',
		maxDate:null,
		minDate: null,
		maxTime:null,
		minTime:null,
		//maxDateTime:null,
		//minDateTime:null,
		addEventHandlers: function(){ // 최소 일자 : 오늘날짜/시간 이전은 선택 안되게 설정.
			var oDTP = this;
			oDTP.settings.minDateTime = oDTP.getDateTimeStringInFormat('DateTime', 'yyyy-MM-dd HH:mm', moment(dateNow).hours(0).minutes(0).seconds(0).milliseconds(0));
			//oDTP.settings.minDateTime = oDTP.getDateTimeStringInFormat('DateTime', 'yyyy-MM-dd HH:mm', new Date());
		},
		settingValueOfElement:function(sValue, dDateTime, oInputElement){ // 시작 <--> 종료 컨트롤.
			//console.log('sValue : ', sValue);
			//console.log('dDateTime : ', dDateTime);
			//console.log('oInputElement : ', oInputElement);
			
			var oDTP = this;
			
			var inputEl = $(oInputElement);
			var inputElName = $(inputEl).prop('name');
			
			var setVal = toStr(sValue);
			var setDate = '', setTime = '';
			if('' != setVal){
				setDate = setVal.substring(0, 10).replaceAll('-', '');
				setTime = setVal.substring(11, 16).replaceAll(':', '');
			}

			if('v_requestdate' == inputElName){
				$('input[name="m_requestdt"]').val(setDate);
				$('input[name="m_requesttime"]').val(setTime);
				
				$('input[name="v_requestdate2"]').val(setVal);
				$('input[name="m_requestdt2"]').val(setDate);
				$('input[name="m_requesttime2"]').val(setTime);
			}
			else{
				$(inputEl).closest('td').find('input[name="m_requestdt2"]').val(setDate);
				$(inputEl).closest('td').find('input[name="m_requesttime2"]').val(setTime);
			}
			
			//if(oInputElement.hasClass(startDateTimeClass)){
			//	$('.'+endDateTimeInClass).data('min', $('.'+startDateTimeClass).val());
			//}
			//if(oInputElement.hasClass(endDateTimeInClass)){
			//	$('.'+startDateTimeClass).data('max', $('.'+endDateTimeInClass).val());
			//}
		},
		shortDayNames: ['일','월','화','수','목','금','토'],
		fullDayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
		shortMonthNames: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		fullMonthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		labels: {'year': '년', 'month': '월', 'day': '일', 'hour': '시', 'minutes': '분', 'seconds': '초', 'meridiem': ''},
		minuteInterval: 30, // 분 증감 단위
		roundOffMinutes:true,
		secondsInterval: 1,
		roundOffSeconds:true,
		showHeader:true,
		formatHumanDate:function(oDateTime, sMode, sFormat){ // 헤더 날짜 포맷 세팅.
		  return oDateTime.yyyy+'년 '+oDateTime.MM+'월 '+oDateTime.dd+'일 ('+oDateTime.dayShort+') '+oDateTime.HH+'시 '+oDateTime.mm+'분';
		  //return oDateTime.dayShort +", " + oDateTime.month +" " + oDateTime.dd +", " + oDateTime.yyyy;
		},
		titleContentDate:'납품요청일 설정',
		titleContentTime:'납품요청일 설정',
		titleContentDateTime:'납품요청일 설정',
		buttonsToDisplay: ['HeaderCloseButton','SetButton','ClearButton'],
		setButtonContent:'설정',
		clearButtonContent:'초기화',
		buttonClicked:function(sButtonType, oInputElement, c){ // SET, CLEAR, CANCEL, TAB
			//console.log('sButtonType : ', sButtonType);
			//console.log('oInputElement : ', oInputElement);
			if('SET' == sButtonType){
				
			}
			if('CLEAR' == sButtonType){
				//$('input[name="m_requestdt"]').val('');
				//$('input[name="m_requesttime"]').val('');
			}
		},
		incrementButtonContent:'+',
		decrementButtonContent:'-',
		setValueInTextboxOnEveryClick:false, //true=날짜가변경 됨에 따라 input에 입력.
		readonlyInputs:false,
		animationDuration: 400,
		touchHoldInterval: 300,// in Milliseconds
		captureTouchHold:false,// capture Touch Hold Event
		mouseHoldInterval: 50,// in Milliseconds
		captureMouseHold:false,// capture Mouse Hold Event
		isPopup:true,
		parentElement:'body',
		isInline:false,
		inputElement:null,
		//language:'ko',
	});	
}

// 납품처 초기화.
function setDefaultShipTo(){ 
	$('input[name="m_shiptocd"]').val('');
	$('input[name="v_shiptonm"]').val('');
	
	$('input[name="m_custommatter"]').val('');
	$('#matterSpanId').empty();
}

// 납품처 선택 팝업 띄우기.
function openShiptoPop(obj){
	var selectedCustCd = toStr('${orderHeader.CUST_CD}');
	
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 805;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="shiptoListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderadd" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '	<input type="hidden" name="r_custcd" value="'+selectedCustCd+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/shiptoListPop.lime';
	window.open('', 'shiptoListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

//return 납품처 팝업에서 개별 선택.
function setShiptoFromPop(jsonData){
	$('input[name="m_shiptocd"]').val(toStr(jsonData.SHIPTO_CD));
	$('input[name="v_shiptonm"]').val(toStr(jsonData.SHIPTO_NM));
	$('input[name="m_zipcd"]').val(toStr(jsonData.ZIP_CD));
	$('input[name="m_add1"]').val(toStr(jsonData.ADD1));
	$('input[name="m_add2"]').val('');
	
	/* 
	var tels = toStr(jsonData.ADD3);
	tels = tels.replaceAll(' ', '');
	tels = tels.replaceAll('-', '');
	var telArr = tels.split(',');
	if('' != tels){
		var alltlp_reg = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?[0-9]{3,4}?[0-9]{4}$/; // 휴대폰+일반전화번호+050+070 체크, '-' 제외
		for(var i=0,j=telArr.length; i<j; i++){ // 데이터가 엉뚱한 값이 많이 들어가다보니... 거르자.
			// 전화번호 형식인 경우에만 입력.
			if(alltlp_reg.test(telArr[i].replaceAll(' ',''))){	
				if(0==i){
					$('input[name="m_tel1"]').val(telArr[i].replaceAll(' ',''));
				}else if(1==i){
					$('input[name="m_tel2"]').val(telArr[i].replaceAll(' ',''));
				}
			}
		}
	}
	*/
	
	
	$('input[name="m_custommatter"]').val(jsonData.ADD4); // TO_BE ADD2에서 ADD4로 개선요청.
	$('#matterSpanId').empty();
	$('#matterSpanId').append(jsonData.ADD4); // TO_BE ADD2에서 ADD4로 개선요청.
}

// 품목 선택 팝업 띄우기.
function openItemPop(obj, tr_id, item_deli_type){ // item_deli_yn : Y=배송비 아이템만 출력, 빈값=배송비 아이템 제외하고 출력, ALL=모두출력.
	// 팝업 세팅.
	var widthPx = 1200;
	var heightPx = 900;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop" method="post" target="itemListPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="orderedit" />';
	htmlText += '	<input type="hidden" name="r_multiselect" value="false" />'; // 행 단위 선택 가능여부 T/F
	htmlText += '	<input type="hidden" name="r_settrid" value="'+tr_id+'" />';
	htmlText += '	<input type="hidden" name="r_itemdeliverytype" value="'+item_deli_type+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/itemListPop.lime';
	window.open('', 'itemListPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// return 품목 팝업에서 다중 선택.
function setItemFromPop(jsonData, tr_id){
	//console.log('jsonData : ', jsonData);
	$('#'+tr_id).find('input[name="v_desc1"]').val(jsonData.DESC1);
	
	//$('#'+tr_id).find('select[name="v_unit"]').val(jsonData.UNIT);
	$('#'+tr_id).find('input[name="m_unit"]').val(jsonData.UNIT);
	
	var weight = jsonData.WEIGHT;
	
	setItemCd(tr_id);
}

// 선택한 출고지 and 품목명으로 품목코드 리스트 가져오기.
function setItemCd(tr_id){
	// 배송비 tr인지 체크.
	var deliveryTrTf = false;
	if('' != tr_id){ // 배송비는 개별 선택만 있음. 즉 ||없음
		deliveryTrTf = $('#'+tr_id).hasClass('itemDeliveryTrClass')
	} 

	var ri_trid = '';
	var ri_companycd = '';
	var ri_desc1 = '';
	var divider = '!!';
	if('' == tr_id){ // 전체 출고지 선택.
		$('#confirmDetailListTbodyId > tr').each(function(i,e){
			var r_trid = $(e).prop('id');
			var r_companycd = $(e).find('select[name="m_companycd"] option:selected').val();
			var r_desc1 = $(e).find('input[name="v_desc1"]').val();
			if('' != r_companycd && '' != r_desc1){
				if(0==i){
					ri_trid = r_trid;
					ri_companycd = r_companycd;
					ri_desc1 = r_desc1;
				}
				else{
					ri_trid += divider + r_trid;
					ri_companycd += divider + r_companycd;
					ri_desc1 += divider + r_desc1;
				}
			}
		});
	}else{ // 개별 출고지 선택.
		ri_trid = tr_id;
		ri_companycd = $('#'+tr_id).find('select[name="m_companycd"] option:selected').val();
		ri_desc1 = $('#'+tr_id).find('input[name="v_desc1"]').val();
	}
	//alert('ri_trid : '+ri_trid+'\nri_companycd : '+ri_companycd+'\nri_desc1 : '+ri_desc1);
	
	// 품목코드 리스트 가져오기.
	if('' != ri_companycd && '' != ri_desc1){
		$.ajax({
			async : false,
			url : '${url}/admin/base/getItemMcuListAjax.lime', 
			cache : false,
			type : 'POST',
			dataType: 'json',
			data : {
				ri_trid : ri_trid
				, ri_itemmcu : ri_companycd
				, ri_desc1 : ri_desc1
			},
			success : function(data){
				var divider = '!!';
				var ri_tridarr = ri_trid.split(divider);
				for(var i=0,j=ri_tridarr.length; i<j; i++){
					var listStr = ri_tridarr[i];
					var mcuList = data[listStr];
					var mcuCnt = mcuList.length;
					var htmlBody = '';
					
					if(0 == mcuCnt || 1 < mcuCnt) htmlBody='<option value="">선택</option>';
					$(mcuList).each(function(i,e){
						htmlBody += '<option value="'+e.ITEM_CD+'">'+e.ITEM_CD+'</option>';
					});
					$('#'+ri_tridarr[i]).find('select[name="m_itemcd"]').empty();
					$('#'+ri_tridarr[i]).find('select[name="m_itemcd"]').append(htmlBody);
				}
				
				// 재고가져오기 > 배송비 품목은 제외하고 실행.
				if(!deliveryTrTf){
					setItemStock(ri_trid);
				}
				//$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				//$(obj).prop('disabled', false);
			}
		});	
	}
}

// 재고 + 중량 가져오기. 
function setItemStock(tr_id){
	var divider = '!!';
	var tr_id_arr = tr_id.split(divider);
	var ri_trid = '';
	var ri_itemcd = '';
	var ri_companycd = '';

	for(var i=0,j=tr_id_arr.length; i<j; i++){
		var r_itemcd = $('#'+tr_id_arr[i]).find('select[name="m_itemcd"] option:selected').val();
		var r_companycd = $('#'+tr_id_arr[i]).find('select[name="m_companycd"] option:selected').val();
		
		if('' != r_itemcd && '' != r_companycd){
			if('' == ri_trid){
				ri_trid = tr_id_arr[i];
				ri_itemcd = r_itemcd;
				ri_companycd = r_companycd;
			}
			else{
				ri_trid += divider + tr_id_arr[i];
				ri_itemcd += divider + r_itemcd;
				ri_companycd += divider + r_companycd;
			}
		}
	}
	//alert('ri_trid : '+ri_trid+'\nri_itemcd : '+ri_itemcd+'\nri_companycd : '+ri_companycd);
	
	if('' != ri_trid){
		$.ajax({
			//async : false,
			url : '${url}/admin/base/getItemStockAjax.lime',
			cache : false,
			type : 'POST',
			dataType: 'json',
			data : {
				ri_trid : ri_trid
				, ri_itemcd : ri_itemcd
				, ri_itemmcu : ri_companycd
				/*PLANT: "4635", 
			    MATERIAL: "786593",
			    UNIT: "PC",
			    CHECK_RULE: "A"*/
			},
			success : function(data){
				var divider = '!!';
				var ri_tridarr = ri_trid.split(divider);
				console.log("TRIDARR : " + ri_tridarr);
				console.log(data);
				
				for(var i=0,j=ri_tridarr.length; i<j; i++){
					var listStr = ri_tridarr[i];
					var stock = data[listStr];
					var weight = data[listStr+"_WEIGHT"]; // 개별중량.
					
					console.log('stock : ', stock);
					console.log('weight : ', weight);
					
					// 재고.
					$('#'+listStr).find('.stockTdClass').empty();
					if(stock && null != stock){
						$('#'+listStr).find('.stockTdClass').append(addComma(stock.TOT_AVAIL));
					}else{
						$('#'+listStr).find('.stockTdClass').append(0);
					}

					$('#'+listStr).attr('weightAttr', weight);
					changeWeight(listStr); // 중량 계산하기.
				}
				
				$('#ajax_indicator').fadeOut();
				//$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$('#ajax_indicator').fadeOut();
				//$(obj).prop('disabled', false);
			},
			beforeSend: function(xhr){
				$('#ajax_indicator').show().fadeIn('fast');
			},
			uploadProgress: function(event, position, total, percentComplete){
			},
		});	
	}
}

// 개별중량 * 출고수량, 운송비 제외.
function changeWeight(tr_id){
	var weight = $('#'+tr_id).attr('weightAttr'); // 개별중량.
	if(typeof weight === undefined || weight == undefined || weight == 'undefined') return;
	weight = new BigNumber(weight);
	
	var quantity = $('#'+tr_id).find('input[name="m_quantity"]').val(); // 출고수량.
	quantity = quantity.replaceAll(',', '');
	if('' == quantity) quantity = 0;
	quantity = new BigNumber(quantity);
	
	var wq = decimalScale(quantity*weight, 3, 2); // 개별중량 * 출고수량.
	$('#'+tr_id).find('.weightTdClass').empty();
	$('#'+tr_id).find('.weightTdClass').append(addComma(wq));
}

// 주문품목 확정처리 > 전체 / 개별 출고지 선택.
function changeCompanyCd(obj, tr_id){
	if('' == tr_id){ // 전체 출고지 선택.
		// 전체 출고지 선택인 경우, 운송비 tr 삭제하고, 나머지 tr에 일괄처리.
		$('#confirmDetailListTbodyId > tr').each(function(i,e){ 
			if($(e).hasClass('itemDeliveryTrClass')){
				$(e).remove();
			}
			else{
				$(e).find('select[name="m_companycd"]').val($(obj).val());
			}
		});
	}
	setItemCd(tr_id);
	
	var m_ocdstatuscd = $('#'+tr_id).find('input[name="m_ocdstatuscd"]').val(); //03=CS반려
	if('03' == m_ocdstatuscd){
		cancelOrderReturn(tr_id);
	}
}

// 주문품목 확정처리 > 전체 주차 선택.
function changeAllWeek(obj){
	$('select[name="m_week"]').each(function(i,e){
		$(e).val($(obj).val());
	});
}

// 주문품목 확정처리 > 품목별 > 주문분리,반려,운송비
function setOrderItem(obj, tr_id, type){ // type : 100=주문분리,200=반려등록,201=반려수정,300=운송비,500=확정(CS)요청사항,900=tr삭제.
	var nowTrObj = $(obj).closest('tr');
	var mainTrTf = $(nowTrObj).hasClass('itemMainTrClass'); // 선택한 class가 Main(원오더) Tr 여부(true/false);
	//var subTrTf = $(nowTrObj).hasClass('itemSubTrClass'); // 선택한 class가 Sub(주문분리오더) Tr 여부(true/false);
	var parentTrObj = (mainTrTf) ? nowTrObj : $(nowTrObj).prev(); // 이전 tr.
	
	//alert(mainTrTf);
	var htmlText = '';
	
	// tr삭제 : 주문분리 및 운송비 tr삭제.
	if('900' == type){
		$(nowTrObj).remove();
	}
	
	// 주문분리 : mainTr당 한개만 가능. >> 여러개 가능 으로 변경.
	else if('100' == type){
		if(!mainTrTf) return;
		//if(0 < $('#'+trId).length) return;
		
		var nowSubTrCnt = $('tr[id ^= "'+tr_id+'_"]').length;
		
		var trId = tr_id+'_'+(nowSubTrCnt+1);
		
		// 원주문의 출고지를 분리주문에서 선택 못하게 하기위한.. >> 의미 없어짐..
		/* 
		var selectedCompanyCd = $(nowTrObj).find('select[name="m_companycd"] option:selected').val();
		if('' == selectedCompanyCd){
			alert('출고지를 선택 후 진행해 주세요.');
			return;
		}
		*/
		
		// 전체 tr 상태값 변경 : 05 > 07
		/* 
		$('#confirmDetailListTbodyId > tr').each(function(i,e){
			var m_status = $(e).find('input[name="m_status"]').val();
			if('05' == m_status){
				$(e).find('input[name="m_status"]').val('07');
			}
		});
		*/
		
		// tr 생성.
		htmlText +='<tr id="'+trId+'" class="itemSubTrClass" mainSubGroupTrIdAttr="'+tr_id+'">';
		htmlText +='	<td class="text-center">';
		//htmlText +='		<input  type="hidden" name="m_status" value="07" />'; // 07(주문확정(분리))
		htmlText +='		<input type="hidden" name="m_ocdreturncd" value="" />';
		htmlText +='		<input type="hidden" name="m_ocdreturnmsg" value="" />';
		htmlText +='		<input type="hidden" name="m_ocdstatuscd" value="" />';
		htmlText += '		<input type="hidden" name="m_price" value="">';
		htmlText += '		<input type="hidden" name="m_confirmremark" value="" />';
		htmlText += '		<input type="hidden" name="m_orderSeparation" value="'+tr_id+'" />'; // 2025-02-11 hsg Ankle Rock. 주문분리일 경우 오더번호를 생성하기 위해 주문분리 구분자 추가. 구분자 : 부모행 번호(trId_x) // 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기
		
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<input type="text" name="m_orderGroup" value="" />';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<select name="m_companycd" onchange=\'changeCompanyCd(this, "'+trId+'");\'>';
		htmlText +='			<option value="">선택</option>';
		
		var plantListToJson = $.parseJSON('${plantListToJson}');
		$(plantListToJson).each(function(i,e){
			if(selectedCompanyCd != e.PT_CODE){
				htmlText +='		<option value="'+e.PT_CODE+'">'+e.PT_NAME+'</option>';
			}else{
				htmlText +='		<option value="'+e.PT_CODE+'">'+e.PT_NAME+'</option>';
				//htmlText +='		<option value="'+e.PT_CODE+'" disabled="disabled">'+e.PT_NAME+'</option>';
			}
		});
		
		htmlText +='		</select>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<input type="text" class="w-p-r-md" name="v_desc1" value="'+$(parentTrObj).find('input[name="v_desc1"]').val()+'" readonly="readonly" />';
		//htmlText +='		<a href="javascript:;" onclick=\'openItemPop(this, "'+trId+'", "N");\'><i class="fa fa-search i-search f-s-15"></i></a>';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<select name="m_itemcd" onchange=\'setItemStock("'+trId+'");\'>';
		htmlText +='			<option value="">선택</option>';
		htmlText +='		</select>';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		
		/* 
		htmlText +='		<select name="v_unit"  disabled="disabled">';
		var unitListToJson = $.parseJSON('${unitListToJson}');
		var parentUnitSelected = $(parentTrObj).find('select[name="v_unit"] option:selected').val();
		$(unitListToJson).each(function(i,e){
			if(parentUnitSelected != e.CC_NAME){
				htmlText +='	<option value="'+e.CC_NAME+'">'+e.CC_NAME+'</option>';
			}else{
				htmlText +='	<option value="'+e.CC_NAME+'" selected="selected">'+e.CC_NAME+'</option>';
			}
		});
		htmlText +='		</select>';
		*/
		
		var parentUnitSelected2 = $(parentTrObj).find('input[name="m_unit"]').val();
		htmlText +='		<input name="m_unit" type="text" value="'+parentUnitSelected2+'" readonly="readonly" />';
		htmlText +='	</td>';
		
		var orderQuantity = $(parentTrObj).attr('orderQuantityAttr'); // 주문수량
		orderQuantity = new BigNumber(orderQuantity);
		//var parentQuantity = ($(parentTrObj).find('input[name="m_quantity"]').val()).replaceAll(',', '');
		var parentQuantity = 0;
		$('#confirmDetailListTbodyId > tr').each(function(i2,e2){
			if(tr_id == $(e2).attr('mainsubgrouptridattr')){
				var outEa = toStr($(e2).find('input[name="m_quantity"]').val().replaceAll(',', ''));
				if('' == outEa) outEa = 0;
				else outEa = Number(outEa);
				parentQuantity += outEa;
			}
		});
		parentQuantity = new BigNumber(parentQuantity);
		var quantity = decimalScale(orderQuantity-parentQuantity, 3, 2); //
		
		htmlText +='	<td class="text-right">'+addComma(orderQuantity)+'</td>';
		htmlText +='	<td class="text-center"><input type="text" class="text-right amountClass2" name="m_quantity" onkeyup=\'changeWeight("'+trId+'"); checkQuantity(this, "'+tr_id+'", "'+orderQuantity+'");\' value="'+quantity+'" /></td>';
		
		htmlText +='	<td class="text-right f-red stockTdClass"></td>';
		htmlText +='	<td class="text-right weightTdClass"></td>';
		
		var requestDate2 = $(parentTrObj).find('input[name="v_requestdate2"]').val();
		var requestDt2 = $(parentTrObj).find('input[name="m_requestdt2"]').val();
		var requestTime2 = $(parentTrObj).find('input[name="m_requesttime2"]').val();
		
		htmlText +='	<td class="text-right">';
		htmlText +='		<input type="text" class="p-r-md" name="v_requestdate2" data-field="datetime" data-startend="start" value="'+requestDate2+'" readonly="readonly" /><i class="fa fa-calendar i-calendar"></i>';
		htmlText +='		<input type="hidden" name="m_requestdt2" value="'+requestDt2+'" />';
		htmlText +='		<input type="hidden" name="m_requesttime2" value="'+requestTime2+'" />';
		htmlText +='	</td>';
		
		var pickingDt = toStr($(parentTrObj).find('input[name="m_pickingdt"]').val());
		
		htmlText +='	<td class="text-center">';
		htmlText +='		<input type="text" class="p-r-md" name="m_pickingdt" readonly="readonly" value="'+pickingDt+'" /><i class="fa fa-calendar i-calendar"></i>';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<select name="m_week">';
		htmlText +='			<option value="">선택</option>';
		
		var orderWeekListToJson = $.parseJSON('${orderWeekListToJson}');
		var parentWeekSelected = $(parentTrObj).find('select[name="m_week"] option:selected').val();
		$(orderWeekListToJson).each(function(i,e){
			if('' != toStr(e.DRDL01)){
				if(parentWeekSelected != e.DRKY){
					htmlText +='	<option value="'+e.DRKY+'">' + e.DRDL01 + '(' + e.DRKY + ') </option>';
				}else{
					htmlText +='	<option value="'+e.DRKY+'" selected="selected">' + e.DRDL01 + '(' + e.DRKY + ') </option>';
				}
			}
		});
		
		htmlText +='		</select>';
		htmlText +='	</td>';
		htmlText +='	<td class="buttonTdClass text-center">';
		htmlText +='		<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+trId+'", "200");\'>반려</button>';
		htmlText +='		<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+trId+'", "300");\'>운송비</button>';
		htmlText +='		<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+trId+'", "500");\'>요청사항</button>';
		htmlText +='		<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+trId+'", "900");\'>삭제</button>';
		htmlText +='	</td>';
		htmlText +='</tr>';
		
		// 그런데 현재 선택한 tr 다음에 운송비 tr이 있는경우, 운송비 tr 이후로 생성. 즉 원주문 > 운송비 > 주문분리 순으로 tr이 생성.
		$('#confirmDetailListTbodyId > tr.itemMainTrClass').each(function(i,e){
			if($(e)[0] == $(nowTrObj)[0]){
				if(0 < $('#confirmDetailListTbodyId > tr.itemMainTrClass').eq(i+1).length){ // 마지막 행이 아닌 경우.
					$('#confirmDetailListTbodyId > tr.itemMainTrClass').eq(i+1).before(htmlText);
				}else{ // 마지막 행.
					$('#confirmDetailListTbodyId:last').append(htmlText);
				}
			}
		});
		
		activeDatePicker();
		initAutoNumeric();
	}
	
	// 반려 사유 팝업 띄우기.
	else if('200' == type || '201' == type){ //200=등록/201=수정.
		openOrderReturnPop(tr_id, 'csReturn', type);
	}
	
	// 배송비 : 출고지 별로 한개만 가능 & 출고지 선택이후 가능.
	else if('300' == type){
		//if(!mainTrTf) return;
		
		// 체크.
		var selectedCompanyCd = $(nowTrObj).find('select[name="m_companycd"] option:selected').val();
		//var selectedCompanyText = $(nowTrObj).find('select[name="m_companycd"] option:selected').text();
		if('' == selectedCompanyCd){
			alert('출고지를 선택 후 진행해 주세요.');
			return;
		}
		
		/* 
		var dupCheck = true;
		$('#confirmDetailListTbodyId > tr').each(function(i,e){ //현재 선택한 tr의 출고지를 갖는 운송비 tr이 있는지 체크.
			if(selectedCompanyCd == $(e).find('select[name="m_companycd"] option:selected').val()){
				if($(e).hasClass('itemDeliveryTrClass')){
					alert('동일한 출고지 운송비기 이미 존재 합니다.\n운송비는 출고지 별로 1개만 입력 가능합니다.');
					dupCheck = false;
					return false;
				}
			}
		});
		if(!dupCheck) return;
		*/
		
		// tr 생성.
		var trIdTmp = $(nowTrObj).prop('id')+'_D_';
		var deliveryCnt = $('tr[id ^= "'+trIdTmp+'"]').length;
		var trId = trIdTmp+(deliveryCnt+1);
		
		//var trId = $(parentTrObj).prop('id')+'_D';
		htmlText += '<tr id="'+trId+'" class="itemDeliveryTrClass">';
		// 2025-03-11 hsg. Jack Hammer : 운송비 배열 오류. 운송비 입력 시 새로 추가된 주문그룹 열에 대한 처리. colspan="2" 추가
		htmlText += '	<td class="text-center" colspan="2">';
		
		htmlText +='		<input type="hidden" name="m_ocdreturncd" value="" />';
		htmlText +='		<input type="hidden" name="m_ocdreturnmsg" value="" />';
		htmlText +='		<input type="hidden" name="m_ocdstatuscd" value="" />';
		
		htmlText +='		<input type="hidden" name="m_quantity" value="" />';
		htmlText +='		<input type="hidden" name="m_requestdt2" value="" />';
		htmlText +='		<input type="hidden" name="m_requesttime2" value="" />';
		htmlText +='		<input type="hidden" name="m_pickingdt" value="" />';
		htmlText +='		<input type="hidden" name="m_week" value="" />';
		htmlText +='		<input type="hidden" name="m_confirmremark" value="" />';
		
		htmlText += '	</td>'; //
		
		htmlText += '	<td class="text-center">';
		htmlText += '		<select name="m_companycd" onchange=\'changeCompanyCd(this, "'+trId+'");\' >';
		//htmlText += '			<option value="">선택</option>';
		
		var plantListToJson = $.parseJSON('${plantListToJson}');
		$(plantListToJson).each(function(i,e){
			if(e.PT_CODE == selectedCompanyCd){
				htmlText += '	<option value="'+e.PT_CODE+'" selected="selected">'+e.PT_NAME+'</option>';	
			}
			else{
				htmlText += '	<option value="'+e.PT_CODE+'" disabled="disabled">'+e.PT_NAME+'</option>';
			}
		});
		
		htmlText += '		</select>';
		htmlText += '	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<input type="text" class="w-p-r-md" name="v_desc1" value="" readonly="readonly" />';
		htmlText +='		<a href="javascript:;" onclick=\'openItemPop(this, "'+trId+'", "Y");\'><i class="fa fa-search i-search f-s-15"></i></a>';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		htmlText +='		<select name="m_itemcd">';
		//htmlText +='		<select name="m_itemcd" onchange=\'setItemStock("'+trId+'");\'>';
		htmlText +='			<option value="">선택</option>';
		htmlText +='		</select>';
		htmlText +='	</td>';
		htmlText +='	<td class="text-center">';
		/* 
		htmlText +='		<select name="v_unit" disabled="disabled">';
		var unitListToJson = $.parseJSON('${unitListToJson}');
		$(unitListToJson).each(function(i,e){
			if('EA' != e.CC_NAME){
				htmlText +='	<option value="'+e.CC_NAME+'">'+e.CC_NAME+'</option>';
			}else{
				htmlText +='	<option value="'+e.CC_NAME+'" selected="selected">'+e.CC_NAME+'</option>';
			}
		});
		htmlText +='		</select>';
		*/
		htmlText +='		<input name="m_unit" type="text" value="EA" readonly="readonly" />';
		
		htmlText +='	</td>';
		htmlText +='	<td colspan="2" class="text-center">운송비금액</td>';
		htmlText +='	<td colspan="5">';
		htmlText += '		<input type="text" class="text-right amountClass2" name="m_price" value="">';
		htmlText +='	</td>';
		htmlText +='	<td class="buttonTdClass text-center">';
		htmlText +='		<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+trId+'", "900");\'>삭제</button>';
		htmlText +='	</td>';
		htmlText += '</tr>';
		
		if(0 == deliveryCnt){
			$(nowTrObj).after(htmlText);
		}
		else{
			$('tr[id="'+trIdTmp+(deliveryCnt)+'"]').after(htmlText);
		} 
		
		initAutoNumeric();
	}
	
	// 확정 요청사항 등록 팝업 띄우기.
	else if('500' == type){
		addConfirmRemark(tr_id);	
	}
}

// 확정 요청사항 레이어 팝업 띄우기.
function addConfirmRemark(tr_id){
	//trId_${status.index}
	var nowTrObj = $('#'+tr_id);
	var mainTrTf = $(nowTrObj).hasClass('itemMainTrClass'); // 선택한 class가 Main(원오더) Tr 여부(true/false);
	var m_confirmremark = '';
	
	$.confirm({
	    title: '',
	    content: '' +
	    '<form action="" class="formName">' +
	    '	<div class="form-group">' +
	    '		<label>확정 요청사항</label>' +
	    '		<input class="form-control" type="text" name="v_confirmremark" placeholder="요청사항을 입력해 주세요." value="'+m_confirmremark+'" onkeyup=\'checkByte(this, "40");\' />' +
	    '	</div>' +
	    '</form>',
	    buttons: {
	        formSubmit: {
	            text: '등록',
	            btnClass: 'btn btn-info', //btn-blue
	            action: function () {
	            	var v_confirmremark = this.$content.find('input[name="v_confirmremark"]').val();
	            	if('' == v_confirmremark){
	            		alert('요청사항을 입력해 주세요.');
	            		this.$content.find('input[name="v_confirmremark"]').focus();
	            		return false;
	            	}
	            	
	            	$(nowTrObj).find('input[name="m_confirmremark"]').val(v_confirmremark);
	            }
	        },
			delRemark: {
				text: '삭제',
				btnClass: 'btn btn-github',
				action: function(){
					$(nowTrObj).find('input[name="m_confirmremark"]').val('');
				}
	        },
	        cancel: {
	        	text: '닫기',
	        	btnClass: 'btn btn-gray',
	        },
	    },
	    onContentReady: function () {
	        // bind to events
	        var jc = this;
	        this.$content.find('form').on('submit', function (e) {
	            // if the user submits the form by pressing enter in the field.
	            e.preventDefault();
	            jc.$$formSubmit.trigger('click'); // reference the button and click it
	        });
	        
	        this.$content.find('input[name="v_confirmremark"]').val(m_confirmremark);
	    },
	    contentLoaded: function(data, status, xhr){
	        // when content is fetched
	        //alert('contentLoaded: ' + status);
	        alert(data);
	    },
	    onOpenBefore: function () {
	        // before the modal is displayed.
	        //alert('onOpenBefore');
	    	//m_confirmremark
	    	m_confirmremark = $(nowTrObj).find('input[name="m_confirmremark"]').val();
	    },
	    onOpen: function () {
	        // after the modal is displayed.
	        //alert('onOpen');
	    },
	    onClose: function () {
	        // before the modal is hidden.
	        //alert('onClose');
	    },
	    onDestroy: function () {
	        // when the modal is removed from DOM
	        //alert('onDestroy');
	    },
	    onAction: function (btnName) {
	        // when a button is clicked, with the button name
	        //alert('onAction: ' + btnName);
	    },
	});
}

// CS반려 팝업 띄우기.
// tr_id : 품목별 반려 처리인 경우에만 있음. 전체반려인 경우 빈값
// cancel_type : csReturn=품목별 반려, csAllReturn=전체반려
// type : 200=등록, 201=수정.
function openOrderReturnPop(tr_id, cancel_type, type){
	// 팝업 세팅.
	var widthPx = 600;
	var heightPx = 350;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop"]').remove();
	
	var htmlText = '';
	var pageType = ('200' == type) ? 'ADD' : 'EDIT';
	htmlText += '<form name="frm_pop" method="post" target="orderReturnPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="page_type" value="'+pageType+'" />';
	htmlText += '	<input type="hidden" name="cancel_type" value="'+cancel_type+'" />';
	htmlText += '	<input type="hidden" name="r_settrid" value="'+tr_id+'" />';
	
	htmlText += '	<input type="hidden" name="v_ocdreturncd" value="'+toStr($('#'+tr_id).find('input[name="m_ocdreturncd"]').val())+'" />';
	htmlText += '	<input type="hidden" name="v_ocdreturnmsg" value="'+toStr($('#'+tr_id).find('input[name="m_ocdreturnmsg"]').val())+'" />';
	
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/pop/orderReturnPop.lime';
	window.open('', 'orderReturnPop', options);
	$('form[name="frm_pop"]').prop('action', popUrl);
	$('form[name="frm_pop"]').submit().remove();
}

// return 품목별 CS반려(03) 팝업에서 확인.
function setOrderReturnFromPop(jsonData, tr_id){
	//console.log('jsonData : ', jsonData);
	//alert(tr_id);
	
	$('#'+tr_id).find('input[name="m_ocdreturncd"]').val(toStr(jsonData.OCD_RETURNCD));
	$('#'+tr_id).find('input[name="m_ocdreturnmsg"]').val(toStr(jsonData.OCD_RETURNMSG));
	$('#'+tr_id).find('input[name="m_ocdstatuscd"]').val('03');
	
	var htmlText = '';
	
	$('#'+tr_id).find('.buttonTdClass').empty();
	
	htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "201");\'>반려사유수정</button> ';
	htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'cancelOrderReturn("'+tr_id+'");\'>초기화</button>';
	
	$('#'+tr_id).find('.buttonTdClass').append(htmlText);

	orderCheckFunction();
}

//return 전체 CS반려(03) 팝업에서 확인.
function setOrderAllReturnFromPop(jsonData){
	$('input[name="m_returncd"]').val(jsonData.RETURN_CD);
	$('input[name="m_returndesc"]').val(jsonData.RETURN_DESC);

	dataInAjax($('#btn002')[0], '03');
}

//return 전체 CS반려(03) 팝업에서 확인.
function setOrderAllReturnFromPopProcess(jsonData){
	$('input[name="m_returncd"]').val(jsonData.RETURN_CD);
	$('input[name="m_returndesc"]').val(jsonData.RETURN_DESC);

	dataInAjax($('#btn002')[0], '03','N');
}

// 반려건 취소.
function cancelOrderReturn(tr_id){
	$('#'+tr_id).find('input[name="m_ocdreturncd"]').val('');
	$('#'+tr_id).find('input[name="m_ocdreturnmsg"]').val('');
	$('#'+tr_id).find('input[name="m_ocdstatuscd"]').val('');
	
	var htmlText = '';

	$('#'+tr_id).find('.buttonTdClass').empty();
	
	if($('#'+tr_id).hasClass('itemMainTrClass')){
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "100");\'>주문분리</button> ';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "200");\'>반려</button> ';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "300");\'>운송비</button>';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "500");\'>요청사항</button>';
	}
	if($('#'+tr_id).hasClass('itemSubTrClass')){
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "200");\'>반려</button> ';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "300");\'>운송비</button> ';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "500");\'>요청사항</button> ';
		htmlText +='<button type="button" class="btn btn-default btn-xs" onclick=\'setOrderItem(this, "'+tr_id+'", "900");\'>삭제</button>';
	}
	
	$('#'+tr_id).find('.buttonTdClass').append(htmlText);

	orderCheckFunction();
}

// 자재주문서 출력 팝업.
function openOrderPaperPop(obj){
	var reqno = '${orderHeader.REQ_NO}';
	
	// 팝업 세팅.
	var widthPx = 900;
	var heightPx = 750;
	var options = 'toolbar=no, location=no, status=no, directories=no, channelmode=no, menubar=no, scrollbars=yes, resizable=yes, width='+widthPx+', height='+heightPx;
	
	$('form[name="frm_pop2"]').remove();
	
	var htmlText = '';
	htmlText += '<form name="frm_pop2" method="post" target="orderPaperPop">';
	htmlText += '	<input type="hidden" name="pop" value="1" />';
	htmlText += '	<input type="hidden" name="ri_reqno" value="'+reqno+'" />';
	htmlText += '</form>';
	$('body').append(htmlText);
	
	// #POST# 팝업 열기.
	var popUrl = '${url}/admin/base/orderPaperPop.lime';
	window.open('', 'orderPaperPop', options);
	$('form[name="frm_pop2"]').prop('action', popUrl);
	$('form[name="frm_pop2"]').submit().remove();
}

// 유효성 체크.
function dataValidation(){
	var checkTf = true;
	
	if(checkTf) checkTf = validation($('input[name="v_requestdate"]')[0], '납품요청일시', 'value');
	if(checkTf) checkTf = validation($('input[name="m_zipcd"]')[0], '납품 주소 우편번호', 'value');
	if(checkTf) checkTf = validation($('input[name="m_add1"]')[0], '납품 주소', 'value');
	// if(checkTf) checkTf = validation($('input[name="m_add2"]')[0], '납품 상세 주소', 'value');
	if(!checkTf){
		return checkTf;
	}

	if($('input[name="m_zipcd"]').val().length != 5) {
		alert('우편번호는 5자리만 입력 가능합니다.');
		checkTf = false;
		return false;
	}
	
	$('#confirmDetailListTbodyId > tr').each(function(i,e){
		// 공통 체크.		
		if('' == $(e).find('select[name="m_companycd"] option:selected').val()){
			alert('출고지를 선택해 주세요.');
			$(e).find('select[name="m_companycd"]').focus();
			checkTf = false;
			return false;
		}
		
		if('' == $(e).find('input[name="v_desc1"]').val()){
			alert('품목명을 입력해 주세요.');
			$(e).find('input[name="v_desc1"]').focus();
			checkTf = false;
			return false;
		}
		
		if('' == $(e).find('select[name="m_itemcd"] option:selected').val()){
			alert('품목코드를 선택해 주세요.');
			$(e).find('select[name="m_itemcd"]').focus();
			checkTf = false;
			return false;
		}

		
		
		// 원주문 / 주문부리  tr체크.
		if($(e).hasClass('itemMainTrClass') || $(e).hasClass('itemSubTrClass')){
			if('' == $(e).find('input[name="m_quantity"]').val()){
				alert('출고수량을 입력해 주세요.');
				$(e).find('input[name="m_quantity"]').focus();
				checkTf = false;
				return false;
			}
			
			// 납품요청일시 선택 여부.
			if('' == $(e).find('input[name="v_requestdate2"]').val()){
				alert('납품요청일시를 입력해 주세요.');
				$(e).find('input[name="v_requestdate2"]').focus();
				checkTf = false;
				return false;
			}
			
			// 피킹일자 선택 여부.
			if('' == $(e).find('input[name="m_pickingdt"]').val()){
				alert('피킹일자를 입력해 주세요.');
				$(e).find('input[name="m_pickingdt"]').focus();
				checkTf = false;
				return false;
			}

			// 주차 선택 여부.
			if('' == $(e).find('select[name="m_week"] option:selected').val()){
				alert('주차를 선택해 주세요.');
				$(e).find('select[name="m_week"]').focus();
				checkTf = false;
				return false;
			}
			
			// 납품요청일시는 피킹일자보다 빠를수 없음 체크.
			var v_requestdate2 = $(e).find('input[name="v_requestdate2"]').val();
			v_requestdate2 = v_requestdate2.substring(0, 10);
			v_requestdate2 = v_requestdate2.replaceAll('-', '');
			var m_pickingdt = $(e).find('input[name="m_pickingdt"]').val();
			m_pickingdt = m_pickingdt.replaceAll('-', '');
			if(v_requestdate2 < m_pickingdt){
				alert('납품요청일은 피킹일자 보다 빠를수 없습니다.');
				$(e).find('input[name="v_requestdate2"]').focus();
				checkTf = false;
				return false;
			}
			
			// 납품요청일은 오늘보다 이전날짜 선택 할 수 없음 체크. > 달력에서 제어.
			// 피킹일자는  오늘보다 이전날짜 선택 할 수 없음 체크. > 달력에서 제어.
			// 휴일을 피킹일로 지정 할 수 없음. > O_DATE.HOLIDAY_YN='Y'가 없음.
		}
		
		// 운송비 tr체크.
		if($(e).hasClass('itemDeliveryTrClass')){
			//운송비금액 입력여부 체크.
			if('' == $(e).find('input[name="m_price"]').val()){
				alert('운송비를 입력해 주세요.');
				$(e).find('input[name="m_price"]').focus();
				checkTf = false;
				return false;
			}
		}
	});
	
	return checkTf;
}

function checkDataIn(obj, status) {
	var params = {r_zipcd : $('input[name="m_zipcd"]').val()};
	$.ajax({
		async : false,
		url : '${url}/admin/order/getPostalCodeCount.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : params,
		success : function(data){
			if(data.useFlag === 'Y') {
				dataIn(obj, status, reqNo);
			} else {
				alert('해당 우편번호는 시스템에 존재하지 않습니다. 담당CS직원에게 문의해 주세요.');
			}
		},
		error : function(request,status,error){
			alert('해당 우편번호는 시스템에 존재하지 않습니다. 담당CS직원에게 문의해 주세요.');
		}
	});
}

// 주문처리.
function dataIn(obj, status){ // status : 주문확정(주문확정(분리))=0507, 전체반려=03.
	if('03' != status){
		$(obj).prop('disabled', true);
	}


	/* 2025-02-27 hsg. Belly to Belly Suplex :
	 *	주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기.
	 *	주문그룹 입력 건수가 전체 건수와 같거나 아예 없어야 한다
	 * ▽▽▽▽▽▽▽▽▽▽▽▽▽ 추가 시작 ▽▽▽▽▽▽▽▽▽▽▽▽▽▽▽▽▽▽▽
	 */

	 //$("input[name='username']").eq(1).val("Bob 수정됨"); // 두 번째 input만 변경


	var m_orderGroup_length_cnt = $("input[name='m_orderGroup']").length;
	var m_orderGroup_empty_cnt = 0;
	var m_orderGroup_input_cnt = 0;
	var m_orderSeparator_check = false; // 2025-03-11 hsg. Jack Hammer : 주문그룹에 다른 값이 있을 경우 주문확정(분리)로, 모두 같을 경우 주문분리로  


	for( var i = 0 ; i < m_orderGroup_length_cnt ; i++ ){
		if( "" == $('input[name="m_orderGroup"]').eq(i).val() ){
			m_orderGroup_empty_cnt++;
		} else {
			m_orderGroup_input_cnt++;
		}
	}

	if( m_orderGroup_length_cnt != m_orderGroup_empty_cnt ){
		if( m_orderGroup_length_cnt != m_orderGroup_input_cnt ){
			alert('주문그룹은 전체를 입력하시거나 하나도 입력하지 않아야 합니다.');ㅑ 
			$(obj).prop('disabled', false);
			return;
		}
	}

	//alert("total : " + m_orderGroup_length_cnt + " // empty : " + m_orderGroup_empty_cnt + "// input : " + m_orderGroup_input_cnt);

	if( m_orderGroup_length_cnt == m_orderGroup_input_cnt ){
		for ( var i = 0 ; i < m_orderGroup_length_cnt ; i++ ) {
			for ( var j = 0 ; j < m_orderGroup_length_cnt ; j++ ) {
				if( $('input[name="m_orderGroup"]').eq(i).val() ==  $('input[name="m_orderGroup"]').eq(j).val() ){
					if( (i != j) && $('select[name="m_companycd"] option:selected')[i].value !=  $('select[name="m_companycd"] option:selected')[j].value ){
						alert('출고지가 다르게 입력되어 있습니다.');
						$(obj).prop('disabled', false);
						return;
					}
				} else {
					m_orderSeparator_check = true; // 2025-03-11 hsg. Jack Hammer : 주문그룹에 다른 값이 있을 경우 주문확정(분리)로, 모두 같을 경우 주문분리로 
				}
			}
		}
	}


	// alert('성공!!');
	// $(obj).prop('disabled', false);

	// return;

	/* 2025-02-27 hsg. Belly to Belly Suplex :
	 * △△△△△△△△△△△△△△ 추가 끝 △△△△△△△△△△△△△△△△
	 */


	var postalCodeChk = false;
	var params = {r_zipcd : $('input[name="m_zipcd"]').val()};
	$.ajax({
		async : false,
		url : '${url}/admin/order/getPostalCodeCount.lime',
		cache : false,
		type : 'POST',
		dataType: 'json',
		data : params,
		success : function(data){
			if(data.useFlag === 'Y') {
				postalCodeChk = true;
			}
		},
		error : function(request,status,error){	
		}
	});

	if(!postalCodeChk) {
		alert('해당 우편번호는 시스템에 존재하지 않습니다. 담당CS직원에게 문의해 주세요.');
		$(obj).prop('disabled', false);
		return;
	}

	// 파라미터 재정의.
	$('input[name="m_returncd"]').val('');
	$('input[name="m_returndesc"]').val('');

	// 주문 상태값 정의. > 주문확정(분리)07은 2가지 케이스로 정의 해야 함.
	var m_statuscd = '05';
	if(0 < $('#confirmDetailListTbodyId > tr.itemSubTrClass').length){
		m_statuscd = '07';
	}
	var m_companycd = '';
	$('#confirmDetailListTbodyId > tr').each(function(i,e){
		if(0==i){
			m_companycd = '||'+$(e).find('select[name="m_companycd"] option:selected').val()+'||';
		}else{
			if(0 > m_companycd.indexOf('||'+$(e).find('select[name="m_companycd"] option:selected').val()+'||')){
				m_statuscd = '07';
			}
		}
	});
	
	if( m_orderSeparator_check ) {
		// 2025-03-11 hsg. Jack Hammer : 주문그룹으로 나뉘어진 경우 주문확정(분리)으로 변경한다.
		m_statuscd = '07';
	}
	
	//alert('m_companycd : '+m_companycd+'\nm_statuscd : '+m_statuscd);
	// 요청사항 행바꿈/엔터 제거. 
	var m_remark = $('input[name="m_remark"]').val();
	if('' != m_remark){
		m_remark = m_remark.replace(/\n/g, ' '); // 행바꿈 제거
		m_remark = m_remark.replace(/\r/g, ' '); // 엔터 제거
		$('input[name="m_remark"]').val(m_remark);
	}
	
	if('03' == status) m_statuscd = '03';

	
	// 전체반려.
	/*if('03' == m_statuscd){
		openOrderReturnPop('', 'csAllReturn', '200');
		return;
	}*/

	// 전체반려가 아닌경우 유효성 체크.
	var checkTf = dataValidation();
	if(!checkTf){
		$(obj).prop('disabled', false);
		return;
	}


	// 전체반려.
	if('03' == m_statuscd){
		openOrderReturnPop('', 'csAllReturn', '200');
		return;
	}
	
	
	// 출고수량이 주문수량보다 적은지/많은지 체크.
	var checkMainGroupId = '';
	$('#confirmDetailListTbodyId > tr').each(function(i,e){
		if(!$(e).hasClass('itemDeliveryTrClass')){ // 운송비 tr 제외.
			if(0 > checkMainGroupId.indexOf($(e).attr('mainsubgrouptridattr'))){
				if('' == checkMainGroupId){
					checkMainGroupId = $(e).attr('mainsubgrouptridattr');
				}
				else{
					checkMainGroupId += ','+$(e).attr('mainsubgrouptridattr');	
				}
			}
		}
	});
	var checkMainGroupIdArr = checkMainGroupId.split(',');
	for(var i=0,j=checkMainGroupIdArr.length; i<j; i++){
		var mainTrId = checkMainGroupIdArr[i];
		var nowTrOutEa = 0;
		var orderQuantity = Number($('#'+mainTrId).attr('orderQuantityAttr')); // 주문수량
		$('#confirmDetailListTbodyId > tr').each(function(i2,e2){
			if(mainTrId == $(e2).attr('mainsubgrouptridattr')){
				var outEa = toStr($(e2).find('input[name="m_quantity"]').val().replaceAll(',', ''));
				if('' == outEa) outEa = 0;
				else outEa = Number(outEa);
				nowTrOutEa += outEa;
			}
		});
		//alert('주문수량 : '+orderQuantity+'\n출고수량 : '+nowTrOutEa);
		if(orderQuantity > nowTrOutEa){
			dCheck = false;
			alert('출고수량이 주문수량보다 적을 수 없습니다.');
			$(obj).prop('disabled', false);
			return false;
		}
		if(orderQuantity < nowTrOutEa){
			dCheck = false;
			alert('출고수량이 주문수량보다 많을 수 없습니다.');
			$(obj).prop('disabled', false);
			return false;
		}
	}
	
	// 주문확정인 경우 체크, 품목 리스트에 있는 납품요청일시 & 픽업일자가 모두 동일한지 체크. 주차는 달라도 상관없음.
	var dCheck = true;
	if('05' == m_statuscd){
		var firstRequestDt = '';
		var firstPickingDt = '';
		$('#confirmDetailListTbodyId > tr').each(function(i,e){
			if(!$(e).hasClass('itemDeliveryTrClass')){ // 운송비 tr 제외.
				
				if(0==i){
					firstRequestDt = $(e).find('input[name="v_requestdate2"]').val();	
					firstPickingDt = $(e).find('input[name="m_pickingdt"]').val();
					
					if($('input[name="v_requestdate"]').val() != firstRequestDt){
						dCheck = false;
						alert('상단의 납품요청일시와 주문품목의 납품요청일시를 동일하게 입력 해 주세요.');
						return false;
					}
				}
				
				if(firstRequestDt != $(e).find('input[name="v_requestdate2"]').val()){
					dCheck = false;
					alert('주문품목의 납품요청일시를 동일하게 입력 해 주세요.');
					return false;
				}
				if(firstPickingDt != $(e).find('input[name="m_pickingdt"]').val()){
					dCheck = false;
					alert('주문품목의 피킹일자를 동일하게 입력 해 주세요.');
					return false;
				}
			}
		});
	}
	
	if(!dCheck){
		$(obj).prop('disabled', false);
		return;
	}
	// End. 주문확정인 경우 체크.
	
	console.log("m_statuscd : " + m_statuscd);
	// 주문처리 저장.
	dataInAjax(obj, m_statuscd);
}

// 주문처리 저장.
function dataInAjax(obj, status_cd, confrimFlag){
	$('input[name="m_statuscd"]').val(status_cd);
	
	var confirmText = '';
	if('03' == status_cd){
		confirmText = '전체반려 하시겠습니까?';
	}else if('05' == status_cd){
		confirmText = '주문확정 하시겠습니까?';
	}else if('07' == status_cd){
		confirmText = '주문확정(분리) 하시겠습니까?';
	}
	
	if((confrimFlag != undefined && confrimFlag == 'N') || confirm(confirmText)){
		$('form[name="frm"]').ajaxSubmit({
			dataType : 'json',
			type : 'post',
			url : '${url}/admin/order/insertOrderConfirmAjax.lime',
			//async : false, //사용x
			//data : param, //사용x
			success : function(data) {
				if(data.RES_CODE == '0000') {
					alert(data.RES_MSG);
					
					$('#moveListBtnId').trigger('click');
					//formGetSubmit('${url}/admin/order/orderList.lime', 'fromOrderView=Y');
					//formGetSubmit('${url}/admin/order/orderList.lime', '');
				}
				else if(data.RES_CODE == '0320'){
					formGetSubmit('${url}/admin/order/orderEdit.lime', 'r_reqno=${param.r_reqno}');
					//document.location.reload();
				}
				$('#ajax_indicator').fadeOut();
				$(obj).prop('disabled', false);
			},
			error : function(request,status,error){
				alert('Error');
				$('#ajax_indicator').fadeOut();
				$(obj).prop('disabled', false);
			},
			beforeSend: function(xhr){
				$('#ajax_indicator').show().fadeIn('fast');
			},
			uploadProgress: function(event, position, total, percentComplete){
			},
		});
	}else{
		$(obj).prop('disabled', false);
	}
}

// 출고수량은 주문수량보다 많을 수 없음. > 주문분리 한경우 출고수량의 합을 계산해줘서 주문수량과 비교.
function checkQuantity(obj, group_tr_id, order_quantity) { // order_quantity:주문수량
	var orderEa = 0; // 출고수량
	
	$('#confirmDetailListTbodyId > tr').each(function(i,e){
		if(group_tr_id == $(e).attr('mainSubGroupTrIdAttr')){
			orderEa += Number(($(e).find('input[name="m_quantity"]').val()).replaceAll(',', ''));
		}
	});
	
	if(order_quantity < orderEa){
		alert('출고수량은 주문수량보다 많을 수 없습니다.');
		$(obj).val('');
	}
}

function orderCheckFunction() {
	var chkReturn = false;
	$('#confirmDetailListTbodyId > tr').each(function(i,e) {
		var stat = $(e).find('input[name="m_ocdstatuscd"]').val();	
		if(stat !== '03')
			chkReturn = true;
	});
	if(chkReturn) {
		$('#btn001').prop('disabled', false);
		$('#btn003').prop('disabled', false);
	} else {
		$('#btn001').prop('disabled', true);
		$('#btn003').prop('disabled', true);
		alert('전체반려 선택 가능한 상태입니다.');
	}
}

</script>
</head>

<body class="page-header-fixed pace-done compact-menu searchHidden">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>
	
	<div class="overlay"></div>
	
	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
	
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>${orderStatus[orderHeader.STATUS_CD]} ${orderHeader.REQ_NO} <%-- 상태값 & 주문번호 --%>
					<div class="page-right">
						<button type="button" class="btn btn-line w100 w-s" onclick="openOrderPaperPop(this);" >자재주문서 출력</button>
						<button type="button" class="btn btn-line f-black" title="목록" id="moveListBtnId" onclick="document.location.href='${url}/admin/order/orderList.lime?fromOrderView=Y'"><i class="fa fa-list-ul"></i><em>목록</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="document.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<form name="frm" method="post">
							<input type="hidden" name="r_reqno" value="${param.r_reqno}" />
							<input type="hidden" name="r_ohhseq_now" value="${orderHistorySeq}" /> <%-- 주문처리 가능한지 체크를 위한 OrderHeaderHisotry.OHH_SEQ --%>
							<input type="hidden" name="m_statuscd" value="05" />
							<input type="hidden" name="m_returncd" value="" />
							<input type="hidden" name="m_returndesc" value="" />

							<%-- Create an empty container for the picker popup. --%>
							<div id="dateTimePickerDivId"></div>
							
							<%-- Start. 납품요청일시 세팅. --%>
							<fmt:parseDate value="${orderHeader.REQUEST_DT}" var="requestDate" pattern="yyyyMMdd"/>
							<fmt:parseDate value="${orderHeader.REQUEST_TIME}" var="requestTime" pattern="HHmm"/>
							<c:set var="v_requestdatedt"><fmt:formatDate value="${requestDate}" pattern="yyyy-MM-dd"/> <fmt:formatDate value="${requestTime}" pattern="HH:mm"/></c:set>
							<%-- End. 납품요청일시 세팅. --%>
							
							<div class="panel-body">
								<h5 class="table-title">주문정보</h5>
								<div class="btnList writeObjectClass">
									<button type="button" class="btn btn-info" id="btn001" onclick="dataIn(this, '0507');">주문확정</button>
									<button type="button" class="btn btn-gray-d" id="btn002" onclick="dataIn(this, '03');">전체반려</button>
								</div>
								
								<div class="table-responsive">
									<table id="" class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="12%" />
											<col width="38%" />
											<col width="12%" />
											<col width="38%" />
										</colgroup>
										<tbody>
											<tr>
												<th>거래처명</th>
												<td>${orderHeader.CUST_NM}(${orderHeader.CUST_CD})</td>
												<th>납품처</th>
												<td>
													<c:set var="shiptoCd">${orderHeader.SHIPTO_CD}</c:set>
													<c:if test="${'0' eq shiptoCd}"><c:set var="shiptoCd" value="" /></c:if>
													
													<input type="text" class="w-16" name="m_shiptocd" placeholder="납품처코드" value="${shiptoCd}" readonly="readonly" onclick="openShiptoPop(this);" />
													<input type="text" class="w-40" name="v_shiptonm" placeholder="납품처명" value="${orderHeader.SHIPTO_NM}" readonly="readonly" onclick="openShiptoPop(this);" />
													<a href="javascript:;" onclick="openShiptoPop(this);"><i class="fa fa-search i-search"></i></a>
													<button type="button" class="btn btn-line btn-xs writeObjectClass" onclick="setDefaultShipTo();">초기화</button>
												</td>
											</tr>
											<tr>
												<th>주문자 / 주문일자</th>
												<td>
													${orderHeader.USER_NM}(${orderHeader.USERID}) / 
													<c:choose>
														<c:when test="${empty orderHeader.INDATE}">-</c:when>
														<c:otherwise>${fn:substring(orderHeader.INDATE, 0, 16)}</c:otherwise>
													</c:choose>
												</td>
												<th>납품요청일시 *</th>
												<td>
													<input type="text" class="w-40" name="v_requestdate" data-field="datetime" data-startend="start" value="${v_requestdatedt}" readonly="readonly" /><i class="fa fa-calendar i-calendar"></i>
													<input type="hidden" name="m_requestdt" value="<fmt:formatDate value="${requestDate}" pattern="yyyyMMdd"/>" /> <%-- YYYYMMDD --%>
													<input type="hidden" name="m_requesttime" value="<fmt:formatDate value="${requestTime}" pattern="HHmm"/>" /> <%-- HHMM --%>
												</td>
											</tr>
											<tr>
												<th>인수자명</th>
												<td>
													${orderHeader.RECEIVER}
													<%-- <input type="text" class="w-40" name="m_receiver" value="${orderHeader.RECEIVER}" onkeyup="checkByte(this, '40')"; /> --%>
												</td>
												
												<th>연락처1 / 연락처2</th>
												<td>
													${orderHeader.TEL1}<c:if test="${!empty orderHeader.TEL2}"> / ${orderHeader.TEL2}</c:if>
													<%-- 
													<input type="text" class="w-40" name="m_tel1" placeholder="연락처 필수, 숫자만 입력해 주세요." value="${orderHeader.TEL1}" onkeyup="checkByte(this, '40')"; />
													<input type="text" class="w-40" name="m_tel2" placeholder="연락처2, 숫자만 입력해 주세요." value="${orderHeader.TEL2}" onkeyup="checkByte(this, '40')"; />
													 --%>
												</td>
											</tr>
											<tr>
												<th>영업담당자</th>
												<td>
													<c:choose>
														<c:when test="${empty orderHeader.SALESUSERID}">-</c:when>
														<c:otherwise>${orderHeader.SALESUSER_NM}(${orderHeader.SALESUSERID})</c:otherwise>
													</c:choose>
												</td>
												<th>운송수단 *</th>
												<td class="radio">
													<label><input type="radio" name="m_transty" value="AA" <c:if test="${empty orderHeader.TRANS_TY or 'AA' eq orderHeader.TRANS_TY}">checked="checked"</c:if> />기본운송</label>
													<label><input type="radio" name="m_transty" value="AB" <c:if test="${'AB' eq orderHeader.TRANS_TY}">checked="checked"</c:if> />자차운송(주문처운송)</label>
												</td>
											</tr>
											<tr>
												<th>납품주소 *</th>
												<td colspan="3">
													<div class="orderadd">
														<input type="text" class="w-16 numberClass" name="m_zipcd" placeholder="우편번호" value="${orderHeader.ZIP_CD}" onkeyup="checkByte(this, '12')"; />
														<button type="button" class="btn btn-black btn-xs writeObjectClass" onclick="openPostPop2('m_zipcd', 'm_add1', 'm_add2', '', '40');">우편번호찾기</button>
													</div>
													<input type="text" class="w-40" name="m_add1" placeholder="주소" value="${orderHeader.ADD1}" onkeyup="checkByte(this, '180')"; />
													<input type="text" class="w-40" name="m_add2" placeholder="상세주소" value="${orderHeader.ADD2}" onkeyup="checkByte(this, '80')"; />
												</td>
											</tr>
											<tr>
												<th class="f-red">요청사항</th>
												<td colspan="3">
													<input type="text" class="f-red" name="m_remark" value="${orderHeader.REMARK}" onkeyup="checkByte(this, '40');" />
												</td>
											</tr>
											<tr>
												<th>거래처 주의사항</th>
												<td colspan="3">
													<!-- 2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가. SHIP_TO Table에 Comment(VARCHAR(80)) 추가 -->
													<span id="matterSpanId">${shipToOne.Comment}</span>
													<input type="hidden" class="" name="m_custommatter" value="${shipToOne.Comment}" />
													<%-- <span id="matterSpanId">${shipToOne.ADD4}</span>
													<input type="hidden" class="" name="m_custommatter" value="${shipToOne.ADD4}" /> --%>
													<%-- 이전 시스템에서는 O_SHIPTO.ADD2=거래처주의사항이였으나, TO_BE에서는 ADD4로 개선요청. --%>
													<%-- <input type="text" class="" name="m_custommatter" value="${shipToOne.ADD2}" /> --%>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							
								<h5 class="table-title">주문품목</h5>
								<div class="table-responsive m-t-xs">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="5%" />
											<col width="10%" />
											<col width="6%" />
											<col width="10%" />
											<col width="*" />
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>품목코드</th>
												<th>단위</th>
												<th>수량</th>
												<th class="text-left p-l-xxxl">품목명</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${orderDetailList}" var="list" varStatus="status">
											<tr>
												<td class="text-center"><fmt:formatNumber value="${status.count}" pattern="#,###" /></td>
												<td class="text-center">${list.ITEM_CD}</td>
												<td class="text-center">${list.UNIT}</td>
												<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" /></td>
												<td class="text-left p-l-xxxl">${list.DESC1}</td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								
								<h5 class="table-title">주문품목 확정처리</h5>
								<div class="btnList2 more">
									<select class="" name="select_companycd" onchange="changeCompanyCd(this, '');">
										<option value="">출고지를 선택하세요</option>
										<c:forEach items="${plantList}" var="list">
											<option value="${list.PT_CODE}">${list.PT_NAME}</option>
										</c:forEach>
									</select>
									
									<input type="text" class="form-control" name="select_pickingdt" value="" placeholder="피킹일자를 선택하세요" readonly="readonly" /><i class="fa fa-calendar i-calendar"></i>
									
									<select name="select_week" onchange="changeAllWeek(this);">
										<option value="">ROUTE를 선택하세요</option>
										<c:forEach items="${orderWeekList}" var="list">
											<!--<c:if test="${!empty list.DRDL01}">-->
												<!--  <option value="${list.DRKY}">${list.DRSPHD}년 ${list.DRDL01}</option> -->
												<option value="${list.DRKY}">${list.DRDL01}(${list.DRKY})</option>
											<!--</c:if> -->
										</c:forEach>
									</select>
								</div>
								
								<div class="table-responsive m-t-xs">
									<table class="display table dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
										<colgroup>
											<col width="2%" />
											<col width="4%" /><!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 추가된 주문그룹 -->
											<col width="9%" />
											<col width="13%" />
											<col width="7%" />
											<col width="4%" />
											
											<col width="5%" /><!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 크기가 변경된 항목 -->
											<col width="6%" /><!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 크기가 변경된 항목 -->
											<col width="5%" />
											<col width="5%" />
											
											<col width="10%" /><!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 크기가 변경된 항목 -->
											<col width="8%" />
											<col width="7%" />
											<col width="15%" />
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>주문<br>그룹</th><!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 추가된 주문그룹 -->
												<th>출고지</th>
												<th>품목명</th>
												<th>품목코드</th>
												<th>단위</th>
												
												<th>주문수량</th>
												<th>출고수량</th>
												<th class="f-red">재고</th>
												<th>중량</th>
												
												<th>납품요청일시</th>
												<th>피킹일자</th>
												<th>ROUTE</th>
												<th>기능</th>
											</tr>
										</thead>
										
										<%-- ####################################################################################################################################### --%>
										<%-- ####### [주의] 아래 내용 수정시 스크립트 부분도 수정해야 합니다. function setOrderItem / setOrderReturnFromPop / cancelOrderReturn > 동적으로 tr 생성. ####### --%>
										<%-- ####################################################################################################################################### --%>
										
										<tbody id="confirmDetailListTbodyId">
											<c:forEach items="${orderDetailList}" var="list" varStatus="status">
											<tr id="trId_${status.index}" class="itemMainTrClass" orderQuantityAttr="${list.QUANTITY}" mainSubGroupTrIdAttr="trId_${status.index}">
												<td class="text-center">
													<%-- default : 05(주문확정) --%>
													<%-- <input  type="hidden" name="m_status" value="05" /> --%> 
													
													<input type="hidden" name="m_ocdreturncd" value="" /> <%-- 반려코드 From 반려팝업. --%>
													<input type="hidden" name="m_ocdreturnmsg" value="" /> <%-- 반려사유 From 반려팝업. --%>
													<input type="hidden" name="m_ocdstatuscd" value="" /> <%-- 반려상태값(03=CS반려) From 반려팝업. --%>
													<input type="hidden" name="m_orderSeparation" value="trId_${status.index}" /><%--  2025-02-11 hsg Ankle Rock. 주문분리일 경우 오더번호를 생성하기 위해 주문분리 구분자 추가. 구분자 : 부모행 번호(trId_x) --%><%-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 주문분리 했을 경우 부모 값으로 설정 --%>

													<input type="hidden" name="m_price" value="" />
													
													<input type="hidden" name="m_confirmremark" value="" />
												
													<fmt:formatNumber value="${status.count}" pattern="#,###" />
												</td>
												<!-- 2025-02-27 hsg. Belly to Belly Suplex : 주문분리 변경사항 => 현재 운영 서버 소스로 되돌리고, 주문그룹 추가 하기. 그로 인해 추가된 주문그룹 -->
												<%-- 2025-03-12 hsg. Diving body press : 주문그룹 출력 시에 디바이스의 해상도 혹은 배율이 다를 경우 주문그룹이 짤리는데 무조건 표기되도록 style="width:7ch;" onkeyup="checkByte(this, 3);" 추가 --%>
												<td class="text-center"><input type="text" class="p-r-md" style="width:7ch;" onkeyup="checkByte(this, 3);"  name="m_orderGroup" value="" /></td>
												<td class="text-center">
													<select name="m_companycd" onchange="changeCompanyCd(this, 'trId_${status.index}');">
														<option value="">선택</option>
														<c:forEach items="${plantList}" var="list2">
															<option value="${list2.PT_CODE}">${list2.PT_NAME}</option>
														</c:forEach>
													</select>
												</td>
												<td class="text-center">
													<input type="text" class="p-r-md" name="v_desc1" value="${list.DESC1}" readonly="readonly" />
													<a href="javascript:;" onclick="openItemPop(this, 'trId_${status.index}', 'N');"><i class="fa fa-search i-search"></i></a>
												</td>
												<td class="text-center"><!-- 품목코드 -->
													<select name="m_itemcd" onchange="setItemStock('trId_${status.index}');">
														<option value="">선택</option>
													</select>
												</td>
												<td class="text-center">
													<%-- 
													<select name="v_unit" disabled="disabled">
														<c:forEach items="${unitList}" var="list2">
															<option value="${list2.CC_NAME}" <c:if test="${list.UNIT eq list2.CC_NAME}">selected="selected"</c:if>>${list2.CC_NAME}</option>
														</c:forEach>
													</select>
													--%>
													<input name="m_unit" type="text" value="${list.UNIT}" readonly="readonly" />
												</td>
												<td class="text-right"><fmt:formatNumber value="${list.QUANTITY}" type="number" pattern="#,###.##" /></td>
												<td class="text-center">
													<input type="text" class="text-right amountClass2" name="m_quantity" onkeyup="changeWeight('trId_${status.index}'); checkQuantity(this, 'trId_${status.index}', '${list.QUANTITY}');" value="${list.QUANTITY}" />
												</td>
												<td class="text-right f-red stockTdClass"></td>
												<td class="text-right weightTdClass"></td>
												<td class="text-right">
													<%-- 2025-03-12 hsg. Haribo : 납품요청일시 출력 시에 디바이스의 해상도 혹은 배율이 다를 경우 시간이 표기가 되지 않는데 시간이 무조건 표기되도록 style="width:20ch;" 추가 --%>
													<input type="text" class="p-r-md" style="width:20ch;" name="v_requestdate2" data-field="datetime" data-startend="start" value="${v_requestdatedt}" readonly="readonly" /><i class="fa fa-calendar i-calendar"></i>
													<input type="hidden" name="m_requestdt2" value="<fmt:formatDate value="${requestDate}" pattern="yyyyMMdd"/>" /> <%-- YYYYMMDD --%>
													<input type="hidden" name="m_requesttime2" value="<fmt:formatDate value="${requestTime}" pattern="HHmm"/>" /> <%-- HHMM --%>
												</td>
												<td class="text-center">
													<input type="text" class="p-r-md" name="m_pickingdt" readonly="readonly" /><i class="fa fa-calendar i-calendar"></i>
												</td>
												<td class="text-center">
													<select name="m_week">
														<option value="">선택</option>
														<c:forEach items="${orderWeekList}" var="list">
															<!--<c:if test="${!empty list.DRDL01}">
																<option value="${list.DRKY}">${list.DRSPHD}년 ${list.DRDL01}</option>
															</c:if>-->
															<option value="${list.DRKY}">${list.DRDL01}(${list.DRKY})</option>
														</c:forEach>
													</select>
												</td>
												<td class="buttonTdClass text-center">
													<button type="button" class="btn btn-default btn-xs" onclick="setOrderItem(this, 'trId_${status.index}', '100');">주문분리</button>
													<button type="button" class="btn btn-default btn-xs" onclick="setOrderItem(this, 'trId_${status.index}', '200');">반려</button>
													<button type="button" class="btn btn-default btn-xs" onclick="setOrderItem(this, 'trId_${status.index}', '300');">운송비</button>
													<button type="button" class="btn btn-default btn-xs" onclick="setOrderItem(this, 'trId_${status.index}', '500');">요청사항</button>
												</td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								
								<div class="btnList m-t-xl writeObjectClass">
									<button type="button" class="btn btn-info" id="btn003" onclick="dataIn(this, '0507');">주문확정</button>
									<button type="button" class="btn btn-gray-d" id="btn004" onclick="dataIn(this, '03');">전체반려</button>
								</div>
							</div>
							</form>
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
	<div class="cd-overlay"></div>
</body>
</html>