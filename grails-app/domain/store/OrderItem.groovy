package store

class OrderItem {
    Order order
    Product product
    Integer quantity
    BigDecimal subtotal
    AppUser createdBy  // NEW FIELD to track the creator


    static belongsTo = [order: Order, product: Product, createdBy: AppUser]  // Combine all associations into one

    static constraints = {
        quantity nullable: false, min: 1
        subtotal nullable: false, min: 0.0G
        createdBy nullable: false  // Ensure creator is always recorded

    }

    static mapping = {
        createdBy column: 'created_by_id'  // Map 'createdBy' to 'created_by_id' column
    }
}
