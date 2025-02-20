package store

class UrlMappings {

    static mappings = {
        // ✅ Default Landing Page (Now set to Login Page)
        "/"(controller: "auth", action: "login")

        // ✅ Login Page
        "/auth/login"(controller: "auth", action: "login")
        // ✅ Logout Action
        "/auth/logout"(controller: "auth", action: "logout")

        // ✅ Admin Role Management Page
        "/admin/roleManagement"(controller: "admin", action: "roleManagement")
        // ✅ Save New User
        "/admin/saveUser"(controller: "admin", action: "saveUser")
        // ✅ Assign Role to User
        "/admin/assignRole"(controller: "admin", action: "assignRole")
        // ✅ Save New Role
        "/admin/saveRole"(controller: "admin", action: "saveRole")
        // ✅ Assign Permissions to Role
        "/admin/assignPermission"(controller: "admin", action: "assignPermission")

        // ✅ Dashboard Home
        "/dashboard"(controller: "dashboard", action: "index")

        // ✅ Fetch Orders Data for Area Graph
        "/dashboard/getOrdersData"(controller: "dashboard", action: "getOrdersData")
        "/dashboard/getOrdersTrend"(controller: "dashboard", action: "getOrdersTrend")

        // ✅ Fetch Product Quantities for Donut Chart
        "/dashboard/getProductQuantities"(controller: "dashboard", action: "getProductQuantities")
        "/dashboard/getOrdersOverTime"(controller: "dashboard", action: "getOrdersOverTime")


        // ✅ Inventory Page
        "/inventory"(controller: "store", action: "inventory")

        // ✅ Checkout Page
        "/order/checkout"(controller: "order", action: "checkout")
        // ✅ Fetch Product by Barcode
        "/order/getProductByBarcode"(controller: "order", action: "getProductByBarcode")
        // ✅ Save Order (POST request)
        "/order/saveOrder"(controller: "order", action: "saveOrder", method: "POST")
        // ✅ List All Orders
        "/order/listOrders"(controller: "order", action: "listOrders")
        // ✅ View Specific Order Details
        "/order/orderDetails/$id?"(controller: "order", action: "orderDetails")
        "/order/$id/details"(controller: "order", action: "orderDetails")

        // ✅ Settings Page
        "/settings"(controller: "settings", action: "settings")

        // ✅ Subscription Page
        "/subscription"(controller: "subscription", action: "subscription")

        // ✅ User List for Admin
        "/admin/userList"(controller: "admin", action: "userList")
        // ✅ Edit User Details
        "/admin/editUser/$id"(controller: "admin", action: "editUser")
        // ✅ Update User Details
        "/admin/updateUser"(controller: "admin", action: "updateUser")
        // ✅ Fetch a User for Editing
        "/admin/showUser/$id"(controller: "admin", action: "showUser")
        // ✅ Delete User
        "/admin/deleteUser/$id"(controller: "admin", action: "deleteUser")

        // ✅ Store Inventory Page
        "/store/inventory"(controller: "store", action: "inventory")
        // ✅ View Product Details
        "/store/showProduct/$id"(controller: "store", action: "showProduct")
        // ✅ Save New Product
        "/store/saveProduct"(controller: "store", action: "saveProduct")
        // ✅ Delete Product
        "/store/deleteProduct/$id"(controller: "store", action: "deleteProduct")

        // ✅ Error Page
        "500"(view: "/error")
        // ✅ Not Found Page
        "404"(view: "/notFound")
    }
}
