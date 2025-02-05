package store

class CustomerController {


    def checkout() {
        // Render the checkout form (GSP)
        render view: 'checkout'
    }

    def processCheckout() {
        // Create a new Customer order using the posted customer name
        def customer = new Customer(customerName: params.customerName)

        // Assume the checkout form posts arrays for:
        // - productId[]: the IDs of selected products
        // - quantity[]: the quantity purchased for each product
        def productIds = params.list('productId')
        def quantities = params.list('quantity')

        productIds.eachWithIndex { prodId, i ->
            def product = Product.get(prodId)
            if (product) {
                // Create a PurchasedItem capturing the current product details
                def item = new PurchasedItem(
                        productName: product.productName,
                        productDescription: product.productDescription,
                        productSKU: product.productSKU,
                        productBarcode: product.productBarcode,
                        unitPrice: product.productPrice,
                        quantity: quantities[i]?.toInteger() ?: 1
                )
                customer.addToPurchasedItems(item)
            }
        }

        // Calculate the total order price
        customer.calculateTotalPrice()
        if (!customer.save(flush: true)) {
            flash.message = "Error processing checkout."
            render view: 'checkoutForm', model: [customer: customer]
            return
        }

        // Update the Product table: subtract purchased quantities
        customer.purchasedItems.each { item ->
            // Locate the product using a unique identifier (SKU in this case)
            def product = Product.findByProductSKU(item.productSKU)
            if (product) {
                product.productQuantity = product.productQuantity - item.quantity
                product.save(flush: true)
            }
        }

        // Render an order details view that includes JavaScript to pop up the details
        render view: 'orderDetails', model: [customer: customer]
    }
}
