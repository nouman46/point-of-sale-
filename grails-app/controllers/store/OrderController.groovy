package store
import grails.validation.Validateable
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import store.ProductCommand

class OrderController {

    def checkout() {
        if (!session.user) {
            render(status: 403, text: "Unauthorized access")
            return
        }
        println "CheckoutController: index action called"
        render(view: "/order/checkout")
    }
    def getAllProducts() {
        try {
            def products = Product.list()
            render products as JSON
        } catch (Exception e) {
            e.printStackTrace()
            render(status: 500, text: "Internal Server Error")
        }
    }


    def getProductByBarcode() {
        try {
            if (!session.user) {
                render(status: 403, text: "Unauthorized access")
                return
            }

            println "🔍 getProductByBarcode called with barcode: '${params.productBarcode}'"

            if (!params.productBarcode) {
                render(status: 400, text: "Barcode is required")
                return
            }

            // Fetch the createdBy ID of the current user
            def createdById = session.user.createdBy?.id ?: session.user.id

            // Fetch the product by barcode and ensure it belongs to the same createdBy hierarchy
            def product = Product.findByProductBarcode(params.productBarcode?.trim())
            if (!product || product.createdBy.id != createdById) {
                render(status: 404, text: "Product not found or unauthorized")
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
        if (!session.user) {
            render(status: 403, text: "Unauthorized access")
            return
        }

        if (command.hasErrors()) {
            def errors = command.errors.allErrors.collectEntries {
                [(it.field): message(code: it.defaultMessage)]
            }
            render([status: "error", message: "Validation failed", errors: errors] as JSON)
            return
        }

        println "🛒 Processing Order for ${command.customerName}..."

        // Fetch the current user (ensure it's attached to the session)
        def currentUser = AppUser.get(session.user.id)

        def order = new Order(customerName: command.customerName, totalAmount: 0, createdBy: currentUser)
        order.orderItems = []

        command.products.each { productData ->
            def product = Product.findByProductBarcode(productData.productBarcode)

            // Ensure the product belongs to the same createdBy hierarchy
            if (product && product.createdBy.id == currentUser.createdBy?.id ?: currentUser.id) {
                if (product.productQuantity >= productData.quantity) {
                    def orderItem = new OrderItem(
                            order: order,
                            product: product,
                            quantity: productData.quantity,
                            subtotal: product.productPrice * productData.quantity,
                            createdBy: currentUser // Set the createdBy field for OrderItem
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
        if (!session.user) {
            render(status: 403, text: "Unauthorized access")
            return
        }

        // Fetch the createdBy ID of the current user
        def createdById = session.user.createdBy?.id ?: session.user.id

        def order = Order.get(id)
        if (!order || order.createdBy.id != createdById) {
            flash.message = "Order not found or unauthorized!"
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
        def currentUser = session.user
        if (!currentUser) {
            render(status: 403, text: "Unauthorized access")
            return
        }

        // Eagerly fetch the createdBy association for the current user
        currentUser = AppUser.findById(currentUser.id, [fetch: [createdBy: 'join']])

        // Fetch the createdBy ID of the current user
        def createdById = currentUser.createdBy?.id ?: currentUser.id

        String startDateStr = params.startDate
        String endDateStr = params.endDate

        def orders = Order.createCriteria().list {
            eq("createdBy.id", createdById) // Fetch orders created by the same hierarchy
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
    @Transactional(readOnly = true)
    def getOrdersOverTime() {
        def orders = Order.createCriteria().list {
            projections {
                groupProperty('dateCreated', 'order_date') // Grouping by dateCreated
                count('id', 'order_count')  // Counting order IDs
            }
            order("dateCreated", "asc")  // Ordering by dateCreated in ascending order
        }

        // Formatting the result
        def formattedOrders = orders.collect {
            [date: it.order_date.toString(), count: it.order_count]
        }

        render formattedOrders as JSON
    }
}

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


