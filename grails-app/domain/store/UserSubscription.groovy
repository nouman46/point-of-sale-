package store

class UserSubscription {
    AppUser user
    SubscriptionPlan plan
    Date startDate
    Date endDate
    Boolean isActive = true


    static constraints = {
        user validator: { val, obj ->
            if (obj.isActive) {
                // Check if another active subscription exists for this user
                def existingActive = UserSubscription.findByUserAndIsActive(val, true)
                if (existingActive && existingActive.id != obj.id) {
                    return ['userSubscription.user.isActive.unique'] // Error code for validation failure
                }
            }
            true // Return true if validation passes
        }
        plan(nullable: false)
        startDate(nullable: false)
        endDate(nullable: false)

    }
}
