package store

class UrlMappings {

    static mappings = {
        "/auth/login"(controller: "auth", action: "login")
        "/auth/logout"(controller: "auth", action: "logout")
        "/"(controller: "dashboard", action: "index")  // Default landing page
        "/admin/roleManagement"(controller: "admin", action: "roleManagement")
        "/dashboard"(controller: "dashboard", action: "index")
        "/inventory"(controller: "store", action: "inventory")
        "/sales"(controller: "sales", action: "sales")
        "/checkout"(controller: "checkout", action: "checkout")
        "/settings"(controller: "settings", action: "settings")
        "/subscription"(controller: "subscription", action: "subscription")
        "/admin/userList"(controller: "admin", action: "userList")
        "/admin/saveUser"(controller: "admin", action: "saveUser")
        "/admin/editUser/$id"(controller: "admin", action: "editUser")
        "/admin/updateUser"(controller: "admin", action: "updateUser")
        "/admin/showUser/$id"(controller: "admin", action: "showUser")  // Fetch a user for editing
        "/admin/deleteUser/$id"(controller: "admin", action: "deleteUser")  // Delete user
        "/store/inventory"(controller: "store", action: "inventory")
        "/store/showProduct/$id"(controller: "store", action: "showProduct")
        "/store/saveProduct"(controller: "store", action: "saveProduct")
        "/store/deleteProduct/$id"(controller: "store", action: "deleteProduct")

        // Authentication
        "/auth/login"(controller: "auth", action: "login")
        "/auth/logout"(controller: "auth", action: "logout")

        "500"(view: "/error")  // Error page
        "404"(view: "/notFound")  // Not Found page
    }
}
