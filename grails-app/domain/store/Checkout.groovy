package store

import groovy.json.JsonSlurper
import groovy.json.JsonBuilder

class Checkout {
    String customerName
    String status // e.g., 'pending', 'completed'
    BigDecimal totalAmount


    static constraints = {
        customerName blank: false, maxSize: 255
        status blank: false, maxSize: 50
        totalAmount min: 0.00

    }


}
