package com.limenets.eorder.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class ShipToDao {
	@Inject private SqlSession sqlSession;
	
	public Map<String, Object> one(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_shipto.one", svcMap);
	}

	public int cnt(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_shipto.cnt", svcMap);
	}
	
	public List<Map<String, Object>> list(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_shipto.list", svcMap);
	}
	
	public List<Map<String, Object>> getNewShiptoList(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_shipto.getNewShiptoList", svcMap);
	}
	
	/**
	 * SHIPTOBOOKMARK Table.
	 */
	public int inBookmark(Map<String, Object> svcMap) {
		return sqlSession.insert("eorder.o_shipto.inBookmark", svcMap);
	}
	
	public int cntBookmark(Map<String, Object> svcMap) {
		return sqlSession.selectOne("eorder.o_shipto.cntBookmark", svcMap);
	}
	
	public int delBookmark(Map<String, Object> svcMap) {
		return sqlSession.delete("eorder.o_shipto.delBookmark", svcMap);
	}	
	

//	2025-02-20 hsg Frog Splash. 웹주문현황에서 거래처 주의사항 추가로 주의사항 저장로직 추가
	public int insertUpdateComment(Map<String, Object> svcMap) {
		return sqlSession.insert("eorder.o_shipto.insertUpdateComment", svcMap);
	}

}
