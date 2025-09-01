package com.limenets.eorder.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.limenets.eorder.dto.QuotationDto;

@Repository
public class QuotationDao {
	@Inject private SqlSession sqlSession;
	
	/**
	 * O_Qu_VERIFICATION Table.
	 */
	public int mergeQuotation(Map<String, Object> svcMap) {
		return sqlSession.insert("eorder.o_quotation_verification.mergeQuotation", svcMap);
	}
	
	public List<Map<String, Object>> getQuotationListAjax(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_quotation_verification.getQuotationListAjax", svcMap);
	}
	
	public List<QuotationDto> checkQuotationItemListAjax(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_quotation_verification.checkQuotationItemListAjax", svcMap);
	}
	
	public int cnt(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_quotation_verification.cnt", svcMap);
	}
}
