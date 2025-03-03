package store

import org.mindrot.jbcrypt.BCrypt

class AuthController {

    def login() {
        if (request.method == "POST") {
            def username = params.username
            def password = params.password

            def users = AppUser.findAllByUsername(username)
            if (!users) {
                flash.message = "Invalid username or password"
                redirect(action: "login")
                return
            }

            session.permissions = session.permissions ?: [:]


            def authenticatedUser = users.find { user -> BCrypt.checkpw(password, user.password) }
            if (authenticatedUser) {
                session.user = authenticatedUser
                session.isAdmin = authenticatedUser.isAdmin
                session.isSystemAdmin = authenticatedUser.isSystemAdmin

                def permissions = [:]

                if (authenticatedUser.isSystemAdmin) {
                    // Full access for system admins
                    def allPages = ["dashboard", "inventory", "listOrders", "checkout", "settings", "subscription", "roleManagement","manageUsers"]
                    allPages.each { page ->
                        permissions[page] = [canView: true, canEdit: true, canDelete: true]
                    }
                } else {
                    // Handle store owners and employees (see Store Owner section below)
                    def subscriptionPlan = getStoreSubscriptionPlan(authenticatedUser)
                    if (subscriptionPlan) {
                        def availablePages = subscriptionPlan.features
                        if (authenticatedUser.activeSubscription) {
                            // Store owner: full access to subscription features
                            availablePages.each { page ->
                                permissions[page] = [canView: true, canEdit: true, canDelete: true]
                            }
                        } else {
                            // Employee: role-based access within subscription features
                            authenticatedUser.assignRole?.each { assignRole ->
                                assignRole.permissions?.each { perm ->
                                    if (availablePages.contains(perm.pageName)) {
                                        permissions[perm.pageName] = permissions[perm.pageName] ?: [canView: false, canEdit: false, canDelete: false]
                                        permissions[perm.pageName].canView |= perm.canView
                                        permissions[perm.pageName].canEdit |= perm.canEdit
                                        permissions[perm.pageName].canDelete |= perm.canDelete
                                    }
                                }
                            }
                        }
                    } else {
                        flash.message = "No active subscription found."
                        redirect(action: "login")
                        return
                    }
                }

                session.permissions = permissions
                redirect(controller: "dashboard", action: "dashboard")
                return
            } else {
                flash.message = "Invalid username or password"
                redirect(action: "login")
                return
            }
        }

        if (session.user) {
            redirect(controller: "dashboard", action: "dashboard")
            return
        }

        render(view: "login")
    }

    private SubscriptionPlan getStoreSubscriptionPlan(AppUser user) {
        while (user && !user.activeSubscription) {
            user = user.createdBy
        }
        return user?.activeSubscription?.plan
    }

    def logout() {
        session.invalidate()
        flash.message = "Logged out successfully"
        println "🔴 User logged out"
        redirect(action: "login")
    }
}