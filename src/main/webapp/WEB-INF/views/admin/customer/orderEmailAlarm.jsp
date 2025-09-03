<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />

<script type="text/javascript">
//==================================================================================
//전역 변수 및 원본 데이터 저장
//==================================================================================
var originalDataMap = {};    // 원본 데이터 저장용 맵
var modifiedRowsSet = new Set();    // 수정된 행 ID들을 추적

//이메일 형식 유효성 검사 함수
function validateEmail(email) {
    if (!email || email.trim() === '') return true; // 빈 값은 유효한 것으로 처리
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(email.trim());
}

//배경색 및 multiselect 완전 동기화 함수 - 조건부 처리 강화
function syncRowState(rowId, isModified) {
    var grid = $('#gridList');
    var selectedRows = grid.jqGrid('getGridParam', 'selarrrow');
    var isCurrentlySelected = selectedRows.indexOf(rowId) !== -1;
    if (isModified) {
        // 수정된 행 표시: 배경색 + multiselect 선택
        $('#gridList #' + rowId).css('background-color', '#ffebcd');

        // 현재 선택되지 않은 경우에만 선택 - 중복 방지
        if (!isCurrentlySelected) {
            grid.jqGrid('setSelection', rowId, true);
        }
        
        if(typeof rowId !== 'string') {
        	modifiedRowsSet.add(rowId);
        }
    } else {
        // 원래 상태로 복원: 배경색 + multiselect 해제
        $('#gridList #' + rowId).css('background-color', '');

        // 현재 선택된 경우에만 해제 - 중복 방지
        if (isCurrentlySelected) {
            grid.jqGrid('setSelection', rowId, false);
        }
        modifiedRowsSet.delete(rowId);
    }
}

//값 정규화 함수 - 데이터 타입 통일
function normalizeValue(value) {
    if (value === null || value === undefined) {
        return '';
    }
    return String(value).trim();
}

//행에 다른 수정사항이 있는지 확인 - 정확한 값 비교 로직 개선
function hasOtherModifications(rowId) {
    if (!originalDataMap[rowId]) return false;
    var grid = $('#gridList');
    // 편집모드인 경우 현재 input 값들을 직접 가져오기
    var isEditMode = $('#' + rowId).hasClass('jqgrow-edit');
    var currentData = {};
    if (isEditMode) {
        // 편집모드에서 실제 input 값들 수집
        var row = $('#' + rowId);
        currentData.CUST_MAIN_EMAIL = normalizeValue(row.find('input[name="CUST_MAIN_EMAIL"]').val());
        currentData.SALESREP_EMAIL = normalizeValue(row.find('input[name="SALESREP_EMAIL"]').val());
        currentData.COMMENTS = normalizeValue(row.find('input[name="COMMENTS"]').val());

        // 체크박스는 formatter로 만들어졌으므로 별도 처리
        currentData.CUST_SENDMAIL_YN = row.find('.mail-checkbox[data-field="CUST_SENDMAIL_YN"]').is(':checked') ? 'Y' : 'N';
        currentData.SALESREP_SENDMAIL_YN = row.find('.mail-checkbox[data-field="SALESREP_SENDMAIL_YN"]').is(':checked') ? 'Y' : 'N';
    } else {
        // 일반모드에서는 기존 방식 사용
        var rawData = getCleanRowData(rowId);
        currentData.CUST_MAIN_EMAIL = normalizeValue(rawData.CUST_MAIN_EMAIL);
        currentData.SALESREP_EMAIL = normalizeValue(rawData.SALESREP_EMAIL);
        currentData.COMMENTS = normalizeValue(rawData.COMMENTS);
        currentData.CUST_SENDMAIL_YN = normalizeValue(rawData.CUST_SENDMAIL_YN);
        currentData.SALESREP_SENDMAIL_YN = normalizeValue(rawData.SALESREP_SENDMAIL_YN);
    }
    var originalData = originalDataMap[rowId];
    // 편집 가능한 모든 필드 확인 - 정규화된 값으로 비교
    var editableFields = [
        'CUST_MAIN_EMAIL', 'CUST_SENDMAIL_YN',
        'SALESREP_EMAIL', 'SALESREP_SENDMAIL_YN',
        'COMMENTS'
    ];
    for (var i = 0; i < editableFields.length; i++) {
        var field = editableFields[i];
        var currentValue = normalizeValue(currentData[field]);
        var originalValue = normalizeValue(originalData[field]);

        // 엄격한 문자열 비교
        if (currentValue !== originalValue) {
            return true;
        }
    }
    return false;
}

//체크박스 포맷터 - 이벤트 처리 강화
function checkboxFormatter(cellVal, options, rowObj) {
    var checked = (cellVal === 'Y') ? 'checked' : '';
    var rowId = options.rowId;
    return '<input type="checkbox" class="mail-checkbox" ' + checked +
        ' data-rowid="' + rowId + '" data-field="' + options.colModel.name + '"' +
        ' onclick="handleCheckboxClick(this); event.stopPropagation();" />';
}

//체크박스 클릭 이벤트 핸들러 - 정확한 상태 동기화
function handleCheckboxClick(checkbox) {
    var rowId = $(checkbox).data('rowid');
    var fieldName = $(checkbox).data('field');
    var newValue = checkbox.checked ? 'Y' : 'N';
    // JQGrid 셀 값 즉시 업데이트
    $('#gridList').jqGrid('setCell', rowId, fieldName, newValue);
    // 약간의 지연 후 전체 행 수정 상태 확인 및 동기화
    setTimeout(function() {
        var hasModifications = hasOtherModifications(rowId);
        // 실제로 수정사항이 있을 때만 상태 변경
        if (hasModifications !== (modifiedRowsSet.has(rowId))) {
            syncRowState(rowId, hasModifications);
        }
    }, 10);
}

//이메일 필드 변경 처리 - 개선된 동기화 로직
function handleEmailChange(input) {
    var rowId = $(input).closest('tr').attr('id');
    var fieldName = $(input).attr('name') || $(input).data('field');
    var newValue = $(input).val().trim();
    // 지연 후 전체 행의 수정 상태 확인 (편집모드 고려)
    setTimeout(function() {
        var hasModifications = hasOtherModifications(rowId);
        var currentlyModified = modifiedRowsSet.has(rowId);

        // 상태가 실제로 변경된 경우에만 동기화
        if (hasModifications !== currentlyModified) {
            syncRowState(rowId, hasModifications);
        }
    }, 20);
    return true;
}

//텍스트 필드 변경 처리 - 개선된 동기화 로직
function handleTextChange(input) {
    var rowId = $(input).closest('tr').attr('id');
    var fieldName = $(input).attr('name') || $(input).data('field');
    var newValue = $(input).val().trim();
    // 지연 후 전체 행의 수정 상태 확인 (편집모드 고려)
    setTimeout(function() {
        var hasModifications = hasOtherModifications(rowId);
        var currentlyModified = modifiedRowsSet.has(rowId);

        // 상태가 실제로 변경된 경우에만 동기화
        if (hasModifications !== currentlyModified) {
            syncRowState(rowId, hasModifications);
        }
    }, 20);
}

//multiselect 직접 클릭 시 배경색 동기화 - 로직 개선
function handleMultiselectChange() {
    var grid = $('#gridList');
    var selectedRows = grid.jqGrid('getGridParam', 'selarrrow');
    var allRowIds = grid.jqGrid('getDataIDs');
    // 사용자가 직접 선택/해제한 행들의 배경색 동기화
    $.each(allRowIds, function(index, rowId) {
        var isSelected = selectedRows.indexOf(rowId) !== -1;
        var hasModifications = hasOtherModifications(rowId);
        var currentlyModified = modifiedRowsSet.has(rowId);

        if (isSelected && !hasModifications) {
            // 선택되었지만 실제 수정사항이 없는 경우: 배경색 변경하지만 수정 상태로는 기록하지 않음
            $('#gridList #' + rowId).css('background-color', '#ffebcd');
        } else if (isSelected && hasModifications) {
            // 선택되고 실제 수정사항이 있는 경우: 수정 상태 유지
            $('#gridList #' + rowId).css('background-color', '#ffebcd');
            modifiedRowsSet.add(rowId);
        } else if (!isSelected && hasModifications) {
            // 선택 해제되었지만 실제 수정사항이 있는 경우: 다시 선택 상태로 복원
            grid.jqGrid('setSelection', rowId, true);
            $('#gridList #' + rowId).css('background-color', '#ffebcd');
            modifiedRowsSet.add(rowId);
        } else {
            // 선택 해제되고 수정사항도 없는 경우: 원상복구
            $('#gridList #' + rowId).css('background-color', '');
            modifiedRowsSet.delete(rowId);
        }
    });
}

$(function() {
    getGridList();
});

//수정된 행 데이터 가져오기 - 실제 수정사항만 필터링
function getModifiedRows() {
    var grid = $('#gridList');
    var modifiedRows = [];
    // modifiedRowsSet에 있는 행들 중에서 실제로 수정된 행만 포함
    modifiedRowsSet.forEach(function(rowId) {
        if (hasOtherModifications(rowId)) {
            // 편집모드인 경우 먼저 편집 완료 처리
            var isEditMode = $('#' + rowId).hasClass('jqgrow-edit');
            if (isEditMode) {
                grid.jqGrid('saveRow', rowId);
            }

            var rowData = getCleanRowData(rowId);
            if (rowData) {
                modifiedRows.push(rowData);
            }
        }
    });
    
    return modifiedRows;
}

//편집모드를 고려한 깨끗한 행 데이터 가져오기
function getCleanRowData(rowId) {
    var grid = $('#gridList');
    /*var rowData = grid.jqGrid('getRowData', rowId);
    var cleanData = {};
    // 각 필드별로 실제 값 추출
    $.each(rowData, function(key, value) {
        if (typeof value === 'string') {
            // HTML 태그가 포함된 경우 처리
            if (value.indexOf('<input') !== -1) {
                // input 태그에서 실제 값 추출
                var $temp = $('<div>').html(value);
                var inputValue = $temp.find('input').val();
                cleanData[key] = normalizeValue(inputValue);
            } else if (value.indexOf('<') !== -1) {
                // 기타 HTML 태그 제거
                var $temp = $('<div>').html(value);
                cleanData[key] = normalizeValue($temp.text());
            } else {
                cleanData[key] = normalizeValue(value);
            }
        } else {
            cleanData[key] = normalizeValue(value);
        }
    });*/
    
    //currentData.CUST_MAIN_EMAIL = normalizeValue(row.find('input[name="CUST_MAIN_EMAIL"]').val());
    //currentData.SALESREP_EMAIL = normalizeValue(row.find('input[name="SALESREP_EMAIL"]').val());
    //currentData.COMMENTS = normalizeValue(row.find('input[name="COMMENTS"]').val());
    
    var row = $('#' + rowId);
    
    let CUST_CD = grid.jqGrid('getCell', rowId, 'CUST_CD');
    //let CUST_MAIN_EMAIL = grid.jqGrid('getCell', rowId, 'CUST_MAIN_EMAIL');
    let CUST_MAIN_EMAIL = normalizeValue(row.find('input[name="CUST_MAIN_EMAIL"]').val());
    //let CUST_SENDMAIL_YN = $('#' + rowId + '_CUST_SENDMAIL_YN').is(':checked');
    let CUST_SENDMAIL_YN = grid.jqGrid('getRowData', rowId).CUST_SENDMAIL_YN.includes('checked');
    //let SALESREP_EMAIL = grid.jqGrid('getCell', rowId, 'SALESREP_EMAIL');
    let SALESREP_EMAIL = normalizeValue(row.find('input[name="SALESREP_EMAIL"]').val());
    //let SALESREP_SENDMAIL_YN = $('#' + rowId + '_SALESREP_SENDMAIL_YN').is(':checked');
    let SALESREP_SENDMAIL_YN = grid.jqGrid('getRowData', rowId).SALESREP_SENDMAIL_YN.includes('checked');
    //let COMMENTS = grid.jqGrid('getCell', rowId, 'COMMENTS');
    let COMMENTS = normalizeValue(row.find('input[name="COMMENTS"]').val());
    let INID = grid.jqGrid('getCell', rowId, 'INID');
    let MOID = grid.jqGrid('getCell', rowId, 'MOID');
    
    var cleanData = {
    		CUST_CD: CUST_CD,
    		CUST_MAIN_EMAIL: CUST_MAIN_EMAIL,
    		CUST_SENDMAIL_YN : (CUST_SENDMAIL_YN==true ? 'Y' : 'N'), 
    		SALESREP_EMAIL: SALESREP_EMAIL,
    		SALESREP_SENDMAIL_YN: (SALESREP_SENDMAIL_YN==true ? 'Y' : 'N'),
    		COMMENTS: COMMENTS,
    		INID: INID,
    		MOID: MOID
    };
    
    return cleanData;
}

var lastSelection;

function editRow(id) {
    if (id && id !== lastSelection) {
        var grid = $('#gridList');
        grid.jqGrid('editRow', id, {
            keys: true,
            focusField: true,
            oneditfunc: function(rowId) {
                // 편집 시작 시 이벤트 핸들러 바인딩
                var row = $('#' + rowId);

                // 이메일 필드 이벤트 바인딩
                row.find('input[name="CUST_MAIN_EMAIL"]').on('blur', function() {
                    $(this).data('field', 'CUST_MAIN_EMAIL');
                    handleEmailChange(this);
                });

                row.find('input[name="SALESREP_EMAIL"]').on('blur', function() {
                    $(this).data('field', 'SALESREP_EMAIL');
                    handleEmailChange(this);
                });

                // 텍스트 필드 이벤트 바인딩
                row.find('input[name="COMMENTS"]').on('blur', function() {
                    $(this).data('field', 'COMMENTS');
                    handleTextChange(this);
                });
            }
        });
        lastSelection = id;
    }
}

function dataSave(obj) {
    $(obj).prop('disabled', true);
    // 편집 중인 모든 행 저장 처리

    var grid = $('#gridList');
    var allRowIds = grid.jqGrid('getDataIDs');
    $.each(allRowIds, function(index, rowId) {
        var isEditMode = $('#' + rowId).hasClass('jqgrow-edit');
        if (isEditMode) {
            grid.jqGrid('saveRow', rowId);
        }
    });
    
    const schdHour = document.getElementById("schdHour").value;
    const schdMin = document.getElementById("schdMin").value;
    if(schdHour === '') {
    	alert('예약발송 [시간]을 선택해 주세요.');
        $(obj).prop('disabled', false);
        return false;
    }
    
    if(schdMin === '') {
    	alert('예약발송 [분]을 선택해 주세요.');
        $(obj).prop('disabled', false);
        return false;
    }
    
    // 선택된 행 중에서 실제 수정된 행만 가져오기
    var modifiedRows = getModifiedRows();
    if (modifiedRows.length === 0) {
        alert('수정된 내용이 없습니다.');
        $(obj).prop('disabled', false);
        return false;
    }
    // *** 여기서만 유효성 검사 수행 ***
    var validationFailed = false;
    $.each(modifiedRows, function(i, rowData) {
        // 이메일 형식 검사
        if (rowData.CUST_MAIN_EMAIL && !validateEmail(rowData.CUST_MAIN_EMAIL)) {
            alert('거래처 담당자 이메일 형식이 올바르지 않습니다. (거래처코드: ' + rowData.CUST_CD + ')');
            validationFailed = true;
            return false;
        }

        if (rowData.SALESREP_EMAIL && !validateEmail(rowData.SALESREP_EMAIL)) {
            alert('영업 담당 이메일 형식이 올바르지 않습니다. (거래처코드: ' + rowData.CUST_CD + ')');
            validationFailed = true;
            return false;
        }

        // 발송 여부 체크 시 이메일 존재 확인
        if (rowData.CUST_SENDMAIL_YN === 'Y' && !rowData.CUST_MAIN_EMAIL) {
            alert('담당자 이메일 발송이 체크되어 있지만 담당자 이메일이 비어있습니다. (거래처코드: ' + rowData.CUST_CD + ')');
            validationFailed = true;
            return false;
        }

        if (rowData.SALESREP_SENDMAIL_YN === 'Y' && !rowData.SALESREP_EMAIL) {
            alert('영업 담당 이메일 발송이 체크되어 있지만 영업 담당 이메일이 비어있습니다. (거래처코드: ' + rowData.CUST_CD + ')');
            validationFailed = true;
            return false;
        }
    });
    if (validationFailed) {
        $(obj).prop('disabled', false);
        return false;
    }

    
    // 데이터 준비
    var iFormObj = $('form[name="iForm"]');
    iFormObj.empty();
    $.each(modifiedRows, function(i, rowData) {
        iFormObj.append('<input type="hidden" name="custCd" value="' + rowData.CUST_CD + '" />');
        iFormObj.append('<input type="hidden" name="custMainEmail" value="' + (rowData.CUST_MAIN_EMAIL || '') + '" />');
        iFormObj.append('<input type="hidden" name="custSendmailYn" value="' + (rowData.CUST_SENDMAIL_YN || 'N') + '" />');
        iFormObj.append('<input type="hidden" name="salesrepEmail" value="' + (rowData.SALESREP_EMAIL || '') + '" />');
        iFormObj.append('<input type="hidden" name="salesrepSendmailYn" value="' + (rowData.SALESREP_SENDMAIL_YN || 'N') + '" />');
        iFormObj.append('<input type="hidden" name="comments" value="' + (rowData.COMMENTS || '') + '" />');
    });
    
    iFormObj.append('<input type="hidden" name="scheduleHour" value="' + schdHour.substring(0, 2) + '" />');
    iFormObj.append('<input type="hidden" name="scheduleMin" value="' + schdMin.substring(0, 2) + '" />');
    if (confirm('저장 하시겠습니까?')) {
        var iFormData = iFormObj.serialize();
        var url = '${url}/admin/customer/insertUpdateOrderEmailAlarmAjax.lime';
        $.ajax({
            async : false,
            data : iFormData,
            type : 'POST',
            url : url,
            success : function(data) {
                if (data.RES_CODE == '0000') {
                    alert(data.RES_MSG);

                    // 성공 후 상태 초기화
                    resetAllStates();

                    // 그리드 리로드로 최신 데이터 반영
                    dataSearch();
                } else {
                    alert(data.RES_MSG);
                }
                $(obj).prop('disabled', false);
            },
            error : function(request,status,error){
            	debugger;
                alert('Error');
                $(obj).prop('disabled', false);
            }
        });
    } else {
        $(obj).prop('disabled', false);
    }
}

//모든 상태 초기화
function resetAllStates() {
    var grid = $('#gridList');
    var allRowIds = grid.jqGrid('getDataIDs');
    // 모든 행의 배경색 초기화
    $.each(allRowIds, function(index, rowId) {
        $('#gridList #' + rowId).css('background-color', '');
    });
    // multiselect 모두 해제
    grid.jqGrid('resetSelection');
    // 수정된 행 목록 초기화
    modifiedRowsSet.clear();
}

//==================================================================================
//jqGrid Columns Order 설정
//==================================================================================
var ckNameJqGrid = 'admin/customer/customerList/jqGridCookie';
ckNameJqGrid += '/gridList';

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [
 {name:"CUST_CD", key:true, label:'거래처코드', width:120, align:'center', sortable:true},
 {name:"CUST_NM", label:'거래처명', width:220, align:'left', sortable:true},
 {name:"CUST_MAIN_EMAIL", label:'담당자 이메일', width:220, align:'center', sortable:true, editable:true},
 {name:"CUST_SENDMAIL_YN", label:'발송 여부', width:100, align:'center', sortable:true, formatter:checkboxFormatter},
 {name:"SALESREP_NM", label:'영업 담당', width:100, align:'center', sortable:true},
 {name:"SALESREP_EMAIL", label:'영업 담당 이메일', width:300, align:'center', sortable:true, editable:true},
 {name:"SALESREP_SENDMAIL_YN", label:'발송 여부', width:100, align:'center', sortable:true, formatter:checkboxFormatter},
 {name:"COMMENTS", label:'비고', width:450, align:'left', sortable:true, editable:true}
];

var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
var updateComModel = [];

//쿠키에서 컬럼 순서 복원
if (0 < globalColumnOrder.length) {
 if (defaultColModel.length == globalColumnOrder.length) {
     for (var i = 0, j = globalColumnOrder.length; i < j; i++) {
         updateComModel.push(defaultColModel[globalColumnOrder[i]]);
     }
     setCookie(ckNameJqGrid, globalColumnOrder, 365);
 } else {
     updateComModel = defaultColModel;
     setCookie(ckNameJqGrid, defaultColumnOrder, 365);
 }
} else {
 updateComModel = defaultColModel;
 setCookie(ckNameJqGrid, defaultColumnOrder, 365);
}

//==================================================================================
//jqGrid Column Width 설정
//==================================================================================
var ckNameJqGridWidth = ckNameJqGrid + '/width';
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;

if ('' != globalColumnWidthStr) {
 if (updateComModel.length == globalColumnWidth.length) {
     updateColumnWidth = globalColumnWidth;
 } else {
     for (var j = 0; j < updateComModel.length; j++) {
         if ('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name) {
             var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
             if ('' == defaultColumnWidthStr) {
                 defaultColumnWidthStr = v;
             } else {
                 defaultColumnWidthStr += ',' + v;
             }
         }
     }
     defaultColumnWidth = defaultColumnWidthStr.split(',');
     updateColumnWidth = defaultColumnWidth;
     setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
 }
} else {
 for (var j = 0; j < updateComModel.length; j++) {
     if ('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name) {
         var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
         if ('' == defaultColumnWidthStr) {
             defaultColumnWidthStr = v;
         } else {
             defaultColumnWidthStr += ',' + v;
         }
     }
 }
 defaultColumnWidth = defaultColumnWidthStr.split(',');
 updateColumnWidth = defaultColumnWidth;
 setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
}

//컬럼 너비 적용
if (updateComModel.length == globalColumnWidth.length) {
 for (var j = 0; j < updateComModel.length; j++) {
     updateComModel[j].width = toStr(updateColumnWidth[j]);
 }
}

function getGridList(){
 var searchData = getSearchData();
 $('#gridList').jqGrid({
     url: "${url}/admin/customer/getOrderEmailAlarmAjax.lime",
     editurl: 'clientArray',
     datatype: "json",
     mtype: 'POST',
     postData: searchData,
     colModel: updateComModel,
     height: '360px',
     autowidth: false,
     multiselect: true,
     rowNum: 10,
     rowList: ['10', '30', '50', '100'],
     rownumbers: true,
     pagination: true,
     pager: "#pager",
     actions : true,
     pginput : true,
     jsonReader: {
         root: 'list',
         id: 'CUST_CD'
     },
     
     // 그리드 로드 완료 후 원본 데이터 저장 - 정규화 처리 추가
     loadComplete: function(data) {
         originalDataMap = {};
         modifiedRowsSet.clear();

         if (data && data.list) {
             $.each(data.list, function(index, item) {
                 // 원본 데이터를 정규화하여 저장
                 var normalizedItem = {};
                 $.each(item, function(key, value) {
                     normalizedItem[key] = normalizeValue(value);
                 });
                 originalDataMap[item.CUST_CD] = normalizedItem;
             });
         }

         if(data && data.scheduleTime) {
        	 document.getElementById("schdHour").value = data.scheduleTime;
         }
         
         if(data && data.scheduleMinute) {
        	 document.getElementById("schdMin").value = data.scheduleMinute;
         }
         
         // multiselect 헤더 체크박스에 이벤트 바인딩
         $('#cb_gridList').off('click').on('click', function() {
             setTimeout(handleMultiselectChange, 50);
         });
     },
     
     // 열 순서 변경 이벤트
     sortable: {
         update: function(relativeColumnOrder) {
             var grid = $('#gridList');
             var defaultColIndicies = [];
             for (var i = 0; i < defaultColModel.length; i++) {
                 defaultColIndicies.push(defaultColModel[i].name);
             }
             globalColumnOrder = [];
             var columnOrder = [];
             var currentColModel = grid.getGridParam('colModel');
             for (var j = 0; j < relativeColumnOrder.length; j++) {
                 if ('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name) {
                     columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
                 }
             }
             globalColumnOrder = columnOrder;
             setCookie(ckNameJqGrid, globalColumnOrder, 365);
             var tempUpdateColumnWidth = [];
             for (var j = 0; j < currentColModel.length; j++) {
                 if ('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name) {
                     tempUpdateColumnWidth.push(currentColModel[j].width);
                 }
             }
             updateColumnWidth = tempUpdateColumnWidth;
             setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
         }
     },

     // 열 크기 조정 후 실행되는 이벤트
     resizeStop: function(width, index) {
         var minusIdx = 0;
         var grid = $('#gridList');
         var currentColModel = grid.getGridParam('colModel');
         if ('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
         if ('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
         var resizeIdx = index + minusIdx;
         updateColumnWidth[resizeIdx] = width;
         setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
     },

     sortorder: 'desc',

     onSelectRow: function(rowId, status, e){
         // multiselect 체크박스 직접 클릭 시
         if (e && $(e.target).is('input[type="checkbox"]') && $(e.target).closest('td').hasClass('cbox')) {
             setTimeout(function() {
                 handleMultiselectChange();
             }, 10);
             return;
         }
         
         // 발송 여부 체크박스 클릭 시 (mail-checkbox)
         if (e && $(e.target).hasClass('mail-checkbox')) {
             // 체크박스 이벤트는 handleCheckboxClick에서 처리
             return;
         }
         
         // 일반 행 선택 시 편집 모드만 진입 (multiselect 건드리지 않음)
         editRow(rowId);
     }
 });
}

function getSearchData(){
 var rl_custcd = $('input[name="searchCustCd"]').val();
 var rl_custnm = $('input[name="searchCustNm"]').val();
 var rl_salesrepnm = $('input[name="searchSalesrepNm"]').val();

 var searchData = {
 		rl_custcd : rl_custcd
 		, rl_custnm : rl_custnm 
 		, rl_salesrepnm : rl_salesrepnm 
 	};

	return searchData;
}

//조회
function dataSearch() {
 var searchData = getSearchData();
 $('#gridList').setGridParam({
     postData : searchData
 }).trigger("reloadGrid");
}

//엑셀다운로드
function excelDown(obj){
 $('#ajax_indicator').show().fadeIn('fast');
 var token = getFileToken('excel');
 $('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
 
 formPostSubmit('frm', '${url}/admin/system/orderMailAlarmExcelDown.lime');
 $('form[name="frm"]').attr('action', '');
 
 $('input[name="filetoken"]').remove();
 var fileTimer = setInterval(function() {
     if('true' == getCookie(token)){
         $('#ajax_indicator').fadeOut();
         delCookie(token);
         clearInterval(fileTimer);
     }
 }, 1000 );
}
</script>
</head>

<body class="page-header-fixed compact-menu">
    <div id="ajax_indicator" style="display:none;">
        <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
            <img src="${url}/include/images/common/loadingbar.gif" />
        </p>
    </div>

    <main class="page-content content-wrap">
    
        <%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
        <%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
        
        <form name="iForm" method="post"></form>
        
        <form name="frm" method="post">
        
        <div class="page-inner">
            <div class="page-title">
                <h3>
                    주문메일알람 관리
                    <div class="page-right">
                        <button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
                        <button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
                        <button type="button" class="btn btn-line f-black" title="엑셀다운로드" onclick="excelDown(this);"><i class="fa fa-file-excel-o"></i><em>엑셀다운로드</em></button>
                    </div>
                </h3>
            </div>
            
            <div id="main-wrapper">
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-white">
                            <div class="panel-body no-p">
                                <div class="tableSearch">
                                    <div class="topSearch">
                                        <ul>
                                            <li>
                                                <label class="search-h">거래처코드</label>
                                                <div class="search-c">
                                                    <input type="text" class="search-input" name="searchCustCd" value="${param.rl_custcd}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
                                                </div>
                                            </li>
                                            <li>
                                                <label class="search-h">거래처명</label>
                                                <div class="search-c">
                                                    <input type="text" class="search-input" name="searchCustNm" value="${param.rl_custnm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
                                                </div>
                                            </li>
                                            <li>
                                                <label class="search-h">영업담당</label>
                                                <div class="search-c">
                                                    <input type="text" class="search-input" name="searchSalesrepNm" value="${param.rl_salesrepnm}" onkeypress="if(event.keyCode == 13){dataSearch();}" />
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="panel-body">
                                <h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
                                <div class="btnList writeObjectClass">
                                        <%-- 예약발송 시각 설정 --%>
                                        <label>예약발송 시간:</label>
                                        <select name="scheduleTime" id="schdHour">
                                            <option value="">선택</option>
                                            <% 
                                            String currentHour = request.getParameter("scheduleTime") != null ? request.getParameter("scheduleTime") : "";
                                            for(int i = 0; i <= 23; i++) { 
                                                String hourStr = String.format("%02d", i);
                                                String selected = hourStr.equals(currentHour) ? "selected" : "";
                                            %>
                                                <option value="<%= hourStr %>" <%= selected %>><%= hourStr %>시</option>
                                            <% } %>
                                        </select>
                                        <select name="scheduleMinute" id="schdMin">
                                            <option value="">선택</option>
                                            <% 
                                            String currentMinute = request.getParameter("scheduleMinute") != null ? request.getParameter("scheduleMinute") : "";
                                            int[] minutes = {0, 10, 20, 30, 40, 50};
                                            for(int minute : minutes) { 
                                                String minuteStr = String.format("%02d", minute);
                                                String selected = minuteStr.equals(currentMinute) ? "selected" : "";
                                            %>
                                                <option value="<%= minuteStr %>" <%= selected %>><%= minuteStr %>분</option>
                                            <% } %>
                                        </select>
                                    <button type="button" class="btn btn-info" onclick="dataSave(this);">저장</button>
                                </div>
                                <div class="table-responsive in">
                                    <table id="gridList" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
                                    <div id="pager"></div>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                </div>
                </div>
            <%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
            
        </div>
        
        </form>
    </main>
    
</body>

</html>