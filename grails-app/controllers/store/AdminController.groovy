package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import org.springframework.dao.DataIntegrityViolationException

class AdminController {

    def userList() {
        def users = AppUser.list()
        [users: users]
    }
    @Transactional
    def saveUser() {
        try {
            log.info("saveUser action hit with params: ${params}")
            def user = params.id ? AppUser.get(params.id) : new AppUser()

            if (params.id && !user) {
                render status: 404, text: "User not found"
                return
            }

            user.username = params.username
            user.password = params.password
            user.allowedPages = params.list('allowedPages').join(',')

            if (user.validate() && user.save(flush: true)) {
                // Handle Role Assignment
                if (params.roleName) {
                    def role = Role.findByName(params.roleName) ?: new Role(name: params.roleName).save(flush: true)
                    if (!UserRole.findByUserAndRole(user, role)) {
                        new UserRole(user: user, role: role).save(flush: true)
                    }
                }
                log.info("User saved successfully: ${user}")
                render status: 200, text: "User saved successfully"
            } else {
                log.error("Failed to save user: ${user.errors}")
                render status: 400, text: "Failed to save user: " + user.errors
            }
        } catch (Exception e) {
            log.error("Error in saveUser action: ${e.message}", e)
            render status: 500, text: "An error occurred while saving the user"
        }
    }

    /**
     * Fetch user details for editing
     */
    def showUser(Long id) {
        try {
            log.info("Fetching user details for ID: ${id}")
            def user = AppUser.get(id)
            if (!user) {
                log.warn("User with ID ${id} not found")
                render status: 404, text: "User not found"
                return
            }

            def userRole = UserRole.findByUser(user)?.role?.name ?: "No Role Assigned"
            def allowedPagesList = user.allowedPages ? user.allowedPages.split(',') : []

            def userData = [
                    id          : user.id,
                    username    : user.username,
                    password    : user.password,
                    allowedPages: allowedPagesList,
                    role        : userRole
            ]

            log.info("User Data: ${userData}") // Debugging log
            render userData as JSON
        } catch (Exception e) {
            log.error("Error fetching user data: ${e.message}", e)
            render status: 500, text: "An error occurred while fetching user data"
        }
    }


    /**
     * Delete a user and their associated roles
     */
    @Transactional
    def deleteUser(Long id) {
        try {
            log.info("Attempting to delete user with ID: ${id}")
            def user = AppUser.get(id)
            if (!user) {
                log.warn("User with ID ${id} not found")
                render status: 404, text: "User not found"
                return
            }

            // Delete associated roles first
            def roles = UserRole.findAllByUser(user)
            roles.each { it.delete(flush: true) }

            log.info("Deleted role associations for user ID: ${id}")

            // Delete user
            user.delete(flush: true)
            log.info("User with ID ${id} deleted successfully")
            render status: 200, text: "User deleted successfully"
        } catch (DataIntegrityViolationException e) {
            log.error("Data integrity error while deleting user ID ${id}: ${e.message}", e)
            render status: 400, text: "Cannot delete user due to data integrity constraints"
        } catch (Exception e) {
            log.error("Unexpected error while deleting user ID ${id}: ${e.message}", e)
            render status: 500, text: "An unexpected error occurred while deleting the user"
        }
    }

}
