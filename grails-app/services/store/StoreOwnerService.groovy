package store

import grails.gorm.transactions.Transactional

@Transactional
class StoreOwnerService {
    def saveStoreOwner(StoreOwner storeOwner) {
        if (!storeOwner.validate()) {
            storeOwner.errors.allErrors.each { error ->
                log.error "Validation error: ${error}"
            }
            throw new RuntimeException("Validation failed: ${storeOwner.errors}")
        }
        storeOwner.save(flush: true, failOnError: true)
    }
}