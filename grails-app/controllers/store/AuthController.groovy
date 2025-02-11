package store

class AuthController {

    def index() {
        redirect(action: "login") // Redirect root to login
    }

    def login() {
        if (request.method == "POST") {  // Handle form submission
            def user = AppUser.findByUsername(params.username)

            if (!user) {
                println "User not found: ${params.username}"
                flash.message = "Invalid username or password."
                redirect(action: "login")
                return
            }

            println "User found: ${user.username}, Stored Password: ${user.password}"

            if (params.password == user.password) {
                session.user = user
                redirect(controller: "dashboard", action: "index")
            } else {
                println "Password mismatch for user: ${params.username}"
                flash.message = "Invalid username or password."
                redirect(action: "login")
            }
        } else {
            render(view: "login") // Show login page
        }
    }

    def logout() {
        session.invalidate()
        redirect(action: "login")
    }
}
