package store

import org.mindrot.jbcrypt.BCrypt

class AuthController {

    def login() {
        if (request.method == "POST") {
            def username = params.username
            def password = params.password

            // Find the user by username, but we need to handle multiple users with the same username
            def users = AppUser.findAllByUsername(username)

            if (!users) {
                flash.message = "Invalid username or password"
                println "❌ Authentication failed for ${username} - User not found"
                redirect(action: "login")
                return
            }

            // Try to authenticate each user with the provided password
            def authenticatedUser = users.find { user ->
                BCrypt.checkpw(password, user.password)
            }

            if (authenticatedUser) {
                println "✅ User Found: ${authenticatedUser.username} (ID: ${authenticatedUser.id}, createdBy: ${authenticatedUser.createdBy?.id})"
                session.user = authenticatedUser
                session.isAdmin = authenticatedUser.isAdmin

                // Ensure roles are properly fetched and initialized
                session.assignRole = authenticatedUser.assignRole ? authenticatedUser.assignRole*.roleName : []

                // Fetch and set permissions based on the user's roles
                def permissions = [:]

                if (authenticatedUser.isAdmin) {
                    // Admin gets access to ALL pages with FULL permissions
                    def allPages = ["dashboard", "inventory", "listOrders", "checkout", "settings", "subscription", "roleManagement"]
                    allPages.each { page ->
                        permissions[page] = [canView: true, canEdit: true, canDelete: true]
                    }
                } else {
                    // Normal users get permissions from their assigned roles
                    authenticatedUser.assignRole?.each { assignRole ->
                        assignRole.permissions?.each { perm ->
                            if (!permissions.containsKey(perm.pageName)) {
                                permissions[perm.pageName] = [canView: false, canEdit: false, canDelete: false]
                            }
                            permissions[perm.pageName].canView |= perm.canView
                            permissions[perm.pageName].canEdit |= perm.canEdit
                            permissions[perm.pageName].canDelete |= perm.canDelete
                        }
                    }
                }

                session.permissions = permissions

                println "✅ Session Set: ${session.user.username}, Roles: ${session.assignRole}, Permissions: ${session.permissions}"
                flash.message = "Login successful!"

                // Redirect to the user's specific dashboard or screen based on their permissions
                redirect(controller: "dashboard", action: "dashboard")
                return
            } else {
                flash.message = "Invalid username or password"
                println "❌ Authentication failed for ${username} - Password mismatch"
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

    def logout() {
        session.invalidate()
        flash.message = "Logged out successfully"
        println "🔴 User logged out"
        redirect(action: "login")
    }
}