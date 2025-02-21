package store

import grails.gorm.transactions.Transactional
import grails.validation.Validateable
import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException

class StoreController {

    def inventory() {
        def user = session.user
        def permissions = session.permissions?.get('inventory')

        println "🔍 Checking Session Data in Inventory Page"
        println "🔍 User: ${user?.username}"
        println "🔍 User Roles: ${session.assignRole}"
        println "🔍 Permissions for Inventory: ${permissions}"

        if (!user) {
            println "⚠️ No Logged-in User Found! Redirecting to login..."
            flash.message = "Session expired. Please log in again."
            redirect(controller: "auth", action: "login")
            return
        }

        if (!permissions?.canView) {
            println "⛔ Unauthorized access! User '${user.username}' tried to access inventory without permission."
            flash.message = "You do not have permission to view this page."
            redirect(controller: "dashboard", action: "index")
            return
        }

        int maxResults = 8
        int currentPage = params.page ? params.page.toInteger() : 1
        int totalProducts = Product.count()
        int totalPages = Math.ceil(totalProducts / maxResults)
        int offset = (currentPage - 1) * maxResults

        def productList = Product.list(max: maxResults, offset: offset)
        def allProducts = Product.list()

        return [productList: productList, currentPage: currentPage, totalPages: totalPages, allProducts: allProducts, permissions: permissions]
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
