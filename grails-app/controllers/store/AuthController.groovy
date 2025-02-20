package store

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.mindrot.jbcrypt.BCrypt

class AuthController {
//    def passwordEncoder = new BCryptPasswordEncoder()

    def login() {
        if (request.method == "POST") {
            def user = AppUser.findByUsername(params.username)

            if (user) {
                println "Stored hash: ${user.password}"
                println "Matches 'zeeshan123'? ${BCrypt.checkpw('zeeshan123', user.password)}"
            }

            if (user && BCrypt.checkpw(params.password, user.password)) {
                println "✅ User Found: ${user.username}"
                session.user = user
                session.isAdmin = user.isAdmin


                // Ensure roles are properly fetched
                session.assignRole = user.assignRole ? user.assignRole*.roleName : []

                def permissions = [:]

                if (user.isAdmin) {
                    // ✅ Admin gets access to ALL pages with FULL permissions
                    def allPages = ["inventory", "sales", "checkout", "settings", "subscription", "roleManagement"]
                    allPages.each { page -> permissions[page] = [canView: true, canEdit: true, canDelete: true]
                    }
                } else {
                    // ✅ Normal users get permissions from assigned roles
                    user.assignRole?.each { assignRole ->
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
