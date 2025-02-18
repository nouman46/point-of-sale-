package store

class AppUser {
    String username
    String password
    Boolean isAdmin = false
    AppUser createdBy  // Stores the admin who created the user

    static hasMany = [assignRole: AssignRole]
    static belongsTo = AssignRole

    static constraints = {
        username unique: true, blank: false
        password blank: false
        createdBy nullable: true // Can be null for the super admin
    }

    static mapping = {
        version false
        assignRoles joinTable: [name: "app_user_assign_role", key: "app_user_id", column: "assign_role_id"]
    }
}
