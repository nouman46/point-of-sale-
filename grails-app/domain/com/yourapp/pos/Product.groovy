package com.yourapp.pos

// this is a test comment from sidra
// this is a test comment from niuman

class Product {
    String name
    String description
    BigDecimal price
    Integer stockQuantity
    Date dateAdded = new Date()

    static constraints = {
        name blank: false, unique: true
        description nullable: true, maxSize: 500
        price min: 0.0, scale: 2
        stockQuantity min: 0
    }
}
