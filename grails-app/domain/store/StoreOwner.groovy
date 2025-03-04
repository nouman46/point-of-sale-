package store

class StoreOwner {
    String email
    String storeName
    AppUser appUser
    byte[] logo
    String logoContentType

    static constraints = {
        email email: true, blank: false, unique: true
        storeName blank: false
        appUser(nullable: false)
        logo nullable: true, maxSize: 1024 * 1024 * 5 // Max 5MB
        logoContentType nullable: true
    }
}