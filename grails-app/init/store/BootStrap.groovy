package store

class BootStrap {

    def init = { servletContext ->
        // Use a transactional block to ensure database operations are within a transaction
        User.withTransaction { status ->  // <--- Crucial addition
            // Create a default role (if it doesn't exist)
            def userRole = Role.findByAuthority('ROLE_USER') ?: new Role(authority: 'ROLE_USER').save(failOnError: true)

            // Create a default admin role (if it doesn't exist)
            def adminRole = Role.findByAuthority('ROLE_ADMIN') ?: new Role(authority: 'ROLE_ADMIN').save(failOnError: true)

            // Create a default user (if it doesn't exist)
            def user = User.findByUsername('admin') ?: new User(
                    username: 'admin',
                    password: 'password', // Password will be hashed automatically
                    enabled: true
            ).save(failOnError: true)

            // Assign roles to the user
            if (!UserRole.exists(user.id, userRole.id)) {
                UserRole.create(user, userRole, true)
            }
            if (!UserRole.exists(user.id, adminRole.id)) {
                UserRole.create(user, adminRole, true)
            }
        }
        def destroy = {

        }
    }
}