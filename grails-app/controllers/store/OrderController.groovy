package store
import grails.validation.Validateable
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date

class OrderController {

    def checkout() {
        if (!session.user) {
            redirect(controller: "auth", action: "login")
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
                redirect(controller: "auth", action: "login")
                return
            }

            println "🔍 getProductByBarcode called with barcode: '${params.productBarcode}'"

            if (!params.productBarcode) {
                render(status: 400, text: "Please enter a barcode.") // Consistent message with client-side
                return
            }

            def currentUser = AppUser.findById(session.user.id, [fetch: [createdBy: 'join']])
            def createdById = currentUser.createdBy?.id ?: currentUser.id
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
    def saveOrder() {
        if (!session.user) {
            render(status: 403, text: "Unauthorized access")
            return
        }

        def jsonData = request.JSON
        def customerName = jsonData.customerName
        def productsData = jsonData.products
        def amountReceived = jsonData.amountReceived as BigDecimal

        if (!customerName || !productsData) {
            render([status: "error", message: "Missing required fields"] as JSON)
            return
        }

        println "🛒 Processing Order for ${customerName}..."

        def currentUser = AppUser.get(session.user.id)
        def createdByUser = currentUser.createdBy ?: currentUser

        def order = new Order(
                customerName: customerName,
                totalAmount: 0.0G,
                amountReceived: amountReceived ?: 0.0G,
                createdBy: createdByUser
        )
        order.orderItems = []

        productsData.each { productData ->
            def product = Product.findByProductBarcode(productData.productBarcode)

            if (product && product.createdBy.id == createdByUser.id) {
                if (product.productQuantity >= productData.quantity) {
                    def orderItem = new OrderItem(
                            order: order,
                            product: product,
                            quantity: productData.quantity,
                            subtotal: product.productPrice * productData.quantity,
                            createdBy: createdByUser
                    )
                    order.addToOrderItems(orderItem)

                    product.productQuantity -= productData.quantity
                    product.save(flush: true, failOnError: true)
                } else {
                    render([status: "error", message: "Not enough stock for ${product.productName}", productBarcode: productData.productBarcode] as JSON)
                    return
                }
            }
        }

        order.totalAmount = order.orderItems.sum { it.subtotal } ?: 0.0G
        order.remainingAmount = order.amountReceived - order.totalAmount

        if (order.save(flush: true, failOnError: true)) {
            render([status: "success", message: "Checkout completed!", orderId: order.id] as JSON)
        } else {
            render([status: "error", message: "Error while saving the order"] as JSON)
        }
    }

    @Transactional(readOnly = true)
    def orderDetails(Long id) {
        if (!session.user) {
            redirect(controller: "auth", action: "login")
            return
        }

        // Fetch the current user
        def currentUser = AppUser.get(session.user.id)

        // Fetch the order with `createdBy` eagerly loaded
        def order = Order.createCriteria().get {
            eq("id", id)
            createAlias("createdBy", "cb", org.hibernate.criterion.CriteriaSpecification.LEFT_JOIN)
        }

        if (!order || order.createdBy.id != (currentUser.createdBy?.id ?: currentUser.id)) {
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

        // Ensure all necessary order properties are available in the model
        render(view: "orderDetails", model: [
                order: order,
                orderItems: orderItems
        ])
    }


    def listOrders() {
        def currentUser = session.user
        if (!currentUser) {
            redirect(controller: "auth", action: "login")
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
