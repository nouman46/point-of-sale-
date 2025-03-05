package store

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

import java.nio.file.Files

class BootStrap {
    def passwordEncoder = new BCryptPasswordEncoder()

    def init = { servletContext ->

        SubscriptionPlan.withTransaction { status ->
            try {
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

                def adminUser = AppUser.findByUsername("admin")
                if (!adminUser) {
                    String hashedPassword = passwordEncoder.encode("password")

                    adminUser = new AppUser(username: "admin", password: hashedPassword, isAdmin: true).save(failOnError: true)
                    adminUser.createdBy = adminUser
                    adminUser.save(failOnError: true)

                    def basicPlan = SubscriptionPlan.findByName("Basic")

                    if (basicPlan) {
                        def adminSubscription = new UserSubscription(
                                user: adminUser,
                                plan: basicPlan,
                                startDate: new Date(),
                                endDate: calculateEndDate(new Date(), 30)
                        )
                        adminSubscription.save(failOnError: true)
                        adminUser.activeSubscription = adminSubscription
                        adminUser.save(failOnError: true)
                    } else {
                        println "Basic plan not found, admin user subscription not set."
                    }

                    def adminRole = AssignRole.findByRoleName("ADMIN")
                    if (!adminRole) {
                        adminRole = new AssignRole(roleName: "ADMIN").save(failOnError: true)
                    }

                    adminUser.addToAssignRole(adminRole)
                    adminUser.save(failOnError: true)

                    def storeOwner = StoreOwner.findByAppUser(adminUser)
                    if (!storeOwner) {
                        def logoPath = "grails-app/assets/images/pos-logo.png"
                        def logoFile = new File(logoPath)
                        byte[] logoBytes = null
                        String logoContentType = null
                        if (logoFile.exists()) {
                            logoBytes = Files.readAllBytes(logoFile.toPath())
                            logoContentType = "image/png" // Corrected for .jpg file
                        }

                        storeOwner = new StoreOwner(
                                email: "admin@store.com",
                                storeName: "Admin's Store",
                                appUser: adminUser, // Link to the admin AppUser
                                logo: logoBytes,
                                logoContentType: logoContentType).save(failOnError: true)
                    }
                    println("Store owner created for admin user")
                }

                println "Admin user and subscription plans initialized"

            } catch (Exception e) {
                status.setRollbackOnly()
                println "An error occurred while initializing subscription plans and admin: ${e.message}"
            }

            if (AppUser.countByIsSystemAdmin(true) == 0) {
                // Create a new system admin
                def systemAdmin = new AppUser(
                        username: "sysadmin",
                        password: passwordEncoder.encode("admin123"),  // Note: In production, encode this password
                        isSystemAdmin: true,
                        isAdmin: false          // Optional, depending on additional admin needs
                )
                systemAdmin.save(failOnError: true)
                println "System admin created with username: sysadmin"
            } else {
                println "System admin already exists"
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