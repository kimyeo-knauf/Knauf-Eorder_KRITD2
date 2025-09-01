package com.limenets.common.util;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.FileOutputStream;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

public class PdfGenerator {
	
	public static File convertHtmlToPdf(String htmlContent, String outputFilePath) throws IOException{
		File pdfFile = new File(outputFilePath);
		try(OutputStream os = new FileOutputStream(pdfFile)){
			PdfRendererBuilder builder = new PdfRendererBuilder();
			builder.useFastMode();
			builder.withHtmlContent(htmlContent, null);
			builder.toStream(os);
			builder.run();
		}catch (Exception e) {
			e.printStackTrace();
			throw new IOException("PDF 변환 실패", e);
		}
		return pdfFile;
	}
}
