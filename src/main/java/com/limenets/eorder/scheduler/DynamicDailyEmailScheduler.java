package com.limenets.eorder.scheduler;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;

import com.limenets.eorder.dto.DynamicDailyMailDto;
import com.limenets.eorder.svc.CustomerSvc;
import com.limenets.eorder.svc.OrderSvc;

@Configuration
@EnableScheduling
public class DynamicDailyEmailScheduler implements SchedulingConfigurer {
	//private String cronExpr = "0 0 3 * * ?";
	private String cronExpr = "0 */30 * * * *";
	
	@Inject CustomerSvc customerSvc;
	@Inject OrderSvc orderSvc;
	@Value("${https.url}") private String httpsUrl;
    @Value("${mail.smtp.sender.addr}") private String smtpSender;
    @Value("${shop.name}") private String shopName;
    @Value("${mail.smtp.url}") private String smtpHost;
	
	@Override
	public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
		taskRegistrar.addTriggerTask(
			() -> sendEmail() ,
			triggerContext -> new CronTrigger(cronExpr).nextExecutionTime(triggerContext)
		);
	}
	
	public void updateDailyTime(int hour, int minute) {
		this.cronExpr = String.format("0, %d %d * * ?", minute, hour);
		System.out.println("Updated DynamicDailyEmailScheduler : " + hour + minute);
	}
	
	public String buildOrderTable(List<DynamicDailyMailDto> orders) {
	    StringBuilder sb = new StringBuilder();

	    sb.append("<div style='font-family:Arial,sans-serif; font-size:14px; color:#333;'>")
	      .append("안녕하세요 크나우프석고보드 입니다<br><br>")
	      .append("2025년 5월 16일 기준 귀사의 익일착 오더 안내 드립니다<br><br>")

	      .append("<table border='1' cellspacing='0' cellpadding='5' ")
	      .append("style='border-collapse:collapse; width:100%; text-align:center;'>")
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
	      .append("</tr>")
	      .append("</thead>")
	      .append("<tbody>");

	    for (DynamicDailyMailDto order : orders) {
	        sb.append("<tr>")
	          .append("<td>").append(order.getOrderNo()).append("</td>")
	          .append("<td>").append(order.getFactory()).append("</td>")
	          .append("<td>").append(order.getReqDate()).append("</td>")
	          .append("<td>").append(order.getReqTime()).append("</td>")
	          .append("<td>").append(order.getClient()).append("</td>")
	          .append("<td>").append(order.getDeliClient()).append("</td>")
	          .append("<td>").append(order.getProduct()).append("</td>")
	          .append("<td>").append(order.getQuantity()).append("</td>")
	          .append("<td>").append(order.getDeliAddress()).append("</td>")
	          .append("</tr>");
	    }

	    sb.append("</tbody>")
	      .append("</table><br><br>")
	      .append("감사합니다.")
	      .append("</div>");

	    return sb.toString();
	}
	
	public void sendEmail() {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDate today = LocalDate.now();
		String stDate = today.atStartOfDay().format(formatter);
		String endDate = today.atTime(23,59, 59).format(formatter);
		System.out.println("DynamicDailyEmailScheduler : " + stDate + " : " + endDate);
	}
 }
