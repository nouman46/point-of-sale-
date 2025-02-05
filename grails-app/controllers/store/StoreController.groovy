package store

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class StoreController {

    def index() {
        render "Hello, Congratulations for your first pos"

    }
}