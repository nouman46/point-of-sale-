package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional

class OrderController {

    def checkout() {
        println "CheckoutController: index action called"
        render(view: "/order/checkout")
    }

    def getProductByBarcode() {
        try {
            println "🔍 addItem action called with barcode: '${params.productBarcode}'"

            if (!params.productBarcode) {
                println "❌ Error: Barcode parameter is missing!"
                render(status: 400, text: "Barcode is required")
                return
            }

            def product = Product.findByProductBarcode(params.productBarcode?.trim())

            if (!product) {
                println "❌ Product Not Found for Barcode: '${params.productBarcode}'"
                render(status: 404, text: "Product not found")
                return
            }

            println "✅ Product Found: ${product.productName}, Price: ${product.productPrice}"
            render(template: "/order/itemRow", model: [product: product])  // Render GSP template
        } catch (Exception e) {
            println "❌ Error occurred: ${e.message}"
            e.printStackTrace()  // Print error in logs
            render(status: 500, text: "Internal Server Error")
        }
    }

    @Transactional
    def saveOrder() {
        println "🛒 Processing Order..."

        def requestData = request.JSON // Parse the incoming JSON data
        def customerName = requestData.customerName
        def products = requestData.products

        if (!products) {
            println "❌ No products found in the request!"
            render([status: "error", message: "No products found in the request!"] as JSON)
            return
        }

        def order = new Order(customerName: customerName, totalAmount: 0)
        order.orderItems = []

        products.each { productData ->
            def product = Product.findByProductBarcode(productData.productBarcode)

            if (product) {
                if (product.productQuantity >= productData.quantity) { // ✅ Check stock availability
                    def orderItem = new OrderItem(
                            order: order,
                            product: product,
                            quantity: productData.quantity,
                            subtotal: product.productPrice * productData.quantity
                    )
                    order.addToOrderItems(orderItem)

                    // ✅ Deduct the purchased quantity from product stock
                    product.productQuantity -= productData.quantity
                    product.save(flush: true, failOnError: true)
                } else {
                    println "❌ Not enough stock for product: ${product.productName} (Barcode: ${productData.productBarcode})"
                    render([status: "error", message: "Not enough stock for ${product.productName}"] as JSON)
                    return
                }
            } else {
                println "❌ Product not found for barcode: ${productData.productBarcode}"
            }
        }

        order.totalAmount = order.orderItems.sum { it.subtotal }

        if (order.save(flush: true, failOnError: true)) { // ✅ Save order
            println "✅ Order Saved!"
            render([status: "success", message: "Checkout completed!"] as JSON)
        } else {
            println "❌ Error while saving order!"
            render([status: "error", message: "Error while saving the order"] as JSON)
        }
    }



    def orderDetails(Long id) {
        def order = Order.get(id)
        if (!order) {
            flash.message = "Order not found"
            redirect(action: "checkout")
        }
        render(view: "orderDetails", model: [order: order])
    }
}
