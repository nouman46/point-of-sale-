package store

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class RegistrationService {
    def passwordEncoder = new BCryptPasswordEncoder()

    @Transactional(rollbackFor=Exception.class)
    def registerStoreOwner(StoreOwnerRegistrationCommand cmd, logoFile) {
        def appUser = new AppUser(
                username: cmd.username,
                password: passwordEncoder.encode(cmd.password),
                isAdmin: true,
                isSystemAdmin: false
        )

        if (AppUser.findByUsername(cmd.username)) {
            appUser.errors.rejectValue('username', 'appUser.username.unique', 'Username already exists')
            return [success: false, errors: appUser.errors]
        }

        if (!appUser.validate()) {
            return [success: false, errors: appUser.errors]
        }

        def storeOwner = new StoreOwner(
                email: cmd.email,
                storeName: cmd.storeName,
                appUser: appUser
        )

        if (StoreOwner.findByEmail(cmd.email)) {
            storeOwner.errors.rejectValue('email', 'storeOwner.email.unique', 'Email already exists')
            return [success: false, errors: storeOwner.errors]
        }

        if (logoFile && !logoFile.isEmpty()) {
            storeOwner.logo = logoFile.bytes
            storeOwner.logoContentType = logoFile.contentType
        }

        if (!storeOwner.validate()) {
            return [success: false, errors: storeOwner.errors]
        }

        appUser.save(flush: true)
        appUser.createdBy = appUser // Now safe since appUser has an ID
        appUser.save(flush: true)

        storeOwner.save(flush: true)

        def plan = SubscriptionPlan.get(cmd.subscriptionPlanId)
        if (!plan) {
            appUser.errors.rejectValue('activeSubscription', 'subscription.plan.not.found', 'Invalid subscription plan')
            return [success: false, errors: appUser.errors]
        }

        def startDate = new Date()
        def endDate = calculateEndDate(startDate, plan.billingCycle)
        def userSubscription = new UserSubscription(
                user: appUser,
                plan: plan,
                startDate: startDate,
                endDate: endDate,
                isActive: true
        )

        if (!userSubscription.validate()) {
            return [success: false, errors: userSubscription.errors]
        }
        userSubscription.save(flush: true)

        appUser.activeSubscription = userSubscription
        appUser.save(flush: true)

        def adminRole = AssignRole.findByRoleName('ADMIN') ?: new AssignRole(roleName: 'ADMIN', createdBy: appUser.id).save(flush: true)
        appUser.addToAssignRole(adminRole)
        appUser.save(flush: true)

        return [success: true, appUser: appUser, storeOwner: storeOwner]

    }

    private Date calculateEndDate(Date startDate, Integer billingCycle) {
        Calendar cal = Calendar.getInstance()
        cal.setTime(startDate)
        cal.add(Calendar.MONTH, billingCycle ?: 1)
        return cal.getTime()
    }
}