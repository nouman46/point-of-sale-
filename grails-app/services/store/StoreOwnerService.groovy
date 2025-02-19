package store

import grails.gorm.transactions.Transactional

@Transactional
class StoreOwnerService {
    def saveStoreOwner(StoreOwner storeOwner) {
        storeOwner.save(flush: true)
    }
}