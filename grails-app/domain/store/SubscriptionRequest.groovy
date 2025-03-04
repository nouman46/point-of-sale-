package store

class SubscriptionRequest {
    AppUser user
    SubscriptionPlan plan
    Date requestDate = new Date()
    String status = "pending" // Possible values: pending, approved, rejected
    AppUser approvedBy
    Date approvalDate

    static constraints = {
        user(nullable: false)
        plan(nullable: false)
        status(inList: ["pending", "approved", "rejected"])
        approvedBy(nullable: true)
        approvalDate(nullable: true)
    }
}