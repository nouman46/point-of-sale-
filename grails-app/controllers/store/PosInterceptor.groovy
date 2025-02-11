package store

class PosInterceptor {

    PosInterceptor() {
        matchAll().excludes(controller: "auth") // Allow login page access
    }

    boolean before() {
        // ✅ 1. Ensure session is set
        if (!session.user) {
            if (controllerName != "auth") { // Prevent infinite redirect
                redirect(controller: "auth", action: "login")
                return false
            }
            return true // Allow login page to load
        }

        // ✅ 2. Admin can access everything
        if (session.user?.username == "admin") {
            return true
        }

        // ✅ 3. Restrict normal users based on allowedPages
        def allowedPages = session.user?.allowedPages?.split(",") ?: []
        def currentPage = controllerName

        if (!allowedPages.contains(currentPage)) {
            if (controllerName != "dashboard") { // Prevent infinite redirect loop
                flash.message = "Unauthorized Access!"
                redirect(controller: "dashboard", action: "index")
                return false
            }
        }

        return true
    }
}
