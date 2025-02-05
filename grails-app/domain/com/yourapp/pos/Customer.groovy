package com.yourapp.pos

class Customer {

    String productName
    String productDescription
    String productBarcode
    BigDecimal productPrice
    Integer productQuantity

        static constraints = {
            productName blank: false, maxSize: 255
            productDescription nullable: true, maxSize: 500
            productSKU blank: false, unique: true, maxSize: 50
            productBarcode blank: false, unique: true, maxSize: 50
            productPrice min: 0.01, scale: 2
        }
    }
