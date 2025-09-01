package com.limenets.eorder.util;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** 기상청 중기육상예보 API 응답값 xml 파싱 클래스 2025.06.11 ijy */
@XmlRootElement(name = "response")
@XmlAccessorType(XmlAccessType.FIELD)
public class WeatherMidLandResponseXml {

    private Header header;
    private Body body;

    public Header getHeader() { return header; }
    public void setHeader(Header header) { this.header = header; }

    public Body getBody() { return body; }
    public void setBody(Body body) { this.body = body; }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Header {
        private String resultCode;
        private String resultMsg;

        public String getResultCode() { return resultCode; }
        public void setResultCode(String resultCode) { this.resultCode = resultCode; }

        public String getResultMsg() { return resultMsg; }
        public void setResultMsg(String resultMsg) { this.resultMsg = resultMsg; }
    }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Body {
        private Items items;

        public Items getItems() { return items; }
        public void setItems(Items items) { this.items = items; }

        @XmlAccessorType(XmlAccessType.FIELD)
        public static class Items {
            @XmlElement(name = "item")
            private List<Item> item;

            public List<Item> getItem() { return item; }
            public void setItem(List<Item> item) { this.item = item; }

            @XmlAccessorType(XmlAccessType.FIELD)
            public static class Item {
                private String regId;
                
                private String rnSt4Am;
                private String rnSt4Pm;
                private String rnSt5Am;
                private String rnSt5Pm;
                private String rnSt6Am;
                private String rnSt6Pm;
                private String rnSt7Am;
                private String rnSt7Pm;
                private String rnSt8;
                private String rnSt9;
                private String rnSt10;
                
                private String wf4Am;
                private String wf4Pm;
                private String wf5Am;
                private String wf5Pm;
                private String wf6Am;
                private String wf6Pm;
                private String wf7Am;
                private String wf7Pm;
                private String wf8;
                private String wf9;
                private String wf10;
                
                
                public String getRegId() {
					return regId;
				}
				public void setRegId(String regId) {
					this.regId = regId;
				}
				public String getRnSt4Am() {
					return rnSt4Am;
				}
				public void setRnSt4Am(String rnSt4Am) {
					this.rnSt4Am = rnSt4Am;
				}
				public String getRnSt4Pm() {
					return rnSt4Pm;
				}
				public void setRnSt4Pm(String rnSt4Pm) {
					this.rnSt4Pm = rnSt4Pm;
				}
				public String getRnSt5Am() {
					return rnSt5Am;
				}
				public void setRnSt5Am(String rnSt5Am) {
					this.rnSt5Am = rnSt5Am;
				}
				public String getRnSt5Pm() {
					return rnSt5Pm;
				}
				public void setRnSt5Pm(String rnSt5Pm) {
					this.rnSt5Pm = rnSt5Pm;
				}
				public String getRnSt6Am() {
					return rnSt6Am;
				}
				public void setRnSt6Am(String rnSt6Am) {
					this.rnSt6Am = rnSt6Am;
				}
				public String getRnSt6Pm() {
					return rnSt6Pm;
				}
				public void setRnSt6Pm(String rnSt6Pm) {
					this.rnSt6Pm = rnSt6Pm;
				}
				public String getRnSt7Am() {
					return rnSt7Am;
				}
				public void setRnSt7Am(String rnSt7Am) {
					this.rnSt7Am = rnSt7Am;
				}
				public String getRnSt7Pm() {
					return rnSt7Pm;
				}
				public void setRnSt7Pm(String rnSt7Pm) {
					this.rnSt7Pm = rnSt7Pm;
				}
				public String getRnSt8() {
					return rnSt8;
				}
				public void setRnSt8(String rnSt8) {
					this.rnSt8 = rnSt8;
				}
				public String getRnSt9() {
					return rnSt9;
				}
				public void setRnSt9(String rnSt9) {
					this.rnSt9 = rnSt9;
				}
				public String getRnSt10() {
					return rnSt10;
				}
				public void setRnSt10(String rnSt10) {
					this.rnSt10 = rnSt10;
				}
				public String getWf4Am() {
					return wf4Am;
				}
				public void setWf4Am(String wf4Am) {
					this.wf4Am = wf4Am;
				}
				public String getWf4Pm() {
					return wf4Pm;
				}
				public void setWf4Pm(String wf4Pm) {
					this.wf4Pm = wf4Pm;
				}
				public String getWf5Am() {
					return wf5Am;
				}
				public void setWf5Am(String wf5Am) {
					this.wf5Am = wf5Am;
				}
				public String getWf5Pm() {
					return wf5Pm;
				}
				public void setWf5Pm(String wf5Pm) {
					this.wf5Pm = wf5Pm;
				}
				public String getWf6Am() {
					return wf6Am;
				}
				public void setWf6Am(String wf6Am) {
					this.wf6Am = wf6Am;
				}
				public String getWf6Pm() {
					return wf6Pm;
				}
				public void setWf6Pm(String wf6Pm) {
					this.wf6Pm = wf6Pm;
				}
				public String getWf7Am() {
					return wf7Am;
				}
				public void setWf7Am(String wf7Am) {
					this.wf7Am = wf7Am;
				}
				public String getWf7Pm() {
					return wf7Pm;
				}
				public void setWf7Pm(String wf7Pm) {
					this.wf7Pm = wf7Pm;
				}
				public String getWf8() {
					return wf8;
				}
				public void setWf8(String wf8) {
					this.wf8 = wf8;
				}
				public String getWf9() {
					return wf9;
				}
				public void setWf9(String wf9) {
					this.wf9 = wf9;
				}
				public String getWf10() {
					return wf10;
				}
				public void setWf10(String wf10) {
					this.wf10 = wf10;
				}
				
            }
        }
    }
}