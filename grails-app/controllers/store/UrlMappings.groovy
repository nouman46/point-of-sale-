package store

class UrlMappings {

    static mappings = {
        "/"(controller: "dashboard", action: "index")  // Default landing page

        "/dashboard"(controller: "dashboard", action: "index")
        "/store/inventory"(controller: "store", action: "inventory")
        "/sales"(controller: "sales", action: "index")
        "/checkout"(controller: "checkout", action: "index")
        "/settings"(controller: "settings", action: "index")
        "/subscription"(controller: "subscription", action: "index")
        "/admin/userList"(controller: "admin", action: "userList")
        "/admin/saveUser"(controller: "admin", action: "saveUser")
        "/admin/editUser/$id"(controller: "admin", action: "editUser")
        "/admin/updateUser"(controller: "admin", action: "updateUser")

        // ✅ FIXED: Added missing mappings
        "/admin/showUser/$id"(controller: "admin", action: "showUser")  // Fetch a user for editing
        "/admin/deleteUser/$id"(controller: "admin", action: "deleteUser")  // Delete user

        "/auth/login"(controller: "auth", action: "login")
        "/auth/logout"(controller: "auth", action: "logout")

        "500"(view: "/error")  // Error page
        "404"(view: "/notFound")  // Not Found page
    }
}
