package com.limenets.eorder.util;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** 기상청 단기예보 API 응답값 xml 파싱 클래스 2025.06.11 ijy */
@XmlRootElement(name = "response")
@XmlAccessorType(XmlAccessType.FIELD)
public class WeatherShortResponseXml {

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
                private String baseDate;
                private String baseTime;
                private String category;
                private String fcstDate;
                private String fcstTime;
                private String fcstValue;
                private String nx;
                private String ny;

                // Getter/Setter
                public String getBaseDate() { return baseDate; }
                public void setBaseDate(String baseDate) { this.baseDate = baseDate; }

                public String getBaseTime() { return baseTime; }
                public void setBaseTime(String baseTime) { this.baseTime = baseTime; }

                public String getCategory() { return category; }
                public void setCategory(String category) { this.category = category; }

                public String getFcstDate() { return fcstDate; }
                public void setFcstDate(String fcstDate) { this.fcstDate = fcstDate; }

                public String getFcstTime() { return fcstTime; }
                public void setFcstTime(String fcstTime) { this.fcstTime = fcstTime; }

                public String getFcstValue() { return fcstValue; }
                public void setFcstValue(String fcstValue) { this.fcstValue = fcstValue; }

                public String getNx() { return nx; }
                public void setNx(String nx) { this.nx = nx; }

                public String getNy() { return ny; }
                public void setNy(String ny) { this.ny = ny; }
            }
        }
    }
}