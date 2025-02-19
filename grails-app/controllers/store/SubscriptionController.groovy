package store

import grails.gorm.transactions.Transactional

class SubscriptionController {
    def subscriptionService
    def springSecurityService

    def index() {
        if (!hasAdminAccess()) {
            render status: 403
            return
        }

        def user = AppUser.get(springSecurityService.principal.id)
        def currentSubscription = UserSubscription.findByUserAndIsActive(user, true)
        def plans = SubscriptionPlan.list()

        [plans: plans, currentSubscription: currentSubscription]

//        plans.each { plan ->
//            plan.features = plan.features.collect { feature ->
//                feature.replaceAll(/([A-Z])/) { match -> " " + match.toLowerCase() }
//            }
//        }
//        render(view: "index", model:[plans: plans, currentSubscription: session.user?.activeSubscription])

    }

    @Transactional
    def subscribe(Long planId) {
        if (!hasAdminAccess()) {
            render status: 403
            return
        }

        def user = AppUser.get(springSecurityService.principal.id)
        def planID = params.long('planId')
        def plan = SubscriptionPlan.get(planID)

        if (!plan) {
            flash.message = "Plan not found."
            redirect(action: "index")
            return
        }

        // Deactivate current subscription if exists
        def currentSubscription = UserSubscription.findByUserAndIsActive(user, true)
        if (currentSubscription) {
            currentSubscription.isActive = false
            currentSubscription.save(flush: true)
        }

        // Create new subscription
        def newSubscription = new UserSubscription(
                user: user,
                plan: plan,
                startDate: new Date(),
                endDate: calculateEndDate(plan.billingCycle)
        )

        if (newSubscription.save(flush: true)) {
            flash.message = "Successfully subscribed to ${plan.name}"
        } else {
            flash.message = "Failed to subscribe: ${newSubscription.errors}"
        }

        redirect(action: "index")

//        def sessionUser = session.user
//        if (!sessionUser) {
//            flash.message = "Login required."
//            redirect(controller: "auth", action: "login")
//            return
//        }
//
//        def plan = SubscriptionPlan.get(planId)
//        if (!plan) {
//            flash.message = "Plan not found."
//            redirect(action: "index")
//            return
//        }
//
//        UserSubscription.withTransaction { status ->
//            try {
//                // Deactivate old subscription
//                UserSubscription.where { user == sessionUser && isActive == true }.updateAll(isActive: false)
//                println("Deactivated old subscription for ${sessionUser.username}")
//
//                // Create new subscription
//                def newSub = new UserSubscription(
//                        plan: plan,
//                        startDate: new Date(),
//                        endDate: subscriptionService.calculateEndDate(plan.billingCycle),
//                        isActive: true,
//                        user: sessionUser // Use sessionUser here
//                )
//                println("Creating new subscription for ${sessionUser.username}")
//
//                if (newSub.save(flush:true)) { // Flush here after saving newSub
//                    sessionUser.activeSubscription = newSub // Update sessionUser object
//                    sessionUser.save(flush: true) // Save sessionUser object again
//                    session.user = AppUser.get(sessionUser.id) // Refresh session user just to be sure
//                    flash.message = "Subscribed to ${plan.name}!"
//                    println("Subscription successful for ${sessionUser.username}")
//                } else {
//                    flash.message = "Subscription failed: ${newSub.errors}"
//                    status.setRollbackOnly() // Rollback the transaction if saving fails
//                    println("Subscription failed for ${sessionUser.username}")
//                }
//            } catch (Exception e) {
//                status.setRollbackOnly() // Rollback the transaction in case of any exception
//                flash.message = "An error occurred: ${e.message}"
//                println("Error in subscription: ${e.message}")
//            }
//        }
//        redirect(action: "index")
    }
    private static Date calculateEndDate(int billingCycle) {
        Calendar cal = Calendar.instance
        cal.add(Calendar.MONTH, billingCycle)
        return cal.time
    }

    private boolean hasAdminAccess() {
        def user = AppUser.get(springSecurityService.principal.id)
        user?.isAdmin
    }
}
