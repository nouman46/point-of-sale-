package store

class Permission {
    String pageName
    Boolean canView = false
    Boolean canEdit = false
    Boolean canDelete = false
    Long createdBy  // Add this field to track the creator

    static belongsTo = [assignRole: AssignRole]  // Ensure correct association

    static constraints = {
        pageName blank: false
        createdBy nullable: true  // Allow nullable for flexibility
    }

    static mapping = {
        version false
        assignRole column: "assign_role_id"  // Ensure correct FK mapping

        createdBy column: 'created_by_id'    // Map to a specific column
    }
}