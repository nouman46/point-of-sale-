package store

import grails.converters.JSON
import java.time.ZoneId
import java.time.format.DateTimeFormatter

class DashboardController {

    def dashboard() {
        render(view: "dashboard")
    }

    // API to get total orders, products, and sales (Filtered by Admin)
    def getOrdersData() {
        def currentAdmin = session.user
        if (!currentAdmin) {
            render(status: 403, text: "Unauthorized access!")
            return
        }

        def totalOrders = Order.countByCreatedBy(currentAdmin)
        def totalProducts = Product.countByCreatedBy(currentAdmin)
        def totalSales = Order.createCriteria().get {
            projections {
                sum('totalAmount')
            }
            eq("createdBy", currentAdmin)  // Fixed filtering
        } ?: 0.0

        render([
                ordersThisMonth: totalOrders,
                totalProducts: totalProducts,
                totalSales: totalSales
        ] as JSON)
    }

    // API to get order trends (Filtered by Admin)
    def getOrdersTrend() {
        def currentAdmin = session.user
        if (!currentAdmin) {
            render(status: 403, text: "Unauthorized access!")
            return
        }

        def ordersByDate = Order.createCriteria().list {
            projections {
                groupProperty("dateCreated")
                count("id")
            }
            eq("createdBy", currentAdmin)  // Fixed filtering
            order("dateCreated", "asc")
        }

        def groupedOrders = ordersByDate.groupBy { row ->
            row[0]?.toInstant()?.atZone(ZoneId.systemDefault())?.toLocalDate()
        }.collect { date, entries ->
            [date: date?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")), count: entries.sum { it[1] }]
        }

        render groupedOrders as JSON
    }

    // API to get product quantities (Filtered by Admin)
    def getProductQuantities() {
        def currentAdmin = session.user
        if (!currentAdmin) {
            render(status: 403, text: "Unauthorized access!")
            return
        }

        def products = Product.findAllByCreatedBy(currentAdmin)
        def productData = products.collect { product ->
            [name: product.productName, quantity: product.productQuantity]
        }
        render(productData as JSON)
    }
}
