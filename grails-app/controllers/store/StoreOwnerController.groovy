package store

import org.mindrot.jbcrypt.BCrypt


class StoreOwnerController {
    StoreOwnerService storeOwnerService

    def index() { }

    def register() {
        if (request.method == 'POST') {
            def storeOwner = new StoreOwner(params)
            storeOwner.passwordHash = BCrypt.hashpw(params.password, BCrypt.gensalt())
            params.remove('password')

            if (!storeOwnerService.saveStoreOwner(storeOwner)) {
                storeOwner.errors.allErrors.each {
                    flash.message = it
                }
                render(view: "register", model: [storeOwner: storeOwner])
                return
            }
            flash.message = "Registration successful"
            redirect(controller: "auth", action: "login")
        } else {
            // GET request, just show the form
            [storeOwner: new StoreOwner()]
        }
    }
}