package store

class BootStrap {

    def init = { servletContext ->
        SubscriptionPlan.withTransaction { status ->
            try {
                // Subscription Plans
                if (!SubscriptionPlan.findByName("Basic")) {
                    new SubscriptionPlan(name: "Basic",
                            description: "Access to basic store management tools",
                            price: 9.99,
                            billingCycle: 1,
                            features: ["inventory"] as Set).save(failOnError: true)
                }

                if (!SubscriptionPlan.findByName("Pro")) {
                    new SubscriptionPlan(name: "Pro",
                            description: "Advanced features for growing stores",
                            price: 29.99,
                            billingCycle: 1,
                            features: ["inventory", "reports", "discounts"] as Set).save(failOnError: true)
                }

                if (!SubscriptionPlan.findByName("Enterprise")) {
                    new SubscriptionPlan(name: "Enterprise",
                            description: "Comprehensive tools for large scale businesses",
                            price: 299.99,
                            billingCycle: 12,
                            features: ["inventory", "reports", "discounts", "multi-store management"] as Set).save(failOnError: true)
                }

                // Admin User Setup
                def adminUser = AppUser.findByUsername("admin")
                if (!adminUser) {
                    adminUser = new AppUser(username: "admin", password: "password", isAdmin: true).save(failOnError: true)

                    // Create or fetch the 'Basic' plan
                    def basicPlan = SubscriptionPlan.findByName("Basic")

                    // Set up a subscription for the admin user with the Basic plan
                    if (basicPlan) {
                        def adminSubscription = new UserSubscription(user: adminUser,
                                plan: basicPlan,
                                startDate: new Date(),
                                endDate: calculateEndDate(new Date(), 365))
                        adminSubscription.save(failOnError: true)
                        adminUser.activeSubscription = adminSubscription
                        adminUser.save(failOnError: true)
                    } else {
                        println "Basic plan not found, admin user subscription not set."
                    }

                    // Assign role to admin
                    def adminRole = AssignRole.findByRoleName("ADMIN")
                    if (!adminRole) {
                        adminRole = new AssignRole(roleName: "ADMIN").save(failOnError: true)
                    }
                    adminUser.addToAssignRole(adminRole)
                    adminUser.save(failOnError: true)
                }

                println "Admin user and subscription plans initialized"
            } catch (Exception e) {
                status.setRollbackOnly()
                println "An error occurred while initializing subscription plans and admin: ${e.message}"
            }
        }
    }

    private static Date calculateEndDate(Date startDate, int daysToAdd) {
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(startDate)
        calendar.add(Calendar.DATE, daysToAdd)
        return calendar.getTime()
    }

    def destroy = {}
}