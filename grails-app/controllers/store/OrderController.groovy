package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import java.text.SimpleDateFormat

class OrderController {

    def checkout() {
        println "CheckoutController: index action called"
        render(view: "/order/checkout")
    }

    def getProductByBarcode() {
        try {
            println "🔍 getProductByBarcode called with barcode: '${params.productBarcode}'"

            if (!params.productBarcode) {
                render(status: 400, text: "Barcode is required")
                return
            }

            def product = Product.findByProductBarcode(params.productBarcode?.trim())

            if (!product) {
                render(status: 404, text: "Product not found")
                return
            }

            render(template: "/order/itemRow", model: [product: product])
        } catch (Exception e) {
            e.printStackTrace()
            render(status: 500, text: "Internal Server Error")
        }
    }

    @Transactional
    def saveOrder() {
        println "🛒 Processing Order..."

        def requestData = request.JSON
        def customerName = requestData.customerName
        def products = requestData.products

        if (!products) {
            render([status: "error", message: "No products found in the request!"] as JSON)
            return
        }

        def order = new Order(customerName: customerName, totalAmount: 0)
        order.orderItems = []

        products.each { productData ->
            def product = Product.findByProductBarcode(productData.productBarcode)

            if (product) {
                if (product.productQuantity >= productData.quantity) {
                    def orderItem = new OrderItem(
                            order: order,
                            product: product,
                            quantity: productData.quantity,
                            subtotal: product.productPrice * productData.quantity
                    )
                    order.addToOrderItems(orderItem)

                    product.productQuantity -= productData.quantity
                    product.save(flush: true, failOnError: true)
                } else {
                    render([status: "error", message: "Not enough stock for ${product.productName}"] as JSON)
                    return
                }
            } else {
                println "❌ Product not found for barcode: ${productData.productBarcode}"
            }
        }

        order.totalAmount = order.orderItems.sum { it.subtotal }

        if (order.save(flush: true, failOnError: true)) {
            render([status: "success", message: "Checkout completed!"] as JSON)
        } else {
            render([status: "error", message: "Error while saving the order"] as JSON)
        }
    }

    def orderDetails(Long id) {
        def order = Order.get(id)
        if (!order) {
            flash.message = "Order not found!"
            redirect(action: "listOrders")
            return
        }

        def orderItems = order.orderItems.collect { item ->
            [
                    productName: item.product?.productName, // ✅ Fixed property name
                    price: item.product?.productPrice, // ✅ Fixed property name
                    quantity: item.quantity,
                    subtotal: item.subtotal
            ]
        }

        render(view: "orderDetails", model: [order: order, orderItems: orderItems])
    }

    def listOrders() {
        // Retrieve startDate and endDate parameters from the request
        String startDateStr = params.startDate
        String endDateStr = params.endDate

        def orders = Order.createCriteria().list {
            if (startDateStr && endDateStr) {
                // Convert String to java.util.Date
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
                Date startDate = sdf.parse(startDateStr)
                Date endDate = sdf.parse(endDateStr)

                // Adjust endDate to include the full day (23:59:59)
                Calendar cal = Calendar.getInstance()
                cal.setTime(endDate)
                cal.set(Calendar.HOUR_OF_DAY, 23)
                cal.set(Calendar.MINUTE, 59)
                cal.set(Calendar.SECOND, 59)
                cal.set(Calendar.MILLISECOND, 999)
                endDate = cal.getTime()

                // Ensure orders on startDate and endDate are included
                ge("dateCreated", startDate) // dateCreated >= startDate
                le("dateCreated", endDate)   // dateCreated <= endDate
            }
            order("dateCreated", "desc")  // Sort by latest orders
        }

        // Calculate the total sales amount
        def totalSales = orders.sum { it.totalAmount }

        // Render the view with the filtered orders and total sales
        render(view: "orderList", model: [orders: orders, startDate: startDateStr, endDate: endDateStr, totalSales: totalSales])
    }


}
