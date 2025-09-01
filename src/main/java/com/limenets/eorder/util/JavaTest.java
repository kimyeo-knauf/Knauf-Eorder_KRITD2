package com.limenets.eorder.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.limenets.common.util.Converter;
import com.limenets.eorder.util.WeatherShortSummaryByHalfDay.DailyHalfSummary;


public class JavaTest {
	
	//로컬에서 카카오 api 사용시 인증서 관련 오류 발생. 테스트 환경에서만 사용해야 함. 보안에 취약.
	private static void disableSslVerification() throws Exception {
		TrustManager[] trustAllCerts = new TrustManager[]{
			new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) { }
				public void checkServerTrusted(X509Certificate[] certs, String authType) { }
			}
		};

		SSLContext sc = SSLContext.getInstance("SSL");
		sc.init(null, trustAllCerts, new java.security.SecureRandom());
		HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

		HostnameVerifier allHostsValid = (hostname, session) -> true;
		HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
	}
	
	
	public Map<String, Object> getSkyApi1(String tmFc, String regId){
		Map<String, Object> returnMap = new HashMap<>();
		
		//String serviceKey2 = "tKC/EKOf9UYXkyi1qfzZ2nsQrz41+m2d9zo6UBLw2xI3L+wvdaVp9CkMbyiS0kpDB7eyCxw+aDl/bXKbxSoO/Q=="; //인코딩 전
		
		String serviceKey = "tKC%2FEKOf9UYXkyi1qfzZ2nsQrz41%2Bm2d9zo6UBLw2xI3L%2BwvdaVp9CkMbyiS0kpDB7eyCxw%2BaDl%2FbXKbxSoO%2FQ%3D%3D"; //인코딩 후
		String baseUrl = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa";
		
		try {
			
			StringBuilder urlBuilder = new StringBuilder(baseUrl);
			urlBuilder.append("?serviceKey=" + serviceKey);
			urlBuilder.append("&pageNo=1" );
			urlBuilder.append("&numOfRows=100" );
			urlBuilder.append("&dataType=XML");
			urlBuilder.append("&regId="+regId);
			urlBuilder.append("&tmFc="+tmFc);
			

			URL url = new URL(urlBuilder.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("Content-type", "application/json");

			System.out.println("Response Code: " + conn.getResponseCode());

			BufferedReader rd;
			if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}

			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = rd.readLine()) != null) {
				sb.append(line);
			}

			rd.close();
			conn.disconnect();
			
			String xml = sb.toString();
			System.out.println(xml);
			
			
			// XML → 객체 변환
			JAXBContext context = JAXBContext.newInstance(WeatherMidTaResponseXml.class);
			Unmarshaller unmarshaller = context.createUnmarshaller();
			WeatherMidTaResponseXml response = (WeatherMidTaResponseXml) unmarshaller.unmarshal(new StringReader(xml));

			// 결과 출력
			System.out.println("결과 코드: " + response.getHeader().getResultCode());
			System.out.println("결과 메시지: " + response.getHeader().getResultMsg());
			
			String resultCode = response.getHeader().getResultCode();
			
			if("00".equals(resultCode)) {
				for (WeatherMidTaResponseXml.Body.Items.Item item : response.getBody().getItems().getItemList()) {
					returnMap.put("midtaItem", item);
					System.out.println("4일 후 최저: " + item.getTaMin4() + " / 최고: " + item.getTaMax4());
					System.out.println("5일 후 최저: " + item.getTaMin5() + " / 최고: " + item.getTaMax5());
					System.out.println("6일 후 최저: " + item.getTaMin6() + " / 최고: " + item.getTaMax6());
					System.out.println("7일 후 최저: " + item.getTaMin7() + " / 최고: " + item.getTaMax7());
					System.out.println("8일 후 최저: " + item.getTaMin8() + " / 최고: " + item.getTaMax8());
					System.out.println("9일 후 최저: " + item.getTaMin9() + " / 최고: " + item.getTaMax9());
					System.out.println("10일 후 최저: " + item.getTaMin10() + " / 최고: " + item.getTaMax10());
					
					System.out.println("--------------------------------");
				}
			} else {
				System.out.println("resultCode 00 X : " + resultCode);
			}

			
			System.out.println("--------------------------------");

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return returnMap;
	}
	
	public Map<String, Object> getSkyApi2(String tmFc, String regId){
		Map<String, Object> returnMap = new HashMap<>();
		
		String serviceKey = "tKC%2FEKOf9UYXkyi1qfzZ2nsQrz41%2Bm2d9zo6UBLw2xI3L%2BwvdaVp9CkMbyiS0kpDB7eyCxw%2BaDl%2FbXKbxSoO%2FQ%3D%3D"; //인코딩 후
		String baseUrl = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst";
		
		
		try {
			
			StringBuilder urlBuilder = new StringBuilder(baseUrl);
			urlBuilder.append("?serviceKey=" + serviceKey);
			urlBuilder.append("&pageNo=1" );
			urlBuilder.append("&numOfRows=100" );
			urlBuilder.append("&dataType=XML");
			urlBuilder.append("&regId="+regId);
			urlBuilder.append("&tmFc="+tmFc);
			

			URL url = new URL(urlBuilder.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("Content-type", "application/json");

			System.out.println("Response Code: " + conn.getResponseCode());

			BufferedReader rd;
			if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}

			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = rd.readLine()) != null) {
				sb.append(line);
			}

			rd.close();
			conn.disconnect();
			
			String xml = sb.toString();
			System.out.println(xml);
			
			
			// XML → 객체 변환
			JAXBContext context = JAXBContext.newInstance(WeatherMidLandResponseXml.class);
			Unmarshaller unmarshaller = context.createUnmarshaller();
			WeatherMidLandResponseXml response = (WeatherMidLandResponseXml) unmarshaller.unmarshal(new StringReader(xml));

			// 결과 출력
			System.out.println("결과 코드: " + response.getHeader().getResultCode());
			System.out.println("결과 메시지: " + response.getHeader().getResultMsg());
			
			String resultCode = response.getHeader().getResultCode();
			
			if("00".equals(resultCode)) {
				for (WeatherMidLandResponseXml.Body.Items.Item item : response.getBody().getItems().getItem()) {
					returnMap.put("midlandItem", item);
					System.out.println("지역: " + item.getRegId());
					System.out.println("4일 후 날씨 오전: " + item.getWf4Am() + " / 오후: " + item.getWf4Pm());
					System.out.println("5일 후 날씨 오전: " + item.getWf5Am() + " / 오후: " + item.getWf5Pm());
					System.out.println("6일 후 날씨 오전: " + item.getWf6Am() + " / 오후: " + item.getWf6Pm());
					System.out.println("7일 후 날씨 오전: " + item.getWf7Am() + " / 오후: " + item.getWf7Pm());
					System.out.println("8일 후 날씨: " + item.getWf8());
					System.out.println("9일 후 날씨: " + item.getWf9());
					System.out.println("10일 후 날씨: " + item.getWf10());
					
					
					System.out.println("4일 후 강수확률 오전: " + item.getRnSt4Am() + " / 오후: " + item.getRnSt4Pm());
					System.out.println("5일 후 강수확률 오전: " + item.getRnSt5Am() + " / 오후: " + item.getRnSt5Pm());
					System.out.println("6일 후 강수확률 오전: " + item.getRnSt6Am() + " / 오후: " + item.getRnSt6Pm());
					System.out.println("7일 후 강수확률 오전: " + item.getRnSt7Am() + " / 오후: " + item.getRnSt7Pm());
					System.out.println("8일 후 강수확률: " + item.getRnSt8());
					System.out.println("9일 후 강수확률: " + item.getRnSt9());
					System.out.println("10일 후 강수확률: " + item.getRnSt10());
					
					System.out.println("--------------------------------");
				}
			} else {
				System.out.println("resultCode 00 X : " + resultCode);
			}

			
			System.out.println("--------------------------------");

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return returnMap;
	}
	
	
	public Map<String, Object> getWeatherShortApi(String base_date, String nx, String ny){
		Map<String, Object> returnMap = new HashMap<>();
		
		String serviceKey = "tKC%2FEKOf9UYXkyi1qfzZ2nsQrz41%2Bm2d9zo6UBLw2xI3L%2BwvdaVp9CkMbyiS0kpDB7eyCxw%2BaDl%2FbXKbxSoO%2FQ%3D%3D"; //인코딩 후
		String baseUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
		
		try {
//			String base_date = "20250610";  
			String base_time = "0500";
			
			StringBuilder urlBuilder = new StringBuilder(baseUrl);
			urlBuilder.append("?serviceKey=" + serviceKey);
			urlBuilder.append("&pageNo=1" );
			urlBuilder.append("&numOfRows=1000" );
			urlBuilder.append("&dataType=XML");
			urlBuilder.append("&base_date="+base_date);
			urlBuilder.append("&base_time="+base_time);
			urlBuilder.append("&nx="+nx);
			urlBuilder.append("&ny="+ny);
			

			URL url = new URL(urlBuilder.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("Content-type", "application/json");

			System.out.println("Response Code: " + conn.getResponseCode());

			BufferedReader rd;
			if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}

			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = rd.readLine()) != null) {
				sb.append(line);
			}

			rd.close();
			conn.disconnect();
			
			String xml = sb.toString();
			System.out.println(xml);
			
			
			// XML → 객체 변환
			JAXBContext context = JAXBContext.newInstance(WeatherShortResponseXml.class);
			Unmarshaller unmarshaller = context.createUnmarshaller();
			WeatherShortResponseXml response = (WeatherShortResponseXml) unmarshaller.unmarshal(new StringReader(xml));

			// 결과 출력
			System.out.println("결과 코드: " + response.getHeader().getResultCode());
			System.out.println("결과 메시지: " + response.getHeader().getResultMsg());
			
			String resultCode = response.getHeader().getResultCode();
			returnMap.put("resultCode", resultCode);
			
			List<Map<String, Object>> list = new ArrayList<>();
			if("00".equals(resultCode)) {
				list = WeatherShortSummaryByHalfDay.summarize(response.getBody().getItems().getItem());
				
				if(list.size() > 0) {
					for (Map<String, Object> weatherMap : list) {
						System.out.println("weatherMap : " + weatherMap.toString());
					}
					
					returnMap.put("shortList", list);
				}
				
			} else {
				System.out.println("resultCode 00 X : " + resultCode);
			}

			
			System.out.println("--------------------------------");

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return returnMap;
	}
	
	
	public Map<String, Object> getKakaoApi(String addr){
		String kakaoApiKey = "2757d88ef9c99628d60fe1a419caf965";
		
		Map<String, Object> returnMap = new HashMap<>();
		
		String query = UriComponentsBuilder
				.fromHttpUrl("https://dapi.kakao.com/v2/local/search/address.XML")
				.queryParam("query", addr)
				.build()
				.toUriString();

		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "KakaoAK " + kakaoApiKey);

		HttpEntity<Void> requestEntity = new HttpEntity<>(headers);
		RestTemplate restTemplate = new RestTemplate();

		ResponseEntity<JsonNode> response = restTemplate.exchange(
				query,
				HttpMethod.GET,
				requestEntity,
				JsonNode.class
		);

		JsonNode documents = response.getBody().path("documents");
		
		System.out.println("response.getStatusCode = " + response.getStatusCode());
		System.out.println("response.getHeaders = " + response.getHeaders());
		System.out.println("response.getBody = " + response.getBody());
		
		int nx = 0;
		int ny = 0;
		
		if (documents.isArray() && documents.size() > 0) {
			JsonNode location = documents.get(0);
			double x = location.path("x").asDouble(); // longitude
			double y = location.path("y").asDouble(); // latitude
			
			System.out.println("x: " + x + " / y: " + y);
			
			GeoTransUtil.GridPoint point = GeoTransUtil.convertGPS2GRID(x, y);
			
			nx = point.x;
			ny = point.y;
			
			System.out.println("기상청 격자 X: " + nx);
			System.out.println("기상청 격자 Y: " + ny);
			
		} else {
			System.out.println("카카오 API 좌표 조회 실패. " + addr);
		}
		
		returnMap.put("nx", nx);
		returnMap.put("ny", ny);
		return returnMap;
	}
	
	
	public void addrTT(String address) {

        Map<String, String> mappingTable = new HashMap<>();
        mappingTable.put("인천", "001");
        mappingTable.put("경기 광주", "002");
        mappingTable.put("강원 고성", "003");
        mappingTable.put("고성", "004");
        mappingTable.put("경상남도 고성", "005");
        mappingTable.put("경남 고성", "005");

        String normalizedAddress = address.replace("도 ", "도").replaceAll("\\s+", "");
        
        //주소정보로 구역테이블 조회해서 (mappingTable) 조회된 데이터 중 가장 길게 일치하는 구역 코드 추출.
        Optional<Map.Entry<String, String>> bestMatch = mappingTable.entrySet().stream()
                .filter(entry -> normalizedAddress.contains(entry.getKey().replaceAll("\\s+", "")))
                .max(Comparator.comparingInt(e -> e.getKey().replaceAll("\\s+", "").length()));

        if (bestMatch.isPresent()) {
        	System.out.println(address);
            System.out.println("최장 일치 코드: " + bestMatch.get().getValue());
        } else {
            System.out.println("일치 없음");
        }
	}
	
	
	public List<Map<String, Object>> mergeMidWeatherData(Map<String, Object> midtaMap, Map<String, Object> midlandMap) {
	    List<Map<String, Object>> mergedList = new ArrayList<>();
	    
	    // 오늘 기준 날짜 계산
	    LocalDate today = LocalDate.now();

	    for (int i = 4; i <= 10; i++) {
	        Map<String, Object> daily = new HashMap<>();

	        LocalDate targetDate = today.plusDays(i);
	        String dayOfWeek = targetDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN);
	        String dateStr = targetDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

	        daily.put("date", dateStr);
	        daily.put("dayOfWeek", dayOfWeek);
	        daily.put("day", i + "일차");

	        // 날씨
	        if (i <= 7) {
	            String amKey = "wf" + i + "Am";
	            String pmKey = "wf" + i + "Pm";
	            daily.put("amWeather", midlandMap.get(amKey));
	            daily.put("pmWeather", midlandMap.get(pmKey));

	            String popAmKey = "rnSt" + i + "Am";
	            String popPmKey = "rnSt" + i + "Pm";
	            daily.put("amPop", midlandMap.get(popAmKey));
	            daily.put("pmPop", midlandMap.get(popPmKey));
	        } else {
	            String wfKey = "wf" + i;
	            String popKey = "rnSt" + i;
	            daily.put("amWeather", midlandMap.get(wfKey));
	            daily.put("pmWeather", midlandMap.get(wfKey));
	            daily.put("amPop", midlandMap.get(popKey));
	            daily.put("pmPop", midlandMap.get(popKey));
	        }

	        // 기온
	        String taMinKey = "taMin" + i;
	        String taMaxKey = "taMax" + i;
	        daily.put("minTemp", midtaMap.get(taMinKey));
	        daily.put("maxTemp", midtaMap.get(taMaxKey));

	        mergedList.add(daily);
	    }

	    return mergedList;
	}
	
	public static List<Map<String, Object>> summarizeMidForecast( Map<String, Object> tItem, Map<String, Object> lItem ) {
		
        WeatherMidTaResponseXml.Body.Items.Item taItem     = (WeatherMidTaResponseXml.Body.Items.Item) tItem.get("taItem");
        WeatherMidLandResponseXml.Body.Items.Item landItem = (WeatherMidLandResponseXml.Body.Items.Item) lItem.get("landItem");
        
        
	    List<Map<String, Object>> list = new ArrayList<>();
	    LocalDate today = LocalDate.now();
	    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	    for (int i = 4; i <= 10; i++) {
	        Map<String, Object> map = new HashMap<>();

	        LocalDate targetDate = today.plusDays(i);
	        DayOfWeek dayOfWeek = targetDate.getDayOfWeek();

	        map.put("date", targetDate.format(dateFormatter)); // "yyyy-MM-dd"
	        map.put("dayOfWeek", getKoreanDayOfWeek(dayOfWeek)); // "월", "화" 등

	        map.put("minTemp", getField(taItem, "taMin" + i));
	        map.put("maxTemp", getField(taItem, "taMax" + i));

	        if (i <= 7) {
	            map.put("amWeather", getField(landItem, "wf" + i + "Am"));
	            map.put("pmWeather", getField(landItem, "wf" + i + "Pm"));
	            map.put("amPop", getField(landItem, "rnSt" + i + "Am"));
	            map.put("pmPop", getField(landItem, "rnSt" + i + "Pm"));
	        } else {
	            String weather = getField(landItem, "wf" + i);
	            String pop = getField(landItem, "rnSt" + i);
	            map.put("amWeather", weather);
	            map.put("pmWeather", weather);
	            map.put("amPop", pop);
	            map.put("pmPop", pop);
	        }

	        list.add(map);
	    }

	    return list;
	}
	
	private static String getField(Object obj, String fieldName) {
	    try {
	        Field field = obj.getClass().getDeclaredField(fieldName);
	        field.setAccessible(true);
	        return (String) field.get(obj);
	    } catch (Exception e) {
	        return null;
	    }
	}
	
	private static String getKoreanDayOfWeek(DayOfWeek dayOfWeek) {
	    switch (dayOfWeek) {
	        case MONDAY:    return "월";
	        case TUESDAY:   return "화";
	        case WEDNESDAY: return "수";
	        case THURSDAY:  return "목";
	        case FRIDAY:    return "금";
	        case SATURDAY:  return "토";
	        case SUNDAY:    return "일";
	        default:        return "";
	    }
	}
	
	
	

	public static void main(String[] args) throws ParseException {
		JavaTest jt = new JavaTest();
		
//		List<String> addrList = Arrays.asList(
//				"강원 고성시 고성읍 1",
//				"서울시 동작구 1",
//				"경상도 고성시 용두동 21",
//				"경남 고성시 동문대로 24",
//				"경상남도 고성시 북구 4",
//				"강원특별자치시 고성시 동구 45"
//		);
//
//		jt.addrTT(addrList.get(0));
//		System.out.println("");
//		jt.addrTT(addrList.get(1));
//		System.out.println("");
//		jt.addrTT(addrList.get(2));
//		System.out.println("");
//		jt.addrTT(addrList.get(3));
//		System.out.println("");
//		jt.addrTT(addrList.get(4));
//		System.out.println("");
//		jt.addrTT(addrList.get(5));
//		System.out.println("");
		
		try {
			jt.disableSslVerification();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String selDate = "2025-06-15 22:00";
		String toDate  = Converter.dateToStr("yyyyMMdd");
		selDate = Converter.convertDateFormat(selDate, "yyyyMMdd");
//		try {
//			selDate = Converter.dateToStr("yyyyMMdd", Converter.toDate("yyyyMMdd", selDate));
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
		System.out.println("selDate = " + selDate);
		System.out.println("toDate = " + toDate);
		
		//int diff = Converter.dateDiff(toDate, selDate);
		int diff = Converter.dateDiff(toDate, selDate,"D");
		System.out.println("diff : " + diff);
		
		
		String addr2 = "경남 의령군 봉수면 대한로 763";
		
		String addr = "서울시 동작구 사당동";
		
		String base_date = toDate;
		String tmFc = toDate+"0600";
		String regId = "11B10101";
		String regId2 = "11B00000";
		
		Map<String, Object> kakao = jt.getKakaoApi(addr);
		
		String nx = Converter.toStr(kakao.get("nx"));
		String ny = Converter.toStr(kakao.get("ny"));
		
		Map<String, Object> msgMap = new HashMap<>();
		
		msgMap = jt.getWeatherShortApi(base_date, nx, ny); //1일~4일. (5일 데이터는 의미 없음. 데이터 이상함)
		
		
		List<Map<String, Object>> weatherList = new ArrayList<>();
		List<Map<String, Object>> shortList   = (List<Map<String, Object>>) msgMap.get("shortList");
		
		if(shortList != null && shortList.size() > 0) {
			for(Map<String, Object> oneDay : shortList ) {
				if(selDate.equals(oneDay.get("date"))) {
					weatherList.add(oneDay);
				}
			}
		}
		msgMap.put("weatherList", weatherList);
		msgMap.remove("shortList");
		
		System.out.println("weatherList : " + weatherList.toString());
		System.out.println("msgMap : " + msgMap.toString());
		
		Map<String, Object> midTaItem = jt.getSkyApi1(tmFc, regId); //4일~10일. 최저, 최고기온
		Map<String, Object> midLandItem = jt.getSkyApi2(tmFc, regId2); //4일~10일. 날씨(맑음, 흐림 등), 강수확률
		
		
		List<Map<String, Object>> mergedList = jt.summarizeMidForecast(midTaItem, midLandItem);
		
		if(mergedList.size()>0) {
			for (Map<String, Object> map : mergedList) {
				System.out.println("map " + map.toString());
			}
		}
		
	}
}
