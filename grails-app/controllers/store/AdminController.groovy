package store

import grails.gorm.transactions.Transactional
import grails.converters.JSON


class AdminController {

    def roleManagement() {
        render(view: "roleManagement")
    }

    def getRoles() {
        def roles = Role.list().collect { role ->
            [id: role.id, roleName: role.roleName]
        }

        println "Roles found: ${roles}" // Debugging
        render roles as JSON
    }

    def saveRole() {
        def role = params.id ? Role.get(params.id) : new Role()
        role.roleName = params.roleName
        role.save(flush: true)

        render([message: "Role saved successfully!"] as JSON)
    }

    def deleteRole() {
        def role = Role.get(params.id)
        if (role) {
            role.delete(flush: true)
            render([message: "Role deleted successfully!"] as JSON)
        } else {
            render([message: "Role not found!"] as JSON)
        }
    }

    def savePermissions() {
        def role = Role.get(params.roleId)
        if (!role) {
            render([message: "Invalid role"] as JSON)
            return
        }

        // Remove old permissions
        role.permissions*.delete(flush: true)

        // Assign new permissions
        params.each { key, value ->
            if (key.startsWith("inventory") || key.startsWith("sales")) {
                def parts = key.split("_")
                def page = parts[0]
                def action = parts[1]

                def permission = role.permissions.find { it.pageName == page } ?: new Permission(pageName: page, role: role)
                if (action == "view") permission.canView = value == "true"
                if (action == "edit") permission.canEdit = value == "true"
                if (action == "delete") permission.canDelete = value == "true"

                permission.save(flush: true)
            }
        }

        render([message: "Permissions updated!"] as JSON)
    }
}
