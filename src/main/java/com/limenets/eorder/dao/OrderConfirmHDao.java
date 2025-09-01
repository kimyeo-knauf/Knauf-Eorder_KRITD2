package com.limenets.eorder.dao;

import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class OrderConfirmHDao {
	@Inject private SqlSession sqlSession;
	
	public int in(Map<String, Object> svcMap) {
		return sqlSession.insert("eorder.o_order_confirm_h.in", svcMap);
	}
	
	public int upByReqNo(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_order_confirm_h.upByReqNo", svcMap);
	}
	
	public int upByCustPo(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_order_confirm_h.upByCustPo", svcMap);
	}



    /**
     * ★★ 주문상태 보류 추가 ★★ 
     * @작성일 : 2025-07-21
     * @작성자 : hsg
     */
	public int chageOrderStatusUpdate(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_order_confirm_h.chageOrderStatusUpdate", svcMap);
	}



}
