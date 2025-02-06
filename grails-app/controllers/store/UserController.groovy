package store

//import grails.plugin.springsecurity.annotation.Secured


//@Secured(['ROLE_USER'])
class UserController {

    def springSecurityService

//    def index() {
//
//    }

    def register() {
        if (request.method == 'POST') {
            def user = new User(
                    username: params.username,
                    password: params.password,
                    email: params.email,
                    enabled: true
            )

            if (user.save()) {
                Role userRole = Role.findByAuthority('ROLE_USER')
                UserRole.create(user, userRole,true)
            }

            springSecurityService.reauthenticate(params.username)
            redirect(uri:'/')
        }else {
            render(view: 'signup')
        }

    }
}