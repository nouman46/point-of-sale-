package store

import grails.gorm.transactions.Transactional
import org.mindrot.jbcrypt.BCrypt
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class SettingController {
    def passwordEncoder = new BCryptPasswordEncoder()

    def index(Long id) {
        def storeOwnerUsername = session.user?.id

        println("storeOwnerUsername: ${storeOwnerUsername}")

        def storeOwner = StoreOwner.get(storeOwnerUsername)

        println("storeowner: ${storeOwner}")

        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(controller: "auth", action: "login")
            return
        }
        def currentAdmin = session.user // Assuming session stores the logged-in admin
        if (!currentAdmin) {
            flash.error = "Unauthorized access!"
            return
        }

        def users = AppUser.findAllByCreatedBy(currentAdmin) // Fetch only users created by this admin
        def roles = AssignRole.list()
        def permissions = Permission.list()
        def pages = ['dashboard', 'inventory', 'listOrders', 'checkout', 'settings', 'subscription', 'roleManagement']

        def appUser = storeOwner.appUser
        def currentSubscription = appUser.activeSubscription
        def pendingRequest = SubscriptionRequest.findByUserAndStatus(appUser, "pending")
        def allPlans = SubscriptionPlan.list()

        render (view: "editStoreOwner", model: [storeOwner         : storeOwner,
                                               currentSubscription: currentSubscription,
                                               pendingRequest     : pendingRequest,
                                               allPlans           : allPlans,
                                               users              : users,
                                               roles              : roles,
                                               permissions        : permissions,
                                               pages              : pages])
    }

    @Transactional
    def updateStoreOwner(Long id) {
        def storeOwnerID = session.user?.id
        if (!storeOwnerID) {
            flash.message = "Please log in to update your settings"
            redirect(controller: "auth", action: "login")
            return
        }

        def storeOwner = StoreOwner.get(storeOwnerID)
        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(action: "index")
            return
        }

        def appUser = storeOwner.appUser
        if (!appUser) {
            flash.message = "Associated user not found"
            redirect(action: "index")
            return
        }

        bindData(storeOwner, params, [exclude: ['appUser', 'username', 'password']])

        if (params.username && params.username != appUser.username) {
            if (AppUser.findByUsername(params.username)) {
                storeOwner.errors.rejectValue('appUser', 'appUser.username.unique', "Username '${params.username}' is already taken")
                render(view: "editStoreOwner", model: [storeOwner: storeOwner])
                return
            }
            appUser.username = params.username
        }

        if (params.password) {
            appUser.password = passwordEncoder.encode(params.password)
        }

        if (!storeOwner.validate() || !appUser.validate()) {
            render(view: "editStoreOwner", model: [storeOwner: storeOwner])
            return
        }

        storeOwner.save(flush: true)
        appUser.save(flush: true)

        flash.message = "Store Owner updated successfully"
        redirect(action: "index", id: storeOwner.id)
    }

    @Transactional
    def updateLogo() {
        def storeOwnerID = session.user?.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(action: "index")
            return
        }

        def logoFile = request.getFile('logo')
        if (!logoFile || logoFile.empty) {
            flash.message = "No file selected"
            redirect(action: "index")
            return
        }

        try {
            // Print debug info
            println("🔍 Received file: ${logoFile.originalFilename}, size: ${logoFile.size} bytes, type: ${logoFile.contentType}")

            // Get the bytes directly
            byte[] fileBytes = logoFile.bytes
            println("🔍 File bytes length: ${fileBytes.length}")

            // Save to database
            storeOwner.logo = fileBytes
            storeOwner.logoContentType = logoFile.contentType

            if (storeOwner.save(flush: true)) {
                // Verify after save
                def savedOwner = StoreOwner.get(storeOwner.id)
                println("🔍 Saved logo: ${savedOwner?.logo?.length} bytes")
                flash.message = "Logo updated successfully"
            } else {
                println("🔍 Save failed: ${storeOwner.errors}")
                flash.message = "Failed to save logo: ${storeOwner.errors}"
            }
        } catch (Exception e) {
            println("🔍 Error: ${e.message}")
            e.printStackTrace()
            flash.message = "Error saving logo: ${e.message}"
        }

        redirect(action: "index")
    }

    @Transactional
    def requestSubscription() {
        def storeOwnerID = session.user?.id
        def storeOwner = StoreOwner.get(storeOwnerID)
        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(action: "index")
            return
        }

        def appUser = storeOwner.appUser
        def planId = params.planId
        def plan = SubscriptionPlan.get(planId)
        if (!plan) {
            flash.message = "Invalid subscription plan"
            redirect(action: "index")
            return
        }

        // Check for existing pending request
        def existingRequest = SubscriptionRequest.findByUserAndStatus(appUser, "pending")
        if (existingRequest) {
            flash.message = "You already have a pending subscription request"
            redirect(action: "index")
            return
        }

        // Create and save the subscription request
        def request = new SubscriptionRequest(user: appUser, plan: plan)
        if (request.save(flush: true)) {
            flash.message = "Subscription request submitted successfully"
        } else {
            flash.message = "Failed to submit subscription request"
        }
        redirect(action: "index")
    }

    def displayLogo() {
        def storeOwnerID = params.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (!storeOwner || !storeOwner.logo) {
            response.sendError(404)
            return
        }

        // Set content type
        response.contentType = storeOwner.logoContentType ?: 'image/png'

        // Write bytes directly to output stream
        response.outputStream << storeOwner.logo
        response.outputStream.flush()
        response.outputStream.close()

        // Prevent view rendering
        return false
    }

    @Transactional
    def saveUser() {
        def currentAdmin = session.user // Assuming the admin is stored in the session
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            return
        }

        def existinguser = AppUser.findByUsername(params.username)
        if (existinguser) {
            flash.error = "User already exists!"
        } else {
            // Encrypt the password before saving
            def encryptedPassword = BCrypt.hashpw(params.password, BCrypt.gensalt())

            def user = new AppUser(
                    username: params.username,
                    password: encryptedPassword, // Save the encrypted password
                    isAdmin: params.isAdmin ? true : false,
                    createdBy: currentAdmin // Assign the logged-in admin as creator
            )

            if (user.save(flush: true)) {
                flash.message = "User added successfully"
            } else {
                flash.error = "Failed to add User"
            }
        }
        redirect(action: "index")
    }

    @Transactional
    def saveRole() {
        def existingRole = AssignRole.findByRoleName(params.roleName)
        if (existingRole) {
            flash.error = "Role already exists!"
        } else {
            def role = new AssignRole(roleName: params.roleName)
            if (role.save(flush: true)) {
                flash.message = "Role added successfully"
            } else {
                flash.error = "Failed to add role"
            }
        }
        redirect(action: "index")
    }

    @Transactional
    def assignRole() {
        def user = AppUser.get(params.userId)
        def role = AssignRole.get(params.roleId)

        if (user && role) {
            if (!user.assignRole.contains(role)) { // Prevent duplicate roles
                user.addToAssignRole(role)
                role.addToUsers(user)  // Ensure bidirectional save
                user.save(flush: true, failOnError: true)
                role.save(flush: true, failOnError: true)  // Save role as well
                flash.message = "Role assigned successfully"
            } else {
                flash.error = "User already has this role!"
            }
        } else {
            flash.error = "Invalid user or role!"
        }
        redirect(action: "index")
    }

    // Delete a user
    @Transactional
    def deleteUser() {
        def user = AppUser.get(params.id)

        if (!user) {
            render(status: 404, text: "User not found!")
            return
        }

        try {
            // Clear associations with roles
            user.assignRole.each { role ->
                role.users.remove(user)  // Remove the user from the role's users collection
                role.save(flush: true)   // Save the role after removing the user
            }

            // Now delete the user
            user.delete(flush: true)

            flash.message = "User deleted successfully!"
            render(status: 200, text: "User deleted successfully!")
        } catch (Exception e) {
            log.error("Error deleting user: ${e.message}")
            flash.error = "Error deleting user: ${e.message}"
            render(status: 500, text: "Error deleting user!")
        }
    }

    @Transactional
    def editRole() {
        try {
            def role = AssignRole.get(params.id)
            if (!role) {
                flash.error = "Role not found!"
                redirect(action: "roleManagement")
                return
            }

            def existingRole = AssignRole.findByRoleName(params.roleName)
            if (existingRole && existingRole.id != role.id) {
                flash.error = "Role '${params.roleName}' already exists!"
                redirect(action: "index")
                return
            }

            if (params.roleName) {
                role.roleName = params.roleName
            }

            role.save(flush: true, failOnError: true)
            flash.message = "Role updated successfully!"
            redirect(action: "index")
        } catch (Exception e) {
            flash.error = "Error updating role: ${e.message}"
            redirect(action: "roleManagement")
        }
    }

    @Transactional
    def editUser() {
        try {
            def user = AppUser.get(params.userId)

            if (!user) {
                flash.error = "User not found!"
                redirect(action: "index")
                return
            }

            // Check if the new username already exists for another user
            if (params.username && AppUser.findByUsername(params.username) && params.username != user.username) {
                flash.error = "Username '${params.username}' is already taken!"
                redirect(action: "index")
                return
            }

            // Update username if provided
            if (params.username) {
                user.username = params.username
            }

            // Encrypt the password if provided
            if (params.password) {
                user.password = BCrypt.hashpw(params.password, BCrypt.gensalt()) // Encrypt the password
            }

            // Ensure roles are fetched to avoid lazy loading issues
            user.assignRole = user.assignRole ?: []

            // Explicitly remove each role association
            user.assignRole.toList().each { role ->
                user.removeFromAssignRole(role)
            }

            // Add new roles from the form
            if (params.roles) {
                def roleIds = params.list("roles")
                roleIds.each { roleId ->
                    def role = AssignRole.get(roleId)
                    if (role) {
                        user.addToAssignRole(role)
                    }
                }
            }

            // Final save to store new role assignments and updated password
            user.save(flush: true, failOnError: true)
            flash.message = "User updated successfully!"
            redirect(action: "index")
        } catch (Exception e) {
            flash.error = "Error: Unable to edit user! ${e.message}"
            redirect(action: "index")
        }
    }
    // Delete a role
    @Transactional
    def deleteRole() {
        def role = AssignRole.get(params.id)
        if (!role) {
            render(status: 404, text: "Role not found!")
            return
        }

        try {
            // Clear all permissions associated with the role
            Permission.findAllByAssignRole(role)*.delete(flush: true)

            // Clear all users associated with the role
            role.users.each { user ->
                user.assignRole.remove(role)
                user.save(flush: true)
            }

            // Now delete the role
            role.delete(flush: true)

            flash.message = "Role deleted successfully!"
        } catch (Exception e) {
            flash.error = "Error: Unable to delete role! Ensure there are no dependencies."
        }
        redirect(action: "index")
    }

    @Transactional
    def assignPermission() {
        println "Received params: " + params // Debugging output

        def role = AssignRole.get(params.roleId)
        if (!role) {
            flash.error = "Invalid Role!"
            redirect(action: "index")
            return
        }

        // Check if any pages were selected
        if (!params.pages) {
            flash.error = "No pages selected!"
            redirect(action: "index")
            return
        }

        // Remove old permissions before adding new ones
        Permission.findAllByAssignRole(role)*.delete(flush: true)

        // Iterate through each selected page
        params.pages.each { page ->
            def permission = new Permission(assignRole: role,
                    pageName: page,
                    canView: params["canView_${page}"] == "on",
                    canEdit: params["canEdit_${page}"] == "on",
                    canDelete: params["canDelete_${page}"] == "on")

            if (!permission.save(flush: true, failOnError: true)) {
                println "Error saving permission for ${page}: " + permission.errors
                flash.error = "Failed to save permission for ${page}"
            } else {
                println "Saved permission: " + permission
            }
        }

        flash.message = "Permissions assigned successfully!"
        redirect(action: "index")
    }

    def testLogo() {
        def storeOwnerID = params.id ?: session.user?.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (storeOwner?.logo) {
            String base64 = storeOwner.logo.encodeBase64().toString()
            render """
            <!DOCTYPE html>
            <html>
            <head><title>Logo Test</title></head>
            <body>
                <h1>Logo Test</h1>
                <p>Size: ${storeOwner.logo.length} bytes</p>
                <p>Type: ${storeOwner.logoContentType}</p>
                <img src="data:${storeOwner.logoContentType};base64,${base64}" alt="Logo" style="max-width:300px"/>
            </body>
            </html>
        """
        } else {
            render "No logo found"
        }
    }
}