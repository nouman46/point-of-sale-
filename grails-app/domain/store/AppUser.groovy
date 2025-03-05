package store

class AppUser {
    String username
    String password
    Boolean isAdmin = false
    Boolean isSystemAdmin = false
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

    Integer getRemainingDays() {
        if (activeSubscription && activeSubscription.endDate) {
            // Prepare today's date
            def todayCal = Calendar.getInstance()
            todayCal.setTime(new Date())
            todayCal.set(Calendar.HOUR_OF_DAY, 0)
            todayCal.set(Calendar.MINUTE, 0)
            todayCal.set(Calendar.SECOND, 0)
            todayCal.set(Calendar.MILLISECOND, 0)
            def today = todayCal.getTime()

            // Prepare end date
            def endCal = Calendar.getInstance()
            endCal.setTime(activeSubscription.endDate)
            endCal.set(Calendar.HOUR_OF_DAY, 0)
            endCal.set(Calendar.MINUTE, 0)
            endCal.set(Calendar.SECOND, 0)
            endCal.set(Calendar.MILLISECOND, 0)
            def endDate = endCal.getTime()

            // Calculate difference in days
            long diff = endDate.time - today.time
            long days = diff / (1000 * 60 * 60 * 24)
            return days as Integer
        }
        return null
    }
}