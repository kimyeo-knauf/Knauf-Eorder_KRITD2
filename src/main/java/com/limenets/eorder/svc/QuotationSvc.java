package com.limenets.eorder.svc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.limenets.common.util.Pager;
import com.limenets.common.dto.LoginDto;
import com.limenets.common.exception.LimeBizException;
import com.limenets.common.exception.MsgCode;
import com.limenets.common.util.Converter;
import com.limenets.eorder.dao.QuotationDao;
import com.limenets.eorder.dto.QuotationDto;
import com.limenets.eorder.util.ExcelFilterUtil;

/**
 * 쿼테이션 관리 서비스.
 */
@Service
public class QuotationSvc {
	private static final Logger logger = LoggerFactory.getLogger(QuotationSvc.class);
	
	
	@Inject private QuotationDao quotationDao;
	
	private ExcelFilterUtil excelFilterUtil;
	
	
	/**
	 * 쿼테이션 번호 검증 기능 도입을 위한 쿼테이션 번호 및 품목 코드 일괄 저장
	 * @작성일 : 2025. 5.30
	 * @작성자 : ijy
	 */
	public Map<String, Object> updateItemQuotationListExcelAjax(Map<String, Object> params, HttpServletRequest req, LoginDto loginDto) throws Exception {
		if (!MultipartHttpServletRequest.class.isInstance(req)) {
			throw new LimeBizException(MsgCode.FILE_REQUEST_ERROR);
		}
		
		MultipartHttpServletRequest mtreq = (MultipartHttpServletRequest)req;
		MultipartFile mpf = mtreq.getFile("file");
		
		//Sales Document,Material. 엑셀 문서 내 헤더 명칭이 변경되면 jsp만 수정. 순서는 지정 필요. quoteQt가 앞, itemCd가 뒤
		String[] headerList = Converter.toStr(params.get("headerList")).split(",");
		if(headerList == null || headerList.length == 0 || "".equals(headerList[0])) {
			//헤더명 누락
			return MsgCode.getResultMap(MsgCode.FILE_UPLOAD_ERROR);
		}
		
		//엑셀 파일과 헤더명을 넘기면 해당 헤더의 데이터를 추출해서 리턴.
		List<Map<String, String>> extractedRows = excelFilterUtil.extractDataByHeaders(mpf, headerList);
		
		if(extractedRows != null && extractedRows.size() > 0) {
			
			Map<String, Object> svcMap = new HashMap<>();
			String errorMsg  = "";
			int    resultCnt = 0;
			int    errorCnt  = 0;
			
			String insertId  = loginDto.getUserId();
			String quoteQt   = "";
			String itemCd    = "";
			for (int i = 0; i < extractedRows.size(); i++) {
				
				quoteQt = Converter.toStr(extractedRows.get(i).get(headerList[0]));
				itemCd  = Converter.toStr(extractedRows.get(i).get(headerList[1]));
				
				if ("".equals(quoteQt)) {
					errorMsg += (i+2) + "행 저장 실패, "+headerList[0]+": 누락, "+headerList[1]+": "+ itemCd +"\n";
					errorCnt++;
					continue;
				}
				
				if ("".equals(itemCd)) {
					errorMsg += (i+2) + "행 저장 실패, "+headerList[0]+": "+ quoteQt +", "+headerList[1]+": 누락\n";
					errorCnt++;
					continue;
				}
				
				if(!Converter.isNumeric(quoteQt)) {
					errorMsg += (i+2) + "행 저장 실패, "+headerList[0]+": "+ quoteQt + ", "+headerList[1]+": "+ itemCd + " / "+headerList[0]+" 형식 오류\n";
					errorCnt++;
					continue;
				}
				
				if(!Converter.isNumeric(itemCd)) {
					errorMsg += (i+2) + "행 저장 실패, "+headerList[0]+": " + quoteQt + ", "+headerList[1]+": "+ itemCd + " / "+headerList[1]+" 형식 오류\n";
					errorCnt++;
					continue;
				}
				
				svcMap.put("quoteQt",  quoteQt);
				svcMap.put("itemCd",   itemCd);
				svcMap.put("insertId", insertId);
				
				int result = 0;
				try {
					result = quotationDao.mergeQuotation(svcMap);
				} catch (Exception e) {
					e.printStackTrace();
					result = 0;
				}
				
				if(result > 0) {
					resultCnt++;
				} else {
					errorMsg += (i+2) + "행 저장 실패, "+headerList[0]+": " + quoteQt + ", "+headerList[1]+": "+ itemCd + " / DB 오류\n";
					errorCnt++;
				}
				
			}
			
			String returnMsg = "총 " + extractedRows.size() + "건 중 " + resultCnt + "건 성공. ";
			if(errorCnt > 0) {
				returnMsg += errorCnt + "건 실패.\n실패사유:\n" + errorMsg;
			}
			
			MsgCode returnCode = new MsgCode("0000", returnMsg);
			
			return MsgCode.getResultMap(returnCode);
			
		} else {
			return MsgCode.getResultMap(MsgCode.DATA_EXCEL_HEADER_DATA_ERROR);
		}
		
	}
	
	
	/**
	 * 쿼테이션 번호와 품목코드가 등록되어 있는지 체크하고 등록되지 않은 품목코드 리턴
	 * @작성일 : 2025. 6. 2
	 * @작성자 : ijy
	 */
	public Map<String, Object> checkQuotationItemListAjax(Map<String, Object> params) throws Exception {
		
		Map<String, Object> svcMap = new HashMap<>();
		Map<String, Object> msgMap = new HashMap<>();
		
		String quoteQt     = Converter.toStr(params.get("quoteQt")).trim();
		String itemCd      = Converter.toStr(params.get("itemCd")).replaceAll(" ", "");
		String [] itemList = itemCd.split(",");
		
		if("".equals(quoteQt) || "".equals(itemCd)) {
			return MsgCode.getResultMap(MsgCode.DATA_REQUIRE_ERROR2);
		}
		
		svcMap.put("quoteQt",  quoteQt);
		svcMap.put("itemList", itemList);
		
		List<QuotationDto> selList = quotationDao.checkQuotationItemListAjax(svcMap);
		
		if (!Converter.isEmpty(selList)) {

		    // 1. checkList 생성
		    Set<QuotationDto> checkSet = new HashSet<>();
		    for (String item : itemList) {
		        QuotationDto dto = new QuotationDto();
		        dto.setQUOTE_QT(quoteQt);
		        dto.setITEM_CD(item);
		        checkSet.add(dto);
		    }

		    // 2. selList → Set 변환
		    Set<QuotationDto> selSet = new HashSet<>(selList);
		    
		    // 3. DB에 없는 아이템만 남기기
		    checkSet.removeAll(selSet);
		    
		    List<String> missingList = new ArrayList<>();
		    if(checkSet.size() > 0){
		    	// 4. 결과 출력
			    for (QuotationDto dto : checkSet) {
			        missingList.add(dto.getITEM_CD());
			    }
			    
			    String missingItem = String.join(",", missingList);
			    
			    msgMap.putAll(MsgCode.getResultMap(MsgCode.DATA_QUOTATION_VERIFICATION_ERROR, missingItem));
			    msgMap.put("missingItem", missingItem);
			    
			    return msgMap;
			    
		    } else {
		    	return MsgCode.getResultMap(MsgCode.SUCCESS);
		    }
		} else {
			msgMap.putAll(MsgCode.getResultMap(MsgCode.DATA_QUOTATION_VERIFICATION_ERROR, itemCd));
		    msgMap.put("missingItem", itemCd);
			return msgMap;
		}
		
	}
	
	/**
	 * Get O_QUOTATION_VERIFICATION List.
	 * @작성일 : 2025. 7. 24.
	 * @작성자 : psy
	 */
	
	public Map<String, Object> getQuotationListAjax(Map<String, Object> svcMap, HttpServletRequest req, LoginDto loginDto){
		//return itemDao.list(svcMap);
        Map<String, Object> resMap = new HashMap<>();
		int totalCnt = quotationDao.cnt(svcMap);
        //String where = Converter.toStr(svcMap.get("where"));
		
		Pager pager = new Pager();
        pager.gridSetInfo(totalCnt, svcMap, req);
        resMap.put("total", Converter.toInt(svcMap.get("totpage")));
		resMap.put("listTotalCount", totalCnt);
        
        //resMap.put("listTotalCount", totalCnt);
		
        // Start. Define Only For Form-Paging.
        resMap.put("startnumber", svcMap.get("startnumber"));
        resMap.put("r_page", svcMap.get("r_page"));
        resMap.put("startpage", svcMap.get("startpage"));
        resMap.put("endpage", svcMap.get("endpage"));
        resMap.put("r_limitrow", svcMap.get("r_limitrow"));
        // End.
		
        
        String r_orderby = "";
        String sidx = Converter.toStr(svcMap.get("sidx")); //정렬기준컬럼
        String sord = Converter.toStr(svcMap.get("sord")); //내림차순,오름차순
        if(StringUtils.equals("USERID", sidx)) sidx = "COH."+sidx; //alias 명시.
        if(StringUtils.equals("CUST_CD", sidx)) sidx = "COH."+sidx;
        if(StringUtils.equals("SHIPTO_CD", sidx)) sidx = "COH."+sidx;
        r_orderby = sidx + " " + sord;
        if(StringUtils.equals("", sidx)) { r_orderby = "XX.INDATE DESC "; } //디폴트 지정
        
        svcMap.put("r_orderby", r_orderby);
        
        List<Map<String, Object>> list = this.getQuotationList(svcMap);
        resMap.put("list", list);
        resMap.put("data", list);
        resMap.put("page", svcMap.get("r_page"));
        //resMap.put("where", where);
        
        return resMap;
	}
	
	public List<Map<String ,Object>> getQuotationList(Map<String, Object> svcMap){
		return quotationDao.getQuotationListAjax(svcMap);
	}
	

	/*public int getQuotationItemCnt(Map<String, Object> params) {
		return quotationDao.cnt(params);
	}*/
	
	
}