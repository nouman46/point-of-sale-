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
    AppUser createdBy      // Linking product to the admin who created it

    static belongsTo = [createdBy: AppUser, admin: AppUser]

    static constraints = {
        productName blank: false, nullable: false, maxSize: 100, unique: ['createdBy']
        productDescription blank: false, nullable: false, maxSize: 500
        productSKU blank: false, nullable: false, maxSize: 50, unique: ['createdBy']
        productBarcode blank: false, nullable: false, maxSize: 50
        productPrice nullable: false, scale: 2, min: 0.01
        productQuantity nullable: false, min: 0
        createdBy nullable: false  // Ensure creator is always recorded
    }

    static mapping = {
        createdBy column: 'created_by_id'
        version false  // Disable optimistic locking to fix 'Invalid column name version' error
    }
}