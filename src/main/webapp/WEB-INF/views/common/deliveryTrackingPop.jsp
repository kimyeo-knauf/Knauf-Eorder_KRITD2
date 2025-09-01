<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/front/commonimport.jsp" %>
<!DOCTYPE html>
<html>
<head>
<c:set var="isLayerPop" value="false" />
<c:if test="${'Y' eq param.layer_pop}"><c:set var="isLayerPop" value="true" /></c:if>

<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
<meta name="title" content="e-Ordering System">
<meta name="keywords" content="e-Ordering System">
<meta name="description" content="e-Ordering System">
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<c:if test="${!isLayerPop}">
<link rel="shortcut icon" href="${url}/data/config/favicon.ico" type="image/x-icon" /><!-- 파비콘 -->
<script src="${url}/include/js/common/jquery/jquery-2.1.4.min.js"></script>
<script src="${url}/include/js/lime.js"></script>
</c:if>

<link href="${url}/include/js/common/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="${url}/include/css/modern.css" />

<%@ include file="/WEB-INF/views/include/front/commonpop.jsp" %>

</head>
<body>

<!-- Wrap -->
<div id="wrap" class="popup-wrapper trackingLayerPopDivId">

	<!-- Container Fluid -->
	<div class="container-fluid no-p">
	
		<button type="button" class="close" onclick="Close();"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		
		<div id="map" class="mapArea"></div>
		<%-- 모바일앱 레이어팝업인 경우는 부모페이지인 salesOrderList에서 정의 한다. --%>
		<c:if test="${!isLayerPop}">
			<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}&libraries=services"></script>
		</c:if>
		<%-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2cea0af4a16b7dcc44252ecc26297bc8&libraries=services"></script> --%>
		<script>
		var x = '${x}';   //경도 Lng
		var y = '${y}';   //위도 Lat
		var addr = '';
		// var addr = '서울 영등포구 선유로49길 17 부윤빌딩';
		
		if(x == 0.0 && y == 0.0){
			alert('GPS 정보 미수신되는 차량은 차량 추적이 불가합니다.');
			<c:if test="${!isLayerPop}">
				window.open('about:blank', '_self').close();
			</c:if>
			<c:if test="${isLayerPop}">
				$('#deliveryTrackingPopMId').modal('hide');
			</c:if>
		}
		
		// 지도 생성
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(y, x),
			level: 3
		};
		
		var map = new kakao.maps.Map(container, options);
		 mapOption = {
		       center: new kakao.maps.LatLng(y, x), // 지도의 중심좌표
		       level: 3 // 지도의 확대 레벨
		   };
		
		// 지도 컨트롤 
		var mapTypeControl = new kakao.maps.MapTypeControl();
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
		
		// 줌 컨트롤
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
		
		// 마커 아이콘
		var icon = new kakao.maps.MarkerImage(
		    '${url}/include/images/common/icon_location.png',
		    new kakao.maps.Size(31, 43),
		    {
		        offset: new kakao.maps.Point(16, 34)
		    }
		);
		
		// 좌표-주소 변환객체
		var geocoder = new kakao.maps.services.Geocoder();
		
		if(addr == ''){
			// 좌표로 주소 가져오기
			var coord = new kakao.maps.LatLng(y, x);
			var callback = function(result, status) {
			    if (status === kakao.maps.services.Status.OK) {
			    	// 마커생성
			    	var marker = new kakao.maps.Marker({
			            map: map,
			            position: coord,
			            image: icon
			        });
			
			        // 지도의 중심을 결과값으로 받은 위치로 이동
			        map.setCenter(coord);
			    	
			        // 주소출력
			    	$('#address').html(result[0].address.address_name);
			    }
			};
			geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
		
		}else{
			
			// 주소로 좌표 가져오기
			geocoder.addressSearch(addr, function(result, status) {
			    if (status === kakao.maps.services.Status.OK) {
			        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			        var marker = new kakao.maps.Marker({
			            map: map,
			            position: coords,
			            image: icon
			        });
			        
			        // 지도의 중심을 결과값으로 받은 위치로 이동
			        map.setCenter(coords);
			        
			       // 주소출력
		    	   $('#address').html(result[0].address.address_name);
			    } 
			});
		}
		</script>
		<div class="deliveryInfo">
			<h3>현재위치</h3>
			<ul>
				<li>
					<strong id="address"></strong>
					좌표처리이므로 시간에 따라 차이가 있을 수 있습니다.<br />
					<img src="${url}/include/images/common/icon_location.png" alt="img" />
				</li>
				<li>
					<table>
						<colgroup>
							<col width="35%" />
							<col width="65%" />
						</colgroup>
						<tbody>
							<!-- 
							<tr>
								<th>배송방법</th>
								<td>화물</td>
							</tr>
							-->
							<tr>
								<th>출하지</th>
								<td>${r_plantdesc}</td>
							</tr>
							<tr>
								<th>출하일</th>
								<td>
									<c:set var="actualShipDt">${r_actualshipdt}</c:set>
									<c:if test="${!empty actualShipDt}">
										${fn:substring(actualShipDt, 0, 4)}-${fn:substring(actualShipDt, 4, 6)}-${fn:substring(actualShipDt, 6, 8)}
									</c:if>
								</td>
							</tr>
							<tr>
								<th>기사 TEL</th>
								<td>${r_driverphone}</td>
							</tr>
							<tr>
								<th>차량번호</th>
								<td>
									<c:set var="truckNo">${r_truckno}</c:set>
									<c:if test="${!empty truckNo}">
										${fn:substring(truckNo, 0, 9)} ${r_drivername}
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
				</li>
			</ul>
			
		</div> <!-- boardListArea -->
		
	</div> <!-- Container Fluid -->
	
</div> <!-- Wrap -->

</body>

</html>