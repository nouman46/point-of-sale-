package store

class Permission {
    String pageName  // e.g., "inventory", "sales", "checkout"
    Boolean canView = false
    Boolean canEdit = false
    Boolean canDelete = false

    static belongsTo = [role: Role]

    static constraints = {
        pageName blank: false
    }
    static mapping = {
        version false  // Disable optimistic locking
    }
}
