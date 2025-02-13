package store

class AuthController {

    def login() {
        if (request.method == "POST") {
            def user = AppUser.findByUsernameAndPassword(params.username, params.password)

            if (user) {
                println "✅ User Found: ${user.username}"
                session.user = user
                session.isAdmin = user.isAdmin
                session.roles = user.roles.collect { it.roleName }

                def permissions = [:]

                if (user.isAdmin) {
                    // ✅ Admin gets access to ALL pages with FULL permissions
                    def allPages = ["inventory", "sales", "checkout", "users", "settings"] // Add all relevant pages
                    allPages.each { page ->
                        permissions[page] = [canView: true, canEdit: true, canDelete: true]
                    }
                } else {
                    // ✅ Normal users get permissions from assigned roles
                    user.roles.each { role ->
                        role.permissions.each { perm ->
                            permissions[perm.pageName] = [
                                    canView  : perm.canView,
                                    canEdit  : perm.canEdit,
                                    canDelete: perm.canDelete
                            ]
                        }
                    }
                }

                session.permissions = permissions

                println "✅ Session Set: ${session.user.username}, Roles: ${session.roles}, Permissions: ${session.permissions}"
                flash.message = "Login successful!"
                redirect(controller: "dashboard", action: "index")
                return
            } else {
                flash.message = "Invalid username or password"
                println "❌ Authentication failed for ${params.username}"
                redirect(action: "login")
                return
            }
        }

        if (session.user) {
            redirect(controller: "dashboard", action: "index")
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
