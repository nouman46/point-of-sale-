package store

import grails.boot.GrailsApp
import grails.boot.config.GrailsAutoConfiguration
import groovy.transform.CompileStatic
import grails.plugins.metadata.*

@CompileStatic
class Application extends GrailsAutoConfiguration {

    // Define the upload directory for product images
    static final String UPLOAD_DIR = "D:\\uploads\\products"  // e.g., "/images/products"

    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}
