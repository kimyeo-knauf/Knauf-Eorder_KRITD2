package com.limenets.eorder.scheduler;


import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ScheduledFuture;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import com.limenets.common.util.MailUtil;
import com.limenets.eorder.dao.ScheduleDao;
import com.limenets.eorder.svc.ScheduleSvc;

@Component
public class DynamicDailyEmailScheduler {
	
	private final ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
	private ScheduledFuture<?> scheduledFuter;
	private String cronExpr = "0 0 3 * * ?";
	//private String cronExpr = "0 */1 * * * *";
	
	@Inject private ScheduleDao scheduleDao;
	@Inject ScheduleSvc scheduleSvc;
	@Value("${https.url}") private String httpsUrl;
    @Value("${mail.smtp.sender.addr}") private String smtpSender;
    @Value("${shop.name}") private String shopName;
    @Value("${mail.smtp.url}") private String smtpHost;
    
    public DynamicDailyEmailScheduler() {
    	scheduler.initialize();
    }
    
    @PostConstruct
    public void init() {
    	getCronExp();
    }
    
    private void schedulTask() {
    	if(scheduledFuter != null) {
    		scheduledFuter.cancel(false);
    	}
    	
    	scheduledFuter = scheduler.schedule(
			() -> sendEmail(),
			new CronTrigger(cronExpr)
    	);
    }
    
    public void updateDailyTime(int hour, int minute) {
		this.cronExpr = String.format("0 %d %d * * ?", minute, hour);
		System.out.println("Updated DynamicDailyEmailScheduler : " + this.cronExpr);
		schedulTask();
	}
	
	private String buildOrderTable(List<Map<String, Object>> orders, String tm) {
	    StringBuilder sb = new StringBuilder();
	    sb.append("<div style='font-family:Arial,sans-serif; font-size:14px; color:#333;'>")
	      .append("안녕하세요 크나우프석고보드 입니다<br><br>")
	      .append(String.format("%s년 %s월 %s일 기준 귀사의 익일착 오더 안내 드립니다<br><br>", tm.substring(0, 4), tm.substring(4, 6), tm.substring(6, 8)))
	      .append("<table border='1' cellspacing='0' cellpadding='5' ")
	      .append("style='border-collapse:collapse; width:100%; text-align:center; font-size:10px;'>")
	      .append("<thead style='background-color:#00AEEF; color:white;'>")
	      .append("<tr>")
	      .append("<th>오더 번호</th>")
	      .append("<th>출하지</th>")
	      .append("<th>요청 날짜</th>")
	      .append("<th>요청 시간</th>")
	      .append("<th>거래처명</th>")
	      .append("<th>납품처명</th>")
	      .append("<th>품목</th>")
	      .append("<th>수량</th>")
	      .append("<th>납품처 주소</th>")
	      .append("<th>인수자 연락처</th>")
	      .append("</tr>")
	      .append("</thead>")
	      .append("<tbody>");

	    for (Map<String, Object> order : orders) {
	        sb.append("<tr>")
	          .append("<td>").append(order.get("REQ_NO")).append("</td>")
	          .append("<td>").append(order.get("PT_NAME")==null ? "" : order.get("PT_NAME")).append("</td>")
	          .append("<td>").append(order.get("REQUEST_DT")==null ? "" : order.get("REQUEST_DT")).append("</td>")
	          .append("<td>").append(order.get("REQUEST_TIME")==null ? "" : order.get("REQUEST_TIME")).append("</td>")
	          .append("<td>").append(order.get("CUST_NM")==null ? "" : order.get("CUST_NM")).append("</td>")
	          .append("<td>").append(order.get("SHIPTO_NM")==null ? "" : order.get("SHIPTO_NM")).append("</td>")
	          .append("<td>").append(order.get("DESC1")==null ? "" : order.get("DESC1")).append("</td>")
	          .append("<td>").append(order.get("QUANTITY")).append("</td>")
	          .append("<td>").append(order.get("ADD1")==null ? "" : order.get("ADD1")).append("</td>")
	          .append("<td>").append(order.get("TEL1")==null ? "" : order.get("TEL1")).append("</td>")
	          .append("</tr>");
	    }

	    sb.append("</tbody>")
	      .append("</table><br><br>")
	      .append("감사합니다.")
	      .append("</div>");

	    return sb.toString();
	}
	
	public void sendEmail() {		
		//String tomorrow = "20230608"; getTomorrow();
		String tomorrow = getTomorrow();
		
		int ret = scheduleSvc.deleteDailyEmailSender(null);
		boolean ret_f = false;
		
		List<Map<String, Object>> senders = scheduleSvc.getDailyEmailSenderList(null);
		
		for(Map<String, Object> sender : senders) {
			String CUST_CD = sender.get("CUST_CD").toString(); 
			String CUST_MAIN_EMAIL = sender.get("CUST_MAIN_EMAIL").toString(); 
			boolean CUST_SENDMAIL_YN = sender.get("CUST_SENDMAIL_YN").toString().equals("Y") ? true : false; 
			String SALESREP_EMAIL = sender.get("SALESREP_EMAIL").toString();
			boolean SALESREP_SENDMAIL_YN = sender.get("SALESREP_SENDMAIL_YN").toString().equals("Y") ? true : false;
			String SALESREP_NM = sender.get("SALESREP_NM").toString();
			String CUST_NM = sender.get("CUST_NM").toString();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("cust_code", CUST_CD);
			map.put("request_dt", tomorrow);
			List<Map<String, Object>> orders = scheduleSvc.getDailyEmailList(map);
			
			if(orders.size() > 0) {
				String strContext = buildOrderTable(orders, tomorrow);				
	            String title = String.format("크나우프석고보드 - %s 익일착 오더 안내", tomorrow);
	            
	            Map<String, Object> map_log = new HashMap<String, Object>();
	            map_log.put("m_cust_cd", CUST_CD);
	            map_log.put("m_to_email", CUST_MAIN_EMAIL);
	            map_log.put("m_sales_email", SALESREP_EMAIL);
	            map_log.put("m_sent_hour", "");
	            map_log.put("m_send_min", "");
	            
	            map_log.put("m_subject", title);
	            map_log.put("m_body", strContext);
	            map_log.put("m_err_code", "");
	            map_log.put("m_err_msg", "");
	            
	            try {
	            	MailUtil mail = new MailUtil();
					//mail.sendMail(smtpHost, title, "SG.Hong", "seungjooko@gmail.com", shopName, smtpSender, strContext, null, "");
					//mail.sendMail(smtpHost, title, "Squall", "stpj0002@sorin.co.kr", shopName, smtpSender, strContext, null, "");
	            	
	            	if(CUST_SENDMAIL_YN) {
	            		ret_f = mail.sendMail(smtpHost, title, CUST_NM, CUST_MAIN_EMAIL, shopName, smtpSender, strContext, null, "");
	            		map_log.put("m_success", ret_f);
	            		scheduleSvc.insertDailyEmailSendLog(map_log);
	            	}
	            	
	            	if(SALESREP_SENDMAIL_YN) {
	            		ret_f = mail.sendMail(smtpHost, title, SALESREP_NM, SALESREP_EMAIL, shopName, smtpSender, strContext, null, "");
	            		map_log.put("m_success", ret_f);
	            		scheduleSvc.insertDailyEmailSendLog(map_log);
	            	}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

	            //발송후 상태값 업데이트
	           
			}
		}
	}
	
	private String getTomorrow() {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 1);
		SimpleDateFormat sdt = new SimpleDateFormat("yyyyMMdd");
		return sdt.format(cal.getTime());
	}
	
	private void getCronExp() {
		int hour = 3;
		int min = 0;
		List<Map<String, Object>> schTime  = scheduleDao.getDailyEmailScheduleTime(null);
		if(schTime.size() > 0) {
			hour = Integer.parseInt(schTime.get(0).get("TIME").toString());
			min = Integer.parseInt(schTime.get(0).get("MINUTE").toString());
		} 
		
		updateDailyTime(hour, min);
	}
 }
