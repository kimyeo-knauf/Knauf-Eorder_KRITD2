package com.limenets.eorder.svc;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.limenets.eorder.dao.ScheduleDao;

@Service
public class ScheduleSvc {
	private static final Logger logger = LoggerFactory.getLogger(ConfigSvc.class);
	
	@Inject private ScheduleDao scheduleDao;
	
	public List<Map<String, Object>> getDailyEmailSenderList(Map<String, Object> svcMap){
		return scheduleDao.getDailyEmailSenderList(svcMap);
	}
	
	public List<Map<String, Object>> getDailyEmailList(Map<String, Object> svcMap){
		return scheduleDao.getDailyEmailList(svcMap);
	}
	
	public int insertUpdateDailyEmailScheduleTime(Map<String, Object> svcMap) {
		return scheduleDao.insertUpdateDailyEmailScheduleTime(svcMap);
	}
	
	public List<Map<String, Object>> getDailyEmailScheduleTime(Map<String, Object> svcMap) {
		return scheduleDao.getDailyEmailScheduleTime(svcMap);
	}
	
	public int insertDailyEmailSendLog(Map<String, Object> svcMap) {
		return scheduleDao.insertDailyEmailSendLog(svcMap);
	}
	
	public int deleteDailyEmailSender(Map<String, Object> svcMap) {
		return scheduleDao.deleteDailyEmailSender(svcMap);
	}
}
