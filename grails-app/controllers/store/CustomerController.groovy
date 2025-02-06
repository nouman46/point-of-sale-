package store

import grails.converters.JSON
//import grails.plugin.springsecurity.annotation.Secured

//@Secured(['ROLE_USER'])
class CustomerController {

    def getProducts() {
        try {
            def products = Product.list().findAll { it != null }

            if (!products) {
                render([error: "No products found"] as JSON)
                return
            }

            // Manually mapping each field of the Product domain class
            def productList = products.collect { product ->
                [
                        id: product.id,
                        productName: product.productName,
                        productDescription: product.productDescription,
                        productSKU: product.productSKU,
                        productBarcode: product.productBarcode,
                        productPrice: product.productPrice,

                ]
            }

            render([success: true, products: productList] as JSON)
        } catch (Exception e) {
            render([success: false, message: "Error fetching products: ${e.message}"] as JSON)
        }
    }
    def getProductByBarcode() {
        def barcode = params.barcode
        def product = Product.findByProductBarcode(barcode)

        if (product) {
            render([success: true, product: [
                    id: product.id,
                    productName: product.productName,
                    productDescription: product.productDescription,
                    productSKU: product.productSKU,
                    productPrice: product.productPrice,
                    productQuantity: product.productQuantity
            ]] as JSON)
        } else {
            render([success: false, message: "Product not found."] as JSON)
        }
    }
    def checkout() {
        render view: 'checkout'
    }
}
