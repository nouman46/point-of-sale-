package store

class AppUser {
    String username
    String password
    Boolean isAdmin = false
    UserSubscription activeSubscription
    AppUser createdBy

    static hasMany = [assignRole: AssignRole]
    static belongsTo = AssignRole

    static constraints = {
        username blank: false, unique: ['createdBy'], matches: /^[a-zA-Z0-9_]+$/, maxSize: 50
        password blank: false
        activeSubscription nullable: true
        createdBy nullable: true
    }

    static mapping = {
        version false
        createdBy column: 'created_by_id'
        assignRoles joinTable: [name: "app_user_assign_role", key: "app_user_id", column: "assign_role_id"]
    }
}