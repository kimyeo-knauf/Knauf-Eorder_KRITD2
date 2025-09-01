package com.limenets.eorder.util;

/**
 * 카카오 로컬 API로 구한 위/경도 정보를 기상청 API에서 사용하는 격자값으로 변환하는 유틸.
 * 2025. 6. 11 ijy
 */
public class GeoTransUtil {

    // 기상청 격자 변환용 상수
    private static final double RE		= 6371.00877;	// 지구 반지름 (km)
    private static final double GRID	= 5.0;			// 격자 간격 (km)
    private static final double SLAT1	= 30.0;			// 투영 위도1
    private static final double SLAT2	= 60.0;			// 투영 위도2
    private static final double OLON	= 126.0;		// 기준점 경도
    private static final double OLAT	= 38.0;			// 기준점 위도
    private static final double XO		= 43;			// 기준점 X좌표 (격자)
    private static final double YO		= 136;			// 기준점 Y좌표 (격자)

    public static GridPoint convertGPS2GRID(double lon, double lat) {
        double DEGRAD = Math.PI / 180.0;

        double re = RE / GRID;
        double slat1 = SLAT1 * DEGRAD;
        double slat2 = SLAT2 * DEGRAD;
        double olon = OLON * DEGRAD;
        double olat = OLAT * DEGRAD;

        double sn = Math.tan(Math.PI * 0.25 + slat2 * 0.5) / Math.tan(Math.PI * 0.25 + slat1 * 0.5);
        sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);

        double sf = Math.tan(Math.PI * 0.25 + slat1 * 0.5);
        sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;

        double ro = Math.tan(Math.PI * 0.25 + olat * 0.5);
        ro = re * sf / Math.pow(ro, sn);

        double ra = Math.tan(Math.PI * 0.25 + lat * DEGRAD * 0.5);
        ra = re * sf / Math.pow(ra, sn);

        double theta = lon * DEGRAD - olon;
        if (theta > Math.PI) theta -= 2.0 * Math.PI;
        if (theta < -Math.PI) theta += 2.0 * Math.PI;
        theta *= sn;

        int x = (int) Math.floor(ra * Math.sin(theta) + XO + 0.5);
        int y = (int) Math.floor(ro - ra * Math.cos(theta) + YO + 0.5);

        return new GridPoint(x, y);
    }

    public static class GridPoint {
        public int x;
        public int y;

        public GridPoint(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public String toString() {
            return "GridPoint{" + "x=" + x + ", y=" + y + '}';
        }
    }
}
