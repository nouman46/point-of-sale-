package store

class SubscriptionPlan {
    String name
    String description
    BigDecimal price
    Integer billingCycle // 1=Monthly, 12=Yearly
    Set<String> features // Features enabled in this plan (e.g., ["inventory", "reports"])


    static constraints = {
        name(blank: false, unique: true)
        description(nullable: true)
        price(min: 0.0)
        billingCycle(min: 1)
        features(nullable: false)

    }

    static mapping = {
        features joinTable: [name: "subscription_plan_features", column: "feature"], fetch: "join"
    }
}
