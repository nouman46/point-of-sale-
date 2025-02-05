package com.yourapp.pos


class Product {
    String pname
    String pdescription
    BigDecimal price
    Integer stockQuantity
    Date dateAdded = new Date()

    static constraints = {
        pname blank: false, unique: true
        pdescription nullable: true, maxSize: 500
        price min: 0.0, scale: 2
        stockQuantity min: 0
    }
}
