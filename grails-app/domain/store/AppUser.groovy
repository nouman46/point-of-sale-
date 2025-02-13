package store

class AppUser {
    String username
    String password  // Store hashed passwords
    Boolean isAdmin = false

    static hasMany = [roles: Role]

    static constraints = {
        username unique: true, blank: false
        password blank: false
    }
    static mapping = {
        version false  // Disable optimistic locking
    }
}
