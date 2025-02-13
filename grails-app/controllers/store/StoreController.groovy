package store

import grails.gorm.transactions.Transactional
import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException

class StoreController {



    class StoreController {

        def inventory() {
            def user = session.user
            if (!user) {
                redirect(controller: 'auth', action: 'login')
                return
            }

            def userRoles = user.roles.collect { it.roleName }
            def permissions = [:]

            user.roles.each { role ->
                role.permissions.each { permission ->
                    permissions[permission.pageName] = permission
                }
            }

            session.userRoles = userRoles
            session.userPermissions = permissions

            if (!permissions["inventory"]?.canView) {
                render(view: "/accessDenied")
                return
            }

            def products = Product.list()
            render(view: "inventory", model: [products: products, permissions: permissions["inventory"]])
        }
    }


    def showProduct(Long id) {
        def product = Product.get(id)
        if (product) {
            render product as JSON
        } else {
            render status: 404, text: "Product not found"
        }
    }

    @Transactional
    def saveProduct() {
        try {
            log.info("saveProduct action hit with params: ${params}")

            def product = params.id ? Product.get(params.id) : new Product()

            // If an id was provided but no product was found, return a 404
            if (params.id && !product) {
                render status: 404, text: "Product not found"
                return
            }

            // Update product properties from parameters
            product.properties = params

            if (product.validate() && product.save(flush: true)) {
                render status: 200, text: "Product saved successfully"
            } else {
                render status: 400, text: "Failed to save product: " + product.errors
            }
        } catch (Exception e) {
            log.error("Error in saveProduct action: ${e.message}", e)
            render status: 500, text: "An error occurred while saving the product"
        }
    }


    @Transactional
    def deleteProduct(Long id) {
        try {
            log.info("deleteProduct action hit with product ID: ${id}")

            def product = Product.get(id)

            if (!product) {
                log.warn("Product with ID ${id} not found")
                render status: 404, text: "Product not found"
                return
            }

            // Try to delete the product
            product.delete(flush: true)
            log.info("Product with ID ${id} deleted successfully")
            render status: 200, text: "Product deleted successfully"
        } catch (DataIntegrityViolationException e) {
            log.error("Data integrity violation while deleting product with ID ${id}: ${e.message}", e)
            render status: 400, text: "Failed to delete product due to data integrity error"
        } catch (Exception e) {
            log.error("Unexpected error while deleting product with ID ${id}: ${e.message}", e)
            render status: 500, text: "An unexpected error occurred while deleting the product"
        }
    }

}
