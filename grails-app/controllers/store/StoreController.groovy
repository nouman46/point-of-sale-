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
            render product as JSON
        } else {
            response.status = 404
            render([success: false, message: "Product not found"] as JSON)
        }
    }

    @Transactional
    def saveProduct(ProductInfoCommand productInfo) {
        def currentUser = session.user
        if (!currentUser) {
            response.status = 401
            render([success: false, message: "Unauthorized access!"] as JSON)
            return
        }

        bindData(productInfo, params)

        if (!productInfo.validate()) {
            def errors = productInfo.errors.allErrors.collect { g.message(error: it) }.join("<br>")
            response.status = 400
            render([success: false, message: errors] as JSON) // Simplified message structure
            return
        }

        def product = params.id ? Product.get(params.id) : new Product()
        if (params.id && !product) {
            response.status = 404
            render([success: false, message: "Product not found"] as JSON)
            return
        }

        product.properties = [
                productName: productInfo.productName,
                productDescription: productInfo.productDescription,
                productSKU: productInfo.productSKU,
                productBarcode: productInfo.productBarcode,
                productPrice: productInfo.productPrice,
                productQuantity: productInfo.productQuantity
        ]

        if (!product.createdBy) product.createdBy = currentUser
        if (!product.admin) product.admin = currentUser

        if (product.save(flush: true)) {
            render([success: true, message: "Product ${params.id ? 'updated' : 'created'} successfully", product: product] as JSON)
        } else {
            def errors = product.errors.allErrors.collect { g.message(error: it) }.join("<br>")
            response.status = 500
            render([success: false, message: "Failed to save product:<br>${errors}"] as JSON)
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

            if (OrderItem.countByProduct(product) > 0) {
                response.status = 400
                render([success: false, message: "Cannot delete product as it is referenced in existing orders"] as JSON)
                return
            }

            product.delete(flush: true)
            render([success: true, message: "Product deleted successfully"] as JSON)
        } catch (DataIntegrityViolationException e) {
            response.status = 400
            render([success: false, message: "Failed to delete product due to data integrity error"] as JSON)
        } catch (Exception e) {
            response.status = 500
            render([success: false, message: "An unexpected error occurred: ${e.message}"] as JSON)
        }
    }
}

class ProductInfoCommand implements Validateable {
    String productName
    String productDescription
    String productSKU
    String productBarcode
    BigDecimal productPrice
    Integer productQuantity

    static constraints = {
        productName blank: false, nullable: false, maxSize: 100
        productDescription blank: false, nullable: false, maxSize: 500
        productSKU blank: false, nullable: false, unique: true, maxSize: 50
        productBarcode blank: false, nullable: false, unique: true, maxSize: 50
        productPrice nullable: false, min: 0.01 as BigDecimal, scale: 2
        productQuantity nullable: false, min: 0
    }
}