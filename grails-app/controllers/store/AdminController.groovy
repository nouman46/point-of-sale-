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

        AppUser.withSession { session ->
            currentUser = AppUser.findById(currentUser.id)
            if (!currentUser) {
                flash.error = "User not found!"
                redirect(action: "index")
                return
            }
            currentUser.createdBy?.id
            println "Current user: ${currentUser.username}, createdBy: ${currentUser.createdBy?.id}"
        }

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
            def errors = userInfo.errors.allErrors.collect { g.message(error: it) }.join(". ")
            flash.error = "Validation failed: ${errors}"
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
            def errors = user.errors.allErrors.collect { error ->
                println "Error detail: code=${error.code}, field=${error.field}"
                if (error.code == "unique" && error.field == "username") {
                    return "A user with the username '${user.username}' already exists!"
                }
                g.message(error: error) ?: "An error occurred: ${error.code}"
            }.join(". ")
            flash.error = "Failed to add user: ${errors}"
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
            def errors = roleInfo.errors.allErrors.collect { g.message(error: it) }.join(". ")
            flash.error = "Validation failed: ${errors}"
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
            }.join(". ")
            flash.error = "Failed to add role: ${errors}"
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
            return render(view: "roleManagement", model: [
                    userInfo: userInfo,
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
                    return "A user with the username '${user.username}' already exists!"
                }
                g.message(error: error) ?: "An error occurred: ${error.code}"
            }.join(". ")
            flash.error = "Failed to update user: ${errors}"
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
            def errors = roleInfo.errors.allErrors.collect { g.message(error: it) }.join(". ")
            flash.error = "Validation failed: ${errors}"
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
            }.join(". ")
            flash.error = "Failed to update role: ${errors}"
        }
        redirect(action: "roleManagement")
    }

    @Transactional
    def assignRole() {
        def user = AppUser.get(params.userId)
        def role = AssignRole.get(params.roleId)

        if (user && role) {
            if (!user.assignRole.contains(role)) {
                user.addToAssignRole(role)
                role.addToUsers(user)
                user.save(flush: true, failOnError: true)
                role.save(flush: true, failOnError: true)
                flash.message = "Role assigned successfully"
            } else {
                flash.error = "User already has the role '${role.roleName}'!"
            }
        } else {
            flash.error = "Invalid user or role selected!"
        }
        redirect(action: "roleManagement")
    }

    @Transactional
    def deleteUser() {
        def user = AppUser.get(params.id)

        if (!user) {
            flash.error = "User not found!"
            redirect(action: "roleManagement") // Assuming there's a user management page
            return
        }

        try {
            // Remove user from all assigned roles
            user.assignRole.each { role ->
                role.users.remove(user)
                role.save(flush: true)
            }
            user.delete(flash: true)
            flash.message = "User deleted successfully!"
            redirect(action: "roleManagement") // Redirect to user management page
        } catch (Exception e) {
            flash.error = "Failed to delete user: ${e.message}"
            redirect(action: "roleManagement")
        }
    }

    @Transactional
    def deleteRole() {
        def role = AssignRole.get(params.id)
        if (!role) {
            render(status: 404, text: "Role not found!")
            return
        }

        try {
            Permission.findAllByAssignRole(role)*.delete(flush: true)
            role.users.each { user ->
                user.assignRole.remove(role)
                user.save(flush: true)
            }
            role.delete(flush: true)
            flash.message = "Role deleted successfully!"
        } catch (Exception e) {
            flash.error = "Failed to delete role: Ensure there are no dependencies"
        }
        redirect(action: "roleManagement")
    }

    @Transactional
    def assignPermission() {
        def currentAdmin = session.user
        if (!currentAdmin) {
            flash.error = "Unauthorized action!"
            redirect(action: "roleManagement")
            return
        }

        Long creatorId = currentAdmin.isAdmin ? currentAdmin.id : currentAdmin.createdBy?.id
        if (!creatorId) {
            flash.error = "Unable to determine creator ID!"
            redirect(action: "roleManagement")
            return
        }

        def role = AssignRole.get(params.roleId)
        if (!role || role.createdBy != creatorId) {
            flash.error = "Invalid role selected!"
            redirect(action: "roleManagement")
            return
        }

        if (!params.pages) {
            flash.error = "No pages selected for permissions!"
            redirect(action: "roleManagement")
            return
        }

        Permission.findAllByAssignRole(role)*.delete(flush: true)

        params.pages.each { page ->
            def permission = new Permission(
                    assignRole: role,
                    pageName: page,
                    canView: params["canView_${page}"] == "on",
                    canEdit: params["canEdit_${page}"] == "on",
                    canDelete: params["canDelete_${page}"] == "on",
                    createdBy: currentAdmin.id
            )

            if (!permission.save(flush: true, failOnError: true)) {
                println "Error saving permission for ${page}: " + permission.errors
                flash.error = "Failed to save permission for page '${page}'"
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
                validator: { val, obj ->
                    if (!obj.isEdit && (val == null || val.trim() == "")) {
                        return ['password.required.error']
                    }
                    return true
                }
        isAdmin nullable: false
    }
}

import grails.validation.Validateable

class RoleInfoCommand implements Validateable {
    String roleName

    static constraints = {
        roleName blank: false, nullable: false, maxSize: 50, validator: { val, obj ->
            if (val?.trim()?.toLowerCase() == 'admin') {
                return ['roleName.admin.error']
            }
            return true
        }
    }
}