package store

class Customer {
    String customerName
    BigDecimal totalPrice = 0.0

    static hasMany = [purchasedItems: PurchasedItem]

    static constraints = {
        customerName blank: false, maxSize: 255
        totalPrice min: 0.0, scale: 2
    }

    // Calculate total price from all purchased items
    BigDecimal calculateTotalPrice() {
        totalPrice = purchasedItems?.collect { it.totalItemPrice }?.sum() ?: 0.0
        totalPrice
    }
}
