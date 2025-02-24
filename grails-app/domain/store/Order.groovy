package store

class Order {
    String customerName
    BigDecimal totalAmount = 0.0G
    Date dateCreated
    AppUser createdBy  // NEW FIELD to track the creator

    static belongsTo = [createdBy: AppUser]

    static hasMany = [orderItems: OrderItem]

    static mapping = {
        table "orders"  // Renamed table to 'orders'
        createdBy column: 'created_by_id'  // Map 'createdBy' to 'created_by_id' column
    }

    static constraints = {
        customerName nullable: false, blank: false
        totalAmount nullable: false, min: 0.0G
        createdBy nullable: false  // Ensure creator is always recorded
    }
}
