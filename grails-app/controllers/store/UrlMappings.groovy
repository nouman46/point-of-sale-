package store

class UrlMappings {

    static mappings = {
        "/auth/login"(controller: "auth", action: "login")
        "/admin/roleManagement"(controller: "admin", action: "roleManagement")
        "/admin/roleManagement"(controller: "admin", action: "roleManagement")
        "/admin/saveUser"(controller: "admin", action: "saveUser")
        "/admin/editUser/$id"(controller: 'admin', action: 'editUser')
        "/admin/deleteUser"(controller: "admin", action: "deleteUser")
        "/admin/editUser"(controller: "admin", action: "editUser")


        // URL for deleting a user
// Edit user action



        // URL for editing a role
        "/admin/editRole/$id"(controller: 'admin', action: 'editRole')

        // URL for deleting a role
        "/admin/assignRole"(controller: "admin", action: "assignRole")
        "/admin/saveRole"(controller: "admin", action: "saveRole")

        "/admin/assignPermission"(controller: "admin", action: "assignPermission")
        "/auth/logout"(controller: "auth", action: "logout")
        "/"(controller: "dashboard", action: "index")  // Default landing page
        "/admin/editRole"(controller: "admin", action: "editRole")
        "/admin/deleteRole"(controller: "admin", action: "deleteRole")




        "/dashboard"(controller: "dashboard", action: "index")
        "/inventory"(controller: "store", action: "inventory")
        "/sales"(controller: "sales", action: "sales")
        // ✅ Checkout Page
        "/order/checkout"(controller: "order", action: "checkout")

        // ✅ Fetch Product by Barcode
        "/order/getProductByBarcode"(controller: "order", action: "getProductByBarcode")

        // ✅ Save Order (POST request)
        "/order/saveOrder"(controller: "order", action: "saveOrder", method: "POST")

        // ✅ List All Orders
        "/order/listOrders"(controller: "order", action: "listOrders")

        // ✅ View Specific Order Details
        "/order/$id/details"(controller: "order", action: "orderDetails")
        "/settings"(controller: "settings", action: "settings")
        "/subscription"(controller: "subscription", action: "subscription")
        "/admin/userList"(controller: "admin", action: "userList")
        "/admin/saveUser"(controller: "admin", action: "saveUser")

        "/admin/updateUser"(controller: "admin", action: "updateUser")
        "/admin/showUser/$id"(controller: "admin", action: "showUser")  // Fetch a user for editing
        // Delete user
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