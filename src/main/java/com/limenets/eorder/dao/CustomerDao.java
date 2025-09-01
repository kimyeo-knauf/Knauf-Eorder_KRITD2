package com.limenets.eorder.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class CustomerDao {
	@Inject private SqlSession sqlSession;
	
	public int up(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_customer.up", svcMap);
	}
	public int upByArr(Map<String, Object> svcMap) {
		return sqlSession.update("eorder.o_customer.upByArr", svcMap);
	}
	
	public Map<String, Object> one(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_customer.one", svcMap);
	}

	public int cnt(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_customer.cnt", svcMap);
	}
	
	public List<Map<String, Object>> list(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_customer.list", svcMap);
	}
	
	public Map<String, Object> getOneViewSupplier(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_customer.getOneViewSupplier", svcMap);
	}




	/**
	 * 주문 메일 알람 목록 전체 개수
	 * @param svcMap
	 * @return
	 */
	public int orderEmailAlarmCnt(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_customer.orderEmailAlarmCnt", svcMap);
	}
	
	/**
	 * 주문 메일 알람 목록
	 * @param svcMap
	 * @return
	 */
	public List<Map<String, Object>> orderEmailAlarmList(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_customer.orderEmailAlarmList", svcMap);
	}
	


	/**
	 * 주문 메일 알람 저장
	 * @param svcMap
	 * @return
	 */
	public List<Map<String, Object>> insertUpdateOrderEmailAlarm(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_customer.insertUpdateOrderEmailAlarm", svcMap);
	}
	



}
