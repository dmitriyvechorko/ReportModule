package org.productreport.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "DTO для передачи данных о продукте")
public class ProductResponseDTO {
    @Schema(description = "Уникальный идентификатор продукта")
    private Long id;
    @Schema(description = "Наименование продукта")
    private String productName;
    @Schema(description = "Наименование типа продукции")
    private String productionType;
    @Schema(description = "Указывает на принадлежность продукта к перечню импортозамещающей продукции")
    private Boolean isImport;
    @Schema(description = "Наименование организации производящей продукт")
    private String enterpriseName;
    @Schema(description = "Адрес организации производящей продукт")
    private String enterpriseAddress;
}