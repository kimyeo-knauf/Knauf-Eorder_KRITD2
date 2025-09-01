<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

function openTermsPop(popEndpointNm) {
	if(!isApp()){
		window.open('${url}/common/'+popEndpointNm+'.lime', '_blank', 'width=800, height=900');
	}
	else{
		// 모달팝업
		//$('#'+popEndpointNm+'MId').modal('show');
		var link = '${url}/common/'+popEndpointNm+'.lime?layer_pop=Y';
		// 부모창refresh
		$(document).on('hidden.bs.modal', function (e) {   // bootstrap modal refresh
	       $(e.target).removeData('bs.modal');
	    });
		$('#'+popEndpointNm+'MId').modal({
			remote: link
		});
		
		// 모달팝업 height
		var heightBody = $(window).height();
		$('#'+popEndpointNm+'MId').find('.modal-content').css('min-height', heightBody - 21);
		// inner height (footer)
		$(document).on('shown.bs.modal', function (e) {
			$(e.target).find('.service .inner').css('height', heightBody - 133);
		});
	}
}
</script>
<footer>
	<div class="inner">
		<span>
			<a href="javascript:;" onclick="openTermsPop('privacyPolicyPop');"><strong>개인정보취급방침</strong></a>
			<a href="javascript:;" onclick="openTermsPop('termsOfServicePop');">이용수칙</a>
			<a href="${url}/front/board/faqList.lime">FAQ</a>
			
			<div class="select">
				<div class="placeholder">패밀리사이트</div>
				<ul>
					<li><a href="https://knauf.com/" target="_blank">KNAUF 공식 홈페이지</a></li>
				</ul>
			</div>
		</span>
	</div>
	<div class="copyrightArea">
		<span>
			<i>크나우프 석고보드(주)</i> <i>대표이사 : 송광섭</i> <i>전화번호 : <a>02-6902-3100</a></i> <i>팩스번호 : <a>02-6902-3190</a></i><br />
			<i>서울특별시 강남구 테헤란로 87길 36 (삼성동) 도심공항타워 7층</i><br />
			<br />
			Copyright© 2022 모든 권리는 크나우프 석고보드 주식회사에 있습니다.<br />
			<p>KNAUF와 ARTSOUND, HARDWALL, AQUALOCK, GYPTEX, EXCITEX, EXCITONE, GYPTONE, GYPBOND, MASTER PUTTY는 크나우프 석고보드 주식회사와 Knauf Gips KG를 포함한 하나 이상의 계열회사의 상표입니다. USG와 SHEETROCK, DUROCK, FIBEROCK, RADAR, OLYMPIA, CLIMAPLUS는 United States Gypsum Company의 상표이며, 라이선스 하에 사용됩니다.</p>
		</span>
	</div>
</footer>

<div class="order-add"><a href="${url}/front/order/orderAdd.lime"><img src="${url}/include/images/front/common/icon_plusW.png" alt="more" /><span>주문등록</span></a></div>
<div class="topbtn"><a href="#header"><span class="screen_out">최상단으로 가기</span></a></div>

<!-- Modal -->
<div class="modal fade" id="privacyPolicyPopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		</div>
		<div class="modal-content" style="overflow-x: inherit;">
			
		</div>
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="termsOfServicePopMId" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="${url}/include/images/front/common/total_menu_close_icon.png" width="20" height="20" alt="close" /></button>
		</div>
		<div class="modal-content" style="overflow-x: inherit;">
			
		</div>
	</div>
</div>