package store


import grails.gorm.transactions.Transactional
class AdminController {

    def roleManagement() {
        def users = AppUser.list()
        def roles = AssignRole.list()  // Fetch all roles
        def permissions = Permission.list()
        def pages = ['inventory', 'sales', 'checkout', 'reports', 'settings']

        render(view: "roleManagement", model: [
                users       : users,
                roles       : roles,   // Use roles instead of assignRole
                permissions : permissions,
                pages       : pages
        ])
    }


    @Transactional
    def saveUser() {
        def user = new AppUser(username: params.username, password: params.password, isAdmin: params.isAdmin ? true : false)

        if (user.save(flush: true)) {
            flash.message = "User added successfully"
        } else {
            flash.error = "Failed to add user"
        }
        redirect(action: "roleManagement")
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



    @Transactional
    def assignPermission() {
        def role = AssignRole.get(params.roleId)

        if (!role) {
            flash.error = "Invalid Role!"
            redirect(action: "roleManagement")
            return
        }

        // Remove old permissions for this role before adding new ones
        Permission.findAllByAssignRole(role)*.delete(flush: true)

        // Iterate through each selected page and assign permissions
        params.pages.each { page ->
            def permission = new Permission(
                    assignRole: role,  // Ensure it is mapped correctly
                    pageName: page,
                    canView: params["canView_${page}"] == "on",
                    canEdit: params["canEdit_${page}"] == "on",
                    canDelete: params["canDelete_${page}"] == "on"
            )

            if (!permission.save(flush: true, failOnError: true)) {
                permission.errors.allErrors.each { println it } // Debugging output
                flash.error = "Failed to save permission for ${page}"
            }
        }

        flash.message = "Permissions assigned successfully!"
        redirect(action: "roleManagement")
    }


}
