package store

import grails.converters.JSON

class CheckoutController {

    // Render the checkout page (GET request)
    def checkout() {
        render(view: 'checkout')
    }

    // Handle payment and save checkout details (POST request)
    def processPayment() {
        // Get customer details from the request
        String customerName = params.customerName
        BigDecimal totalAmount = new BigDecimal(params.totalAmount)

        // Create a new Checkout instance to save customer details and purchased items
        Checkout checkout = new Checkout(customerName: customerName, totalAmount: totalAmount)

        // Parse the items sent from the frontend (cartItems)
        def items = JSON.parse(params.items)

        // Create a list to store purchased items
        def purchasedItems = []

        items.each { item ->
            Product product = Product.findByProductBarcode(item.barcode)
            if (product && product.productQuantity >= item.quantity) {
                // Add item details to the purchasedItems list
                purchasedItems << [
                        productName: product.productName,
                        quantity: item.quantity,
                        price: product.productPrice * item.quantity,
                        productBarcode: product.productBarcode
                ]

                // Update product stock
                product.productQuantity -= item.quantity
                product.save(flush: true)
            }
        }

        // Convert the purchased items list to JSON and store it in the Checkout instance
        checkout.purchasedItems = purchasedItems as JSON

        // Save the checkout instance with the purchased items
        if (checkout.save(flush: true)) {
            // Render the confirmation view after successful payment
            render(view: 'confirmation', model: [totalAmount: totalAmount])
        } else {
            // Handle the case where saving failed
            flash.message = "There was an issue with processing the checkout."
            render(view: 'checkout', model: [checkoutInstance: checkout])
        }
    }

    // Endpoint to get product details based on the barcode
    def getProductDetails() {
        def barcode = params.barcode
        def product = Product.findByProductBarcode(barcode)
        if (product) {
            render(contentType: 'application/json') {
                name product.productName
                description product.productDescription
                price product.productPrice
                image product.productImage
            }
        } else {
            render(status: 404, text: 'Product not found')
        }
    }
}
