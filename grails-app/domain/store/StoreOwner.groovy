package store

import org.mindrot.jbcrypt.BCrypt

class StoreOwner {
    String username
    String passwordHash
    String email
    String storeName

    static constraints = {
        username blank: false, unique: true
        passwordHash blank: false
        email email: true, blank: false, unique: true
        storeName blank: false
    }

    static mapping = {
        passwordHash column: 'passwordHash' // or 'password_hash' if that's how it's named in your database
    }

    // Before the object is inserted into the database
    def beforeInsert() {
    }

    // Before the object is updated in the database
    def beforeUpdate() {
    }

//    protected void encodePassword() {
//        passwordHash = BCrypt.hashpw(params.password, BCrypt.gensalt())
//    }

    // Method to check if the provided password matches the stored hash
    boolean checkPassword(String plainPassword) {
        return BCrypt.checkpw(plainPassword, passwordHash)
    }
}