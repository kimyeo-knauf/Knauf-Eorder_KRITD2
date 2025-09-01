<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/admin/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/commonhead.jsp" %>

<script type="text/javascript" src="${url}/include/js/common/select2/select2.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
<link rel="stylesheet" href="${url}/include/js/common/select2/select2.css" />
<script type="text/javascript">
//Start. Setting Jqgrid Columns Order.
var ckNameJqGrid = 'admin/system/qmsStastics/jqGridCookie/qmsStastics'; // 페이지별 쿠키명 설정. // ####### 설정 #######

var globalColumnOrderStr = toStr(decodeURIComponent(getCookie(ckNameJqGrid)));
var globalColumnOrder = globalColumnOrderStr.split(',');

var defaultColModel = [ //  ####### 설정 #######
	{name:"QMS_DEPT_NM", label:'Department', width:200, align:'left', sortable:true, editable:false },
	{name:"QMS_TEAM_NM", label:'Team', width:200, align:'left', sortable:true, editable:false },
	{name:"SALESREP_NM", key:true, label:'담당자', width:163, align:'center', sortable:true },
	{name:"ORDER_QTY", label:'오더수량', width:100, align:'center', sortable:true },
	{name:"QMS_ORDER_CNT", label:'QMS발행', width:100, align:'center', sortable:true },
	{name:"QMS_END_CNT", label:'QMS마감', width:100, align:'center', sortable:true },
	{name:"RETURN_RATE", label:'회수율(%)', width:100, align:'center', sortable:true },
	{name:"TEAM_ORDER_CNT", label:'팀 발행', width:100, align:'center', sortable:true },
	{name:"TEAM_RETURN_CNT", label:'팀 회수', width:100, align:'center', sortable:true },
	{name:"TEAM_RETURN_RATE", label:'팀 회수율(%)', width:100, align:'center', sortable:true },
];

var defaultColModelTeam = [ //  ####### 설정 #######
	{name:"QMS_TEAM_NM", key:true, label:'Team', width:240, align:'left', sortable:false },
	{name:"QMS_ORDER_CNT", label:'발행', width:150, align:'center', sortable:false },
	{name:"QMS_END_CNT", label:'회수', width:150, align:'center', sortable:false },
	{name:"RETURN_RATE", label:'회수율(%)', width:150, align:'center', sortable:false },
	{name:"TEAM_SEQ", label:'팀구분', width:150, align:'center', sortable:false,hidden:true },
];

var defaultColumnOrder = writeIndexToStr(defaultColModel.length);
var updateComModel = []; // 전역.

if(0 < globalColumnOrder.length){ // 쿠키값이 있을때.
	if(defaultColModel.length == globalColumnOrder.length){
		for(var i=0,j=globalColumnOrder.length; i<j; i++){
			updateComModel.push(defaultColModel[globalColumnOrder[i]]);
		}
		
		setCookie(ckNameJqGrid, globalColumnOrder, 365); // 여기서 계산을 다시 해줘야겠네.
	}else{
		updateComModel = defaultColModel;
		
		setCookie(ckNameJqGrid, defaultColumnOrder, 365);
	}
}
else{ // 쿠키값이 없을때.
	updateComModel = defaultColModel;
	setCookie(ckNameJqGrid, defaultColumnOrder, 365);
}

// @@@@@@@ For Resize Column @@@@@@@
//Start. Setting Jqgrid Columns Order.
var ckNameJqGridWidth = ckNameJqGrid+'/width'; // 페이지별 쿠키명 설정.
var globalColumnWidthStr = toStr(decodeURIComponent(getCookie(ckNameJqGridWidth)));
var globalColumnWidth = globalColumnWidthStr.split(',');
var defaultColumnWidthStr = '';
var defaultColumnWidth;
var updateColumnWidth;
if('' != globalColumnWidthStr){ // 쿠키값이 있을때.
	if(updateComModel.length == globalColumnWidth.length){
		updateColumnWidth = globalColumnWidth;
	}else{
		for( var j=0; j<updateComModel.length; j++ ) {
			if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
				var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
				if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
				else defaultColumnWidthStr += ','+v;
			}
		}
		defaultColumnWidth = defaultColumnWidthStr.split(',');
		updateColumnWidth = defaultColumnWidth;
		setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
	}
}
else{ // 쿠키값이 없을때.
	
	for( var j=0; j<updateComModel.length; j++ ) {
		if('rn' != updateComModel[j].name && 'cb' != updateComModel[j].name){
			var v = ('' != toStr(updateComModel[j].width)) ? toStr(updateComModel[j].width) : '0';
			if('' == defaultColumnWidthStr) defaultColumnWidthStr = v;
			else defaultColumnWidthStr += ','+v;
		}
	}
	defaultColumnWidth = defaultColumnWidthStr.split(',');
	updateColumnWidth = defaultColumnWidth;
	setCookie(ckNameJqGridWidth, defaultColumnWidth, 365);
}

if(updateComModel.length == globalColumnWidth.length){
	for( var j=0; j<updateComModel.length; j++ ) {
		updateComModel[j].width = toStr(updateColumnWidth[j]);
	}
}
// End.


$(document).ready(function() {

	/*
	* 개인 그래프
	*/
	/*
	var chartSalesCtx = $("#chartSales");
	var chartSalesChart = new Chart(chartSalesCtx, {
	  type: 'bar',
	  data: {
	    labels: ["이주성;Metro BMD;1/4"
		    ,"서병수;Metro BMD;2/4"
		    ,"이재훈;Metro BMD;3/4"
		    ,"이충현;Metro BMD;4/4"
		    ,"이강일;Regional Whole Sales;1/1"
		    ,"전광영;Project Dealer;1/2"
		    ,"정신영;Project Dealer;2/2"
		    ,"김훈석;Metro installer 1;1/3"
		    ,"김태향;Metro installer 1;2/3"
		    ,"이재우;Metro installer 1;3/3"
		    ,"김효찬;Metro installer 2;1/3"
		    ,"정준석;Metro installer 2;2/3"
		    ,"김민철;Metro installer 2;3/3"
		    ,"박대석;General contractor;1/3"
		    ,"이상교;General contractor;2/3"
		    ,"김민범;General contractor;3/3"
		    ,"임상형;Direct Province;1/3"
		    ,"김성욱;Direct Province;2/3"
		    ,"이봉길;Direct Province;3/3"
		    ,"윤상호;Channel Province;1/5"
		    ,"소순영;Channel Province;2/5"
		    ,"조나현;Channel Province;3/5"
		    ,"조호정;Channel Province;4/5"
		    ,"송효근;Channel Province;5/5"],
	    datasets: [{
	      label: 'QMS발행',
	      xAxisID:'xAxis1',
	      data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3, 9, 17, 28, 26, 29, 9, 12, 19, 3, 5, 2, 3],
	      borderColor: '#0674ec',
	      backgroundColor: '#0674ec'
	    },
	    // here i added another data sets for xAxisID 2 and it works just fine
	    {
	      label: 'QMS마감',
	      xAxisID:'xAxis1',
	      data: [9, 17, 28, 26, 29, 9, 12, 19, 3, 5, 2, 17, 28, 26, 29, 9, 12, 19, 3, 5, 2, 4, 2],
	      borderColor: '#FFB0C1',
	      backgroundColor: '#FFB0C1'
	    }]
	  },
	  options:{
		title: {
			display: true,
			text: '1/4분기 QMS 회수 실적현황(2021/04/12, 12시 기준)'
		},
		legend: {
             position: 'bottom',
             labels: {
                 boxWidth: 20,
                 padding: 20
             }
        },
	    scales:{
	      xAxes:[
	        {
	          id:'xAxis1',
	          type:"category",
	          ticks:{
	            callback:function(label){
	              var data1 = label.split(";")[0];
	              var data2 = label.split(";")[1];
	              return data1;
	            }
	          }
	        },
	        {
	          id:'xAxis2',
	          type:"category",
	          gridLines: {
	        	  display: false,
	              drawBorder: true,
	              drawOnChartArea: false
	          },
	          ticks:{
				display:true,
				autoSkip: false,
                maxRotation: 0,
                minRotation: 0,
	            callback:function(label){
					var data1 = label.split(";")[0];
					var data2 = label.split(";")[1];
					var data3 = label.split(";")[2];
					var align1 = data3.split("/")[0];
					var align2 = data3.split("/")[1];
					var alignArry = [];
					alignArry[0] = '1';
					alignArry[1] = align2;
					
					if(align1 == Math.ceil(getMedian(alignArry))) {
						return data2;
					}
					else {
						return "";
					}
	            }
	          }
	        }],
	      yAxes:[{
	        ticks:{
	          beginAtZero:true
	        }
	      }]
	    }
	  }
	});
	*/
	/*
	* 팀 그래프
	*/
	/*
	var chartTeamCtx = $("#chartTeam");

	var barChartData = {
			  labels: ["January", "February", "March"],
			  datasets: [{
			      label: "Dataset 1",
			      yAxisID: 'yAxis1',
			      backgroundColor: "#FF0000",
			      categoryPercentage: 1,
			      barPercentage: 0.8,
			      stack: "Stack 0",
			      data: [1, 2, 3],
			    },
			    {
			      label: "Dataset 2",
			      yAxisID: 'yAxis1',
			      backgroundColor: "#0000FF",
			      categoryPercentage: 1,
			      barPercentage: 0.8,
			      stack: "Stack 0",
			      data: [5, 4, 3],
			    },
			    {
			      label: "Dataset 3",
			      yAxisID: 'yAxis1',
			      backgroundColor: "#00CC00",
			      categoryPercentage: 1,
			      barPercentage: 0.8,
			      stack: "Stack 1",
			      data: [6, 5, 4],
			    },
			    {
			      label: "Dataset 4",
			      yAxisID: 'yAxis1',
			      backgroundColor: "#000000",
			      categoryPercentage: 1,
			      barPercentage: 0.8,
			      stack: "Stack 2",
			      data: [6, 5, 4],
			    }
			  ]
			};
	
	var chartTeamChart = new Chart(chartTeamCtx, {
	  type: 'horizontalBar',
	  data: {
	    labels: ["전체회수율"
		    ,"Channel mgmt. Dept."
		    ,"Metro BMD Team"
		    ,"Regional Whole Sales Team"
		    ,"Project Dealer team"
		    ,"Direct Metro Sales Dept."
		    ,"Metro installer 1 team"
		    ,"Metro installer 2 team"
		    ,"General contractor team"
		    ,"Province Sales Dept."
		    ,"Direct Province team"
		    ,"Channel Province team"],
	    datasets: [{
	      label: '회수율',
	      data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
	      borderColor: ["#C00000", "#4472C4", "#4472C4", "#FFC000", "#4472C4", "#4472C4", "#4472C4", "#FFC000", "#4472C4", "#4472C4", "#4472C4", "#FFC000"], 
	      backgroundColor: ["#C00000", "#4472C4", "#4472C4", "#FFC000", "#4472C4", "#4472C4", "#4472C4", "#FFC000", "#4472C4", "#4472C4", "#4472C4", "#FFC000"], 
	    }]
	  },
	  options:{
		title: {
			display: true,
			text: '팀별 QMS 회수율'
		},
		legend: {
             display:false
        },
        scales:{
        	xAxes: [
        	    {
        	      ticks: {
        	        min: 0,
        	        max: 100,// Your absolute max value
        	        callback: function (value) {
        	          return (value / 100 * 100).toFixed(0) + '%'; // convert it to percentage
        	        },
        	      },
        	    },
        	  ],
        }
	  }
	});
	*/

// 출고일자 데이트피커.	
	$('input[name="r_actualshipsdt"]').datepicker({
		language: 'kr',
	    format : 'yyyymmdd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function(selected) {
		var minDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';		
		//$('input[name="r_actualshipedt"]').datepicker('setStartDate', minDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });
	
	$('input[name="r_actualshipedt"]').datepicker({
		language: 'kr',
	    format : 'yyyymmdd',
	    todayHighlight: true,
	    autoclose : true,
		clearBtn: true,
	}).on('changeDate', function (selected) {
		var maxDate = (undefined != selected.date) ? new Date(selected.date.valueOf()) : '';		
		//$('input[name="r_actualshipsdt"]').datepicker('setEndDate', maxDate);
		document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
    });

    $('#r_qmsOrdQuat').change();
	/*
	var sel = document.getElementById("r_qmsOrdQuat");
    for(var i=0; i<sel.length; i++){
        if(i==sel.length-2){
            sel[i].selected = true;
            $(sel[i]).trigger('change');
        }
    }
    */

    getgridListSales();
	getgridListTeam();
	
});

//중앙값 계산 함수
//크기 순으로 이미 정렬된 배열을 입력해야만 합니다
//범용성을 위해서 이 함수 자체에는 정렬 기능 미포함
function getMedian(array) {
	if (array.length == 0) return NaN; // 빈 배열은 에러 반환(NaN은 숫자가 아니라는 의미임)
		var center = parseInt(array.length / 2); // 요소 개수의 절반값 구하기
	
	if (array.length % 2 == 1) { // 요소 개수가 홀수면
		return array[center]; // 홀수 개수인 배열에서는 중간 요소를 그대로 반환
	} else {
		return (parseInt(array[center - 1]) + parseInt(array[center])) / 2.0; // 짝수 개 요소는, 중간 두 수의 평균 반환
	}
}

function getgridListSales(){
	// grid init
	var searchData = getSearchData();
	$('#gridListSales').jqGrid({
		url: "${url}/admin/system/getQmsStasticsSalesListAjax.lime",
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: updateComModel,
		height: '360px',
		autowidth: false,
		rowNum : 15,
		rowList : ['15','30','50','100'],
		//multiselect: true,
		//rownumbers: true,
		pagination: true,
		pager: "#pager",
		actions : true,
		pginput : true,
		sortable: false,
		sortable: { // ####### 설정 #######
			update: function(relativeColumnOrder){
				var grid = $('#gridListSales');
				var defaultColIndicies = [];
				for( var i=0; i<defaultColModel.length; i++ ) {
					defaultColIndicies.push(defaultColModel[i].name);
				}
	
				globalColumnOrder = []; // 초기화.
				var columnOrder = [];
				var currentColModel = grid.getGridParam('colModel');
				for( var j=0; j<relativeColumnOrder.length; j++ ) {
					if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
						columnOrder.push(defaultColIndicies.indexOf(currentColModel[j].name));
					}
				}
				globalColumnOrder = columnOrder;
				
				setCookie(ckNameJqGrid, globalColumnOrder, 365);
				
				// @@@@@@@ For Resize Column @@@@@@@
				var tempUpdateColumnWidth = [];
				for( var j=0; j<currentColModel.length; j++ ) {
				   if('rn' != currentColModel[j].name && 'cb' != currentColModel[j].name){
				      tempUpdateColumnWidth.push(currentColModel[j].width); 
				   }
				}
				updateColumnWidth = tempUpdateColumnWidth;
				setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
			}
		},
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder : ', globalColumnOrder);
			var minusIdx = 0;
			
			var grid = $('#gridListSales');
			var currentColModel = grid.getGridParam('colModel');
			if('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
			if('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
			
			var resizeIdx = index + minusIdx;
			
			updateColumnWidth[resizeIdx] = width;
			
			setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
		},
		sortorder: 'desc',
		jsonReader : { 
			root : 'list',
		},
		loadComplete: function(data) {
			$('#listTotalCountSpanId').html(addComma(data.listTotalCount));
		},
		onSelectRow: function(rowId){
			var h_dscode = $('#gridListSales').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
	});
}

function getgridListTeam(){
	// grid init
	var searchData = getSearchData();
	$('#gridListTeam').jqGrid({
		url: "${url}/admin/system/getQmsStasticsTeamListAjax.lime",
		editurl: 'clientArray', //사용x
		datatype: "json",
		mtype: 'POST',
		postData: searchData,
		colModel: defaultColModelTeam,
		height: '160px',
		autowidth: false,
		rowNum : 12,
		pagination: false,
		actions : true,
		pginput : true,
		sortable: false,
		resizeStop: function(width, index) { 
			console.log('globalColumnOrder : ', globalColumnOrder);
			var minusIdx = 0;
			
			var grid = $('#gridListTeam');
			var currentColModel = grid.getGridParam('colModel');
			if('rn' == currentColModel[0].name || 'cb' == currentColModel[0].name) minusIdx--;
			if('rn' == currentColModel[1].name || 'cb' == currentColModel[1].name) minusIdx--;
			
			var resizeIdx = index + minusIdx;
			
			updateColumnWidth[resizeIdx] = width;
			
			setCookie(ckNameJqGridWidth, updateColumnWidth, 365);
		},
		jsonReader : { 
			root : 'list',
		},
		onSelectRow: function(rowId){
			var h_dscode = $('#gridListTeam').find('#'+rowId).find('input[name="h_dscode"]').val();
			if('' != h_dscode){ //editRow
				editRow(rowId);
			}
		},
		loadComplete : function(data){  
			$('#listTotalCountSpanId2').html(addComma(data.listTotalCount));
		    // Row Color Change Event
		    var ids = $("#gridListTeam").getDataIDs();
		    // Grid Data Get!
		    $.each(
		        ids,function(idx, rowId){
		        rowData = $("#gridListTeam").getRowData(rowId);
		        // 만약 rowName 컬럼의 데이터가 공백이라면 해당 Row의 색상을 변경!           
		        if (rowData.TEAM_SEQ == '1') {
		            $("#gridListTeam").setRowData(rowId, false, { background:"#e6f5ff",color:'#007acc' });
		        }
		    }
		    );         
		},
	});
}

function getSearchData(){
	var m_dept = $('input[name="m_dept"]').val();
	var m_quat = $("#r_qmsOrdQuat option:selected").val();
	var r_actualshipsdt = $('input[name="r_actualshipsdt"]').val();
	var r_actualshipedt = $('input[name="r_actualshipedt"]').val();
	var sData = {
		m_dept : m_dept
	   ,m_quat : m_quat
	   ,r_actualshipsdt : r_actualshipsdt
	   ,r_actualshipedt : r_actualshipedt
	};
	return sData;
}

// 조회
function dataSearch() {
	var searchData = getSearchData();
	$('#gridListSales').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
	$('#gridListTeam').setGridParam({
		postData : searchData
	}).trigger("reloadGrid");
}


// jqgrid 검색 조건 증 체크박스 주의.
function salesExcelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="m_quat" value="'+$("#r_qmsOrdQuat option:selected").val()+'" />');

	formPostSubmit('frm', '${url}/admin/system/qmsStasticsSalesExcelDown.lime');
	$('form[name="frm"]').attr('action', '');
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}

function teamEexcelDown(obj){
	$('#ajax_indicator').show().fadeIn('fast');
	var token = getFileToken('excel');
	$('form[name="frm"]').append('<input type="hidden" name="filetoken" value="'+token+'" />');
	$('form[name="frm"]').append('<input type="hidden" name="m_quat" value="'+$("#r_qmsOrdQuat option:selected").val()+'" />');
	
	formPostSubmit('frm', '${url}/admin/system/qmsStasticsTeamExcelDown.lime');
	$('form[name="frm"]').attr('action', '');
	
	$('input[name="filetoken"]').remove();
	var fileTimer = setInterval(function() {
		//console.log('token : ', token);
        console.log("cookie : ", getCookie(token));
		if('true' == getCookie(token)){
			$('#ajax_indicator').fadeOut();
			delCookie(token);
			clearInterval(fileTimer);
		}
    }, 1000 );
}

function getFormatDate(date){
  var year = date.getFullYear();
  var month = (1 + date.getMonth());
  month = month >= 10 ? month : '0' + month;
  var day = date.getDate();
  day = day >= 10 ? day : '0' + day;
  return year + '-' + month + '-' + day;
}
	
function chageQmsOrdQuat(obj) {
	var date = obj.value;	
	var year, startMonth, endMonth, startDate, endDate;
	if(date.length > 0) {
		year = date.substring(0,4);
		switch(date.substring(4,)) {
			case "1Q":
				startMonth = 1;
				endMonth = 3;
				break;
			case "2Q":
				startMonth = 4;
				endMonth = 6;
				break;
			case "3Q":
				startMonth = 7;
				endMonth = 9;
				break;
			case "4Q":
				startMonth = 10;
				endMonth = 12;
				break;
		}
		startDate = new Date(year, startMonth - 1, 1);
		lastDate = new Date(year, endMonth, 0);		

		$('input[name="r_actualshipsdt"]').off('changeDate');
		$('input[name="r_actualshipedt"]').off('changeDate');
		
		$('input[name="r_actualshipsdt"]').val(getFormatDate(startDate));
		$('input[name="r_actualshipsdt"]').datepicker('setDate', startDate);

		$('input[name="r_actualshipedt"]').val(getFormatDate(lastDate));
		$('input[name="r_actualshipedt"]').datepicker('setDate', lastDate);
		
		$('input[name="r_actualshipsdt"]').on('changeDate', function(selected) {
			//$('input[name="r_orderedt"]').datepicker('setStartDate', startDate);
			document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
	    });
		$('input[name="r_actualshipedt"]').on('changeDate', function(selected) {
			//$('input[name="r_ordersdt"]').datepicker('setEndDate', lastDate);
			document.getElementById("r_qmsOrdQuat").selectedIndex = 0;
	    });
	    
	}
	dataSearch();
}
</script>
</head>

<body class="page-header-fixed compact-menu">
	<div id="ajax_indicator" style="display:none;">
	    <p style="position: absolute; top: 50%; left: 50%; margin: -110px 0 0 -110px;">
	        <img src="${url}/include/images/common/loadingbar.gif" />
	    </p>
	</div>

	<!-- Page Content -->
	<main class="page-content content-wrap">
	
		<%@ include file="/WEB-INF/views/include/admin/header.jsp" %>
		<%@ include file="/WEB-INF/views/include/admin/left.jsp" %>
		
		<%-- 임의 form --%>
		<form name="iForm" method="post"></form>
		<%-- <form name="uForm" method="post" action="${url}/admin/system/deliverySpotEditPop.lime" target="deliverySpotEditPop"></form> --%>
		
		<form name="frm" method="post">
		
		<!-- Page Inner -->
		<div class="page-inner">
			<div class="page-title">
				<h3>
					QMS 집계
					<div class="page-right">
						<button type="button" class="btn btn-line f-black" title="검색" onclick="dataSearch();"><i class="fa fa-search"></i><em>검색</em></button>
						<button type="button" class="btn btn-line f-black" title="새로고침" onclick="window.location.reload();"><i class="fa fa-refresh"></i><em>새로고침</em></button>
					</div>
				</h3>
			</div>
			
			<!-- Main Wrapper -->
			<div id="main-wrapper">
				<!-- Row -->
				<div class="row">
					<div class="col-md-12">
						<div class="panel panel-white">
							<div class="panel-body no-p">
								<div class="tableSearch">
									<div class="topSearch">
										<ul>
											<%-- <li>
												<label class="search-h">출고일자</label>
												<div class="search-c">
													<input type="text" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="${ordersdt}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
													<span class="rest">-</span>
													<input type="text" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="${orderedt}" readonly="readonly" />
													<i class="fa fa-calendar i-calendar"></i>
												</div>
											</li> --%>
											<li>
												<!-- 쿼리 성능 개선 위해 hidden 처리 -->
												<input type="hidden" class="search-input form-sm-d p-r-md" name="r_actualshipsdt" value="${ordersdt}"/>												
												<input type="hidden" class="search-input form-sm-d no-m-r p-r-md" name="r_actualshipedt" value="${orderedt}"/>												
												<label class="search-h">출고일자(분기)</label>
												<div class="search-c">
													<select class="form-control" name="r_qmsOrdQuat" id="r_qmsOrdQuat" onchange="chageQmsOrdQuat(this)">
														<option value="">선택안함</option>
														<c:forEach var="ryl" items="${releaseYearList}" varStatus="status">
															<c:choose>
																<c:when test="${ryl.QMS_YEAR_NM eq preYear && ryl.QMS_DELN_QUAT_NM eq preQuat}">
																	<option value="${ryl.QMS_YEAR}${ryl.QMS_DELN_QUAT}" selected>${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:when>
																<c:otherwise>
																	<option value="${ryl.QMS_YEAR}${ryl.QMS_DELN_QUAT}">${ryl.QMS_YEAR_NM} ${ryl.QMS_DELN_QUAT_NM}</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>														
													</select>
												</div>
											</li>
											<!-- <li>
												<label class="search-h">Department</label>
												<div class="search-c">
													<input type="text" class="search-input" name="m_dept" onkeypress="if(event.keyCode == 13){dataSearch();}" />
												</div>
											</li> -->
										</ul>
									</div>
								</div>
							</div>
							
							<!-- <div class="panel-body">
								<div class="row">
									<div class="col-md-7 col-lg-7">
										<div class="table-responsive in">
											<table id="gridListSales" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
											<div id="pager"></div>
										</div>
									</div>
									
									<div class="col-md-5 col-lg-5">
										<div class="table-responsive in">
											<table id="gridListTeam" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
										</div>
										<canvas id="chartTeam"></canvas>
									</div>
								</div>
								
								<canvas id="chartSales"></canvas>
								<div class="table-responsive in">
									<table id="gridListTeam" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
								</div>
								
							</div> -->
							
							<div class="panel-body">
								<h5 class="table-title" style="font-size:20px!important;">QMS 회수 실적현황</h5>
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId">0</span>EA</h5>
								<div class="btnList">
									<button type="button" class="btn btn-warning" onclick="salesExcelDown(this);">엑셀다운로드</button>
								</div>
								<div class="table-responsive in">
									<table id="gridListSales" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager"></div>
								</div>
								<h5 class="table-title" style="font-size:20px!important;">팀별 QMS 회수율</h5>
								<h5 class="table-title listT">TOTAL <span id="listTotalCountSpanId2">0</span>EA</h5>
								<div class="btnList">
									<button type="button" class="btn btn-warning" onclick="teamEexcelDown(this);">엑셀다운로드</button>
								</div>
								<div class="table-responsive in">
									<table id="gridListTeam" class="display table tableList nowrap" width="100%" border="0" cellpadding="0" cellspacing="0"></table>
									<div id="pager2"></div>
								</div>
								
							</div>
							
						</div>
					</div>
				</div>
				<!-- //Row -->
			</div>
			<!-- //Main Wrapper -->
			
			<%@ include file="/WEB-INF/views/include/admin/footer.jsp" %>
			
		</div>
		
		</form>
		<!-- //Page Inner -->
	</main>
	<!-- //Page Content -->
	
	<%-- 팝업 전송 form --%>
	<form name="frmPop" method="post" target="itemViewPop">
		<input name="pop" type="hidden" value="1" />
		<input name="r_itemcd" type="hidden" value="" />
	</form>
	
	
</body>

</html>