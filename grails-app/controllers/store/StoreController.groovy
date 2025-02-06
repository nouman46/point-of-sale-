package store

import grails.converters.JSON
import grails.gorm.transactions.Transactional

//import grails.plugin.springsecurity.annotation.Secured

import org.springframework.dao.DataIntegrityViolationException

//@Secured(['ROLE_USER'])
class StoreController {

    def index() {
        render "Hello, Congratulations for your first POS"

    }

    def inventory() {
        int maxResults = 8  // Show 8 products per page
        int currentPage = params.page ? params.page.toInteger() : 1
        int totalProducts = Product.count()  // Get total number of products
        int totalPages = Math.ceil(totalProducts / maxResults)  // Calculate total pages
        int offset = (currentPage - 1) * maxResults  // Calculate offset for the query

        // Fetch the products for the current page
        def productList = Product.list(max: maxResults, offset: offset)

        // Fetch all products for search functionality
        def allProducts = Product.list()

        // Pass the necessary data to the GSP
        [productList: productList, currentPage: currentPage, totalPages: totalPages, allProducts: allProducts]
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
