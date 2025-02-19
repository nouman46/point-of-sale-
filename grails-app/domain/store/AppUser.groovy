package store

class AppUser {
    String username
    String password
    Boolean isAdmin = false
    AppUser createdBy  // Stores the admin who created the user
    UserSubscription activeSubscription

    static hasMany = [assignRole: AssignRole]
    static belongsTo = AssignRole

    static constraints = {
        username unique: true, blank: false
        password blank: false
        activeSubscription(nullable: true)
    }

    static mapping = {
        version false
        assignRoles joinTable: [name: "app_user_assign_role", key: "app_user_id", column: "assign_role_id"]
    }
}