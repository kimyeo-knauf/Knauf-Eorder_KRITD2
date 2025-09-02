package com.limenets.eorder.svc;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.limenets.eorder.dao.ScheduleDao;

public class ScheduleSvc {
	private static final Logger logger = LoggerFactory.getLogger(ConfigSvc.class);
	
	@Inject private ScheduleDao scheduleDao;
	
	public List<Map<String, Object>> getDailyEmailSenderList(Map<String, Object> svcMap){
		return scheduleDao.getDailyEmailSenderList(svcMap);
	}
	
	public List<Map<String, Object>> getDailyEmailList(Map<String, Object> svcMap){
		return scheduleDao.getDailyEmailList(svcMap);
	}
}
