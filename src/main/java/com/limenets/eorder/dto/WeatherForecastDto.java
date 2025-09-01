package com.limenets.eorder.dto;

public class WeatherForecastDto {
    private int id;                 // 고유 PK
    private int cid;                 // 고유 PK
    private String city;             // 도시명
    private String nx;               // X 좌표
    private String ny;               // Y 좌표
    private String mil_cd;         // Y좌표
    private String mit_cd;         // Y좌표
    private String weather_date;  // 날짜
    private String day_of_week;      // 요일
    private String am_weather;       // 오전 날씨
    private String pm_weather;       // 오후 날씨
    private String am_temp;         // 오전 기온
    private String pm_temp;         // 오후 기온
    private String am_pop;          // 오전 습도
    private String pm_pop;          // 오후 습도
    private String insertid;         // 생성자
    private String updateid;         // 수정자

    // getter/setter 생략 (IDE로 자동 생성 가능)

    public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getCid() {
		return cid;
	}
	public void setCid(int cid) {
		this.cid = cid;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getNx() {
		return nx;
	}
	public void setNx(String nx) {
		this.nx = nx;
	}
	public String getNy() {
		return ny;
	}
	public void setNy(String ny) {
		this.ny = ny;
	}
	public String getMil_cd() {
		return mil_cd;
	}
	public void setMil_cd(String mil_cd) {
		this.mil_cd = mil_cd;
	}
	public String getMit_cd() {
		return mit_cd;
	}
	public void setMit_cd(String mit_cd) {
		this.mit_cd = mit_cd;
	}
	public String getWeather_date() {
		return weather_date;
	}
	public void setWeather_date(String weather_date) {
		this.weather_date = weather_date;
	}
	public String getDay_of_week() {
		return day_of_week;
	}
	public void setDay_of_week(String day_of_week) {
		this.day_of_week = day_of_week;
	}
	public String getAm_weather() {
		return am_weather;
	}
	public void setAm_weather(String am_weather) {
		this.am_weather = am_weather;
	}
	public String getPm_weather() {
		return pm_weather;
	}
	public void setPm_weather(String pm_weather) {
		this.pm_weather = pm_weather;
	}
	public String getAm_temp() {
		return am_temp;
	}
	public void setAm_temp(String am_temp) {
		this.am_temp = am_temp;
	}
	public String getPm_temp() {
		return pm_temp;
	}
	public void setPm_temp(String pm_temp) {
		this.pm_temp = pm_temp;
	}
	public String getAm_pop() {
		return am_pop;
	}
	public void setAm_pop(String am_pop) {
		this.am_pop = am_pop;
	}
	public String getPm_pop() {
		return pm_pop;
	}
	public void setPm_pop(String pm_pop) {
		this.pm_pop = pm_pop;
	}
	public String getInsertid() {
		return insertid;
	}
	public void setInsertid(String insertid) {
		this.insertid = insertid;
	}
	public String getUpdateid() {
		return updateid;
	}
	public void setUpdateid(String updateid) {
		this.updateid = updateid;
	}
}
