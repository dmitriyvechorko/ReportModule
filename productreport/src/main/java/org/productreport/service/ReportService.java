package org.productreport.service;

import lombok.AllArgsConstructor;
import org.apache.poi.xwpf.usermodel.*;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTblWidth;
import org.productreport.dto.ProductResponseDTO;
import org.productreport.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.math.BigInteger;
import java.util.List;

@Service
@AllArgsConstructor
public class ReportService {

    private final ProductRepository productRepository;


    public ByteArrayOutputStream generateWordReport1(String name, String type, Boolean isImport) throws Exception {
        List<ProductResponseDTO> products = productRepository.findFilteredProducts(name, type, isImport);

        XWPFDocument document = new XWPFDocument();

        // === Заголовок ===
        XWPFParagraph title = document.createParagraph();
        title.setAlignment(ParagraphAlignment.CENTER);
        XWPFRun titleRun = title.createRun();
        titleRun.setBold(true);
        titleRun.setFontSize(16);
        titleRun.setText("ОТЧЁТ");

        XWPFParagraph subtitle2 = document.createParagraph();
        subtitle2.setAlignment(ParagraphAlignment.CENTER);
        XWPFRun run2 = subtitle2.createRun();
        run2.setFontSize(12);
        run2.setText("Информация о продукции:");

        // === Таблица ===
        XWPFTable table = document.createTable();
        table.setWidth("100%");

        // Заголовки таблицы
        XWPFTableRow headerRow = table.getRow(0);
        String[] headers = {"№", "Наименование продукта", "Тип продукции", "Наименование организации", "Адрес организации"};
        for (int i = 0; i < headers.length; i++) {
            if (i >= headerRow.getTableCells().size()) {
                headerRow.createCell();
            }
            XWPFTableCell cell = headerRow.getCell(i);
            if (cell != null) {
                cell.setText(headers[i]);
                cell.setColor("D3D3D3"); // серый фон заголовка
            }
        }

        int num = 1;
        for (ProductResponseDTO product : products) {
            XWPFTableRow row = table.createRow();
            row.getCell(0).setText(String.valueOf(num++));
            row.getCell(1).setText(product.getProductName());
            row.getCell(2).setText(product.getProductionType());
            row.getCell(3).setText(product.getEnterpriseName());
            row.getCell(4).setText(product.getEnterpriseAddress());
        }

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        document.write(byteArrayOutputStream);
        document.close();

        return byteArrayOutputStream;
    }

    public ByteArrayOutputStream generateWordReport2(String name, String type, Boolean isImport) throws Exception {
        List<ProductResponseDTO> products = productRepository.findFilteredProducts(name, type, isImport);

        XWPFDocument document = new XWPFDocument();

        // === Заголовок ===
        XWPFParagraph title = document.createParagraph();
        title.setAlignment(ParagraphAlignment.CENTER);
        XWPFRun titleRun = title.createRun();
        titleRun.setBold(true);
        titleRun.setFontSize(16);
        titleRun.setText("ОТЧЁТ");

        // === Таблица ===
        XWPFTable table = document.createTable();

        int totalWidthDXA = 8000;

        // Установка ширины таблицы
        CTTblPr tableProperties = table.getCTTbl().addNewTblPr();
        CTTblWidth tableWidth = tableProperties.addNewTblW();
        tableWidth.setW(BigInteger.valueOf(totalWidthDXA));
        tableWidth.setType(STTblWidth.DXA);

        // Проценты для каждого столбца
        double[] columnPercents = {5.0, 20.0, 15.0, 22.0, 30.0, 8.0};

        // Заголовки таблицы
        String[] headers = {"№", "Наименование продукта", "Тип продукции", "Наименование организации", "Адрес организации", "Является импортозамещающей"};
        XWPFTableRow headerRow = table.getRow(0);

        for (int i = 0; i < headers.length; i++) {
            if (i >= headerRow.getTableCells().size()) {
                headerRow.createCell();
            }
            XWPFTableCell cell = headerRow.getCell(i);
            if (cell != null) {
                cell.setText(headers[i]);
                cell.setColor("D3D3D3");

                // Вычисление ширины в DXA
                int cellWidthDXA = (int) Math.round(totalWidthDXA * columnPercents[i] / 100.0);

                CTTcPr tcPr = cell.getCTTc().addNewTcPr();
                CTTblWidth cellWidth = tcPr.addNewTcW();
                cellWidth.setType(STTblWidth.DXA);
                cellWidth.setW(BigInteger.valueOf(cellWidthDXA));
            }
        }

        int num = 1;
        for (ProductResponseDTO product : products) {
            XWPFTableRow row = table.createRow();
            row.getCell(0).setText(String.valueOf(num++));
            row.getCell(1).setText(product.getProductName());
            row.getCell(2).setText(product.getProductionType());
            row.getCell(3).setText(product.getEnterpriseName());
            row.getCell(4).setText(product.getEnterpriseAddress());
            row.getCell(5).setText(product.getIsImport() ? "Да" : "Нет");
        }

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        document.write(byteArrayOutputStream);
        document.close();

        return byteArrayOutputStream;
    }
}