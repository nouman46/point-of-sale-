package store

class DashboardController {

    def index() {
        if (!session.user) {
            redirect(controller: "auth", action: "login")
            return
        }
        render(view: "index")
    }
}

