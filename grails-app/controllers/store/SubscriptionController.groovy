package store

import grails.gorm.transactions.Transactional

class SubscriptionController {

    def index() {
        if (!hasAdminAccess()) {
            render status: 403
            return
        }

        def user = session.user
        def currentSubscription = UserSubscription.findByUserAndIsActive(user, true)
        def plans = SubscriptionPlan.list()

        [plans: plans, currentSubscription: currentSubscription]

    }

    @Transactional
    def subscribe(Long planId) {
        if (!hasAdminAccess()) {
            render status: 403
            return
        }

        def user = session.user
        def plan = SubscriptionPlan.get(planId)

        if (!plan) {
            flash.message = "Plan not found."
            redirect(action: "index")
            return
        }

        UserSubscription.withTransaction { status ->
            try {
                // Deactivate current subscription if exists
                def currentSubscription = UserSubscription.findByUserAndIsActive(user, true)
                println("Current subscription: $currentSubscription")

                if (currentSubscription) {
                    currentSubscription.isActive = false
                    if (!currentSubscription.save(flush: true)) {
                        println("Failed to deactivate current subscription: ${currentSubscription.errors}")
                        throw new RuntimeException("Failed to deactivate current subscription: ${currentSubscription.errors}")
                    }
                }
                UserSubscription.findAllByUserAndIsActive(user, true).each { sub ->
                    sub.isActive = false
                    if (!sub.save(flush: true)) {
                        throw new RuntimeException("Failed to deactivate subscription: ${sub.errors}")
                    }
                }
                println("Deactivated current subscription: $currentSubscription")


                // Create new subscription
                def newSubscription = new UserSubscription(
                        user: user,
                        plan: plan,
                        startDate: new Date(),
                        endDate: calculateEndDate(plan.billingCycle))

                if (!newSubscription.save(flush: true)) {
                    throw new RuntimeException("Failed to save new subscription: ${newSubscription.errors}")
                }
                println("New subscription: $newSubscription")

                def userFromDB = AppUser.get(user.id)
                println("User from DB: $userFromDB")
                userFromDB.activeSubscription = newSubscription
                if (!userFromDB.save(flush: true)) {
                    println("User save failed: ${userFromDB.errors}")
                }
                println("User after save: $user")

                println("Successfully subscribed to ${plan.name}")
                flash.message = "Successfully subscribed to ${plan.name}"

            } catch (Exception e) {
                status.setRollbackOnly()
                println("Failed to subscribe: ${e.message}")
                flash.message = "Failed to subscribe: ${e.message}"
            }

        }
        redirect(action: "index")
    }

    private static Date calculateEndDate(int billingCycle) {
        Calendar cal = Calendar.instance
        cal.add(Calendar.MONTH, billingCycle)
        return cal.time
    }

    private boolean hasAdminAccess() {
        def user = session.user
        return user?.isAdmin ?: false
    }
}
