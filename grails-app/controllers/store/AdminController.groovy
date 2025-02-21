package store


import grails.validation.Validateable
import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException
import grails.gorm.transactions.Transactional

class AdminController {

    def roleManagement() {
        def currentAdmin = session.user // Assuming session stores the logged-in admin
        if (!currentAdmin) {
            flash.error = "Unauthorized access!"
            return
        }

        def users = AppUser.findAllByCreatedBy(currentAdmin) // Fetch only users created by this admin
        def roles = AssignRole.list()
        def permissions = Permission.list()
        def pages = ['inventory', 'sales', 'checkout', 'settings', 'subscription','roleManagement']

        render(view: "roleManagement", model: [
                users: users,
                roles: roles,
                permissions: permissions,
                pages: pages
        ])
    }


    @Transactional
    def saveUser() {
        def currentAdmin = session.user // Assuming the admin is stored in the session
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            return
        }

        def user = new AppUser(
                username: params.username,
                password: params.password,
                isAdmin: params.isAdmin ? true : false,
                createdBy: currentAdmin // Assign the logged-in admin as creator
        )

        if (user.save(flush: true)) {
            flash.message = "User added successfully"
        } else {
            flash.error = "Failed to add user"
        }
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

// Edit Role Method
    @Transactional
    def editRole() {
        def role = AssignRole.get(params.id)
        if (!role) {
            render(status: 404, text: "Role not found!")
            return
        }

        if (params.roleName) {
            role.roleName = params.roleName
        }

        try {
            role.save(flush: true, failOnError: true)
            flash.message = "Role updated successfully!"
        } catch (Exception e) {
            flash.error = "Error updating role!"
        }
    }

    @Transactional
    def editUser() {
        def user = AppUser.get(params.userId)

        if (!user) {
            flash.error = "User not found!"
            return
        }

        // Update username and password if provided
        if (params.username) {
            user.username = params.username
        }

        if (params.password) {
            user.password = params.password
        }

        // Ensure roles are fetched to avoid lazy loading issues
        user.assignRole = user.assignRole ?: []

        // Explicitly remove each role association
        user.assignRole.toList().each { role ->
            user.removeFromAssignRole(role)
        }

        // Flush the session to persist role removal
        user.save(flush: true, failOnError: true)

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

        // Final save to store new role assignments
        try {
            user.save(flush: true, failOnError: true)
            flash.message = "User updated successfully!"
        } catch (Exception e) {
            flash.error = "Error: Unable to edit user! ${e.message}"
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
        println "Received params: " + params // Debugging output

        def role = AssignRole.get(params.roleId)
        if (!role) {
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
                    canDelete: params["canDelete_${page}"] == "on"
            )

            if (!permission.save(flush: true, failOnError: true)) {
                println "Error saving permission for ${page}: " + permission.errors
                flash.error = "Failed to save permission for ${page}"
            } else {
                println "Saved permission: " + permission
            }
        }

        flash.message = "Permissions assigned successfully!"
        redirect(action: "roleManagement")
    }



}
