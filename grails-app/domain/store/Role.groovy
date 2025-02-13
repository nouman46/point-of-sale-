package store

class Role {
    String roleName // e.g., "Admin", "Cashier", "Accountant"

    static hasMany = [permissions: Permission, users: AppUser]

    static constraints = {
        roleName unique: true, blank: false
    }
    static mapping = {
        version false  // Disable optimistic locking
    }
}
