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
            eq("createdBy", currentAdmin)
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
            eq("createdBy", currentAdmin)
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

    // API to get product data by barcode (Filtered by Admin)
    def getProductDataByBarcode() {
        try {
            if (!session.user) {
                render(status: 403, text: "Unauthorized access")
                return
            }

            println "🔍 getProductDataByBarcode called with barcode: '${params.barcode}'"

            if (!params.barcode) {
                render(status: 400, text: "Barcode is required")
                return
            }

            def createdById = session.user.createdBy?.id ?: session.user.id
            def product = Product.findByProductBarcode(params.barcode?.trim())
            if (!product || product.createdBy.id != createdById) {
                render(status: 404, text: "Product not found or unauthorized")
                return
            }

            def totalOrders = Order.createCriteria().get {
                projections {
                    countDistinct('id')
                }
                orderItems {
                    eq("product", product)
                }
                eq("createdBy", session.user)
            } ?: 0

            def totalQuantitySold = OrderItem.createCriteria().get {
                projections { sum('quantity') }
                eq("product", product)
            } ?: 0

            def totalSales = totalQuantitySold * product.productPrice

            render([
                    totalOrders: totalOrders,
                    totalSales: totalSales,
                    productName: product.productName,
                    quantity: product.productQuantity
            ] as JSON)
        } catch (Exception e) {
            e.printStackTrace()
            render(status: 500, text: "Internal Server Error")
        }
    }
}