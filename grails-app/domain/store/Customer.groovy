package store

class Customer {
    String customerName
    String productName
    String productDescription
    String productBarcode
    BigDecimal productPrice
    BigDecimal totalPrice
    Integer productQuantity

        static constraints = {
            customerName blank: false, maxSize: 255
            productName blank: false, maxSize: 255
            productDescription nullable: true, maxSize: 500
            productBarcode blank: false, unique: true, maxSize: 50
            productPrice min: 0.01, scale: 2
        }
    }
