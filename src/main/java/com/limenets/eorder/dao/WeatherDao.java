package com.limenets.eorder.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.limenets.eorder.dto.WeatherDto;
import com.limenets.eorder.dto.WeatherForecastDto;


@Repository
public class WeatherDao {
	@Inject private SqlSession sqlSession;
	
	/**
	 * O_WEATHER_MIDLAND Table.
	 * O_WEATHER_MIDTA Table.
	 */
	public List<WeatherDto> getWeatherMidLandAreaList(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_weather_forecast.getWeatherMidLandAreaList", svcMap);
	}
	
	public List<WeatherDto> getWeatherMidTaAreaList(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_weather_forecast.getWeatherMidTaAreaList", svcMap);
	}


	public List<WeatherDto> getWeatherMidAreaList(Map<String, Object> svcMap) {
		return sqlSession.selectList("eorder.o_weather_forecast.getWeatherMidAreaList", svcMap);
	}




	public List<WeatherForecastDto> getWeatherCityList() {
		return sqlSession.selectList("eorder.o_weather_forecast.selectAllCities");
	}

	public int updateCityCoords(WeatherForecastDto dto) {
		return sqlSession.update("eorder.o_weather_forecast.updateCityCoords", dto);
	}



	public int mergeWeatherForecast(WeatherForecastDto dto) {
		return sqlSession.update("eorder.o_weather_forecast.mergeWeatherForecast", dto);
	}


	public List<WeatherForecastDto> selectWeeklyForecasts() {
		return sqlSession.selectList("eorder.o_weather_forecast.selectWeeklyForecasts");
	}

}