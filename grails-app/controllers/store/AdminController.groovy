package store

import grails.gorm.transactions.Transactional
import org.mindrot.jbcrypt.BCrypt

class AdminController {

    def roleManagement() {
        def currentUser = session.user
        if (!currentUser) {
            flash.error = "Unauthorized access!"
            redirect(action: "index")
            return
        }

        // Re-fetch and initialize createdBy within an explicit session
        AppUser.withSession { session ->
            currentUser = AppUser.findById(currentUser.id)
            if (!currentUser) {
                flash.error = "User not found!"
                redirect(action: "index")
                return
            }
            currentUser.createdBy?.id  // Initialize the association
            println "Current user: ${currentUser.username}, createdBy: ${currentUser.createdBy?.id}"
        }

        // Determine the creator ID to filter by
        Long creatorId = currentUser.isAdmin ? currentUser.id : currentUser.createdBy?.id
        if (!creatorId) {
            flash.error = "Unable to determine creator ID!"
            redirect(action: "index")
            return
        }

        def users = AppUser.findAllByCreatedBy(AppUser.get(creatorId)).findAll {
            it.assignRole?.roleName != 'ADMIN'
        }

        def roles = AssignRole.findAllByCreatedBy(creatorId).findAll { it.roleName != 'ADMIN' }
        def permissions = Permission.findAllByCreatedBy(creatorId)

        def pages = ['dashboard', 'inventory', 'listOrders', 'checkout', 'settings', 'subscription', 'roleManagement']

        render(view: "roleManagement", model: [
                users      : users,
                roles      : roles,
                permissions: permissions,
                pages      : pages
        ])
    }

    @Transactional
    def saveUser(UserInfoCommand userInfo) {
        def currentAdmin = session.user
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        bindData(userInfo, params)

        if (!userInfo.validate()) {
            def errors = userInfo.errors.allErrors.collect { g.message(error: it) }.join("<br>")
            flash.error = "Validation failed:<br>${errors}"
            redirect(action: "roleManagement")
            return
        }

        def encryptedPassword = BCrypt.hashpw(userInfo.password, BCrypt.gensalt())
        def user = new AppUser(
                username: userInfo.username,
                password: encryptedPassword,
                isAdmin: userInfo.isAdmin,
                createdBy: currentAdmin
        )

        println "Attempting to save user: username=${user.username}, createdBy=${currentAdmin.id}, isAdmin=${user.isAdmin}"

        if (!user.save(flush: true)) {
            // Map domain errors to user-friendly messages and log for debugging
            def errors = user.errors.allErrors.collect { error ->
                println "Error detail: code=${error.code}, field=${error.field}"
                if (error.code == "unique" && error.field == "username") {
                    return g.message(code: "username.unique.error")
                }
                // Fallback for other errors, safely handling FieldError properties
                def errorMessage = g.message(error: error) ?: "An error occurred: ${error.code}"
                errorMessage
            }.join("<br>")
            flash.error = "Failed to add user:<br>${errors}"
            redirect(action: "roleManagement")
            return
        }

        flash.message = "User added successfully!"
        redirect(action: "roleManagement")
    }

    @Transactional
    def saveRole(RoleInfoCommand roleInfo) {
        def currentAdmin = session.user
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        bindData(roleInfo, params)

        if (!roleInfo.validate()) {
            def errors = roleInfo.errors.allErrors.collect { g.message(error: it) }.join("<br>")
            flash.error = "Validation failed:<br>${errors}"
            redirect(action: "roleManagement")
            return
        }

        def role = new AssignRole(
                roleName: roleInfo.roleName,
                createdBy: currentAdmin.id
        )

        println "Attempting to save role: roleName=${role.roleName}, createdBy=${currentAdmin.id}"

        if (role.save(flush: true)) {
            flash.message = "Role added successfully!"
        } else {
            def errors = role.errors.allErrors.collect { error ->
                println "Error detail: code=${error.code}, field=${error.field}"
                g.message(error: error)
            }.join("<br>")
            flash.error = "Failed to add role:<br>${errors}"
        }
        redirect(action: "roleManagement")
    }

    @Transactional
    def editUser(UserInfoCommand userInfo) {
        def currentAdmin = session.user
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        def user = AppUser.get(params.userId)
        if (!user) {
            flash.error = "User not found!"
            redirect(action: "roleManagement")
            return
        }

        userInfo.isEdit = true
        bindData(userInfo, params, [exclude: ['isAdmin']])

        if (!userInfo.validate()) {
            // Instead of redirecting, render the view with errors
            return render(view: "roleManagement", model: [
                    userInfo: userInfo, // Pass the command object with errors
                    users: AppUser.findAllByCreatedBy(AppUser.get(currentAdmin.id)).findAll { it.assignRole?.roleName != 'ADMIN' },
                    roles: AssignRole.findAllByCreatedBy(currentAdmin.id).findAll { it.roleName != 'ADMIN' },
                    permissions: Permission.findAllByCreatedBy(currentAdmin.id),
                    pages: ['dashboard', 'inventory', 'listOrders', 'checkout', 'settings', 'subscription', 'roleManagement']
            ])
        }

        println "Attempting to update user: userId=${user.id}, username=${userInfo.username}"

        user.username = userInfo.username
        if (userInfo.password?.trim()) {
            user.password = BCrypt.hashpw(userInfo.password, BCrypt.gensalt())
        }

        user.assignRole = user.assignRole ?: []
        user.assignRole.toList().each { role ->
            user.removeFromAssignRole(role)
        }

        if (params.roles) {
            def roleIds = params.list("roles")
            roleIds.each { roleId ->
                def role = AssignRole.get(roleId)
                if (role) user.addToAssignRole(role)
            }
        }

        if (!user.save(flush: true)) {
            def errors = user.errors.allErrors.collect { error ->
                println "Error detail: code=${error.code}, field=${error.field}"
                if (error.code == "unique" && error.field == "username") {
                    return g.message(code: "username.unique.error")
                }
                // Fallback for other errors, safely handling FieldError properties
                def errorMessage = g.message(error: error) ?: "An error occurred: ${error.code}"
                errorMessage
            }.join("<br>")
            flash.error = "Failed to update user:<br>${errors}"
            redirect(action: "roleManagement")
            return
        }

        flash.message = "User updated successfully!"
        redirect(action: "roleManagement")
    }

    @Transactional
    def editRole(RoleInfoCommand roleInfo) {
        def currentAdmin = session.user
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        def role = AssignRole.get(params.id)
        if (!role) {
            flash.error = "Role not found!"
            redirect(action: "roleManagement")
            return
        }

        bindData(roleInfo, params)

        if (!roleInfo.validate()) {
            def errors = roleInfo.errors.allErrors.collect { g.message(error: it) }.join("<br>")
            flash.error = "Validation failed:<br>${errors}"
            redirect(action: "roleManagement")
            return
        }

        println "Attempting to update role: roleId=${role.id}, roleName=${roleInfo.roleName}"

        role.roleName = roleInfo.roleName

        if (role.save(flush: true)) {
            flash.message = "Role updated successfully!"
        } else {
            def errors = role.errors.allErrors.collect { error ->
                println "Error detail: code=${error.code}, field=${error.field}"
                g.message(error: error)
            }.join("<br>")
            flash.error = "Failed to update role:<br>${errors}"
        }
        redirect(action: "roleManagement")
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
        redirect(action: "roleManagement")
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
        redirect(action: "roleManagement")
    }

    @Transactional
    def assignPermission() {
        def currentAdmin = session.user  // Get the current admin from the session
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        // Determine the creator ID to filter roles
        Long creatorId = currentAdmin.isAdmin ? currentAdmin.id : currentAdmin.createdBy?.id
        if (!creatorId) {
            flash.error = "Unable to determine creator ID!"
            redirect(action: "roleManagement")
            return
        }

        def role = AssignRole.get(params.roleId)
        if (!role || role.createdBy != creatorId) {
            flash.error = "Invalid Role!"
            redirect(action: "roleManagement")
            return
        }

        // Check if any pages were selected
        if (!params.pages) {
            flash.error = "No pages selected!"
            redirect(action: "roleManagement")
            return
        }

        // Remove old permissions before adding new ones
        Permission.findAllByAssignRole(role)*.delete(flush: true)

        // Iterate through each selected page
        params.pages.each { page ->
            def permission = new Permission(
                    assignRole: role,
                    pageName: page,
                    canView: params["canView_${page}"] == "on",
                    canEdit: params["canEdit_${page}"] == "on",
                    canDelete: params["canDelete_${page}"] == "on",
                    createdBy: currentAdmin.id  // Set the current admin's ID
            )

            if (!permission.save(flush: true, failOnError: true)) {
                println "Error saving permission for ${page}: " + permission.errors
                flash.error = "Failed to save permission for ${page}"
                redirect(action: "roleManagement")
                return
            }
            println "Saved permission: " + permission
        }

        flash.message = "Permissions assigned successfully!"
        redirect(action: "roleManagement")
    }

}
import grails.validation.Validateable

class UserInfoCommand implements Validateable {
    String username
    String password
    Boolean isAdmin = false
    boolean isEdit = false

    static constraints = {
        username blank: false, nullable: false, maxSize: 50, matches: /^[a-zA-Z0-9_]+$/
        password nullable: true, blank: true, minSize: 6, maxSize: 100,
                nullableMessage: 'password.required.error',  // Only for clarity, overridden by validator
                blankMessage: 'password.blank.error',        // Only for clarity, overridden by validator
                minSizeMessage: 'password.minSize.error',
                maxSizeMessage: 'password.maxSize.error',
                validator: { val, obj ->
                    if (!obj.isEdit && (val == null || val.trim() == "")) {
                        return ['password.required.error'] // Return the message key as a list
                    }
                    return true
                }

        isAdmin nullable: false,
                nullableMessage: 'isAdmin.required.error'
    }
}

import grails.validation.Validateable

class RoleInfoCommand implements Validateable {
    String roleName

    static constraints = {
        roleName blank: false, nullable: false, maxSize: 50, validator: { val, obj ->
            if (val?.trim()?.toLowerCase() == 'admin') {
                return ['roleName.admin.error'] // Return the message key as a list
            }
            return true
        }
    }
}