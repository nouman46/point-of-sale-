package store

class OrderItem {
    Order order
    Product product
    Integer quantity
    BigDecimal subtotal

    static belongsTo = [order: Order, product: Product] // ✅ Added product reference

    static constraints = {
        quantity nullable: false, min: 1
        subtotal nullable: false, min: 0.0G // ✅ Fix constraint
    }
}
