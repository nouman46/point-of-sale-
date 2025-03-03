package store

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class StoreOwnerController {
    def registrationService

    @Transactional
    def register(StoreOwnerRegistrationCommand cmd) {
        if (request.method == 'POST') {
            if (cmd.validate()) {
                def logoFile = request.getFile('logo')
                def result = registrationService.registerStoreOwner(cmd, logoFile)
                if (result.errors) {
                    render(view: "register", model: [cmd: cmd, subscriptionPlans: SubscriptionPlan.list()])
                    return
                }

                flash.message = "Registration successful"
                redirect(controller: "auth", action: "login")
            } else {
                render(view: "register", model: [cmd: cmd, subscriptionPlans: SubscriptionPlan.list()])
            }

//            def appUser = new AppUser(username: params.username,
//                    password: passwordEncoder.encode(params.password),
//                    isAdmin: true)
//
//            def storeOwner = new StoreOwner(username: params.username,
//                    email: params.email,
//                    storeName: params.storeName,
//                    appUser: appUser)
//
//            def logoFile = request.getFile('logo')
//            if (logoFile && !logoFile.isEmpty()) {
//                storeOwner.logo = logoFile.bytes
//                storeOwner.logoContentType = logoFile.contentType
//            }
//
//            if (!appUser.validate() || !storeOwner.validate()) {
//                render(view: "register", model: [storeOwner       : storeOwner,
//                                                 appUser          : appUser,
//                                                 subscriptionPlans: SubscriptionPlan.list()])
//                return
//            }
//
//            appUser.save(flush: true)
//            appUser.createdBy = appUser
//            appUser.save(flush: true)
//
//            def plan = SubscriptionPlan.get(params.long('subscriptionPlanId'))
//            if (plan) {
//                Calendar calendar = Calendar.getInstance()
//                Date startDate = calendar.getTime()
//                calendar.add(Calendar.MONTH, plan.billingCycle)
//                Date endDate = calendar.getTime()
//                def userSubscription = new UserSubscription(user: appUser,
//                        plan: plan,
//                        startDate: startDate,
//                        endDate: endDate)
//                userSubscription.save(flush: true)
//                appUser.activeSubscription = userSubscription
//                appUser.save(flush: true)
//            }
//
//            def adminRole = AssignRole.findByRoleName("ADMIN")
//            appUser.addToAssignRole(adminRole)
//            appUser.save(flush: true)
//
//            storeOwner.save(flush: true)
//
//            flash.message = "Registration successful"
//            redirect(controller: "auth", action: "login")
        } else {
            render(view: "register", model: [cmd: new StoreOwnerRegistrationCommand(), subscriptionPlans: SubscriptionPlan.list()])
        }
    }
}