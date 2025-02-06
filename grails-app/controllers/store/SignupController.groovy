package store


class SignupController {

    def springSecurityService

    def index() {
        // Render a registration page
        render view: 'signup'
    }

    def register(SignupCommand cmd) {
        if (cmd.hasErrors()) {
            flash.message = "There were errors in your submission"
            render view: 'signup', model: [command: cmd]
            return
        }

        // Create a new User instance
        def user = new User(username: cmd.username, password: cmd.password)
        if (!user.save(flush: true)) {
            flash.message = "Failed to create user"
            render view: 'signup', model: [command: cmd]
            return
        }
        // Assign a default role (e.g., ROLE_USER)
        def role = Role.findByAuthority('ROLE_USER')
        UserRole.create(user, role, true)

        flash.message = "Registration successful! Please log in."
        redirect controller: 'login', action: 'auth'
    }
}

class SignupCommand {
    String username
    String password
    String confirmPassword

    static constraints = {
        username blank: false, email: true, validator: { val, obj ->
            if (User.findByUsername(val)) {
                return 'signup.username.already.exists'
            }
        }
        password blank: false, minSize: 12  // enforce strong password policies
        confirmPassword validator: { val, obj ->
            if (val != obj.password) {
                return 'signup.password.mismatch'
            }
        }
    }
}
