package com.limenets.eorder.util;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** 기상청 중기기온예보 API 응답값 xml 파싱 클래스 2025.06.11 ijy */
@XmlRootElement(name = "response")
@XmlAccessorType(XmlAccessType.FIELD)
public class WeatherMidTaResponseXml {
    private Header header;
    private Body body;
    
	public Header getHeader() {
		return header;
	}
	public void setHeader(Header header) {
		this.header = header;
	}
	public Body getBody() {
		return body;
	}
	public void setBody(Body body) {
		this.body = body;
	}

	@XmlAccessorType(XmlAccessType.FIELD)
    public static class Header {
        private String resultCode;
        private String resultMsg;
        
		public String getResultCode() {
			return resultCode;
		}
		public void setResultCode(String resultCode) {
			this.resultCode = resultCode;
		}
		public String getResultMsg() {
			return resultMsg;
		}
		public void setResultMsg(String resultMsg) {
			this.resultMsg = resultMsg;
		}
    }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Body {
        private Items items;
        private int numOfRows;
        private int pageNo;
        private int totalCount;
        private String dataType;  // ← 이거 추가!

        
		public Items getItems() {
			return items;
		}
		public void setItems(Items items) {
			this.items = items;
		}
		public int getNumOfRows() {
			return numOfRows;
		}
		public void setNumOfRows(int numOfRows) {
			this.numOfRows = numOfRows;
		}
		public int getPageNo() {
			return pageNo;
		}
		public void setPageNo(int pageNo) {
			this.pageNo = pageNo;
		}
		public int getTotalCount() {
			return totalCount;
		}
		public void setTotalCount(int totalCount) {
			this.totalCount = totalCount;
		}
	    public String getDataType() { return dataType; }
	    public void setDataType(String dataType) { this.dataType = dataType; }

		@XmlAccessorType(XmlAccessType.FIELD)
        public static class Items {
            @XmlElement(name = "item")
            private List<Item> itemList;
            
			public List<Item> getItemList() {
				return itemList;
			}
			public void setItemList(List<Item> itemList) {
				this.itemList = itemList;
			}

			@XmlAccessorType(XmlAccessType.FIELD)
            public static class Item {
                private String regId;
                private String taMin4;
                private String taMax4;
                private String taMin5;
                private String taMax5;
                private String taMin6;
                private String taMax6;
                private String taMin7;
                private String taMax7;
                private String taMin8;
                private String taMax8;
                private String taMin9;
                private String taMax9;
                private String taMin10;
                private String taMax10;
                
				public String getRegId() {
					return regId;
				}
				public void setRegId(String regId) {
					this.regId = regId;
				}
				public String getTaMin4() {
					return taMin4;
				}
				public void setTaMin4(String taMin4) {
					this.taMin4 = taMin4;
				}
				public String getTaMax4() {
					return taMax4;
				}
				public void setTaMax4(String taMax4) {
					this.taMax4 = taMax4;
				}
				public String getTaMin5() {
					return taMin5;
				}
				public void setTaMin5(String taMin5) {
					this.taMin5 = taMin5;
				}
				public String getTaMax5() {
					return taMax5;
				}
				public void setTaMax5(String taMax5) {
					this.taMax5 = taMax5;
				}
				public String getTaMin6() {
					return taMin6;
				}
				public void setTaMin6(String taMin6) {
					this.taMin6 = taMin6;
				}
				public String getTaMax6() {
					return taMax6;
				}
				public void setTaMax6(String taMax6) {
					this.taMax6 = taMax6;
				}
				public String getTaMin7() {
					return taMin7;
				}
				public void setTaMin7(String taMin7) {
					this.taMin7 = taMin7;
				}
				public String getTaMax7() {
					return taMax7;
				}
				public void setTaMax7(String taMax7) {
					this.taMax7 = taMax7;
				}
				public String getTaMin8() {
					return taMin8;
				}
				public void setTaMin8(String taMin8) {
					this.taMin8 = taMin8;
				}
				public String getTaMax8() {
					return taMax8;
				}
				public void setTaMax8(String taMax8) {
					this.taMax8 = taMax8;
				}
				public String getTaMin9() {
					return taMin9;
				}
				public void setTaMin9(String taMin9) {
					this.taMin9 = taMin9;
				}
				public String getTaMax9() {
					return taMax9;
				}
				public void setTaMax9(String taMax9) {
					this.taMax9 = taMax9;
				}
				public String getTaMin10() {
					return taMin10;
				}
				public void setTaMin10(String taMin10) {
					this.taMin10 = taMin10;
				}
				public String getTaMax10() {
					return taMax10;
				}
				public void setTaMax10(String taMax10) {
					this.taMax10 = taMax10;
				}
            }
        }
    }
}