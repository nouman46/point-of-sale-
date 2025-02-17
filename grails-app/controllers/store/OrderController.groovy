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
        def orders = Order.list(sort: "dateCreated", order: "desc")
        render(view: "orderList", model: [orders: orders])
    }
}
