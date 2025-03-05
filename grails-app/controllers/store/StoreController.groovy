package store

import grails.validation.Validateable
import grails.gorm.transactions.Transactional
import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException

class StoreController {

    def inventory() {
        def currentUser = session.user
        if (!currentUser) {
            flash.error = "Unauthorized access!"
            redirect(controller: "auth", action: "login")
            return
        }
        currentUser = AppUser.findById(currentUser.id, [fetch: [createdBy: 'join']])
        def createdById = currentUser.createdBy?.id ?: currentUser.id
        def products = Product.findAllByCreatedBy(AppUser.get(createdById))
        render(view: "inventory", model: [products: products])
    }

    def showProduct(Long id) {
        def product = Product.get(id)
        if (product) {
            def currentUser = session.user
            if (currentUser && (product.createdBy == currentUser || AppUser.findAllByCreatedBy(currentUser).contains(product.createdBy))) {
                render product as JSON
            } else {
                response.status = 403
                render([success: false, message: "Unauthorized access to product"] as JSON)
            }
        } else {
            response.status = 404
            render([success: false, message: "Product not found"] as JSON)
        }
    }

    @Transactional
    def saveProduct(ProductInfoCommand cmd) {
        def currentUser = session.user
        if (!currentUser) {
            response.status = 401
            render([success: false, message: "Unauthorized access!"] as JSON)
            return
        }

        if (request.method == 'POST') {
            if (cmd.validate()) {
                def product = params.id ? Product.get(params.id) : new Product()
                if (params.id && !product) {
                    response.status = 404
                    render([success: false, message: "Product not found"] as JSON)
                    return
                }

                if (!product.createdBy) {
                    product.createdBy = currentUser
                } else if (product.createdBy != currentUser && !AppUser.findAllByCreatedBy(currentUser).contains(product.createdBy)) {
                    response.status = 403
                    render([success: false, message: "Unauthorized to modify this product!"] as JSON)
                    return
                }

                if (!product.admin) product.admin = currentUser

                product.properties = [
                        productName: cmd.productName,
                        productDescription: cmd.productDescription,
                        productSKU: cmd.productSKU,
                        productBarcode: cmd.productBarcode,
                        productPrice: cmd.productPrice,
                        productQuantity: cmd.productQuantity
                ]

                if (product.save(flush: true)) {
                    flash.message = "Product ${params.id ? 'updated' : 'created'} successfully"
                    render([success: true] as JSON)
                } else {
                    def errors = product.errors.allErrors.collect { g.message(error: it) }.join(", ")
                    response.status = 500
                    render([success: false, message: "Failed to save product: ${errors}"] as JSON)
                }
            } else {
                def errors = cmd.errors.allErrors.collect { g.message(error: it) }.join(", ")
                response.status = 400
                render([success: false, message: "Validation failed: ${errors}"] as JSON)
            }
        }
    }

    @Transactional
    def deleteProduct(Long id) {
        try {
            def product = Product.get(id)
            if (!product) {
                response.status = 404
                render([success: false, message: "Product not found"] as JSON)
                return
            }

            def currentUser = session.user
            if (!currentUser || (product.createdBy != currentUser && !AppUser.findAllByCreatedBy(currentUser).contains(product.createdBy))) {
                response.status = 403
                render([success: false, message: "Unauthorized access!"] as JSON)
                return
            }

            // Delete all OrderItem records associated with this product
            OrderItem.findAllByProduct(product).each { orderItem ->
                orderItem.delete()
            }

            product.delete(flush: true)
            flash.message = "Product deleted successfully"
            render([success: true] as JSON)
        } catch (Exception e) {
            response.status = 500
            render([success: false, message: "An unexpected error occurred: ${e.message}"] as JSON)
        }
    }
}



// ProductInfoCommand remains unchanged
class ProductInfoCommand implements Validateable {
    String productName
    String productDescription
    String productSKU
    String productBarcode
    BigDecimal productPrice
    Integer productQuantity

    static constraints = {
        productName nullable: false, blank: false, maxSize: 100, validator: { val, obj ->
            if (val?.length() < 2) return "productName.minLength"
        }
        productDescription nullable: false, blank: false, maxSize: 500
        productSKU nullable: false, blank: false, maxSize: 50, unique: true
        productBarcode nullable: false, blank: false, maxSize: 50, validator: { val, obj ->
            if (!val?.matches("[0-9]+")) return "productBarcode.numeric"
        }
        productPrice nullable: false, min: 0.01 as BigDecimal, scale: 2
        productQuantity nullable: false, min: 0
    }
}