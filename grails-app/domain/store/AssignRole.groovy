package store

class AssignRole {
    String roleName

    static hasMany = [users: AppUser, permissions: Permission]
    static mappedBy = [users: "assignRole", permissions: "assignRole"]

    static constraints = {
        roleName unique: true, blank: false
    }

    static mapping = {
        version false
        permissions cascade: "all-delete-orphan"  // Ensure cascading updates
    }
}
