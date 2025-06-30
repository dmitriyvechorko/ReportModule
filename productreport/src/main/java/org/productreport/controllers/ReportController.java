package org.productreport.controllers;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.productreport.service.ReportService;
import org.productreport.service.WordReportStrategy;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.ByteArrayOutputStream;
import java.util.Map;

@RestController
@RequestMapping("/api/report")
public class ReportController {

    private final Map<String, WordReportStrategy> strategies;

    public ReportController(Map<String, WordReportStrategy> strategies) {
        this.strategies = strategies;
    }

    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadReport(
            @RequestParam String template,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Boolean isImport) throws Exception {

        WordReportStrategy strategy = strategies.get(template);
        if (strategy == null)
            throw new IllegalArgumentException("Неизвестный шаблон: " + template);

        ByteArrayOutputStream reportBytes = strategy.generateReport(name, type, isImport);

        return buildResponse(reportBytes, "report_" + template + ".docx");
    }

    private ResponseEntity<byte[]> buildResponse(ByteArrayOutputStream reportBytes, String filename) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", filename);

        return ResponseEntity.ok().headers(headers).body(reportBytes.toByteArray());
    }
}