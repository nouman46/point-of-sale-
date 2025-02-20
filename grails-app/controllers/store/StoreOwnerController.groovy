package store

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.mindrot.jbcrypt.BCrypt

class StoreOwnerController {
    StoreOwnerService storeOwnerService
//    def passwordEncoder = new BCryptPasswordEncoder()

    def index() { }

    def register() {
        if (request.method == 'POST') {
            def storeOwner = new StoreOwner(params)
            String hashedPassword = BCrypt.hashpw(params.password,BCrypt.gensalt())

            def appUser = new AppUser(username: params.username, password: hashedPassword, isAdmin: true, createdBy: params.username)

            // Assuming subscriptionPlanId is sent from the form
            def plan = SubscriptionPlan.get(params.long('subscriptionPlanId'))
            if (plan) {
                Calendar calendar = Calendar.getInstance()
                Date startDate = calendar.getTime()

                // Assuming billingCycle is in months for this example
                calendar.add(Calendar.MONTH, plan.billingCycle)
                Date endDate = calendar.getTime()
                def userSubscription = new UserSubscription(user: appUser, plan: plan, startDate:startDate, endDate: endDate)
                appUser.activeSubscription = userSubscription
            }

            storeOwner.appUser = appUser

            if (!storeOwnerService.saveStoreOwner(storeOwner)) {
                storeOwner.errors.allErrors.each {
                    flash.message = it.defaultMessage
                }
                render(view: "register", model:[storeOwner: new StoreOwner(), subscriptionPlans: SubscriptionPlan.list()])
                return
            }
            flash.message = "Registration successful"
            redirect(controller: "auth", action: "login")
        } else {
            def plans = SubscriptionPlan.list()
            plans.each { plan ->
                println "Plan ID: ${plan.id}, Name: ${plan.name}"
            }
            render(view: "register", model:[storeOwner: new StoreOwner(), subscriptionPlans: SubscriptionPlan.list()])
            println("Subscription plans: ${SubscriptionPlan.list()}")
        }
    }
}