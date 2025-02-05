package store

class Product {
    String productName
    String productDescription
    String productSKU
    String productBarcode
    BigDecimal productPrice
    Integer productQuantity
    Date dateCreated
    Date lastUpdated

    static constraints = {
        productName blank: false, maxSize: 255
        productDescription nullable: true, maxSize: 500
        productSKU blank: false, unique: true, maxSize: 50
        productBarcode blank: false, unique: true, maxSize: 50
        productPrice min: 0.01, scale: 2
        productQuantity min: 1
    }
}


