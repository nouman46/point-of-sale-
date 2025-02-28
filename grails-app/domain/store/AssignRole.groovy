package store

class AssignRole {
    String roleName
    Long createdBy  // ID of the admin who created this role

    static hasMany = [users: AppUser, permissions: Permission]
    static mappedBy = [users: "assignRole", permissions: "assignRole"]

    static constraints = {
        roleName blank: false, unique: ['createdBy'], maxSize: 50
        createdBy nullable: true  // Allow nullable for flexibility (e.g., system-created roles)
    }

    static mapping = {
        version false
        createdBy column: 'created_by_id'  // Map to a specific column
    }
}