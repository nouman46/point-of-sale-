package com.yourapp.pos

class Customer {

        String cname
        String pname
        String pdescription
        BigDecimal price
        BigDecimal totalprice
        Integer quantity
        Date dateAdded = new Date()

        static constraints = {
            cname blank: false, unique: true
            pname blank: false, unique: true
            pdescription nullable: true, maxSize: 500
            price min: 0.0, scale: 2
            totalprice min: 0.0, scale: 2
            quantity min: 0
        }
    }
