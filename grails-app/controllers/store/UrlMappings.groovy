package store

class UrlMappings {

    static mappings = {

        // ✅ Default Catch-All Mapping (Handles all controller/action routes dynamically)
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // Add constraints if needed
            }
        }

        // ✅ Default Landing Page
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
        "/admin/editUser/$id?"(controller: "admin", action: "editUser")
        "/admin/updateUser"(controller: "admin", action: "updateUser")
        "/admin/showUser/$id"(controller: "admin", action: "showUser")
        "/admin/deleteUser/$id?"(controller: "admin", action: "deleteUser")
        "/admin/editRole"(controller: "admin", action: "editRole")
        "/admin/deleteRole"(controller: "admin", action: "deleteRole")

        // ✅ Dashboard
        "/dashboard"(controller: "dashboard", action: "dashboard")
        "/dashboard/getOrdersData"(controller: "dashboard", action: "getOrdersData")
        "/dashboard/getOrdersTrend"(controller: "dashboard", action: "getOrdersTrend")
        "/dashboard/getProductQuantities"(controller: "dashboard", action: "getProductQuantities")
        "/dashboard/getOrdersOverTime"(controller: "dashboard", action: "getOrdersOverTime")
        "/dashboard/getProductDataByBarcode"(controller: "dashboard", action: "getProductDataByBarcode")
        "/dashboard/getAIPredictions"(controller: "dashboard", action: "getAIPredictions")

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
        "/order/$id/details"(controller: "order", action: "orderDetails") // Kept both for flexibility

        // ✅ Sales
        "/sales"(controller: "sales", action: "sales")

        // ✅ Settings Management
        "/settings"(controller: "setting", action: "index")
        "/settings/index"(controller: "setting", action: "index")
        "/setting/update"(controller: "setting", action: "index")
        "/setting/updateStoreOwner"(controller: "setting", action: "updateStoreOwner")
        "/setting/updateLogo"(controller: "setting", action: "updateLogo")
        "/setting/testLogo"(controller: "setting", action: "testLogo")
        "/setting/requestSubscription"(controller: "setting", action: "requestSubscription")

        // ✅ Store Owner Management
        "/storeOwner/register"(controller: "storeOwner", action: "register")
        "/storeOwner/$id"(controller: "storeOwner", action: "show")
        "/storeOwner/$id/edit"(controller: "storeOwner", action: "edit")
        "/storeOwner/update/$id"(controller: "setting", action: "updateStoreOwner", method: "PUT")

        // ✅ Subscription Management
        "/subscription"(controller: "subscription", action: "index")
        "/subscription/subscribe"(controller: "subscription", action: "subscribe")

        // ✅ Webapp Routes
        "/webapp"(controller: "webapp", action: "index")
        "/webapp/web"(controller: "webapp", action: "web")

        // ✅ Error Handling
        "500"(view: "/error")
        "404"(view: "/notFound")
    }
}
