package store

class UrlMappings {

    static mappings = {
        // ✅ Default Landing Page (Now set to Login Page)'

        "/"(controller: "auth", action: "login")

        // ✅ Authentication
        "/auth/login"(controller: "auth", action: "login")
        "/auth/logout"(controller: "auth", action: "logout")

        // ✅ Admin Role Management
        "/admin/roleManagement"(controller: "admin", action: "roleManagement")

        "/admin/assignRole"(controller: "admin", action: "assignRole")
        "/admin/saveRole"(controller: "admin", action: "saveRole")
        "/admin/assignPermission"(controller: "admin", action: "assignPermission")
        "/admin/userList"(controller: "admin", action: "userList")

        "/admin/saveUser"(controller: "admin", action: "saveUser")
        // ✅ Edit User
        "/admin/editUser"(controller: "admin", action: "editUser")
        // ✅ Delete User
        "/admin/deleteUser"(controller: "admin", action: "deleteUser")
        // ✅ Assign Role to User
        "/admin/assignRole"(controller: "admin", action: "assignRole")
        // ✅ Save New Role
        "/admin/saveRole"(controller: "admin", action: "saveRole")
        // ✅ Edit Role
        "/admin/editRole"(controller: "admin", action: "editRole")

        "/admin/deleteRole"(controller: "admin", action: "deleteRole")

        // ✅ Dashboard
        "/dashboard"(controller: "dashboard", action: "dashboard")
        "/webapp"(controller: "webapp", action: "index")
        "/dashboard/getOrdersData"(controller: "dashboard", action: "getOrdersData")
        "/dashboard/getOrdersTrend"(controller: "dashboard", action: "getOrdersTrend")
        "/dashboard/getProductQuantities"(controller: "dashboard", action: "getProductQuantities")
        "/dashboard/getOrdersOverTime"(controller: "dashboard", action: "getOrdersOverTime")
        "/dashboard/getProductDataByBarcode"(controller: "dashboard", action: "getProductDataByBarcode")


        // ✅ Store & Inventory
        "/store/inventory"(controller: "store", action: "inventory")
        "/store/showProduct/$id"(controller: "store", action: "showProduct")
        "/store/saveProduct"(controller: "store", action: "saveProduct")
        "/store/deleteProduct/$id"(controller: "store", action: "deleteProduct")
        "/store/web"(controller: "store", action: "web")

        // ✅ Orders & Checkout
        "/order/checkout"(controller: "order", action: "checkout")
        "/order/getProductByBarcode"(controller: "order", action: "getProductByBarcode")
        "/order/saveOrder"(controller: "order", action: "saveOrder", method: "POST")
        "/order/listOrders"(controller: "order", action: "listOrders")
        "/order/orderDetails/$id?"(controller: "order", action: "orderDetails")
        "/order/$id/details"(controller: "order", action: "orderDetails")

        // ✅ Sales
        "/sales"(controller: "sales", action: "sales")

        // ✅ Settings
        "/settings"(controller: "setting", action: "index")
        "/settings/index"(controller: "setting", action: "index")
        "/setting/update"(controller: "setting", action: "index")

        // ✅ Subscription
        "/subscription"(controller: "subscription", action: "subscription")

        // ✅ Store Owner Registration
        "/storeOwner/register"(controller: "storeOwner", action: "register")

        // ✅ Error Handling
        "500"(view: "/error")
        "404"(view: "/notFound")
    }
}