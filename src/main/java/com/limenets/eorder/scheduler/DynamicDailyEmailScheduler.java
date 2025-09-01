package com.limenets.eorder.scheduler;

import java.time.LocalDateTime;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;

@Configuration
@EnableScheduling
public class DynamicDailyEmailScheduler implements SchedulingConfigurer {
	private String cronExpr = "0 0 3 * * ?";
	
	@Override
	public void configureTasks(ScheduledTaskRegistrar taskRegistrar){
		taskRegistrar.addTriggerTask(
			() -> System.out.println("DynamicDailyEmailScheduler : " + LocalDateTime.now()),
			triggerContext -> new CronTrigger(cronExpr).nextExecutionTime(triggerContext)
		);
	}
	
	public void updateDailyTime(int hour, int minute) {
		this.cronExpr = String.format("0, %d %d * * ?", minute, hour);
		System.out.println("Updated DynamicDailyEmailScheduler : " + hour + minute);
	}
 }
