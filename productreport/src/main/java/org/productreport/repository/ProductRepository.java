package org.productreport.repository;

import org.productreport.dto.ProductResponseDTO;
import org.productreport.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
    @Query("SELECT new org.productreport.dto.ProductResponseDTO(" +
            "p.id, p.productName, pt.productionType, p.isImport, e.name, e.address) " +
            "FROM Product p " +
            "JOIN p.productionType pt " +
            "LEFT JOIN p.enterprise e " +    // <-- правильно: p.enterprise, а не p.enterpriseList
            "WHERE (:name IS NULL OR p.productName ILIKE %:name%) " +
            "AND (:type IS NULL OR pt.productionType ILIKE %:type%) " +
            "AND (:isImport IS NULL OR p.isImport = :isImport)")
    List<ProductResponseDTO> findFilteredProducts(
            @Param("name") String name,
            @Param("type") String type,
            @Param("isImport") Boolean isImport
    );
}