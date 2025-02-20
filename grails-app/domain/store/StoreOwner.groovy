package store

import org.mindrot.jbcrypt.BCrypt

class StoreOwner {
    String username
    String password
    String email
    String storeName
    AppUser appUser

    static constraints = {
        username blank: false, unique: true
        password blank: false
        email email: true, blank: false, unique: true
        storeName blank: false
        appUser(nullable: false)
    }

    // Method to set the password hash
//    void setPasswordHash(String plainPassword) {
//        password = BCrypt.hashpw(plainPassword, BCrypt.gensalt())
//    }
//
//    // Method to check if the provided password matches the stored hash
//    boolean checkPassword(String plainPassword) {
//        return BCrypt.checkpw(plainPassword, passwordHash)
//    }
}