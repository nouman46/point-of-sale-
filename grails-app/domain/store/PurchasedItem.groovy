package store

class PurchasedItem {
    String productName
    String productDescription
    String productSKU
    String productBarcode
    BigDecimal productPrice
    Integer quantity

    static belongsTo = [customer: Customer]

    static constraints = {
        productName blank: false, maxSize: 255
        productDescription nullable: true, maxSize: 500
        productSKU blank: false, maxSize: 50
        productBarcode blank: false, maxSize: 50
        productPrice min: 0.01, scale: 2
        quantity min: 1
    }

    // Returns the total for this purchased item
    BigDecimal getTotalItemPrice() {
        productPrice * quantity
    }
}
