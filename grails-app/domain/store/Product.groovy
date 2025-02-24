
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
        productName blank: false, maxSize: 255
        productDescription nullable: true, maxSize: 500
        productSKU blank: false, unique: true, maxSize: 50
        productBarcode blank: false, unique: true, maxSize: 50
        productPrice min: 0.01, scale: 2
        productQuantity min: 0
        createdBy nullable: false  // Ensure creator is always recorded
    }
    static mapping = {
        createdBy column: 'created_by_id'
        version false  // Disable optimistic locking to fix 'Invalid column name version' error
    }
}
