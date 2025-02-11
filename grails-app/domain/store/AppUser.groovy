package store

class AppUser {
    String username
    String password
    String allowedPages

    static constraints = {
        username unique: true, nullable: false
        password nullable: false
        allowedPages nullable: true
    }

    static mapping = {
        table 'app_user'  // ✅ Ensure correct table name
        version false  // ✅ Disable version column
    }
}
