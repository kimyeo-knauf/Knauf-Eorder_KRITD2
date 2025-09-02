package com.limenets.eorder.dto;

public class DynamicDailyMailDto {
	private String orderNo;
	private String factory;
	private String reqDate;
	private String reqTime;
	private String client;
	private String deliveryClient;
	private String product;
	private int quantity;
	private String deivertyAddr;
	
	public DynamicDailyMailDto() {};
	
	public void setOrderNo(String ordNo) { orderNo = ordNo; }
	public String getOrderNo() { return orderNo; };
	
	public void setFactory(String fcato) { factory = fcato; }
	public String getFactory() { return factory; };
	
	public void setReqDate(String reqD) { reqDate = reqD; }
	public String getReqDate() { return reqDate; };
	
	public void setReqTime(String reqT) { reqTime = reqT; }
	public String getReqTime() { return reqTime; };
	
	public void setClient(String clt) { client = clt; }
	public String getClient() { return client; };
	
	public void setDeliClient(String deliClt) { deliveryClient = deliClt; }
	public String getDeliClient() { return deliveryClient; };	
	
	public void setProduct(String prod) { product = prod; }
	public String getProduct() { return product; };
	
	public void setQuantity(int qnty) { quantity = qnty; }
	public int getQuantity() { return quantity; };
	
	public void setDeilAddress(String deliAddr) { deivertyAddr = deliAddr; }
	public String getDeliAddress() { return deivertyAddr; };
	
}
