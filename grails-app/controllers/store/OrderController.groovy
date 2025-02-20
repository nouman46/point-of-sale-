package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import grails.validation.Validateable

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
    def saveOrder(OrderCommand command) {
        if (command.hasErrors()) {
            def errors = command.errors.allErrors.collectEntries {
                [(it.field): message(code: it.defaultMessage)]
            }
            render([status: "error", message: "Validation failed", errors: errors] as JSON)
            return
        }

        println "🛒 Processing Order for ${command.customerName}..."

        def order = new Order(customerName: command.customerName, totalAmount: 0)
        order.orderItems = []

        command.products.each { productData ->
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
            }
        }

        order.totalAmount = order.orderItems.sum { it.subtotal }

        if (order.save(flush: true, failOnError: true)) {
            render([status: "success", message: "Checkout completed!", orderId: order.id] as JSON)
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
                    productName: item.product?.productName,
                    price: item.product?.productPrice,
                    quantity: item.quantity,
                    subtotal: item.subtotal
            ]
        }

        render(view: "orderDetails", model: [order: order, orderItems: orderItems])
    }

    def listOrders() {
        String startDateStr = params.startDate
        String endDateStr = params.endDate

        def orders = Order.createCriteria().list {
            if (startDateStr && endDateStr) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
                Date startDate = sdf.parse(startDateStr)
                Date endDate = sdf.parse(endDateStr)

                Calendar cal = Calendar.getInstance()
                cal.setTime(endDate)
                cal.set(Calendar.HOUR_OF_DAY, 23)
                cal.set(Calendar.MINUTE, 59)
                cal.set(Calendar.SECOND, 59)
                cal.set(Calendar.MILLISECOND, 999)
                endDate = cal.getTime()

                ge("dateCreated", startDate)
                le("dateCreated", endDate)
            }
            order("dateCreated", "desc")
        }

        def totalSales = orders.sum { it.totalAmount }

        render(view: "orderList", model: [orders: orders, startDate: startDateStr, endDate: endDateStr, totalSales: totalSales])
    }
}


import grails.validation.Validateable

import java.text.SimpleDateFormat

class OrderCommand implements Validateable {
    String customerName
    List<ProductCommand> products = []

    static constraints = {
        customerName nullable: true, size: 1..255, validator: { val, obj ->
            if (!val) {
                return 'customerNameCannotBeBlank'
            }
        }

        products nullable: true, validator: { val, obj ->
            if (!val || val.isEmpty()) {
                return 'atLeastOneProductRequired'
            }
        }
    }
}

class ProductCommand {
    String productBarcode
    Integer quantity

    static constraints = {
        productBarcode nullable: true, size: 1..255, validator: { val, obj ->
            if (!val) {
                return 'productBarcodeCannotBeBlank'
            }
        }

        quantity nullable: true, min: 1, validator: { val, obj ->
            if (!val || val < 1) {
                return 'quantityMustBeAtLeastOne'
            }
        }
    }
}
