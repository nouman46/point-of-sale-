package store

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import java.nio.file.Files
import java.nio.file.Paths

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

                // Admin User and StoreOwner Setup
                def passwordEncoder = new BCryptPasswordEncoder()

                // Main Admin User Setup
                def adminUser = AppUser.findByUsername("admin")
                if (!adminUser) {
                    String hashedPassword = passwordEncoder.encode("password")
                    adminUser = new AppUser(username: "admin", password: hashedPassword, isAdmin: true, createdBy: null).save(failOnError: true)
                    adminUser.createdBy = adminUser // Self-reference after saving
                    adminUser.save(failOnError: true)

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
                    def adminRole = AssignRole.findByRoleName("ADMIN") ?: new AssignRole(roleName: "ADMIN").save(failOnError: true)
                    adminUser.addToAssignRole(adminRole)
                    adminUser.save(failOnError: true)

                    // Create and link a StoreOwner for the admin user
                    def storeOwner = StoreOwner.findByUsername("admin_store")
                    if (!storeOwner) {
                        def logoPath = "grails-app/assets/images/pos-logo.png"
                        def logoFile = new File(logoPath)
                        byte[] logoBytes = null
                        String logoContentType = null
                        if (logoFile.exists()) {
                            logoBytes = Files.readAllBytes(logoFile.toPath())
                            logoContentType = "image/png"
                            println "Logo file found and loaded from ${logoPath}"
                        } else {
                            println "Logo file not found at ${logoPath}"
                        }

                        println("🔐 BootStrap.init logoBytes: ${logoBytes}")

                        storeOwner = new StoreOwner(username: "admin_store",
                                password: passwordEncoder.encode("storepassword"),
                                email: "admin@store.com",
                                storeName: "Admin's Store",
                                appUser: adminUser,
                                logo: logoBytes,
                                logoContentType: logoContentType).save(failOnError: true)
                    }
                    println("Store owner created for admin user")
                }

                // Dummy Demo Admin User Setup
                def demoAdmin = AppUser.findByUsername("demo_admin")
                if (!demoAdmin) {
                    String demoHashedPassword = passwordEncoder.encode("demo123")
                    demoAdmin = new AppUser(username: "demo_admin", password: demoHashedPassword, isAdmin: true, createdBy: null).save(failOnError: true)
                    demoAdmin.createdBy = demoAdmin // Self-reference after saving
                    demoAdmin.save(failOnError: true)

                    // Assign ADMIN role to demo admin
                    def demoAdminRole = AssignRole.findByRoleName("ADMIN") ?: new AssignRole(roleName: "ADMIN").save(failOnError: true)
                    demoAdmin.addToAssignRole(demoAdminRole)
                    demoAdmin.save(failOnError: true)

                    println "✅ Dummy Demo Admin 'demo_admin' created with ID: ${demoAdmin.id}"
                }

                println "Admin user, demo admin, and subscription plans initialized"

            } catch (Exception e) {
                status.setRollbackOnly()
                println "An error occurred while initializing subscription plans, admin, or demo admin: ${e.message}"
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