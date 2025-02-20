package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import grails.converters.JSON
import store.Order
import java.time.ZoneId
import java.time.format.DateTimeFormatter
class DashboardController {

    def index() {
        render(view: "dashboard")
    }

    // API to get the total count of all orders, total products, and total sales
    def getOrdersData() {
        def totalOrders = Order.count() // ✅ Total number of orders
        def totalProducts = Product.count() // ✅ Count of different products
        def totalSales = Order.createCriteria().get { projections { sum('totalAmount') } } ?: 0.0 // ✅ Sum of all orders totalAmount

        // Debugging: Log the values
        println "🛒 Total Orders Count: ${totalOrders}"
        println "📦 Total Products Count: ${totalProducts}"
        println "💰 Total Sales Amount: ${totalSales}"

        // Return the data as JSON
        render([
                ordersThisMonth: totalOrders,
                totalProducts: totalProducts,
                totalSales: totalSales
        ] as JSON)
    }
    def getOrdersTrend() {
        def ordersByDate = Order.createCriteria().list {
            projections {
                groupProperty("dateCreated") // ✅ Group by full timestamp (wrong)
                count("id")  // ✅ Count orders per timestamp (wrong)
            }
            order("dateCreated", "asc")
        }

        // ✅ Fix: Group orders by date (ignoring time)
        def groupedOrders = ordersByDate.groupBy { row ->
            row[0]?.toInstant()?.atZone(ZoneId.systemDefault())?.toLocalDate()
        }.collect { date, entries ->
            [date: date?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")), count: entries.sum { it[1] }]
        }

        render groupedOrders as JSON
    }
    // API to get product quantities for the donut chart
    def getProductQuantities() {
        def products = Product.list()
        def productData = products.collect { product ->
            [name: product.productName, quantity: product.productQuantity]
        }
        render(productData as JSON)
    }
}
