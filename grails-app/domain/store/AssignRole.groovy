package store

class AssignRole {
    String roleName
    Long createdBy  // Add this field to track the creator

    static hasMany = [users: AppUser, permissions: Permission]
    static mappedBy = [users: "assignRole", permissions: "assignRole"]

    static constraints = {
        roleName unique: true, blank: false
        createdBy nullable: true  // Allow nullable for flexibility (e.g., system-created roles)
    }

    static mapping = {
        version false
        createdBy column: 'created_by_id'  // Map to a specific column
    }
}