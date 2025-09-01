package com.limenets.eorder.ctrl.admin;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.limenets.common.dto.LoginDto;
import com.limenets.common.util.Converter;
import com.limenets.eorder.excel.ItemExcel;
import com.limenets.eorder.svc.QuotationSvc;

/**
 * Admin 쿼테이션 번호 검증 관리 컨트롤러.
 * 쿼테이션 관리 메뉴가 별도로 추가될 수 있어서 별도 컨트롤러로 작업. 2025. 5. 30 ijy
 */
@Controller
@RequestMapping("/admin/quotation/*")
public class QuotationCtrl {
    private static final Logger logger = LoggerFactory.getLogger(QuotationCtrl.class);
    
    @Inject private QuotationSvc quotationSvc;
    
    
    
	/**
	 * 품목관리 > 쿼테이션번호 관리 : 엑셀대량수정 폼.
	 * @작성일 : 2025. 5. 30
	 * @작성자 : ijy
	 */
	@GetMapping(value="itemEditQuotationListExcel")
	public String itemEditQuotationListExcel(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		return "admin/item/itemEditQuotationListExcel";
	}

	/**
	 * 품목관리 > 쿼테이션목록 추가
	 * @작성일 : 2025. 7. 24.
	 * @작성자 : psy
	 */
	@GetMapping(value="itemQuotationListExcel")
	public String itemQuotationListExcel(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		return "admin/item/itemQuotationListExcel";
	}

	
	/**
	 * 품목관리 > 쿼테이션 목록 불러오기
	 * @작성일 : 2025. 7. 24.
	 * @작성자 : psy
	 */
	
	
	@ResponseBody
	@PostMapping(value="itemQuotationListExcelAjax")
	public Object itemQuotationListExcelAjax(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		return quotationSvc.getQuotationListAjax(params, req, loginDto);
	}


	/**
	 * quotationExcelDown => 품목관리 리스트 > 엑셀다운로드.
	 * @작성일 : 2025. 7. 29.
	 * @작성자 : psy
	 */
	@PostMapping(value= {"quotationExcelDown", "quotationExcelDown2"})
	public ModelAndView itemExcelDown(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		Map<String, Object> resMap = new HashMap<>();
		
		// Start. 뷰단에서 넘어온 파일 쿠키 put.
		String fileToken = Converter.toStr(params.get("filetoken"));
		resMap.put("fileToken", fileToken);
		// End.
		
		params.put("where", "excel");
		resMap.putAll(quotationSvc.getQuotationListAjax(params, req, loginDto));
		return new ModelAndView(new ItemExcel(), resMap);
	}
	
	
	
	
	/**
	 * 쿼테이션 번호 검증 기능 도입을 위한 쿼테이션 번호 및 품목 코드 일괄 저장
	 * @작성일 : 2025. 5.30
	 * @작성자 : ijy
	 */
	@ResponseBody
	@PostMapping(value="updateItemQuotationListExcelAjax")
	public Object updateItemQuotationListExcelAjax(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		return quotationSvc.updateItemQuotationListExcelAjax(params, req, loginDto);
	}
	
	/**
	 * 쿼테이션 번호 검증, 쿼테이션 번호와 품목 코드로 등록 되어 있는 품목인지 체크
	 * @작성일 : 2025. 6. 02
	 * @작성자 : ijy
	 */
	@ResponseBody
	@PostMapping(value="checkQuotationItemListAjax")
	public Object checkQuotationItemListAjax(@RequestParam Map<String, Object> params, HttpServletRequest req, HttpServletResponse res, LoginDto loginDto, Model model) throws Exception {
		return quotationSvc.checkQuotationItemListAjax(params);
	}
	
	
	
	
	

}
