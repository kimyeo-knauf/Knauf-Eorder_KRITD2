package com.limenets.eorder.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.web.multipart.MultipartFile;

import com.limenets.common.util.Converter;

public class ExcelFilterUtil {
	
	/**
	 * 엑셀 업로드 시 헤더 위치가 고정이 아닌 동적인 경우 필요한 헤더명의 인덱스에 해당하는 데이터 추출 2025-05-30 ijy
	 */
	public static List<Map<String, String>> extractDataByHeaders(MultipartFile file, String[] headerList) throws IOException {
    	
    	// 추출할 헤더 목록
        List<String> targetHeaders = Arrays.asList(headerList);

        List<Map<String, String>> extractedRows = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            Row headerRow = sheet.getRow(0);

            if (headerRow == null) {
                return extractedRows;
            }

            // 헤더 이름 -> 열 인덱스 매핑
            Map<String, Integer> headerIndexMap = new HashMap<>();
            for (Cell cell : headerRow) {
                String headerName = cell.getStringCellValue().trim();
                if (targetHeaders.contains(headerName)) {
                    headerIndexMap.put(headerName, cell.getColumnIndex());
                }
            }

            // 데이터 추출
            for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                Row dataRow = sheet.getRow(rowIndex);
                if (dataRow == null) continue;

                Map<String, String> rowData = new HashMap<>();

                for (String header : targetHeaders) {
                    Integer colIndex = headerIndexMap.get(header);
                    if (colIndex != null) {
                        Cell cell = dataRow.getCell(colIndex);
                        String cellValue = Converter.convertToString(cell);
                        rowData.put(header, cellValue);
                    }
                }

                extractedRows.add(rowData);
            }
        } catch (InvalidFormatException e) {
			e.printStackTrace();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return extractedRows;
    	
    }
	
	
}