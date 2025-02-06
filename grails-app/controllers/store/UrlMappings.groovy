package store

class UrlMappings {
    static mappings = {
        "/store/showProduct/$id"(controller: "store", action: "showProduct")
        "/store/deleteProduct/$id"(controller: "store", action: "deleteProduct")
        // Add other necessary routes here
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: 'User', view:"create")
        "500"(view:'/error')
        "404"(view:'/notFound')

    }
}
