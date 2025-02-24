package store

import grails.gorm.transactions.Transactional
import grails.validation.Validateable
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

        // Eagerly fetch the createdBy association for the current user
        currentUser = AppUser.findById(currentUser.id, [fetch: [createdBy: 'join']])

        // Fetch the createdBy ID of the current user
        def createdById = currentUser.createdBy?.id ?: currentUser.id

        // Fetch all products where the createdBy ID matches the current user's createdBy ID
        def products = Product.findAllByCreatedBy(AppUser.get(createdById))

        // Debugging: Log the fetched products
        log.info("Fetched Products: ${products.collect { it.productName }}")

        render(view: "inventory", model: [products: products])
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

            // Check if a product with the same name already exists (excluding the current product if updating)
            def existingProduct = Product.findByProductName(params.productName)
            if (existingProduct && (!params.id || existingProduct.id != params.id)) {
                flash.error = "Product already exists!"
                redirect(action: "inventory") // Redirect back to inventory page
                return
            }

            def product = params.id ? Product.get(params.id) : new Product()

            // If an id was provided but no product was found, return a 404
            if (params.id && !product) {
                render status: 404, text: "Product not found"
                return
            }

            // Set the createdBy field to the current admin or user
            def currentUser = session.user
            if (!currentUser) {
                flash.error = "Unauthorized access!"
                redirect(controller: "auth", action: "login")
                return
            }

            // Update product properties from parameters
            product.properties = params

            // Set the createdBy and admin fields
            if (!product.createdBy) {
                product.createdBy = currentUser
            }
            // Set the admin field (if required, this could be the same as createdBy)
            if (!product.admin) {
                product.admin = currentUser
            }

            log.info("Product properties set: ${product.properties}")

            // Validate and save product
            if (product.validate()) {
                if (product.save(flush: true)) {
                    flash.message = "Product saved successfully"
                } else {
                    flash.error = "Failed to save product: " + product.errors
                    log.error("Product validation failed: ${product.errors}")
                }
            } else {
                flash.error = "Product validation failed: ${product.errors}"
                log.error("Product validation failed: ${product.errors}")
            }

            redirect(action: "inventory") // Redirect back to inventory page
        } catch (Exception e) {
            log.error("Error in saveProduct action: ${e.message}", e)
            flash.error = "An error occurred while saving the product"
            redirect(action: "inventory")
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

            // Check if the current user is allowed to delete the product
            def currentUser = session.user
            if (!currentUser || (product.createdBy != currentUser && !AppUser.findAllByCreatedBy(currentUser).contains(product.createdBy))) {
                flash.error = "Unauthorized access!"
                redirect(controller: "auth", action: "login")
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
