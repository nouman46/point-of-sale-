package store

class Role {
    String name

    static constraints = {
        name unique: true, nullable: false
    }

    static mapping = {
        table 'role'  // Ensure correct table mapping
        version false // ✅ Ensure Grails does not use a version column
    }

}
