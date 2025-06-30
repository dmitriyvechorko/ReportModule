package org.productreport.service;

import org.springframework.stereotype.Component;
import java.io.ByteArrayOutputStream;

@Component("template1")
public class TemplateOneReport implements WordReportStrategy {

    private final ReportService reportService;

    public TemplateOneReport(ReportService reportService) {
        this.reportService = reportService;
    }

    @Override
    public ByteArrayOutputStream generateReport(String name, String type, Boolean isImport) throws Exception {
        return reportService.generateWordReport1(name, type, isImport);
    }
}