package org.productreport.service;

import java.io.ByteArrayOutputStream;

public interface WordReportStrategy {
    ByteArrayOutputStream generateReport(String name, String type, Boolean isImport) throws Exception;
}