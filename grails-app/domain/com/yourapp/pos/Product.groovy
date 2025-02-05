package com.yourapp.pos


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
