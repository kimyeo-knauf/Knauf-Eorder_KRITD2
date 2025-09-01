package com.limenets.eorder.dto;

import java.util.Objects;

public class QuotationDto {
	private String QUOTE_QT;
	private String ITEM_CD;
	
	
	public String getQUOTE_QT() {
		return QUOTE_QT;
	}
	public void setQUOTE_QT(String qUOTE_QT) {
		QUOTE_QT = qUOTE_QT;
	}
	public String getITEM_CD() {
		return ITEM_CD;
	}
	public void setITEM_CD(String iTEM_CD) {
		ITEM_CD = iTEM_CD;
	}
	
	@Override
	public String toString() {
		return "QuotationDto [QUOTE_QT=" + QUOTE_QT + ", ITEM_CD=" + ITEM_CD + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(ITEM_CD, QUOTE_QT);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		QuotationDto other = (QuotationDto) obj;
		return Objects.equals(ITEM_CD, other.ITEM_CD) && Objects.equals(QUOTE_QT, other.QUOTE_QT);
	}
}