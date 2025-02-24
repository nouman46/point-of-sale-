package store

class UserSubscription {
    AppUser user
    SubscriptionPlan plan
    Date startDate
    Date endDate
    Boolean isActive = true


    static constraints = {
        user(unique: 'isActive') // Only one active subscription per user
        plan(nullable: false)
        startDate(nullable: false)
        endDate(nullable: false)

    }
}
