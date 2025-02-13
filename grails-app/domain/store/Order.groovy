package store

class Order {
    String customerName
    BigDecimal totalAmount = 0.0G
    Date dateCreated

    static hasMany = [orderItems: OrderItem]
    static mapping = {
        table "orders"  // ✅ Rename the table to 'orders'
    }
    static constraints = {
        customerName nullable: false, blank: false
        totalAmount nullable: false, min: 0.0G
    }
}
