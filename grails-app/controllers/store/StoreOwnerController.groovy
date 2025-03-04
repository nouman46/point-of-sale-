package store

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class StoreOwnerController {
    def registrationService

    @Transactional
    def register(StoreOwnerRegistrationCommand cmd) {
        if (request.method == 'POST') {
            def logoFile = request.getFile('logo')
            if (cmd.validate()) {
                def result = registrationService.registerStoreOwner(cmd, logoFile)
                if (!result.success) {
                    render(view: "register", model: [cmd: cmd, subscriptionPlans: SubscriptionPlan.list(), errors: result.errors])
                    return
                }
                flash.message = "Registration successful"
                redirect(controller: "auth", action: "login")
            } else {
                flash.message = cmd.errors.allErrors.collect { message(error: it) }.join(", ")
                render(view: "register", model: [cmd: cmd, subscriptionPlans: SubscriptionPlan.list()])
            }
        } else {
            def planId = params.long('planId') ?: 1L // Default to Basic plan (ID 1)
            def initialCmd = new StoreOwnerRegistrationCommand(subscriptionPlanId: planId)
            render(view: "register", model: [cmd: initialCmd, subscriptionPlans: SubscriptionPlan.list()])
        }
    }
}