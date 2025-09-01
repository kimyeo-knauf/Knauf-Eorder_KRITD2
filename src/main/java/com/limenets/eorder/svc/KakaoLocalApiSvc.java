package com.limenets.eorder.svc;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpMethod;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.limenets.eorder.util.GeoTransUtil;

@Service
public class KakaoLocalApiSvc {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${kakao.local.api.key}")     private String kakaoApiKey;
	@Value("${kakao.local.api.url}")     private String kakaoApiUrl;


    public Map<String, Object> getKakaoLocalApi(String addr) {
        Map<String, Object> returnMap = new HashMap<>();

//        System.out.println("#################### kakaoApiKey : " + kakaoApiKey);
//        System.out.println("#################### kakaoApiUrl : " + kakaoApiUrl);
        String query = UriComponentsBuilder
                .fromHttpUrl(kakaoApiUrl)
                .queryParam("query", addr)
                .build()
                .toUriString();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoApiKey);

        HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

        ResponseEntity<JsonNode> response = restTemplate.exchange(
                query,
                HttpMethod.GET,
                requestEntity,
                JsonNode.class
        );

        JsonNode documents = response.getBody().path("documents");

        int nx = 0;
        int ny = 0;

        if (documents.isArray() && documents.size() > 0) {
            JsonNode location = documents.get(0);
            double x = location.path("x").asDouble();
            double y = location.path("y").asDouble();

            GeoTransUtil.GridPoint point = GeoTransUtil.convertGPS2GRID(x, y);

            nx = point.x;
            ny = point.y;
        }

        returnMap.put("nx", nx);
        returnMap.put("ny", ny);
        return returnMap;
    }
}

