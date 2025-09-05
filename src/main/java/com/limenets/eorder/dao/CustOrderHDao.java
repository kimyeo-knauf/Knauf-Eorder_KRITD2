package com.limenets.eorder.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class CustOrderHDao {
	@Inject private SqlSession sqlSession;
	
	public int in(Map<String, Object> svcMap) {
		return sqlSession.insert("eorder.o_cust_order_h.in", svcMap);
	}
	
	public int up(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_cust_order_h.up", svcMap);
	}
	
	public int upReqNo(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_cust_order_h.upReqNo", svcMap);
	}
	
	public int del(Map<String, Object> svcMap) {
		return sqlSession.delete("eorder.o_cust_order_h.del", svcMap);
	}
	
	public Map<String, Object> one(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_cust_order_h.one", svcMap);
	}
	
	public int cnt(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_cust_order_h.cnt", svcMap);
	}
	
	public List<Map<String, Object>> list(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_cust_order_h.list", svcMap);
	}
	
	/**
	 * Get O_CUST_ORDER_H.REQ_NO 주문번호 생성하기.
	 */
	public String createCustOrderReqNo(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_cust_order_h.createCustOrderReqNo", svcMap);
	}
	
	/**
	 * askme : No. : REQ0072629 / SubTask : SCTASK0090907
	 * title : [크나우프][SR]이오더 납품처 수정 요청 건
	 * summary : 만료일 지난 납품처 : 'Y', 만료일 이전 납품처 : 'N'
	 * date : 2025-09-04
	 * author : hsg
	 */
	public Map<String, Object> checkShiptoBnddtYn(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_cust_order_h.checkShiptoBnddtYn", svcMap);
	}

}
