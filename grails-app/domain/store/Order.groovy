package store

class Order {
    String customerName
    BigDecimal totalAmount = 0.0G
    BigDecimal amountReceived = 0.0G
    BigDecimal remainingAmount = 0.0G
    Date dateCreated
    AppUser createdBy

    static belongsTo = [createdBy: AppUser]
    static hasMany = [orderItems: OrderItem]

    static mapping = {
        table "orders"
        createdBy column: 'created_by_id'
    }

    static constraints = {
        customerName nullable: false, blank: false
        totalAmount nullable: false, min: 0.0G
        amountReceived nullable: false, min: 0.0G
        remainingAmount nullable: false
        createdBy nullable: false
    }
}