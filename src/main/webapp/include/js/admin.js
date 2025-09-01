$(document).ready(function() {
	$.ajaxSetup({		// ajax 호출시
		global: true,
		dataType: 'json',
		dataFilter: function(data, type) {
			//console.log(data);
			return data;
		},
		complete: function(xhr, status) {
			var data = xhr.responseJSON;
			if (data && data.RES_CODE && data.RES_CODE != '0000') {
				alert(data.RES_MSG);
				if(data.RES_CODE == '0101'){
					location.href=getContextPath()+'/admin/login/login.lime';
				}
			}
		}
	});
});
