package store

class Permission {
    String pageName
    Boolean canView = false
    Boolean canEdit = false
    Boolean canDelete = false

    static belongsTo = [assignRole: AssignRole]  // Ensure correct association

    static constraints = {
        pageName blank: false
    }

    static mapping = {
        version false
        assignRole column: "assign_role_id"  // Ensure correct FK mapping
    }
}
