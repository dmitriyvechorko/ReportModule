package org.productreport.service;

import org.productreport.dto.ProductResponseDTO;
import org.productreport.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductResponseDTO> getFilteredProducts(String name, String type, Boolean isImport) {
        return productRepository.findFilteredProducts(name, type, isImport);
    }
}