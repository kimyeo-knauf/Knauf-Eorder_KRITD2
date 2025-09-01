package com.limenets.eorder.util;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/** 기상청 단기예보 API는 1시간 단위로 조회되는데 일별 오전/오후 요약날씨로 변환 2025.06.11 ijy */
public class WeatherShortSummaryByHalfDay {

    public static class DailyHalfSummary {
        String date;
        String dayOfWeek;
        int minTemp = Integer.MAX_VALUE;
        int maxTemp = Integer.MIN_VALUE;

        Half am = new Half();
        Half pm = new Half();

        static class Half {
            Map<String, Integer> skyCount = new HashMap<>();
            Map<String, Integer> ptyCount = new HashMap<>();
            int maxPop = 0;

            void update(String category, String value) {
                if ("SKY".equals(category)) {
                    skyCount.put(value, skyCount.getOrDefault(value, 0) + 1);
                } else if ("PTY".equals(category)) {
                    ptyCount.put(value, ptyCount.getOrDefault(value, 0) + 1);
                } else if ("POP".equals(category)) {
                    int val = Integer.parseInt(value);
                    if (val > maxPop) maxPop = val;
                }
            }

            String getWeather() {
            	//단기예보는 시간단위로 정보가 조회되고 강수확률, 강수여부(비,눈,비 없음), 날씨(맑음,흐림,구름많음)정보는 전부 별도의 데이터로 제공되고 있고
            	//API를 통해 조회된 시간단위 그대로를 표기하는게 아니라 요구사항에 맞게 일별 오전 오후 요약 날씨로 표기해야 되기 때문에 변환하는 과정에서 
            	//강수확률은 90인데 강수여부는 비없음, 날씨는 맑음일 수 있음(변환없이 시간 단위 그대로 봐도 실제로 발생함). 사용자 친화적이지가 않음. 비가 잠깐이라도 오면 그날은 비가 맞지.
            	//강수여부와 날씨 정보를 하나로 통합하고 비가 없고 맑음이어도 강수확률이 60이상이면 비로 표기되도록 코드 추가. (강수확률 60은 임의지정)
                boolean hasRain = false;
                String commonPty = "0";
                int maxCount = -1;

                for (Map.Entry<String, Integer> entry : ptyCount.entrySet()) {
                    String key = entry.getKey();
                    int count = entry.getValue();
                    if (!"0".equals(key)) {
                        hasRain = true;
                        if (count > maxCount) {
                            commonPty = key;
                            maxCount = count;
                        }
                    }
                }

                if (hasRain || maxPop >= 60) {
                    switch (commonPty) {
                        case "1": return "비";
                        case "2": return "비눈";
                        case "3": return "눈";
                        case "5": return "빗방울";
                        case "6": return "눈날림";
                        default:  return "비";
                    }
                }

                // 강수 없으면 하늘 상태 기준
                String mostCommonSky = "1"; // 기본 맑음
                maxCount = -1;

                for (Map.Entry<String, Integer> entry : skyCount.entrySet()) {
                    if (entry.getValue() > maxCount) {
                        mostCommonSky = entry.getKey();
                        maxCount = entry.getValue();
                    }
                }

                switch (mostCommonSky) {
                    case "1": return "맑음";
                    case "3": return "구름많음";
                    case "4": return "흐림";
                    default:  return "정보없음";
                }
            }
        }

        void update(String category, String fcstTime, String value) {
            if ("TMP".equals(category)) {
                int tmp = Integer.parseInt(value);
                minTemp = Math.min(minTemp, tmp);
                maxTemp = Math.max(maxTemp, tmp);
            } else {
                Half target = null;
                if (fcstTime.compareTo("0000") >= 0 && fcstTime.compareTo("1200") < 0) {
                    target = am;
                } else if (fcstTime.compareTo("1200") >= 0 && fcstTime.compareTo("2400") <= 0) {
                    target = pm;
                }

                if (target != null) {
                    target.update(category, value);
                }
            }
        }
        
        void setDayOfWeek() {
            try {
                LocalDate targetDate = LocalDate.parse(this.date, DateTimeFormatter.ofPattern("yyyyMMdd"));
                LocalDate today = LocalDate.now();

                if (targetDate.equals(today)) {
                    dayOfWeek = "오늘";
                } else if (targetDate.equals(today.plusDays(1))) {
                    dayOfWeek = "내일";
                } else {
                    DayOfWeek dow = targetDate.getDayOfWeek();
                    switch (dow) {
                        case MONDAY:    dayOfWeek = "월"; break;
                        case TUESDAY:   dayOfWeek = "화"; break;
                        case WEDNESDAY: dayOfWeek = "수"; break;
                        case THURSDAY:  dayOfWeek = "목"; break;
                        case FRIDAY:    dayOfWeek = "금"; break;
                        case SATURDAY:  dayOfWeek = "토"; break;
                        case SUNDAY:    dayOfWeek = "일"; break;
                    }
                }
            } catch (Exception e) {
                dayOfWeek = "";
            }
        }

        String summaryString() {
            return String.format(
                "[%s (%s)] 최저: %d℃, 최고: %d℃\n오전 ☀ %s (%d%%)\n오후 ☀ %s (%d%%)",
                date, dayOfWeek != null ? dayOfWeek : "",
                minTemp, maxTemp,
                am.getWeather(), am.maxPop,
                pm.getWeather(), pm.maxPop
            );
        }
    }
    
    
    public static List<Map<String, Object>> summarize(List<WeatherShortResponseXml.Body.Items.Item> items) {
    	List<Map<String, Object>> list = new ArrayList<>();
    	
        Map<String, DailyHalfSummary> dayMap = new TreeMap<>();

        for (WeatherShortResponseXml.Body.Items.Item item : items) {
            String date = item.getFcstDate();
            String time = item.getFcstTime();
            String category = item.getCategory();
            String value = item.getFcstValue();

            if (date == null || time == null || category == null || value == null) continue;

            DailyHalfSummary summary = dayMap.get(date);
            if (summary == null) {
                summary = new DailyHalfSummary();
                summary.date = date;
                summary.setDayOfWeek();
                dayMap.put(date, summary);
            }
            summary.update(category, time, value);
        }

        for (DailyHalfSummary summary : dayMap.values()) {
        	Map<String, Object> map = new HashMap<>();
        	map.put("date",		summary.date);
        	map.put("dayOfWeek",summary.dayOfWeek);
        	map.put("minTemp",	summary.minTemp);
        	map.put("maxTemp",	summary.maxTemp);
        	map.put("amWeather",summary.am.getWeather());
        	map.put("pmWeather",summary.pm.getWeather());
        	map.put("amPop",	summary.am.maxPop);
        	map.put("pmPop",	summary.pm.maxPop);
        	
        	list.add(map);
        }
        
        return list;
    }
    

    public static void summarizeToStr(List<WeatherShortResponseXml.Body.Items.Item> items) {
        Map<String, DailyHalfSummary> dayMap = new TreeMap<>();

        for (WeatherShortResponseXml.Body.Items.Item item : items) {
            String date = item.getFcstDate();
            String time = item.getFcstTime();
            String category = item.getCategory();
            String value = item.getFcstValue();

            if (date == null || time == null || category == null || value == null) continue;

            DailyHalfSummary summary = dayMap.get(date);
            if (summary == null) {
                summary = new DailyHalfSummary();
                summary.date = date;
                summary.setDayOfWeek();
                dayMap.put(date, summary);
            }
            summary.update(category, time, value);
        }

        for (DailyHalfSummary summary : dayMap.values()) {
            //logger.debug(summary.summaryString());
            //logger.debug("--------------------------------------------------");
        }
    }



	public static List<Map<String, Object>> summarizeJson(List<WeatherShortResponseJson.Item> items) {
		List<Map<String, Object>> list = new ArrayList<>();

		Map<String, DailyHalfSummary> dayMap = new TreeMap<>();

		for (WeatherShortResponseJson.Item item : items) {
			String date = item.getFcstDate();
			String time = item.getFcstTime();
			String category = item.getCategory();
			String value = item.getFcstValue();

			if (date == null || time == null || category == null || value == null) continue;

			DailyHalfSummary summary = dayMap.get(date);
			if (summary == null) {
				summary = new DailyHalfSummary();
				summary.date = date;
				summary.setDayOfWeek();
				dayMap.put(date, summary);
			}
			summary.update(category, time, value);
		}

		for (DailyHalfSummary summary : dayMap.values()) {
			Map<String, Object> map = new HashMap<>();
			map.put("date", summary.date);
			map.put("dayOfWeek", summary.dayOfWeek);
			map.put("minTemp", summary.minTemp);
			map.put("maxTemp", summary.maxTemp);
			map.put("amWeather", summary.am.getWeather());
			map.put("pmWeather", summary.pm.getWeather());
			map.put("amPop", summary.am.maxPop);
			map.put("pmPop", summary.pm.maxPop);

			list.add(map);
		}

		return list;
	}

	public static void summarizeJsonToStr(List<WeatherShortResponseJson.Item> items) {
		Map<String, DailyHalfSummary> dayMap = new TreeMap<>();

		for (WeatherShortResponseJson.Item item : items) {
			String date = item.getFcstDate();
			String time = item.getFcstTime();
			String category = item.getCategory();
			String value = item.getFcstValue();

			if (date == null || time == null || category == null || value == null) continue;

			DailyHalfSummary summary = dayMap.get(date);
			if (summary == null) {
				summary = new DailyHalfSummary();
				summary.date = date;
				summary.setDayOfWeek();
				dayMap.put(date, summary);
			}
			summary.update(category, time, value);
		}

		for (DailyHalfSummary summary : dayMap.values()) {
			//logger.debug(summary.summaryString());
			//logger.debug("--------------------------------------------------");
		}
	}




}