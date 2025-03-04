package store

class UrlMappings {

    static mappings = {
        // Default mapping to handle all controller/action routes
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // Add constraints if needed
            }
        }

        // ✅ Default Landing Page (single root mapping)
        "/"(controller: "auth", action: "login") // Chose login as default; adjust if home/index is preferred

        // ✅ Authentication
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
        "/dashboard"(controller: "dashboard", action: "dashboard") // Assuming 'dashboard' is the main action
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
        "/order/$id/details"(controller: "order", action: "orderDetails") // Kept both for flexibility

        // ✅ Sales
        "/sales"(controller: "sales", action: "sales")

        // ✅ Settings

        "/setting/updateStoreOwner"(controller: "setting", action: "updateStoreOwner")
        "/setting/updateLogo"(controller: "setting", action: "updateLogo")
        "/setting/testLogo"(controller: "setting", action: "testLogo")

        // ✅ Store Owner
        // ✅ Settings
        "/settings"(controller: "setting", action: "index")
        "/settings/index"(controller: "setting", action: "index")
        "/setting/update"(controller: "setting", action: "index")
        "/storeOwner/register"(controller: "storeOwner", action: "register")
        "/storeOwner/$id"(controller: "storeOwner", action: "show")
        "/storeOwner/$id/edit"(controller: "storeOwner", action: "edit")
        "/storeOwner/update/$id"(controller: "setting", action: "updateStoreOwner", method: "PUT")

        // ✅ Subscription
        "/subscription"(controller: "subscription", action: "index")
        "/subscription/subscribe"(controller: "subscription", action: "subscribe")

        "/settings/index"(controller: "setting", action: "index")
        "/setting/updateStoreOwner"(controller: "setting", action: "updateStoreOwner")
        "/setting/updateLogo"(controller: "setting", action: "updateLogo")
        "/setting/testLogo"(controller: "setting", action: "testLogo")
        "/setting/requestSubscription"(controller: "setting", action: "requestSubscription")

                // ✅ Webapp
        "/webapp"(controller: "webapp", action: "index")
        "/webapp/web"(controller: "webapp", action: "web")

        // ✅ Error Handling
        "500"(view: "/error")
        "404"(view: "/notFound")
    }
}