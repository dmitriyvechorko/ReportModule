package org.productreport.service;

import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;

@Component("template2")
public class TemplateTwoReport implements WordReportStrategy {

    private final ReportService reportService;

    public TemplateTwoReport(ReportService reportService) {
        this.reportService = reportService;
    }

    @Override
    public ByteArrayOutputStream generateReport(String name, String type, Boolean isImport) throws Exception {
        return reportService.generateWordReport2(name, type, isImport);
    }
}